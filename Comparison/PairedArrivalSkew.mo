within EvaluationLibrary.Comparison;
block PairedArrivalSkew "双事件首达时差及时间一致性"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,42},{106,54}}), iconTransformation(extent={{94,42},{106,54}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  parameter Modelica.Units.SI.Time maximumSkew(min=0) = 0.1 "Maximum absolute skew";
  Modelica.Blocks.Interfaces.BooleanInput a "First stream arrival condition" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.BooleanInput b "Second stream arrival condition" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput skew(unit="s") "First B time minus first A time" annotation(Placement(transformation(extent={{94,-54},{106,-42}}), iconTransformation(extent={{94,-54},{106,-42}})));
  output Modelica.Units.SI.Time arrivedA(start=0,fixed=true);
  output Modelica.Units.SI.Time arrivedB(start=0,fixed=true);
  output EvaluationLibrary.Utilities.Types.Verdict verdict;
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable);
  Boolean dataOK "Validity combined with the metric data domain";
  discrete Boolean seenA(start=false,fixed=true);
  discrete Boolean seenB(start=false,fixed=true);
  Boolean hitA;
  Boolean hitB;
initial equation
  assert(maximumSkew >= 0,"Skew must be nonnegative.");
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  dataOK = valid;
  hitA = inWindow and dataOK and a;
  hitB = inWindow and dataOK and b;
  when {initial(),hitA} then
    seenA = pre(seenA) or hitA;
    arrivedA = if hitA and not pre(seenA) then time else pre(arrivedA);
  end when;
  when {initial(),hitB} then
    seenB = pre(seenB) or hitB;
    arrivedB = if hitB and not pre(seenB) then time else pre(arrivedB);
  end when;
  skew = if seenA and seenB then arrivedB-arrivedA else 0;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if not (seenA and seenB) then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED elseif noEvent(abs(skew)<=maximumSkew) then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-60,30},{-31,30},{-31,56},{57,56}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-60,-15},{20,-15},{20,11},{57,11}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-31,25},{-31,-39}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Line(points={{20,-20},{20,-39}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Line(points={{-31,-31},{20,-31}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="t₂ − t₁", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p><b>Purpose</b> 双事件首达时差及时间一致性</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"; Modelica.Blocks.Interfaces.BooleanInput a \"First stream arrival condition\"; Modelica.Blocks.Interfaces.BooleanInput b \"Second stream arrival condition\"; Modelica.Blocks.Interfaces.RealOutput skew(unit=\"s\") \"First B time minus first A time\"; output Modelica.Units.SI.Time arrivedA(start=0,fixed=true); output Modelica.Units.SI.Time arrivedB(start=0,fixed=true); output EvaluationLibrary.Utilities.Types.Verdict verdict</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"; parameter Modelica.Units.SI.Time maximumSkew(min=0) = 0.1 \"Maximum absolute skew\"</p><p><b>Behavior</b> 双事件首达时差及时间一致性</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.PairedPerformance\">EvaluationLibrary.Examples.PairedPerformance</a></p>
<p>双事件首达时差及时间一致性</p>
<p><b>行为</b> 分别记录窗口内首次为真的时刻。同刻时差为零。缺少一路仍为未决。</p>
<p><b>最小用法</b> 比较两个执行器的到位信号或两个采集标记。</p>
<p><b>适用边界</b> 仅评价首对事件，反向时差保留负号。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Modelica.Units.SI.Time maximumSkew(min=0) = 0.1 \"Maximum absolute skew\"</code></li>
</ul>
<p>接口及方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput observedDuration(unit=\"s\") \"Accumulated valid duration\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput a \"First stream arrival condition\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput b \"Second stream arrival condition\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput skew(unit=\"s\") \"First B time minus first A time\"</code></li>
<li><code>output Modelica.Units.SI.Time arrivedA(start=0,fixed=true)</code></li>
<li><code>output Modelica.Units.SI.Time arrivedB(start=0,fixed=true)</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.Verdict verdict</code></li>
</ul>
<p><a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">IntegratedResultsReporting</a> 提供同域宿主参考。</p>
</html>"));
end PairedArrivalSkew;
