within EvaluationLibrary.Utilities.Internal;
function oneSidedDFT "一侧 DFT、相干增益校正和主峰"
  input Real x[:];
  input Integer nBins "Highest nonnegative bin";
  input EvaluationLibrary.Utilities.Types.SpectralWindow window;
  input Real amplitudeFloor;
  output Real bins[nBins+1,2] "Amplitude and phase";
protected
  Integer n = size(x,1);
  Real w[size(x,1)];
  Real coherentSum;
  Real a;
  Real b;
  Real angle;
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
        Ellipse(extent={{-88,-88},{88,88}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Line(points={{-42.16,35.4},{-42.16,-25.12},{44.2,-25.12}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-29.24,-25.12},{-29.24,-13.56}}, color={0,0,127}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{-10.2,-25.12},{-10.2,13.64}}, color={0,0,127}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{8.84,-25.12},{8.84,27.24}}, color={0,0,127}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{27.88,-25.12},{27.88,-4.04}}, color={0,0,127}, thickness=1.3, pattern=LinePattern.Solid),
        Ellipse(extent={{-31.28,-15.6},{-27.2,-11.52}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-12.24,11.6},{-8.16,15.68}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{6.8,25.2},{10.88,29.28}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{25.84,-6.08},{29.92,-2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Text(extent={{34,-26.48},{46.24,-35.32}}, textString="f", textColor={128,128,128}, fontSize=0),
        Text(extent={{-65,-55},{65,-78}}, textString="DFT", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>一侧 DFT、相干增益校正和主峰</p>
<p><b>行为</b> 一侧 DFT、相干增益校正和主峰。</p>
<p><b>最小用法</b> 由本库组件按源码中的参数和接口装配。</p>
<p><b>适用边界</b> 实现细节随本库版本演进。</p>
<p>接口及方向</p>
<ul>
<li><code>input Real x[:]</code></li>
<li><code>input Integer nBins \"Highest nonnegative bin\"</code></li>
<li><code>input EvaluationLibrary.Utilities.Types.SpectralWindow window</code></li>
<li><code>input Real amplitudeFloor</code></li>
<li><code>output Real bins[nBins+1,2] \"Amplitude and phase\"</code></li>
</ul>
</html>"));
end oneSidedDFT;
