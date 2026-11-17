within EvaluationLibrary.Utilities.Internal;
function oneSidedDFT "Calculate non-negative discrete Fourier transform bins"
  input Real x[:] "Finite uniformly spaced sample values";
  input Integer nBins "Highest nonnegative bin";
  input EvaluationLibrary.Utilities.Types.SpectralWindow window "Finite spectral window selection";
  input Real amplitudeFloor "Positive amplitude below which phase or ratios are undefined";
  output Real bins[nBins+1,2] "Peak amplitude and phase for each retained bin";
protected
  Integer n = size(x,1) "Number of input samples";
  Real w[size(x,1)] "Sample weights";
  Real coherentSum "Sum of sample weights";
  Real a "Real part of the weighted Fourier sum";
  Real b "Imaginary part of the weighted Fourier sum";
  Real angle "Fourier angle for the current bin and sample";
algorithm
  for j in 1:n loop
    w[j] := if window == EvaluationLibrary.Utilities.Types.SpectralWindow.Hann then
      0.5*(1-cos(2*Modelica.Constants.pi*(j-1)/n)) else 1;
  end for;
  coherentSum := sum(w);
  for k in 0:nBins loop
    a := 0;
    b := 0;
    for j in 1:n loop
      angle := 2*Modelica.Constants.pi*k*(j-1)/n;
      a := a+w[j]*x[j]*cos(angle);
      b := b-w[j]*x[j]*sin(angle);
    end for;
    bins[k+1,1] := (if k==0 or 2*k==n then 1 else 2)*sqrt(a^2+b^2)/coherentSum;
    bins[k+1,2] := if bins[k+1,1]>amplitudeFloor then Modelica.Math.atan2(b,a) else 0;
  end for;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Line(points={{-57.868,-33.828},{-57.868,19.785}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-52.762,-28.722},{-52.762,-4.043}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Ellipse(extent={{-55.315,-6.596},{-50.209,-1.49}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{-41.699,-28.722},{-41.699,12.126}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Ellipse(extent={{-44.252,9.573},{-39.146,14.679}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{-30.636,-28.722},{-30.636,1.914}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Ellipse(extent={{-33.189,-0.639},{-28.083,4.467}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{-21.275,-7.447},{-0.851,-7.447}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{4.255,24.04},{4.255,-33.828},{59.57,-33.828}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{11.063,-33.828},{11.063,-17.659}}, color={0,0,127}, thickness=1.8, pattern=LinePattern.Solid),
        Line(points={{26.381,-33.828},{26.381,16.381}}, color={0,0,127}, thickness=1.8, pattern=LinePattern.Solid),
        Line(points={{41.699,-33.828},{41.699,1.063}}, color={0,0,127}, thickness=1.8, pattern=LinePattern.Solid),
        Line(points={{55.315,-33.828},{55.315,-13.404}}, color={0,0,127}, thickness=1.8, pattern=LinePattern.Solid),
        Text(extent={{-50.209,-46.593},{51.911,-72.974}}, textString="f >= 0", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Calculate peak amplitude and phase for bins zero through <code>nBins</code>. Rectangular or periodic Hann weights are normalised by their sum. Non-DC, non-Nyquist bins receive the one-sided factor of two.</p><p>Phase uses a cosine reference at the first sample and is set to zero when amplitude does not exceed <code>amplitudeFloor</code>. The caller supplies a finite, uniformly sampled record and valid array dimensions; this function does not check the input domain.</p></html>"));
end oneSidedDFT;
