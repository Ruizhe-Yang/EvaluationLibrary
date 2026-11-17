within EvaluationLibrary.Response;
block RepeatedResponse "Measure repeated request-response delays using a bounded FIFO"
  parameter String metricId=getInstanceName() "Identifier carried by the result";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Optional requirement version";
  parameter String unitName="s" "Unit label for the reported value";
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime "Fixed interval or first contiguous external window";
  parameter Modelica.Units.SI.Time windowStart=0 "Inclusive start of the observation window";
  parameter Modelica.Units.SI.Time windowStop=5 "Exclusive end of the observation window";
  parameter Boolean applicable=true "True if this assessment is applicable";
  parameter Boolean useValidInput=false "Enable the optional input validity connector";

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Uniform sampling interval for sampled evaluation";
  parameter Modelica.Units.SI.Time sampleStart=0 "Time origin of the uniform sample grid";
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "True if the observed inputs are valid" annotation(Placement(transformation(origin={70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={70,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle "External observation gate; only the first contiguous interval is accepted" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus "Observation coverage and data validity";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement outcome, separate from data qualification";
  output Boolean complete "Observation has ended; completeness is reported by dataStatus";
  output Boolean everViolated "True after a valid violation has been observed";
  output Modelica.Units.SI.Time firstViolationTime "Time of the first valid violation";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Value, qualification and requirement outcome" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));

  parameter Modelica.Units.SI.Time deadline(min=0)=0.2 "Maximum request-response delay in seconds, inclusive";
  parameter Boolean qualifyDeadline=false "Classify the result as a deadline requirement";
  parameter Integer capacity(min=1)=64 "Positive bounded event-queue capacity";
  parameter Integer maxRecords(min=1)=128 "Maximum stored matched delays";
    Modelica.Blocks.Interfaces.BooleanInput request "Request rising edges" annotation(Placement(transformation(origin={-70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={-70,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput response "Actual response rising edges" annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput matched(start=0,fixed=true) "Number of matched request-response pairs" annotation(Placement(transformation(origin={100,50},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,50},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput timedOut(start=0,fixed=true) "Number of requests whose deadlines have expired" annotation(Placement(transformation(origin={100,30},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,30},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput censored(start=0,fixed=true) "Number of requests without complete follow-up" annotation(Placement(transformation(origin={100,10},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,10},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput unmatchedResponse(start=0,fixed=true) "Number of response edges without a queued request" annotation(Placement(transformation(origin={100,-10},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-10},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput overflow(start=false,fixed=true) "True if the queue or delay record capacity was exceeded" annotation(Placement(transformation(origin={100,-30},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-30},extent={{-10,-10},{10,10}})));
  discrete Modelica.Units.SI.Time delays[maxRecords](each start=0,each fixed=true) "Stored matched response delays";
  output Integer queueLength(start=0,fixed=true) "Number of currently outstanding requests";

  Modelica.Blocks.Interfaces.RealOutput value "Numerical result; meaningful only when available" annotation(Placement(transformation(origin={100,-50},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-50},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True if the numerical result is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
  output Integer requestCount "Accepted requests; a full count is unavailable after overflow";
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Effective input validity" annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "External window" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=false,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Observation window and data qualification";
  Boolean dataOK "True if input validity and numerical checks pass";
  Boolean violationNow "Valid requirement violation at the current instant";

  discrete Modelica.Units.SI.Time timestamps[capacity](each start=0,each fixed=true) "Timestamps";
  discrete Modelica.Units.SI.Time delaySum(start=0,fixed=true) "Delay sum";
  discrete Modelica.Units.SI.Time firstMissed(start=0,fixed=true) "First missed";
  Boolean expired "Expired";

initial equation
  assert(deadline>=0 and capacity>=1 and maxRecords>=1,"Invalid queue dimensions or deadline.");
equation
  requestCount=matched+timedOut+censored+queueLength;
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=overflow;
  violationNow=(if false then gate.sampleInWindow else gate.inWindow) and dataOK and (false);
  dataStatus=if qualifyDeadline and gate.status==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE and (censored>0 or matched+timedOut==0) then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else gate.status;
  verdict=EvaluationLibrary.Utilities.Functions.ToVerdict(dataStatus,everViolated,qualifyDeadline);
  complete=gate.complete;
  result.value=value;
  result.valueAvailable=available and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(dataStatus);
  result.verdict=Integer(verdict);
  result.everViolated=everViolated;
  result.firstViolationTime=firstViolationTime;
  result.validDuration=gate.validDuration;
  result.expectedSamples=gate.expectedSamples;
  result.receivedSamples=gate.receivedSamples;
  result.validSamples=gate.validSamples;
  result.metricId=metricId;
  result.requirementId=requirementId;
  result.requirementVersion=requirementVersion;
  result.unit=unitName;
  result.windowStart=gate.actualStart;
  result.windowStop=gate.actualStop;
  result.observedDuration=gate.observedDuration;
  result.samplePeriod=if gate.sampled then samplePeriod else 0;
  result.evidenceKind=Integer(EvaluationLibrary.Utilities.Types.EvidenceKind.Event);
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable);
  result.eventCountsAvailable=not overflow and (gate.validDuration>0 or requestCount>0); result.eventCount=requestCount;
  result.matchedCount=matched;
  result.timedOutCount=timedOut;
  result.censoredCount=censored;
  result.levelAvailable=false;
  result.level=0;
  result.level0Upper=0;
  result.level1Upper=0;
  result.complete=complete;

  expired=pre(queueLength)>0 and time>=pre(timestamps[1])+deadline;
  value=if matched>0 then delaySum/matched else 0;
  available=matched>0;
  everViolated=timedOut>0;
  firstViolationTime=firstMissed;

algorithm
  when {initial(),request,response,expired,gate.complete} then
    (queueLength,matched,timedOut,censored,unmatchedResponse,overflow,timestamps,delays,delaySum,firstMissed):=
      EvaluationLibrary.Utilities.Internal.AdvanceFIFO(
        initial(),gate.inWindow,gate.complete,dataOK,
        request and (initial() or not pre(request)),response and (initial() or not pre(response)),
        time,gate.actualStop,deadline,capacity,
        pre(queueLength),pre(matched),pre(timedOut),pre(censored),pre(unmatchedResponse),pre(overflow),
        pre(timestamps),pre(delays),pre(delaySum),pre(firstMissed));
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,40},{-56,40},{-56,60},{-48,60},{-48,40},{-39,40},{-39,60},{-31,60},{-31,40}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{-20,49},{-5,49}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{4,62},{42,39}}, textString="req", textColor={128,128,128}, fontSize=0),
        Rectangle(extent={{-44,-7},{-16,23}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.65, radius=0),
        Rectangle(extent={{-8,-7},{20,23}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.65, radius=0),
        Rectangle(extent={{28,-7},{56,23}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.65, radius=0),
        Text(extent={{-41,21},{-19,-5}}, textString="1", textColor={0,0,127}, fontSize=0),
        Text(extent={{-5,21},{17,-5}}, textString="2", textColor={0,0,127}, fontSize=0),
        Text(extent={{31,21},{53,-5}}, textString="3", textColor={0,0,127}, fontSize=0),
        Line(points={{-55,-35},{-30,-35},{-30,-20}}, color={64,64,64}, thickness=0.75, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-51,8},{-66,8}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-13,-23},{65,-43}}, textString="feedback", textColor={64,64,64}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="FIFO", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Matches each valid response rising edge to the oldest outstanding request. Same-instant requests are queued before responses, and a response at the inclusive <code>deadline</code> is accepted. <code>value</code> is the mean matched delay; individual delays and event counts remain available.</p><p>Set <code>capacity</code>, <code>maxRecords</code> and the observation window. Unfinished follow-up at window closure is censored, while queue or record overflow invalidates the evidence. Enable <code>qualifyDeadline</code> to treat observed timeouts as requirement violations; otherwise the block is descriptive.</p></html>"));
end RepeatedResponse;
