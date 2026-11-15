within EvaluationLibrary.Response;
block RepeatedResponse "Pair repeated qualified events using a finite FIFO and explicit deadline"
  parameter String metricId=getInstanceName() "Stable metric identity";
  parameter String requirementId="" "Requirement identity; empty for a statistic";
  parameter String requirementVersion="" "Interpreted requirement version";
  parameter String unitName="s" "Engineering unit of the reported value";
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime "Fixed-time or first externally gated observation window";
  parameter Modelica.Units.SI.Time windowStart=0 "Inclusive observation start in seconds";
  parameter Modelica.Units.SI.Time windowStop=5 "Exclusive observation stop in seconds";
  parameter Boolean applicable=true "Whether this evaluation applies";
  parameter Boolean useValidInput=false "Expose the host-provided validity connector";

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Positive uniform sampling interval in seconds";
  parameter Modelica.Units.SI.Time sampleStart=0 "Uniform sample grid origin in seconds";
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "Host declares the observed inputs valid" annotation(Placement(transformation(origin={70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={70,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle "External observation gate; only the first contiguous interval is accepted" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus "Evidence qualification independent of requirement verdict";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement decision independent of observation completeness";
  output Boolean complete "Collection has closed; inspect DataStatus before assuming full evidence";
  output Boolean everViolated "A qualified violation witness exists";
  output Modelica.Units.SI.Time firstViolationTime "First qualified violation instant; meaningful only when everViolated";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Complete directly reportable evidence result" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));

  parameter Modelica.Units.SI.Time deadline(min=0)=0.2 "Maximum request-response delay in seconds, inclusive";
  parameter Boolean qualifyDeadline=false "Classify the result as a deadline requirement";
  parameter Integer capacity(min=1)=64 "Positive bounded event-queue capacity";
  parameter Integer maxRecords(min=1)=128 "Maximum stored matched delays";
    Modelica.Blocks.Interfaces.BooleanInput request "Request" annotation(Placement(transformation(origin={-70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={-70,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput response "Response" annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput matched(start=0,fixed=true) "Matched" annotation(Placement(transformation(origin={100,50},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,50},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput timedOut(start=0,fixed=true) "Timed out" annotation(Placement(transformation(origin={100,30},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,30},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput censored(start=0,fixed=true) "Censored" annotation(Placement(transformation(origin={100,10},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,10},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput unmatchedResponse(start=0,fixed=true) "Unmatched response" annotation(Placement(transformation(origin={100,-10},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-10},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput overflow(start=false,fixed=true) "Overflow" annotation(Placement(transformation(origin={100,-30},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-30},extent={{-10,-10},{10,10}})));
  discrete Modelica.Units.SI.Time delays[maxRecords](each start=0,each fixed=true) "Delays";
  output Integer queueLength(start=0,fixed=true) "Queue length";

  Modelica.Blocks.Interfaces.RealOutput value "Numerical metric; meaningful only when available" annotation(Placement(transformation(origin={100,-50},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-50},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "The numerical output exists in the current data domain" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
  output Integer requestCount "Accepted requests; a full count is unavailable after overflow";
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Trusted" annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "External window" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=false,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Gate";
  Boolean dataOK "Data ok";
  Boolean violationNow "Violation now";

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
    Documentation(info="<html><p>Queue qualified rising requests and match each actual response to at most one oldest request. deadline defaults to 0.2 s, capacity to 64 queued requests and maxRecords to 128 retained delays; capacities must be positive. Requests precede same-instant feedback, deadline equality is accepted, and follow-up beyond the exclusive stop is censored. The numeric result is mean retained delay in seconds. qualifyDeadline defaults to false; enabling it makes recorded timeouts requirement violations. Overflow invalidates evidence. Individual delays and externally gated observation give this specialist value beyond the shared-window EventAssessment summary. The pure explicit-state AdvanceFIFO function preserves the prior pairing mathematics while avoiding a discrete initialization cycle.</p><p>The default fixed observation is [0,5) s. ExternalSingle instead observes only the first contiguous external gate; a later gate invalidates the history. useValidInput defaults to false; when enabled, false validity or nonfinite in-window data latch INVALID. Early normal termination or missing coverage is INCOMPLETE. DataStatus qualifies evidence independently of Verdict. Numeric availability and violation witnesses must be inspected separately. Stable identity, unitName and optional requirement metadata originate here and travel directly with result to a writer.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end RepeatedResponse;
