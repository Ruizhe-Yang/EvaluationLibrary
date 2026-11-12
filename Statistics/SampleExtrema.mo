within EvaluationLibrary.Statistics;
block SampleExtrema "Sample extrema with first time witnesses and peak-to-peak value"
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime;
  parameter Modelica.Units.SI.Time windowStart=0;
  parameter Modelica.Units.SI.Time windowStop=5;
  parameter Boolean applicable=true;
  parameter Boolean useValidInput=false;

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01;
  parameter Modelica.Units.SI.Time sampleStart=0;
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus;
  output EvaluationLibrary.Utilities.Types.Verdict verdict;
  output Boolean complete;
  output Boolean everViolated;
  output Modelica.Units.SI.Time firstViolationTime;
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput value annotation(Placement(transformation(origin={100,50},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,50},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available annotation(Placement(transformation(origin={100,30},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,30},extent={{-10,-10},{10,10}})));
  output Integer nValid;
  Modelica.Blocks.Interfaces.RealOutput minimum annotation(Placement(transformation(origin={100,10},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,10},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput maximum annotation(Placement(transformation(origin={100,-10},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-10},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput argminTime(unit="s") annotation(Placement(transformation(origin={100,-30},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-30},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput argmaxTime(unit="s") annotation(Placement(transformation(origin={100,-50},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-50},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput peakToPeak annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=true,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable);
  Boolean dataOK;
  Boolean violationNow;
  EvaluationLibrary.Utilities.Internal.SampleAccumulator acc;
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
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-56,-7},{-34,37},{-11,14},{15,-23},{37,12},{56,29}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Ellipse(extent={{-59,-10},{-53,-4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-37,34},{-31,40}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-14,11},{-8,17}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{12,-26},{18,-20}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{34,9},{40,15}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{53,26},{59,32}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-40,31},{-28,43}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=1),
        Ellipse(extent={{9,-29},{21,-17}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=1),
        Text(extent={{-65,-50},{65,-75}}, textString="min / max", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Sample extrema with first time witnesses and peak-to-peak value.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput; Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle; output EvaluationLibrary.Utilities.Types.DataStatus dataStatus; output EvaluationLibrary.Utilities.Types.Verdict verdict; output Boolean complete; output Boolean everViolated; output Modelica.Units.SI.Time firstViolationTime; EvaluationLibrary.Utilities.Interfaces.MetricOutput result; Modelica.Blocks.Interfaces.RealInput u; Modelica.Blocks.Interfaces.RealOutput value; Modelica.Blocks.Interfaces.BooleanOutput available; output Integer nValid; Modelica.Blocks.Interfaces.RealOutput minimum; Modelica.Blocks.Interfaces.RealOutput maximum; Modelica.Blocks.Interfaces.RealOutput argminTime(unit=\"s\"); Modelica.Blocks.Interfaces.RealOutput argmaxTime(unit=\"s\"); Modelica.Blocks.Interfaces.RealOutput peakToPeak</p><p><b>Parameters</b> parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime; parameter Modelica.Units.SI.Time windowStart=0; parameter Modelica.Units.SI.Time windowStop=5; parameter Boolean applicable=true; parameter Boolean useValidInput=false; parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01; parameter Modelica.Units.SI.Time sampleStart=0</p><p><b>Behavior</b> Sample extrema with first time witnesses and peak-to-peak value</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Only grid samples are evaluated. Zero or insufficient data cannot establish a complete result.</p><p><b>Observables</b> complete, everViolated, result, value, available, nValid, minimum, maximum, argminTime, argmaxTime</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.AnalyticStatistics\">EvaluationLibrary.Examples.AnalyticStatistics</a></p></html>"));
end SampleExtrema;
