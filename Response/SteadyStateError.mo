within EvaluationLibrary.Response;
block SteadyStateError "用末段采样估计稳态偏差及残差波动"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 "Sampling interval, s";
  parameter Modelica.Units.SI.Time sampleOffset(min=0) = 0 "First tick offset from windowStart, s";
  parameter Integer minimumSamples(min=1) = 2 "Minimum valid observations";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,66},{106,78}}), iconTransformation(extent={{94,66},{106,78}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.IntegerOutput validSamples "Accepted observations" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  parameter Real biasLimit(min=0) = 0.05 "允许的均值偏差幅值";
  parameter Real spreadLimit(min=0) = 0.02 "允许的标准差";
  Modelica.Blocks.Interfaces.RealInput measured "末段实测值" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealInput reference "末段参考值" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput bias "离散有符号均值误差" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  Modelica.Blocks.Interfaces.RealOutput spread "样本总体标准差" annotation(Placement(transformation(extent={{94,-78},{106,-66}}), iconTransformation(extent={{94,-78},{106,-66}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "均值和波动均满足上限才通过";
protected
  EvaluationLibrary.Utilities.Internal.SampledEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable,samplePeriod=samplePeriod,sampleOffset=sampleOffset,minimumSamples=minimumSamples);
  Boolean dataOK "Validity combined with the metric data domain";

  final parameter Modelica.Units.SI.Time firstSample = windowStart+sampleOffset;
  Boolean takeTick "Only the scheduled half-open grid is accepted";
  EvaluationLibrary.Statistics.SampledMoments moments(windowStart=windowStart,windowEnd=windowEnd,
    samplePeriod=samplePeriod,sampleOffset=sampleOffset,minimumSamples=minimumSamples,applicable=applicable);
initial equation
  assert(biasLimit >= 0 and spreadLimit >= 0, "Error limits must be nonnegative.");
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  validSamples = evidence.validSamples;
  takeTick = evidence.takeTick;
  dataOK = valid and abs(measured) < Modelica.Constants.inf and abs(reference) < Modelica.Constants.inf;
  moments.valid = dataOK;
  moments.u = if dataOK then measured-reference else 0;
  bias = moments.mean;
  spread = sqrt(moments.variance);
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if abs(bias) <= biasLimit and spread <= spreadLimit then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-58,5},{62,5}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Line(points={{-56,27},{-53.15,28.816},{-50.3,30.2361},{-47.45,30.9508},{-44.6,30.8042},{-41.75,29.8284},{-38.9,28.2361},{-36.05,26.3743},{-33.2,24.6489},{-30.35,23.436},{-27.5,23},{-24.65,23.436},{-21.8,24.6489},{-18.95,26.3743},{-16.1,28.2361},{-13.25,29.8284},{-10.4,30.8042},{-7.55,30.9508},{-4.7,30.2361},{-1.85,28.816},{1,27},{3.85,25.184},{6.7,23.7639},{9.55,23.0492},{12.4,23.1958},{15.25,24.1716},{18.1,25.7639},{20.95,27.6257},{23.8,29.3511},{26.65,30.564},{29.5,31},{32.35,30.564},{35.2,29.3511},{38.05,27.6257},{40.9,25.7639},{43.75,24.1716},{46.6,23.1958},{49.45,23.0492},{52.3,23.7639},{55.15,25.184},{58,27}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{35,5},{35,27}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="e∞", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="SteadyStateError")}),
    Documentation(info="<html><p><b>Purpose</b> 用末段采样估计稳态偏差及残差波动</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.IntegerOutput validSamples \"Accepted observations\"; Modelica.Blocks.Interfaces.RealInput measured \"末段实测值\"; Modelica.Blocks.Interfaces.RealInput reference \"末段参考值\"; Modelica.Blocks.Interfaces.RealOutput bias \"离散有符号均值误差\"; Modelica.Blocks.Interfaces.RealOutput spread \"样本总体标准差\"; output EvaluationLibrary.Utilities.Types.Verdict verdict \"均值和波动均满足上限才通过\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"; parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 \"Sampling interval, s\"; parameter Modelica.Units.SI.Time sampleOffset(min=0) = 0 \"First tick offset from windowStart, s\"; parameter Integer minimumSamples(min=1) = 2 \"Minimum valid observations\"; parameter Real biasLimit(min=0) = 0.05 \"允许的均值偏差幅值\"; parameter Real spreadLimit(min=0) = 0.02 \"允许的标准差\"</p><p><b>Behavior</b> 用末段采样估计稳态偏差及残差波动</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.FirstOrderResponse\">EvaluationLibrary.Examples.FirstOrderResponse</a></p>
<p>用末段采样估计稳态偏差及残差波动</p>
<p>专业分类为 ResponseAnalysis.SteadyState。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.IntegerOutput validSamples \"Accepted observations\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput measured \"末段实测值\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput reference \"末段参考值\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput bias \"离散有符号均值误差\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput spread \"样本总体标准差\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.Verdict verdict \"均值和波动均满足上限才通过\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 \"Sampling interval, s\"</code></li>
<li><code>Modelica.Units.SI.Time sampleOffset(min=0) = 0 \"First tick offset from windowStart, s\"</code></li>
<li><code>Integer minimumSamples(min=1) = 2 \"Minimum valid observations\"</code></li>
<li><code>Real biasLimit(min=0) = 0.05 \"允许的均值偏差幅值\"</code></li>
<li><code>Real spreadLimit(min=0) = 0.02 \"允许的标准差\"</code></li>
</ul>
<p><b>时序与基准行为</b> 只在指定末段样本上更新，偏差与波动的等号均通过。</p>
<p><b>最小用法</b> 把窗口设在预期稳定段，按实际单位设两个上限。 <a href=\"modelica://EvaluationLibrary.Examples.PairedPerformance\">MechanicalResponseEvaluation</a> 展示同域接线。</p>
<p><b>适用边界</b> 对终段的经验判定。周期性波动需要合理采样率。</p>
</html>"));
end SteadyStateError;
