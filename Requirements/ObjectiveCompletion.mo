within EvaluationLibrary.Requirements;
block ObjectiveCompletion "按独立目标证据和否决条件判定任务完成"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  Modelica.Blocks.Interfaces.BooleanInput objectiveMet "任务目标证据" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.BooleanInput failure "否决条件" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.BooleanOutput completed(start=false,fixed=true) "窗口内已观察目标" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.BooleanOutput vetoed(start=false,fixed=true) "窗口内已观察否决" annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  Modelica.Blocks.Interfaces.RealOutput completionTime(unit="s",start=0,fixed=true) "首个目标证据时刻" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "完整窗口的任务结果";
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable);
  Boolean dataOK "Validity combined with the metric data domain";
  Boolean hit;
  Boolean veto;
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  dataOK = valid;
  hit = inWindow and dataOK and objectiveMet;
  veto = inWindow and dataOK and failure;
  when {initial(),hit} then
    completed = if initial() then hit else true;
    completionTime = if hit and not pre(completed) then time else pre(completionTime);
  end when;
  when {initial(),veto} then
    vetoed = if initial() then veto else true;
  end when;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if completed and not vetoed then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Ellipse(extent={{-43,-30},{39,52}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.5),
        Ellipse(extent={{-27,-14},{23,36}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.5),
        Ellipse(extent={{-11,2},{7,20}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{-2,11},{49,51}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{22.5,-30},{32,-40},{50.5,-16}}, color={75,138,73}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="goal", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="ObjectiveCompletion")}),
    Documentation(info="<html><p><b>Purpose</b> 按独立目标证据和否决条件判定任务完成</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"; Modelica.Blocks.Interfaces.BooleanInput objectiveMet \"任务目标证据\"; Modelica.Blocks.Interfaces.BooleanInput failure \"否决条件\"; Modelica.Blocks.Interfaces.BooleanOutput completed(start=false,fixed=true) \"窗口内已观察目标\"; Modelica.Blocks.Interfaces.BooleanOutput vetoed(start=false,fixed=true) \"窗口内已观察否决\"; Modelica.Blocks.Interfaces.RealOutput completionTime(unit=\"s\",start=0,fixed=true) \"首个目标证据时刻\"; output EvaluationLibrary.Utilities.Types.Verdict verdict \"完整窗口的任务结果\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"</p><p><b>Behavior</b> 按独立目标证据和否决条件判定任务完成</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">EvaluationLibrary.Examples.BoundsAndValidWitness</a></p>
<p>按独立目标证据和否决条件判定任务完成</p>
<p>专业分类为 RequirementChecks.BooleanRequirement。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput objectiveMet \"任务目标证据\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput failure \"否决条件\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput completed(start=false,fixed=true) \"窗口内已观察目标\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput vetoed(start=false,fixed=true) \"窗口内已观察否决\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput completionTime(unit=\"s\",start=0,fixed=true) \"首个目标证据时刻\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.Verdict verdict \"完整窗口的任务结果\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
</ul>
<p><b>时序与基准行为</b> 达到目标即记录首时刻，任一否决事件优先，二者在窗终点冻结。</p>
<p><b>最小用法</b> 从宿主的实际输出构造目标，例如已累计达到交付质量。 <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">MissionAndProtectionEvaluation</a> 展示同域接线。</p>
<p><b>适用边界</b> 按事件评价目标是否出现。若需连续保持，应先按任务定义生成目标证据。</p>
</html>"));
end ObjectiveCompletion;
