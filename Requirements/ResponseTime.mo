within EvaluationLibrary.Requirements;
block ResponseTime "测量首次请求至实际响应并按截止时间判定"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,49},{106,61}}), iconTransformation(extent={{94,49},{106,61}})));
  parameter Modelica.Units.SI.Time deadline(min=0) = 0.5 "允许最大响应时差，s";
  Modelica.Blocks.Interfaces.BooleanInput request "请求或事件条件" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.BooleanInput response "来自实测的动作或恢复条件" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.BooleanOutput triggered(start=false,fixed=true) "已记录请求" annotation(Placement(transformation(extent={{94,21},{106,33}}), iconTransformation(extent={{94,21},{106,33}})));
  Modelica.Blocks.Interfaces.BooleanOutput responded(start=false,fixed=true) "已观察响应" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput triggerTime(unit="s",start=0,fixed=true) "首个请求时刻" annotation(Placement(transformation(extent={{94,-33},{106,-21}}), iconTransformation(extent={{94,-33},{106,-21}})));
  Modelica.Blocks.Interfaces.RealOutput responseAt(unit="s",start=0,fixed=true) "首个响应时刻" annotation(Placement(transformation(extent={{94,-61},{106,-49}}), iconTransformation(extent={{94,-61},{106,-49}})));
  Modelica.Blocks.Interfaces.RealOutput latency(unit="s") "有响应证据时的时差" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "按期限的结果";
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable);
  Boolean dataOK "Validity combined with the metric data domain";
  Boolean triggerNow;
  Boolean responseNow;
initial equation
  assert(deadline >= 0, "Deadline must be nonnegative.");
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  dataOK = valid;
  triggerNow = inWindow and dataOK and request;
  responseNow = inWindow and dataOK and triggered and response;
  when {initial(),triggerNow} then
    triggered = if initial() then triggerNow else true;
    triggerTime = if triggerNow and not pre(triggered) then time else pre(triggerTime);
  end when;
  when {initial(),responseNow} then
    responded = if initial() then responseNow else true;
    responseAt = if responseNow and not pre(responded) then time else pre(responseAt);
  end when;
  latency = if responded then responseAt-triggerTime else 0;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if not triggered then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE elseif responded then (if noEvent(latency <= deadline) then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED) elseif noEvent(triggerTime+deadline < windowEnd) then EvaluationLibrary.Utilities.Types.Verdict.VIOLATED else EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-60,30},{-31,30},{-31,56},{57,56}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-60,-15},{20,-15},{20,11},{57,11}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-31,25},{-31,-39}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Line(points={{20,-20},{20,-39}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Line(points={{-31,-31},{20,-31}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{44,62},{44,-28}}, color={191,0,0}, thickness=0.6, pattern=LinePattern.Dash),
        Text(extent={{-65,-50},{65,-75}}, textString="deadline", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="ResponseTime")}),
    Documentation(info="<html><p><b>Purpose</b> 测量首次请求至实际响应并按截止时间判定</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"; Modelica.Blocks.Interfaces.BooleanInput request \"请求或事件条件\"; Modelica.Blocks.Interfaces.BooleanInput response \"来自实测的动作或恢复条件\"; Modelica.Blocks.Interfaces.BooleanOutput triggered(start=false,fixed=true) \"已记录请求\"; Modelica.Blocks.Interfaces.BooleanOutput responded(start=false,fixed=true) \"已观察响应\"; Modelica.Blocks.Interfaces.RealOutput triggerTime(unit=\"s\",start=0,fixed=true) \"首个请求时刻\"; Modelica.Blocks.Interfaces.RealOutput responseAt(unit=\"s\",start=0,fixed=true) \"首个响应时刻\"; Modelica.Blocks.Interfaces.RealOutput latency(unit=\"s\") \"有响应证据时的时差\"; output EvaluationLibrary.Utilities.Types.Verdict verdict \"按期限的结果\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"; parameter Modelica.Units.SI.Time deadline(min=0) = 0.5 \"允许最大响应时差，s\"</p><p><b>Behavior</b> 测量首次请求至实际响应并按截止时间判定</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">EvaluationLibrary.Examples.BoundsAndValidWitness</a></p>
<p>测量首次请求至实际响应并按截止时间判定</p>
<p>专业分类为 RequirementChecks.TemporalRequirement。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput request \"请求或事件条件\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput response \"来自实测的动作或恢复条件\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput triggered(start=false,fixed=true) \"已记录请求\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput responded(start=false,fixed=true) \"已观察响应\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput triggerTime(unit=\"s\",start=0,fixed=true) \"首个请求时刻\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput responseAt(unit=\"s\",start=0,fixed=true) \"首个响应时刻\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput latency(unit=\"s\") \"有响应证据时的时差\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.Verdict verdict \"按期限的结果\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Modelica.Units.SI.Time deadline(min=0) = 0.5 \"允许最大响应时差，s\"</code></li>
</ul>
<p><b>时序与基准行为</b> 已满足的响应条件计零延迟。等于期限仍满足。未观察请求为不适用，未响应且截止已落在窗口内为违反。</p>
<p><b>最小用法</b> request 接保护请求，response 用实际电流、阀位等反馈生成。需要确认新上升沿时由宿主定义事件信号。 <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">MissionAndProtectionEvaluation</a> 展示同域接线。</p>
<p><b>适用边界</b> 仅评价首个请求。截止恰好等于 windowEnd 时右端缺少样本，未响应仍未决。</p>
</html>"));
end ResponseTime;
