within EvaluationLibrary.Response;
block MovingAverage "连续有效的完整滑窗平均值"
  parameter Modelica.Units.SI.Time length(min=Modelica.Constants.small) = 1 "Trailing window duration, s";
  parameter Modelica.Units.SI.Time coverageTolerance(min=0) = 1e-7 "Numerical integration tolerance, s";
  Modelica.Blocks.Interfaces.RealInput u "Signal" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));
  Modelica.Blocks.Interfaces.BooleanInput valid "Input validity" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.RealOutput mean "Trailing average, same unit as u" annotation(Placement(transformation(extent={{94,42},{106,54}}), iconTransformation(extent={{94,42},{106,54}})));
  Modelica.Blocks.Interfaces.BooleanOutput ready "A full valid duration is available" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput coveredDuration(unit="s") "Valid duration within the current window" annotation(Placement(transformation(extent={{94,-54},{106,-42}}), iconTransformation(extent={{94,-54},{106,-42}})));
protected
  Real integral(start=0,fixed=true);
  Real duration(unit="s",start=0,fixed=true);
  parameter Modelica.Units.SI.Time startTime(fixed=false);
  Boolean dataOK;
initial equation
  startTime = time;
  assert(length > 0 and coverageTolerance >= 0 and coverageTolerance < length, "Invalid moving window.");
equation
  dataOK = valid and noEvent(abs(u) < Modelica.Constants.inf);
  der(integral) = if dataOK then u else 0;
  der(duration) = if dataOK then 1 else 0;
  coveredDuration = min(length,max(0,duration-delay(duration,length)));
  ready = dataOK and time >= startTime+length and noEvent(coveredDuration >= length-coverageTolerance);
  mean = if ready then (integral-delay(integral,length))/length else 0;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Rectangle(extent={{-10,-34},{53,47}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Dash, lineThickness=0.5, radius=0),
        Line(points={{-56,17},{-53.15,21.9939},{-50.3,25.8992},{-47.45,27.8646},{-44.6,27.4616},{-41.75,24.7782},{-38.9,20.3992},{-36.05,15.2792},{-33.2,10.5344},{-30.35,7.19893},{-27.5,6},{-24.65,7.19893},{-21.8,10.5344},{-18.95,15.2792},{-16.1,20.3992},{-13.25,24.7782},{-10.4,27.4616},{-7.55,27.8646},{-4.7,25.8992},{-1.85,21.9939},{1,17},{3.85,12.0061},{6.7,8.10081},{9.55,6.13543},{12.4,6.53838},{15.25,9.22183},{18.1,13.6008},{20.95,18.7208},{23.8,23.4656},{26.65,26.8011},{29.5,28},{32.35,26.8011},{35.2,23.4656},{38.05,18.7208},{40.9,13.6008},{43.75,9.22183},{46.6,6.53838},{49.45,6.13543},{52.3,8.10081},{55.15,12.0061},{58,17}}, color={128,128,128}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-55,10},{-18,16},{15,19},{58,21}}, color={0,0,127}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{-1,-22},{43,-22}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="mean(T)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p><b>Purpose</b> 连续有效的完整滑窗平均值</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.RealInput u \"Signal\"; Modelica.Blocks.Interfaces.BooleanInput valid \"Input validity\"; Modelica.Blocks.Interfaces.RealOutput mean \"Trailing average, same unit as u\"; Modelica.Blocks.Interfaces.BooleanOutput ready \"A full valid duration is available\"; Modelica.Blocks.Interfaces.RealOutput coveredDuration(unit=\"s\") \"Valid duration within the current window\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time length(min=Modelica.Constants.small) = 1 \"Trailing window duration, s\"; parameter Modelica.Units.SI.Time coverageTolerance(min=0) = 1e-7 \"Numerical integration tolerance, s\"</p><p><b>Behavior</b> 连续有效的完整滑窗平均值</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.FirstOrderResponse\">EvaluationLibrary.Examples.FirstOrderResponse</a></p>
<p>连续有效的完整滑窗平均值</p>
<p><b>行为</b> 按连续有效时间积分，等待一整窗且覆盖足够时输出均值。窗内有有效时长缺口时不发布。</p>
<p><b>最小用法</b> 给缓慢变化的电压或温度设置 length，并读取 ready。</p>
<p><b>适用边界</b> 积分差和时间容差是数值近似。零持续时间的无效瞬间没有积分权重。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>Modelica.Units.SI.Time length(min=Modelica.Constants.small) = 1 \"Trailing window duration, s\"</code></li>
<li><code>Modelica.Units.SI.Time coverageTolerance(min=0) = 1e-7 \"Numerical integration tolerance, s\"</code></li>
</ul>
<p>接口及方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.RealInput u \"Signal\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput mean \"Trailing average, same unit as u\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput ready \"A full valid duration is available\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput coveredDuration(unit=\"s\") \"Valid duration within the current window\"</code></li>
</ul>
<p><a href=\"modelica://EvaluationLibrary.Examples.AnalyticStatistics\">ElectricalPowerQualityEvaluation</a> 提供同域宿主参考。</p>
</html>"));
end MovingAverage;
