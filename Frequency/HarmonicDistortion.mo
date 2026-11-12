within EvaluationLibrary.Frequency;
block HarmonicDistortion "Compare harmonic magnitudes with the selected fundamental"
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
  parameter Integer nSamples(min=16,max=1024)=200;
  parameter EvaluationLibrary.Utilities.Types.Taper taper=EvaluationLibrary.Utilities.Types.Taper.Rectangular;
  parameter Boolean removeMean=false;
    Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  output Modelica.Units.SI.Frequency frequencyResolution;
  output Modelica.Units.SI.Frequency nyquist;

  parameter Modelica.Units.SI.Frequency fundamental(min=0)=5;
  parameter Integer harmonics(min=2)=4;
  parameter Real amplitudeFloor(min=0)=1e-8;
  output Real amplitude[harmonics](each start=0,each fixed=true);
  output Real thd;
  Modelica.Blocks.Interfaces.RealOutput value annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=true,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable);
  Boolean dataOK;
  Boolean violationNow;
  EvaluationLibrary.Utilities.Internal.SpectrumBuffer cache(n=nSamples);
  discrete Real re(start=0,fixed=true);
  discrete Real im(start=0,fixed=true);
  discrete Real phase(start=0,fixed=true);
initial equation
  assert(nSamples>=16 and nSamples<=1024,"Invalid spectral sample count.");
  assert(fundamental>0 and harmonics>=2 and harmonics*fundamental*samplePeriod<0.5 and amplitudeFloor>=0,"A harmonic is outside the allowed range.");
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted and abs(u)<Modelica.Constants.inf;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=cache.overflow or (cache.ready and gate.complete and amplitude[1]<=amplitudeFloor);
  violationNow=(if true then gate.sampleInWindow else gate.inWindow) and dataOK and (false);
  when {initial(),violationNow} then
    everViolated=(not initial() and pre(everViolated)) or violationNow;
    firstViolationTime=if violationNow and (initial() or not pre(everViolated)) then time
      else if initial() then 0 else pre(firstViolationTime);
  end when;
  dataStatus=if gate.status==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE and cache.count<>nSamples then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else gate.status;
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

  cache.u=u;
  cache.take=gate.sampleInWindow and dataOK and gate.tick;
  frequencyResolution=1/(nSamples*samplePeriod);
  nyquist=1/(2*samplePeriod);

  thd=if available then sqrt(sum({amplitude[h]^2 for h in 2:harmonics}))/amplitude[1] else 0;
  value=thd;
  available=cache.ready and gate.complete and dataStatus==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE and (amplitude[1]>amplitudeFloor);
algorithm
  when cache.ready then
    for h in 1:harmonics loop
      (re,im,amplitude[h],phase):=EvaluationLibrary.Utilities.Functions.Tone(cache.samples,samplePeriod,h*fundamental,taper,removeMean);
    end for;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-34},{65,-34}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-43,-34},{-43,36}}, color={0,0,127}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{-15,-34},{-15,-5}}, color={0,0,127}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{13,-34},{13,-16}}, color={0,0,127}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{41,-34},{41,-24}}, color={0,0,127}, thickness=1.3, pattern=LinePattern.Solid),
        Ellipse(extent={{-46,33},{-40,39}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-18,-8},{-12,-2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{10,-19},{16,-13}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{38,-27},{44,-21}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Text(extent={{-50,-36},{-29,-49}}, textString="1", textColor={64,64,64}, fontSize=0),
        Text(extent={{-22,-36},{-1,-49}}, textString="2", textColor={64,64,64}, fontSize=0),
        Text(extent={{6,-36},{27,-49}}, textString="3", textColor={64,64,64}, fontSize=0),
        Text(extent={{34,-36},{55,-49}}, textString="4", textColor={64,64,64}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="THD", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Compare harmonic magnitudes with the selected fundamental.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput; Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle; output EvaluationLibrary.Utilities.Types.DataStatus dataStatus; output EvaluationLibrary.Utilities.Types.Verdict verdict; output Boolean complete; output Boolean everViolated; output Modelica.Units.SI.Time firstViolationTime; EvaluationLibrary.Utilities.Interfaces.MetricOutput result; Modelica.Blocks.Interfaces.RealInput u; output Modelica.Units.SI.Frequency frequencyResolution; output Modelica.Units.SI.Frequency nyquist; output Real amplitude[harmonics](each start=0,each fixed=true); output Real thd; Modelica.Blocks.Interfaces.RealOutput value; Modelica.Blocks.Interfaces.BooleanOutput available</p><p><b>Parameters</b> parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime; parameter Modelica.Units.SI.Time windowStart=0; parameter Modelica.Units.SI.Time windowStop=5; parameter Boolean applicable=true; parameter Boolean useValidInput=false; parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01; parameter Modelica.Units.SI.Time sampleStart=0; parameter Integer nSamples(min=16,max=1024)=200; parameter EvaluationLibrary.Utilities.Types.Taper taper=EvaluationLibrary.Utilities.Types.Taper.Rectangular; parameter Boolean removeMean=false; parameter Modelica.Units.SI.Frequency fundamental(min=0)=5; parameter Integer harmonics(min=2)=4; parameter Real amplitudeFloor(min=0)=1e-8</p><p><b>Behavior</b> Compare harmonic magnitudes with the selected fundamental</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> THD is a fraction. Tones must be sufficiently separated and the fundamental must exceed the declared floor.</p><p><b>Observables</b> complete, everViolated, result, amplitude, thd, value, available</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.HarmonicMeasurements\">EvaluationLibrary.Examples.HarmonicMeasurements</a></p></html>"));
end HarmonicDistortion;
