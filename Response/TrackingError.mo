within EvaluationLibrary.Response;
block TrackingError "计算连续跟踪误差的绝对积分与均方根"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  Modelica.Blocks.Interfaces.RealInput measured "实测轨迹" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealInput reference "目标轨迹" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput error "当前有符号误差" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput absoluteIntegral(start=0,fixed=true) "绝对误差积分，输入单位·s" annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  Modelica.Blocks.Interfaces.RealOutput rms "窗口内均方根误差" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable);
  Boolean dataOK "Validity combined with the metric data domain";
  Real squareIntegral(start=0,fixed=true);
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  dataOK = valid and abs(measured) < Modelica.Constants.inf and abs(reference) < Modelica.Constants.inf;
  error = if dataOK then measured-reference else 0;
  der(absoluteIntegral) = if inWindow and dataOK then abs(error) else 0;
  der(squareIntegral) = if inWindow and dataOK then error^2 else 0;
  rms = if noEvent(observedDuration > 0) then sqrt(max(0,squareIntegral/observedDuration)) else 0;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-57,-18},{-31,-5},{-5,20},{24,36},{58,31}}, color={128,128,128}, thickness=0.9, pattern=LinePattern.Dash),
        Line(points={{-57,-26},{-31,-14},{-5,5},{24,23},{58,20}}, color={0,0,127}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{5,26},{5,11}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="e, RMS", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="TrackingError")}),
    Documentation(info="<html><p><b>Purpose</b> 计算连续跟踪误差的绝对积分与均方根</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"; Modelica.Blocks.Interfaces.RealInput measured \"实测轨迹\"; Modelica.Blocks.Interfaces.RealInput reference \"目标轨迹\"; Modelica.Blocks.Interfaces.RealOutput error \"当前有符号误差\"; Modelica.Blocks.Interfaces.RealOutput absoluteIntegral(start=0,fixed=true) \"绝对误差积分，输入单位·s\"; Modelica.Blocks.Interfaces.RealOutput rms \"窗口内均方根误差\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"</p><p><b>Behavior</b> 计算连续跟踪误差的绝对积分与均方根</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.FirstOrderResponse\">EvaluationLibrary.Examples.FirstOrderResponse</a></p>
<p>计算连续跟踪误差的绝对积分与均方根</p>
<p>专业分类为 ResponseAnalysis.Tracking。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput measured \"实测轨迹\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput reference \"目标轨迹\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput error \"当前有符号误差\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput absoluteIntegral(start=0,fixed=true) \"绝对误差积分，输入单位·s\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput rms \"窗口内均方根误差\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
</ul>
<p><b>时序与基准行为</b> 有效窗内连续积分，零时长填零，积分与均方根在结束后冻结。</p>
<p><b>最小用法</b> 读取位置、角度或流量与名义目标。角度差应由宿主选择是否周期化。 <a href=\"modelica://EvaluationLibrary.Examples.PairedPerformance\">MechanicalResponseEvaluation</a> 展示同域接线。</p>
<p><b>适用边界</b> 单位随输入。提前终止时仅有前缀量。</p>
</html>"));
end TrackingError;
