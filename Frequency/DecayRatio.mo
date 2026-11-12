within EvaluationLibrary.Frequency;
block DecayRatio "Measure attenuation across qualified positive sampled peaks"
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

  parameter Real peakFloor(min=0)=1e-8;
  parameter Real growthTolerance(min=0)=1e-5;
    Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  output Integer peakCount(start=0,fixed=true);
  output Real ratio;
  output Real logarithmicDecrement;
  Modelica.Blocks.Interfaces.RealOutput value annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=true,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable);
  Boolean dataOK;
  Boolean violationNow;
  discrete Real secondLast(start=0,fixed=true);
  discrete Real last(start=0,fixed=true);
  discrete Integer seen(start=0,fixed=true);
  discrete Real previousPeak(start=0,fixed=true);
  discrete Real ratioSum(start=0,fixed=true);
  discrete Real logSum(start=0,fixed=true);
  discrete Boolean grew(start=false,fixed=true);
initial equation
  assert(peakFloor>0 and growthTolerance>=0,"Invalid peak thresholds.");
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted and abs(u)<Modelica.Constants.inf;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=grew;
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

  available=peakCount>=3 and not grew and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  ratio=if available then ratioSum/(peakCount-1) else 0;
  logarithmicDecrement=if available then logSum/(peakCount-1) else 0;
  value=ratio;
algorithm

  when gate.tick and gate.sampleInWindow and dataOK then
    if seen>=2 and last>peakFloor and last>secondLast and last>=u then
      if peakCount>0 then
        grew:=pre(grew) or last>previousPeak*(1+growthTolerance);
        ratioSum:=pre(ratioSum)+last/previousPeak;
        logSum:=pre(logSum)+log(previousPeak/last);
      end if;
      peakCount:=pre(peakCount)+1;
      previousPeak:=last;
    end if;
    secondLast:=last;
    last:=u;
    seen:=pre(seen)+1;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-56,3},{-53.15,23.0146},{-50.3,37.1822},{-47.45,42.995},{-44.6,39.9092},{-41.75,29.3},{-38.9,14.0153},{-36.05,-2.34426},{-33.2,-16.2449},{-30.35,-24.959},{-27.5,-27.0734},{-24.65,-22.6807},{-21.8,-13.2363},{-18.95,-1.14136},{-16.1,10.8403},{-13.25,20.1941},{-10.4,25.1638},{-7.55,25.0597},{-4.7,20.3173},{-1.85,12.3135},{1,3},{3.85,-5.55454},{6.7,-11.61},{9.55,-14.0944},{12.4,-12.7755},{15.25,-8.241},{18.1,-1.70809},{20.95,5.28422},{23.8,11.2256},{26.65,14.9501},{29.5,15.8538},{32.35,13.9763},{35.2,9.93963},{38.05,4.77008},{40.9,-0.351079},{43.75,-4.34903},{46.6,-6.47313},{49.45,-6.42865},{52.3,-4.40167},{55.15,-0.980719},{58,3}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Ellipse(extent={{-51,39},{-43,47}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-13,22},{-5,30}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{25,12},{33,20}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Text(extent={{-65,-50},{65,-75}}, textString="Aᵢ₊₁ / Aᵢ", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Measure attenuation across qualified positive sampled peaks.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput; Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle; output EvaluationLibrary.Utilities.Types.DataStatus dataStatus; output EvaluationLibrary.Utilities.Types.Verdict verdict; output Boolean complete; output Boolean everViolated; output Modelica.Units.SI.Time firstViolationTime; EvaluationLibrary.Utilities.Interfaces.MetricOutput result; Modelica.Blocks.Interfaces.RealInput u; output Integer peakCount(start=0,fixed=true); output Real ratio; output Real logarithmicDecrement; Modelica.Blocks.Interfaces.RealOutput value; Modelica.Blocks.Interfaces.BooleanOutput available</p><p><b>Parameters</b> parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime; parameter Modelica.Units.SI.Time windowStart=0; parameter Modelica.Units.SI.Time windowStop=5; parameter Boolean applicable=true; parameter Boolean useValidInput=false; parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01; parameter Modelica.Units.SI.Time sampleStart=0; parameter Real peakFloor(min=0)=1e-8; parameter Real growthTolerance(min=0)=1e-5</p><p><b>Behavior</b> Measure attenuation across qualified positive sampled peaks</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Requires at least three qualified positive peaks of the declared oscillation. A finite observation cannot establish global stability.</p><p><b>Observables</b> complete, everViolated, result, peakCount, ratio, logarithmicDecrement, value, available</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.DecayMeasurement\">EvaluationLibrary.Examples.DecayMeasurement</a></p></html>"));
end DecayRatio;
