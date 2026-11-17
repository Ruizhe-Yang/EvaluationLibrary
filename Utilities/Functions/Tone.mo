within EvaluationLibrary.Utilities.Functions;
function Tone "Project uniformly spaced samples onto a sinusoid"
  extends Modelica.Icons.Function;
input Real x[:] "Finite uniformly spaced sample values";
  input Modelica.Units.SI.Time period "Positive sample spacing";
  input Modelica.Units.SI.Frequency f "Projection frequency from DC to Nyquist";
  input EvaluationLibrary.Utilities.Types.Taper taper=EvaluationLibrary.Utilities.Types.Taper.Rectangular "Finite spectral taper; rectangular or Hann";
  input Boolean removeMean=false "Subtract the sample mean before spectral projection";
  output Real re "Normalised real part of the projection";
  output Real im "Normalised imaginary part of the projection";
  output Real amplitude "One-sided peak amplitude";
  output Real phase(unit="rad") "Phase relative to a cosine at the first sample";
protected
  Integer n=size(x,1) "Number of uniformly spaced samples";
  Real dc "Arithmetic mean removed from the samples";
  Real w "Weight of the current sample";
  Real wTotal "Sum of sample weights";
  Real angle "Projection angle for the current sample";
  Real scale "One-sided amplitude normalisation factor";
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
        Line(points={{-57.017,-6.596},{-55.8469,-3.7256},{-54.6767,-0.9573},{-53.5066,1.6119},{-52.3365,3.89},{-51.1663,5.7963},{-49.9962,7.2642},{-48.8261,8.2403},{-47.656,8.6914},{-46.4858,8.6012},{-45.3157,7.9722},{-44.1456,6.8277},{-42.9755,5.2065},{-41.8053,3.1684},{-40.6352,0.7839},{-39.4651,-1.8627},{-38.295,-4.6761},{-37.1248,-7.5576},{-35.9547,-10.4051},{-34.7846,-13.1181},{-33.6145,-15.5996},{-32.4444,-17.762},{-31.2743,-19.5295},{-30.1041,-20.8383},{-28.934,-21.6425},{-27.7638,-21.914},{-26.5938,-21.6425},{-25.4236,-20.8383},{-24.2535,-19.5295},{-23.0833,-17.762},{-21.9133,-15.5996},{-20.7431,-13.1181},{-19.573,-10.4051},{-18.4028,-7.5576},{-17.2327,-4.6761},{-16.0626,-1.8627},{-14.8925,0.7839},{-13.7223,3.1684},{-12.5522,5.2065},{-11.3821,6.8277},{-10.212,7.9722}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-5.957,-6.596},{11.063,-6.596}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Ellipse(extent={{15.318,-30.424},{57.868,12.126}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{36.593,-24.467},{36.593,7.02}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{19.573,-9.149},{53.613,-9.149}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{36.593,-9.149},{50.209,4.467}}, color={0,0,127}, thickness=1.2, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-29.785,-47.444},{29.785,-72.974}}, textString="f0", textColor={108,88,49}, fontSize=0)
      }),
    Documentation(info="<html><p>Calculate the complex projection, peak amplitude and phase of <code>x</code> at frequency <code>f</code>. The input contains 16 to 1024 uniformly spaced samples; <code>period</code> is positive and <code>f</code> lies between zero and the Nyquist frequency.</p><p>An optional arithmetic-mean subtraction precedes rectangular or symmetric Hann weighting. The projection is normalised by the sum of weights, with a factor of two except at DC and Nyquist. Phase uses a cosine reference at the first sample. The caller is responsible for finite, valid sample values.</p></html>"));
end Tone;
