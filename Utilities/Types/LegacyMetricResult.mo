within EvaluationLibrary.Utilities.Types;
record LegacyMetricResult "数值、单位、时间证据和五态判定记录"
String metric "Metric name";
String unit "Physical unit as text";
Real value "Numerical value; see defined";
Boolean defined "Numerical evidence is available";
Modelica.Units.SI.Time windowStart "Observation start";
Modelica.Units.SI.Time windowEnd "Exclusive observation end";
Modelica.Units.SI.Time observedAt "Representative evidence timestamp";
EvaluationLibrary.Utilities.Types.DataStatus dataState;
EvaluationLibrary.Utilities.Types.Verdict status;
String explanation;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-80,-85},{80,85}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-80,48},{80,48}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-58.08,15.24},{58.08,15.24}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-58.08,-9.4},{58.08,-9.4}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-58.08,-34.04},{58.08,-34.04}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-17.6,32.84},{-17.6,-58.68}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-51.04,11.72},{-25.52,-6.76}}, textString="x", textColor={108,88,49}, fontSize=0),
        Text(extent={{-51.04,-12.92},{-25.52,-30.52}}, textString="s", textColor={108,88,49}, fontSize=0),
        Line(points={{17.38,-43.72},{24.904,-51.64},{39.556,-32.632}}, color={75,138,73}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-70,80},{70,52}}, textString="Legacy", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>数值、单位、时间证据和五态判定记录</p>
<p><b>行为</b> 数值、单位、时间证据和五态判定记录。</p>
<p><b>最小用法</b> 由本库组件按源码中的参数和接口装配。</p>
<p><b>适用边界</b> 实现细节随本库版本演进。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>String metric \"Metric name\"</code></li>
<li><code>String unit \"Physical unit as text\"</code></li>
<li><code>Real value \"Numerical value; see defined\"</code></li>
<li><code>Boolean defined \"Numerical evidence is available\"</code></li>
<li><code>Modelica.Units.SI.Time windowStart \"Observation start\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd \"Exclusive observation end\"</code></li>
<li><code>Modelica.Units.SI.Time observedAt \"Representative evidence timestamp\"</code></li>
<li><code>EvaluationLibrary.Utilities.Types.DataStatus dataState</code></li>
<li><code>EvaluationLibrary.Utilities.Types.Verdict status</code></li>
<li><code>String explanation</code></li>
</ul>
</html>"));
end LegacyMetricResult;
