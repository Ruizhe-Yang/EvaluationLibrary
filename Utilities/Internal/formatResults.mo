within EvaluationLibrary.Utilities.Internal;
function formatResults "生成文件或可读摘要所需的字符串"
  input EvaluationLibrary.Utilities.Types.LegacyMetricResult results[:];
  input EvaluationLibrary.Utilities.Types.ReportFormat format;
  input String title;
  input Boolean includeHeader = true;
  output String content;
protected
  String row;
  String numeric;
  String stamp;
algorithm
  if format == EvaluationLibrary.Utilities.Types.ReportFormat.CSV then
    content := if includeHeader then "metric,unit,value,defined,window_start_s,window_end_s,observed_at_s,data_state,status,explanation" else "";
    for i in 1:size(results,1) loop
      numeric := if results[i].defined then String(results[i].value,significantDigits=12) else "";
      stamp := if results[i].defined then String(results[i].observedAt,significantDigits=12) else "";
      row := EvaluationLibrary.Utilities.Internal.csvQuote(results[i].metric) + "," + EvaluationLibrary.Utilities.Internal.csvQuote(results[i].unit) +
        "," + numeric + "," + String(results[i].defined) +
        "," + String(results[i].windowStart,significantDigits=12) + "," + String(results[i].windowEnd,significantDigits=12) +
        "," + stamp + "," + String(results[i].dataState) + "," + String(results[i].status) +
        "," + EvaluationLibrary.Utilities.Internal.csvQuote(results[i].explanation);
      content := if Modelica.Utilities.Strings.isEmpty(content) then row else content + "\n" + row;
    end for;
  else
    content := title;
    for i in 1:size(results,1) loop
      numeric := if results[i].defined then String(results[i].value,significantDigits=8) + " " + results[i].unit else "unavailable";
      content := content + "\n" + results[i].metric + " = " + numeric +
        " [" + String(results[i].status) + ", " + String(results[i].dataState) + "]" +
        " from " + String(results[i].windowStart) + " to " + String(results[i].windowEnd) + " s. " +
        results[i].explanation;
    end for;
  end if;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-88,-88},{88,88}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Polygon(points={{-25.024,-27.568},{-25.024,29.552},{13.056,29.552},{25.568,17.04},{25.568,-27.568},{-25.024,-27.568}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{13.056,29.552},{13.056,17.04},{25.568,17.04}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-16.32,11.6},{14.144,11.6}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-16.32,2.352},{16.32,2.352}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-16.32,-6.896},{9.248,-6.896}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-16.32,-16.144},{16.32,-16.144}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Text(extent={{-20.4,21.8},{19.04,-15.6}}, textString="=", textColor={108,88,49}, fontSize=0),
        Text(extent={{-65,-55},{65,-78}}, textString="format", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>生成文件或可读摘要所需的字符串</p>
<p><b>行为</b> 生成文件或可读摘要所需的字符串。</p>
<p><b>最小用法</b> 由本库组件按源码中的参数和接口装配。</p>
<p><b>适用边界</b> 实现细节随本库版本演进。</p>
<p>接口及方向</p>
<ul>
<li><code>input EvaluationLibrary.Utilities.Types.LegacyMetricResult results[:]</code></li>
<li><code>input EvaluationLibrary.Utilities.Types.ReportFormat format</code></li>
<li><code>input String title</code></li>
<li><code>input Boolean includeHeader = true</code></li>
<li><code>output String content</code></li>
</ul>
</html>"));
end formatResults;
