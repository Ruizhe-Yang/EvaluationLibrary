within EvaluationLibrary.Utilities.Internal;
function csvQuote "为逗号分隔表转义引号"
  input String raw;
  output String field;
algorithm
  field := "\"" + Modelica.Utilities.Strings.replace(raw,"\"","\"\"") + "\"";
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-88,-88},{88,88}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Text(extent={{-40.12,22.48},{40.12,-7.44}}, textString="\"x\"", textColor={108,88,49}, fontSize=0),
        Line(points={{-24.48,-20.36},{24.48,-20.36}}, color={108,88,49}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-65,-55},{65,-78}}, textString="CSV", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>为逗号分隔表转义引号</p>
<p><b>行为</b> 为逗号分隔表转义引号。</p>
<p><b>最小用法</b> 由本库组件按源码中的参数和接口装配。</p>
<p><b>适用边界</b> 实现细节随本库版本演进。</p>
<p>接口及方向</p>
<ul>
<li><code>input String raw</code></li>
<li><code>output String field</code></li>
</ul>
</html>"));
end csvQuote;
