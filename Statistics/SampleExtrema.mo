within EvaluationLibrary.Statistics;
block SampleExtrema "Sampled extrema, occurrence times and peak-to-peak range"
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
  Modelica.Blocks.Interfaces.RealOutput value "Numerical value; check result.valueAvailable" annotation(Placement(transformation(origin={100,50},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,50},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True when the numerical value is available" annotation(Placement(transformation(origin={100,30},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,30},extent={{-10,-10},{10,10}})));
  output Integer nValid "Number of valid observations";
  Modelica.Blocks.Interfaces.RealOutput minimum "Smallest accepted sample" annotation(Placement(transformation(origin={100,10},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,10},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput maximum "Greatest accepted sample" annotation(Placement(transformation(origin={100,-10},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-10},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput argminTime(unit="s") "First occurrence of the minimum" annotation(Placement(transformation(origin={100,-30},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-30},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput argmaxTime(unit="s") "First occurrence of the maximum" annotation(Placement(transformation(origin={100,-50},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-50},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput peakToPeak "Maximum minus minimum" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Internal validity signal" annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "Internal external-window signal" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=true,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Observation-window qualification";
  Boolean dataOK "Combined input validity";
  Boolean violationNow "Current valid violation condition";
  EvaluationLibrary.Utilities.Internal.SampleAccumulator acc "Continuous or sampled accumulator";
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted and abs(u)<Modelica.Constants.inf;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=false;
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
  available=acc.count>0 and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  value=if available then maximum else 0;
  minimum=acc.minimum;
  maximum=acc.maximum;
  argminTime=acc.argminTime;
  argmaxTime=acc.argmaxTime;
  peakToPeak=maximum-minimum;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,61},{-64,-38},{65,-38}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-52,-38},{-52,1}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-29,-38},{-29,41}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-6,-38},{-6,-19}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{17,-38},{17,18}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{40,-38},{40,29}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{-55.2,-2.2},{-48.8,4.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{-32.2,37.8},{-25.8,44.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{-9.2,-22.2},{-2.8,-15.8}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{13.8,14.8},{20.2,21.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{36.8,25.8},{43.2,32.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{-55,41},{58,41}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Dash),
        Line(points={{-55,-19},{58,-19}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Dash),
        Line(points={{58,-19},{58,41}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Ellipse(extent={{-35,35},{-23,47}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.85),
        Ellipse(extent={{-12,-25},{0,-13}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.85),
        Text(extent={{-65,-50},{65,-75}}, textString="min, max, Δ", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Tracks the minimum and maximum accepted values of <code>u</code>, their first occurrence times, and the peak-to-peak range. Equal later values retain the original occurrence time. At least one accepted sample is required. <code>result.value</code> reports the maximum.</p><p>Sampling uses <code>sampleStart + k*samplePeriod</code> within the half-open observation interval. Configure <code>windowStart</code> and <code>windowStop</code>, or select <code>ExternalSingle</code> and connect a single contiguous <code>window</code> interval. External validity is optional. Inspect <code>result.dataStatus</code> separately from numerical availability; sampled results do not describe behaviour between ticks.</p></html>"));
end SampleExtrema;
