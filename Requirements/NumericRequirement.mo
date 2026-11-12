within EvaluationLibrary.Requirements;
block NumericRequirement "按完整数值证据执行含等号的限值要求"
  parameter EvaluationLibrary.Utilities.Types.NumericComparison comparison = EvaluationLibrary.Utilities.Types.NumericComparison.Inside;
  parameter Real lower = 0 "Inclusive lower limit";
  parameter Real upper = 1 "Inclusive upper limit";
  Modelica.Blocks.Interfaces.RealInput value "Numerical evidence in the units of the bounds" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));
  Modelica.Blocks.Interfaces.BooleanInput defined "The metric value exists" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  input EvaluationLibrary.Utilities.Types.DataStatus dataState "Evidence coverage and validity";
  Modelica.Blocks.Interfaces.RealOutput margin "Signed distance to applicable boundary" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement outcome";
protected
  Boolean finiteValue;
initial equation
  assert(comparison <> EvaluationLibrary.Utilities.Types.NumericComparison.Inside or lower <= upper, "Inverted range.");
equation
  finiteValue = noEvent(abs(value) < Modelica.Constants.inf);
  margin = if defined and finiteValue then
    (if comparison == EvaluationLibrary.Utilities.Types.NumericComparison.AtMost then upper-value elseif comparison == EvaluationLibrary.Utilities.Types.NumericComparison.AtLeast then value-lower
      else min(value-lower,upper-value)) else 0;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if not defined then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED elseif not finiteValue then EvaluationLibrary.Utilities.Types.Verdict.INVALID elseif noEvent(margin>=0) then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-59,48},{-13,-14}}, textString="x", textColor={0,0,127}, fontSize=0),
        Text(extent={{-16,46},{18,-12}}, textString="≤", textColor={64,64,64}, fontSize=0),
        Line(points={{37,47},{37,-12}}, color={128,128,128}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{-10.5,-31},{0.52,-42.6},{21.98,-14.76}}, color={75,138,73}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="criterion", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p><b>Purpose</b> 按完整数值证据执行含等号的限值要求</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.RealInput value \"Numerical evidence in the units of the bounds\"; Modelica.Blocks.Interfaces.BooleanInput defined \"The metric value exists\"; input EvaluationLibrary.Utilities.Types.DataStatus dataState \"Evidence coverage and validity\"; Modelica.Blocks.Interfaces.RealOutput margin \"Signed distance to applicable boundary\"; output EvaluationLibrary.Utilities.Types.Verdict verdict \"Requirement outcome\"</p><p><b>Parameters</b> parameter EvaluationLibrary.Utilities.Types.NumericComparison comparison = EvaluationLibrary.Utilities.Types.NumericComparison.Inside; parameter Real lower = 0 \"Inclusive lower limit\"; parameter Real upper = 1 \"Inclusive upper limit\"</p><p><b>Behavior</b> 按完整数值证据执行含等号的限值要求</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">EvaluationLibrary.Examples.BoundsAndValidWitness</a></p>
<p>按完整数值证据执行含等号的限值要求</p>
<p><b>行为</b> 等号满足要求，裕量为负表示违反。未提供值或证据不足时未决，失效与不适用分别传播。</p>
<p><b>最小用法</b> 把有效的峰值或稳态误差及对应 dataState 接入，并设置同单位限值。</p>
<p><b>适用边界</b> 使用上游证据，时间语义由上游指标定义。数值填零时必须检查 defined。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>EvaluationLibrary.Utilities.Types.NumericComparison comparison = EvaluationLibrary.Utilities.Types.NumericComparison.Inside</code></li>
<li><code>Real lower = 0 \"Inclusive lower limit\"</code></li>
<li><code>Real upper = 1 \"Inclusive upper limit\"</code></li>
</ul>
<p>接口及方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.RealInput value \"Numerical evidence in the units of the bounds\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput defined \"The metric value exists\"</code></li>
<li><code>input EvaluationLibrary.Utilities.Types.DataStatus dataState \"Evidence coverage and validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput margin \"Signed distance to applicable boundary\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.Verdict verdict \"Requirement outcome\"</code></li>
</ul>
<p><a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">IntegratedResultsReporting</a> 提供同域宿主参考。</p>
</html>"));
end NumericRequirement;
