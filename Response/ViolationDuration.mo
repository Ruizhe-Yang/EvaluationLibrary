within EvaluationLibrary.Response;
block ViolationDuration "Measure total and longest continuous true durations"
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
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "True if the observed inputs are valid" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle "External observation gate; only the first contiguous interval is accepted" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus "Observation coverage and data validity";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement outcome, separate from data qualification";
  output Boolean complete "Observation has ended; completeness is reported by dataStatus";
  output Boolean everViolated "True after a valid violation has been observed";
  output Modelica.Units.SI.Time firstViolationTime "Time of the first valid violation";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Value, qualification and requirement outcome" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput u "Observed Boolean condition" annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput total(unit="s",start=0,fixed=true) "Cumulative valid true duration" annotation(Placement(transformation(origin={100,42},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,42},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput longest(unit="s") "Longest uninterrupted valid true interval" annotation(Placement(transformation(origin={100,14},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,14},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput occurrences(start=0,fixed=true) "Number of valid true interval starts" annotation(Placement(transformation(origin={100,-14},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-14},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput value "Numerical result; meaningful only when available" annotation(Placement(transformation(origin={100,-42},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-42},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True if the numerical result is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Effective input validity" annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "External window" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=false,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Observation window and data qualification";
  Boolean dataOK "True if input validity and numerical checks pass";
  Boolean violationNow "Valid requirement violation at the current instant";
  Boolean during "Valid true condition inside the observation window";
  discrete Modelica.Units.SI.Time began(start=0,fixed=true) "Start time of the active true interval";
  discrete Modelica.Units.SI.Time completedLongest(start=0,fixed=true) "Longest completed true interval";
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=false;
  violationNow=(if false then gate.sampleInWindow else gate.inWindow) and dataOK and (false);
  when {initial(),violationNow} then
    everViolated=(not initial() and pre(everViolated)) or violationNow;
    firstViolationTime=if violationNow and (initial() or not pre(everViolated)) then time
      else if initial() then 0 else pre(firstViolationTime);
  end when;
  dataStatus=gate.status;
  verdict=EvaluationLibrary.Utilities.Functions.ToVerdict(dataStatus,everViolated,false);
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
  result.eventCountsAvailable=false; result.eventCount=0;
  result.matchedCount=0;
  result.timedOutCount=0;
  result.censoredCount=0;
  result.levelAvailable=false;
  result.level=0;
  result.level0Upper=0;
  result.level1Upper=0;
  result.complete=complete;


  during=gate.inWindow and dataOK and u;
  der(total)=if during then 1 else 0;
  when {initial(),change(during)} then
    began=if initial() or during then time else pre(began);
    completedLongest=if initial() then 0 elseif not during then max(pre(completedLongest),time-pre(began)) else pre(completedLongest);
    occurrences=(if initial() then 0 else pre(occurrences))+(if during then 1 else 0);
  end when;
  longest=max(completedLongest,if during then time-began else 0);
  value=total;
  available=gate.validDuration>0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-51,-22},{-31,32}}, lineColor={235,235,235}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.1, radius=0),
        Rectangle(extent={{-3,-22},{42,32}}, lineColor={235,235,235}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.1, radius=0),
        Line(points={{-65,-22},{-51,-22},{-51,32},{-31,32},{-31,-22},{-3,-22},{-3,32},{42,32},{42,-22},{65,-22}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-51,-36},{-31,-36}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-51,-41},{-51,-31}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-31,-41},{-31,-31}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-3,-36},{42,-36}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-3,-41},{-3,-31}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{42,-41},{42,-31}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="sum(dt)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Integrates the time for which <code>u</code> is true and valid within the observation window. <code>total</code> and <code>value</code> report cumulative duration, <code>longest</code> reports the longest uninterrupted interval and <code>occurrences</code> counts interval starts.</p><p>Configure the window and optional validity input. A false condition, invalid gap or closed window ends the active interval. This block measures durations without applying a maximum-duration requirement.</p></html>"));
end ViolationDuration;
