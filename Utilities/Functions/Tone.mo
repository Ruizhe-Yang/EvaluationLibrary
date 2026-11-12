within EvaluationLibrary.Utilities.Functions;
function Tone "Project finite uniformly spaced samples onto a complex sinusoid"
  extends Modelica.Icons.Function;
input Real x[:];
  input Modelica.Units.SI.Time period;
  input Modelica.Units.SI.Frequency f;
  input EvaluationLibrary.Utilities.Types.Taper taper=EvaluationLibrary.Utilities.Types.Taper.Rectangular;
  input Boolean removeMean=false;
  output Real re;
  output Real im;
  output Real amplitude;
  output Real phase(unit="rad");
protected
  Integer n=size(x,1);
  Real dc;
  Real w;
  Real wTotal;
  Real angle;
  Real scale;
algorithm
  assert(n>=16 and n<=1024 and period>0 and f>=0 and f<=1/(2*period),"Invalid finite spectral projection.");
  dc:=if removeMean then sum(x)/n else 0;
  re:=0; im:=0; wTotal:=0;
  for k in 1:n loop
    w:=if taper==EvaluationLibrary.Utilities.Types.Taper.Rectangular then 1 else 0.5-0.5*cos(2*Modelica.Constants.pi*(k-1)/(n-1));
    angle:=2*Modelica.Constants.pi*f*(k-1)*period;
    re:=re+w*(x[k]-dc)*cos(angle);
    im:=im-w*(x[k]-dc)*sin(angle);
    wTotal:=wTotal+w;
  end for;
  scale:=(if f<=0 or f>=1/(2*period) then 1 else 2)/wTotal;
  re:=scale*re; im:=scale*im;
  amplitude:=sqrt(re^2+im^2);
  phase:=Modelica.Math.atan2(im,re);
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Line(points={{-36.04,-19.68},{-36.04,27.92}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-36.04,-19.68},{33.32,-19.68}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-36.04,-19.68},{16.32,23.16}}, color={0,0,127}, thickness=1.2, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{16.32,-19.68},{16.32,23.16}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Text(extent={{-65,-55},{65,-78}}, textString="Re, Im", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Project finite uniformly spaced samples onto a complex sinusoid.</p><p><b>Interfaces</b> input Real x[:]; input Modelica.Units.SI.Time period; input Modelica.Units.SI.Frequency f; input EvaluationLibrary.Utilities.Types.Taper taper=EvaluationLibrary.Utilities.Types.Taper.Rectangular; input Boolean removeMean=false; output Real re; output Real im; output Real amplitude; output Real phase(unit=\"rad\")</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Project finite uniformly spaced samples onto a complex sinusoid</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> The phase origin is the first accepted sample. Off-grid tones have finite-window leakage.</p><p><b>Observables</b> re, im, amplitude, phase</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.HarmonicMeasurements\">EvaluationLibrary.Examples.HarmonicMeasurements</a></p></html>"));
end Tone;
