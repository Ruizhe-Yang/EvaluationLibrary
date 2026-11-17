within EvaluationLibrary.Statistics;
block SampleVariance "Sample variance with a configurable degrees-of-freedom correction"
  parameter String metricId=getInstanceName() "Metric identifier";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Requirement version";
  parameter String unitName="1" "Engineering unit of the reported value";
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime "Fixed interval or first contiguous external window";
  parameter Modelica.Units.SI.Time windowStart=0 "Inclusive observation start";
  parameter Modelica.Units.SI.Time windowStop=5 "Exclusive observation stop";
  parameter Boolean applicable=true "Whether this evaluation applies";
  parameter Boolean useValidInput=false "Enable the external validity input";

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Uniform sampling interval; must be positive";
  parameter Modelica.Units.SI.Time sampleStart=0 "Origin of the uniform sampling grid";
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "External input-validity condition" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle "External observation gate; only the first contiguous interval is accepted" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus "Status of the observation data";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement verdict";
  output Boolean complete "True when collection has closed; check data status for completeness";
  output Boolean everViolated "True if a valid violation has been observed";
  output Modelica.Units.SI.Time firstViolationTime "First valid violation time; meaningful when everViolated is true";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Result record with value, status and observation metadata" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput u "Observed signal" annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput value "Numerical value; check result.valueAvailable" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True when the numerical value is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
  output Integer nValid "Number of valid observations";
  parameter Integer ddof(min=0)=1 "Variance denominator correction; valid sample count must exceed it";
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Internal validity signal" annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "Internal external-window signal" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=true,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Observation-window qualification";
  Boolean dataOK "Combined input validity";
  Boolean violationNow "Current valid violation condition";
  EvaluationLibrary.Utilities.Internal.SampleAccumulator acc "Continuous or sampled accumulator";
initial equation
  assert(ddof>=0,"Negative degrees correction.");
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted and abs(u)<Modelica.Constants.inf;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=gate.complete and acc.count>0 and acc.count<=ddof;
  violationNow=(if true then gate.sampleInWindow else gate.inWindow) and dataOK and (false);
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
  result.evidenceKind=Integer(EvaluationLibrary.Utilities.Types.EvidenceKind.Sampled);
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

  connect(u,acc.u);
  acc.take=gate.tick and gate.sampleInWindow and dataOK;
  nValid=acc.count;
  available=acc.count>ddof and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  value=if available then max(0,acc.m2)/(acc.count-ddof) else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,61},{-64,-38},{65,-38}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-51,-38},{-51,-7}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-27,-38},{-27,38}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-3,-38},{-3,12}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{21,-38},{21,-17}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{45,-38},{45,29}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{-54.4,-10.4},{-47.6,-3.6}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{-30.4,34.6},{-23.6,41.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{-6.4,8.6},{0.4,15.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{17.6,-20.4},{24.4,-13.6}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{41.6,25.6},{48.4,32.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{-57,10},{59,10}}, color={95,115,95}, thickness=0.6, pattern=LinePattern.Dash),
        Line(points={{-27,10},{-27,38}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{21,10},{21,-17}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="s²[k]", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Uses a one-pass centred sum of squares divided by <code>nValid - ddof</code>. Set <code>ddof=1</code> for corrected sample variance or <code>ddof=0</code> for population variance. The result has the input unit squared and requires <code>nValid &gt; ddof</code>. A non-empty record that remains too short at closure is invalid.</p><p>Sampling uses <code>sampleStart + k*samplePeriod</code> within the half-open observation interval. Configure <code>windowStart</code> and <code>windowStop</code>, or select <code>ExternalSingle</code> and connect a single contiguous <code>window</code> interval. External validity is optional. Inspect <code>result.dataStatus</code> separately from numerical availability; sampled results do not describe behaviour between ticks.</p></html>"));
end SampleVariance;
