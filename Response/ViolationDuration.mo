within EvaluationLibrary.Response;
block ViolationDuration "Measure cumulative and longest continuous valid violation segments"
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
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "Host declares the observed inputs valid" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle "External observation gate; only the first contiguous interval is accepted" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus "Evidence qualification independent of requirement verdict";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement decision independent of observation completeness";
  output Boolean complete "Collection has closed; inspect DataStatus before assuming full evidence";
  output Boolean everViolated "A qualified violation witness exists";
  output Modelica.Units.SI.Time firstViolationTime "First qualified violation instant; meaningful only when everViolated";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Complete directly reportable evidence result" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput u "Observed Boolean condition" annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput total(unit="s",start=0,fixed=true) "Total" annotation(Placement(transformation(origin={100,42},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,42},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput longest(unit="s") "Longest" annotation(Placement(transformation(origin={100,14},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,14},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput occurrences(start=0,fixed=true) "Occurrences" annotation(Placement(transformation(origin={100,-14},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-14},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput value "Numerical metric; meaningful only when available" annotation(Placement(transformation(origin={100,-42},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-42},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "The numerical output exists in the current data domain" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Trusted" annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "External window" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=false,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Gate";
  Boolean dataOK "Data ok";
  Boolean violationNow "Violation now";
  Boolean during "During";
  discrete Modelica.Units.SI.Time began(start=0,fixed=true) "Began";
  discrete Modelica.Units.SI.Time completedLongest(start=0,fixed=true) "Completed longest";
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
    Documentation(info="<html><p>Integrate qualified residence of true u in seconds. Continuous true intervals and repeated intervals contribute to total duration. No requirement threshold is inferred; use PersistenceLimit for a bound on the longest uninterrupted interval.</p><p>The default fixed observation is [0,5) s. ExternalSingle instead observes only the first contiguous external gate; a later gate invalidates the history. useValidInput defaults to false; when enabled, false validity or nonfinite in-window data latch INVALID. Early normal termination or missing coverage is INCOMPLETE. DataStatus qualifies evidence independently of Verdict. Numeric availability and violation witnesses must be inspected separately. Stable identity, unitName and optional requirement metadata originate here and travel directly with result to a writer.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end ViolationDuration;
