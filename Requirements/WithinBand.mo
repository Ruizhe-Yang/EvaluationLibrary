within EvaluationLibrary.Requirements;
block WithinBand "Evaluate inclusive upper and lower bounds"
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

  parameter Real lower=0;
  parameter Real upper=1;
  parameter Real tolerance(min=0)=0;
  parameter Boolean sampled=false "Use only qualified samples on the declared sample grid";
    Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  output Real margin;
  Modelica.Blocks.Interfaces.RealOutput value annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=sampled,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable);
  Boolean dataOK;
  Boolean violationNow;
  Boolean qualifiedTick;
  Boolean sampleFailed;
initial equation
  assert(tolerance>=0 and tolerance<Modelica.Constants.inf and (abs(lower)<Modelica.Constants.inf and abs(upper)<Modelica.Constants.inf) and (lower<=upper),"Invalid bound or tolerance.");
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted and abs(u)<Modelica.Constants.inf;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=false;
  violationNow=(if sampled then gate.sampleInWindow else gate.inWindow) and dataOK and (if sampled then sampleFailed else margin<0);
  when {initial(),violationNow} then
    everViolated=(not initial() and pre(everViolated)) or violationNow;
    firstViolationTime=if violationNow and (initial() or not pre(everViolated)) then time
      else if initial() then 0 else pre(firstViolationTime);
  end when;
  dataStatus=gate.status;
  verdict=EvaluationLibrary.Utilities.Functions.ToVerdict(dataStatus,everViolated,true);
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

  margin=min(u-lower+tolerance,upper+tolerance-u);
  qualifiedTick=gate.tick and gate.sampleInWindow and dataOK;
  sampleFailed=qualifiedTick and margin<0;
  available=if sampled then gate.validSamples>0 else gate.validDuration>0 or everViolated;
  value=if available and not everViolated then 1 else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Rectangle(extent={{-57,-19},{60,36}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Dash, lineThickness=0.5, radius=0),
        Line(points={{-56,8},{-53.15,12.4355},{-50.3,16.6258},{-47.45,20.3395},{-44.6,23.3713},{-41.75,25.5537},{-38.9,26.7661},{-36.05,26.9414},{-33.2,26.0701},{-30.35,24.2002},{-27.5,21.435},{-24.65,17.9275},{-21.8,13.8713},{-18.95,9.49072},{-16.1,5.02775},{-13.25,0.729015},{-10.4,-3.16792},{-7.55,-6.44771},{-4.7,-8.92912},{-1.85,-10.475},{1,-11},{3.85,-10.475},{6.7,-8.92912},{9.55,-6.44771},{12.4,-3.16792},{15.25,0.729015},{18.1,5.02775},{20.95,9.49072},{23.8,13.8713},{26.65,17.9275},{29.5,21.435},{32.35,24.2002},{35.2,26.0701},{38.05,26.9414},{40.9,26.7661},{43.75,25.5537},{46.6,23.3713},{49.45,20.3395},{52.3,16.6258},{55.15,12.4355},{58,8}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="lo ≤ u ≤ hi", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Evaluate inclusive upper and lower bounds.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput; Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle; output EvaluationLibrary.Utilities.Types.DataStatus dataStatus; output EvaluationLibrary.Utilities.Types.Verdict verdict; output Boolean complete; output Boolean everViolated; output Modelica.Units.SI.Time firstViolationTime; EvaluationLibrary.Utilities.Interfaces.MetricOutput result; Modelica.Blocks.Interfaces.RealInput u; output Real margin; Modelica.Blocks.Interfaces.RealOutput value; Modelica.Blocks.Interfaces.BooleanOutput available</p><p><b>Parameters</b> parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime; parameter Modelica.Units.SI.Time windowStart=0; parameter Modelica.Units.SI.Time windowStop=5; parameter Boolean applicable=true; parameter Boolean useValidInput=false; parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01; parameter Modelica.Units.SI.Time sampleStart=0; parameter Real lower=0; parameter Real upper=1; parameter Real tolerance(min=0)=0; parameter Boolean sampled=false \"Use only qualified samples on the declared sample grid\"</p><p><b>Behavior</b> Evaluate inclusive upper and lower bounds</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> A first violation is retained even if later invalid data changes the verdict.</p><p><b>Observables</b> complete, everViolated, result, margin, value, available</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">EvaluationLibrary.Examples.BoundsAndValidWitness</a></p></html>"));
end WithinBand;
