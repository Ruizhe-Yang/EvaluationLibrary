within EvaluationLibrary.Requirements;
block CircularErrorBound "按最短圆周弧判断角度跟踪误差"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  Modelica.Blocks.Interfaces.BooleanOutput violationObserved "窗口中至少一次观察到越限" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput firstViolationTime(unit="s",start=0,fixed=true) "首次观察到越限的时刻" annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "规则判定";
  parameter Modelica.Units.SI.Angle bound(min=0,max=Modelica.Constants.pi) = 0.1 "误差幅值上界，rad";
  Modelica.Blocks.Interfaces.RealInput angle(unit="rad") "实测角" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealInput reference(unit="rad") "参考角" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput error(unit="rad") "有符号最短角误差" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable);
  Boolean dataOK "Validity combined with the metric data domain";
  Boolean outside "派生资产定义的越限条件";
  Boolean violationNow;
  discrete Boolean seen(start=false,fixed=true);
initial equation
  assert(bound >= 0 and bound <= Modelica.Constants.pi, "Circular bound must be in [0,pi].");
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  violationNow = inWindow and dataOK and outside;
  when {initial(), violationNow} then
    seen = if initial() then violationNow else true;
    firstViolationTime = if violationNow and not pre(seen) then time else pre(firstViolationTime);
  end when;
  violationObserved = seen;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if seen then EvaluationLibrary.Utilities.Types.Verdict.VIOLATED else EvaluationLibrary.Utilities.Types.Verdict.SATISFIED;
  dataOK = valid and abs(angle) < Modelica.Constants.inf and abs(reference) < Modelica.Constants.inf;
  error = if dataOK then Modelica.Math.atan2(sin(angle-reference),cos(angle-reference)) else 0;
  outside = abs(error) > bound;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Ellipse(extent={{-48,-39},{44,53}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{-2,7},{-2,47}}, color={128,128,128}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{-2,7},{29,35}}, color={0,0,127}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{-2,32},{5,32},{13,29},{18,24}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Ellipse(extent={{-5,4},{1,10}}, lineColor={64,64,64}, fillColor={64,64,64}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Text(extent={{-65,-50},{65,-75}}, textString="Δφ", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="CircularErrorBound")}),
    Documentation(info="<html><p><b>Purpose</b> 按最短圆周弧判断角度跟踪误差</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"; Modelica.Blocks.Interfaces.BooleanOutput violationObserved \"窗口中至少一次观察到越限\"; Modelica.Blocks.Interfaces.RealOutput firstViolationTime(unit=\"s\",start=0,fixed=true) \"首次观察到越限的时刻\"; output EvaluationLibrary.Utilities.Types.Verdict verdict \"规则判定\"; Modelica.Blocks.Interfaces.RealInput angle(unit=\"rad\") \"实测角\"; Modelica.Blocks.Interfaces.RealInput reference(unit=\"rad\") \"参考角\"; Modelica.Blocks.Interfaces.RealOutput error(unit=\"rad\") \"有符号最短角误差\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"; parameter Modelica.Units.SI.Angle bound(min=0,max=Modelica.Constants.pi) = 0.1 \"误差幅值上界，rad\"</p><p><b>Behavior</b> 按最短圆周弧判断角度跟踪误差</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">EvaluationLibrary.Examples.BoundsAndValidWitness</a></p>
<p>按最短圆周弧判断角度跟踪误差</p>
<p>专业分类为 ResponseAnalysis.Tracking。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput violationObserved \"窗口中至少一次观察到越限\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput firstViolationTime(unit=\"s\",start=0,fixed=true) \"首次观察到越限的时刻\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.Verdict verdict \"规则判定\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput angle(unit=\"rad\") \"实测角\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput reference(unit=\"rad\") \"参考角\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput error(unit=\"rad\") \"有符号最短角误差\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Modelica.Units.SI.Angle bound(min=0,max=Modelica.Constants.pi) = 0.1 \"误差幅值上界，rad\"</code></li>
</ul>
<p><b>时序与基准行为</b> 幅值严格超过上界越限。反点符号可跳变，幅值连续。</p>
<p><b>最小用法</b> 用于周期姿态误差。累计转角或缠绕次数用普通未折返轨迹另行评价。 <a href=\"modelica://EvaluationLibrary.Examples.PairedPerformance\">MechanicalResponseEvaluation</a> 展示同域接线。</p>
<p><b>适用边界</b> 角单位为 rad。持续旋转的巨大绝对角可能损失相位精度。</p>
</html>"));
end CircularErrorBound;
