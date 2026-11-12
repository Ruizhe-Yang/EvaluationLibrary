within EvaluationLibrary.Response;
block SampleHistory "捕获有限均匀窗口中的离散时标与值"
  parameter Integer n(min=2,max=4096) = 128 "Number of ticks to retain";
  parameter Modelica.Units.SI.Time startTime = 0 "First tick, s";
  parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 "Tick period, s";
  parameter Boolean applicable = true "Applicable trajectory";
  final parameter Modelica.Units.SI.Time endTime = startTime+n*samplePeriod "Exclusive end";
  Modelica.Blocks.Interfaces.RealInput u "Trajectory" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));
  Modelica.Blocks.Interfaces.BooleanInput valid "Validity on sampled ticks" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  output Real samples[n](each start=0,each fixed=true) "Samples in clock order";
  output Modelica.Units.SI.Time stamps[n] = {startTime+(i-1)*samplePeriod for i in 1:n} "Scheduled timestamps";
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Window and data state";
  Modelica.Blocks.Interfaces.IntegerOutput count "Accepted samples" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
protected
  EvaluationLibrary.Utilities.Internal.SampledEvidence evidence(windowStart=startTime,windowEnd=endTime,samplePeriod=samplePeriod,
      minimumSamples=n,applicable=applicable);
  Boolean dataOK;
initial equation
  assert(n>=2 and n<=4096 and samplePeriod>0, "History length or period outside supported range.");
equation
  dataOK = valid and noEvent(abs(u) < Modelica.Constants.inf);
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  count = evidence.validSamples;
  when sample(startTime,samplePeriod) then
    samples = {if evidence.takeTick and dataOK and i==pre(count)+1 then u else pre(samples[i]) for i in 1:n};
  end when;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-50,-34},{-50,-12}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-26,-34},{-26,28}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-2,-34},{-2,15}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{22,-34},{22,-15}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{46,-34},{46,23}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Ellipse(extent={{-54,-16},{-46,-8}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-30,24},{-22,32}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-6,11},{2,19}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{18,-19},{26,-11}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{42,19},{50,27}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Line(points={{-50,51},{46,51}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-50,45},{-50,57}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{46,45},{46,57}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="u[k]", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p><b>Purpose</b> 捕获有限均匀窗口中的离散时标与值</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.RealInput u \"Trajectory\"; Modelica.Blocks.Interfaces.BooleanInput valid \"Validity on sampled ticks\"; output Real samples[n](each start=0,each fixed=true) \"Samples in clock order\"; output Modelica.Units.SI.Time stamps[n] = {startTime+(i-1)*samplePeriod for i in 1:n} \"Scheduled timestamps\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Window and data state\"; Modelica.Blocks.Interfaces.IntegerOutput count \"Accepted samples\"</p><p><b>Parameters</b> parameter Integer n(min=2,max=4096) = 128 \"Number of ticks to retain\"; parameter Modelica.Units.SI.Time startTime = 0 \"First tick, s\"; parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 \"Tick period, s\"; parameter Boolean applicable = true \"Applicable trajectory\"; final parameter Modelica.Units.SI.Time endTime = startTime+n*samplePeriod \"Exclusive end\"</p><p><b>Behavior</b> 捕获有限均匀窗口中的离散时标与值</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.FirstOrderResponse\">EvaluationLibrary.Examples.FirstOrderResponse</a></p>
<p>捕获有限均匀窗口中的离散时标与值</p>
<p><b>行为</b> 时钟按计划网格固定。有效点按索引写入，完整窗输出 COMPLETE 后才可将整数组作为连续样本。</p>
<p><b>最小用法</b> 用 n=128、samplePeriod=0.01 取得 1.28 s 记录，连接给频谱或后处理。</p>
<p><b>适用边界</b> 缺失点会使整个窗口 INVALID，数组前缀不能视为无缺口记录。最多 4096 点。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>Integer n(min=2,max=4096) = 128 \"Number of ticks to retain\"</code></li>
<li><code>Modelica.Units.SI.Time startTime = 0 \"First tick, s\"</code></li>
<li><code>Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 \"Tick period, s\"</code></li>
<li><code>Boolean applicable = true \"Applicable trajectory\"</code></li>
<li><code>final parameter Modelica.Units.SI.Time endTime = startTime+n*samplePeriod \"Exclusive end\"</code></li>
</ul>
<p>接口及方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.RealInput u \"Trajectory\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Validity on sampled ticks\"</code></li>
<li><code>output Real samples[n](each start=0,each fixed=true) \"Samples in clock order\"</code></li>
<li><code>output Modelica.Units.SI.Time stamps[n] = {startTime+(i-1)*samplePeriod for i in 1:n} \"Scheduled timestamps\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Window and data state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.IntegerOutput count \"Accepted samples\"</code></li>
</ul>
<p><a href=\"modelica://EvaluationLibrary.Examples.AnalyticStatistics\">ElectricalPowerQualityEvaluation</a> 提供同域宿主参考。</p>
</html>"));
end SampleHistory;
