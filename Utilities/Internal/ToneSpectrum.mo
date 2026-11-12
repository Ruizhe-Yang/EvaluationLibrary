within EvaluationLibrary.Utilities.Internal;
block ToneSpectrum "有限均匀窗的一侧离散幅度谱和相位谱"
  parameter Integer nSamples(min=4,max=1024) = 128 "Uniform sample count";
  parameter Integer nBins(min=1,max=div(nSamples,2)) = min(32,div(nSamples,2)) "Highest retained nonnegative bin";
  parameter Modelica.Units.SI.Time startTime = 0 "First sample, s";
  parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.01 "Tick period, s";
  parameter EvaluationLibrary.Utilities.Types.SpectralWindow window = EvaluationLibrary.Utilities.Types.SpectralWindow.Rectangular "Weighting";
  parameter Real amplitudeFloor(min=0) = 1e-9 "Smallest reportable amplitude, input unit";
  parameter Boolean applicable = true "Whether this record applies";
  final parameter Modelica.Units.SI.Frequency resolution = 1/(nSamples*samplePeriod) "Bin width, Hz";
  Modelica.Blocks.Interfaces.RealInput u "Trajectory" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));
  Modelica.Blocks.Interfaces.BooleanInput valid "Clocked data validity" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  output Real amplitude[nBins+1] "One-sided peak amplitude, including DC";
  output Modelica.Units.SI.Angle phase[nBins+1] "Phase of cosine reference at startTime";
  output Modelica.Units.SI.Frequency frequency[nBins+1] = {(i-1)*resolution for i in 1:nBins+1};
  Modelica.Blocks.Interfaces.IntegerOutput dominantBin "Strongest non-DC bin, or zero" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  Modelica.Blocks.Interfaces.RealOutput dominantFrequency(unit="Hz") annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState;
protected
  EvaluationLibrary.Response.SampleHistory history(n=nSamples,startTime=startTime,
    samplePeriod=samplePeriod,applicable=applicable);
  Real bins[nBins+1,2] "Discrete spectrum of the completed history";
  Real strongest;
initial equation
  assert(nSamples>=4 and nSamples<=1024 and nBins>=1 and nBins<=div(nSamples,2) and samplePeriod>0 and amplitudeFloor>=0,
    "Invalid DFT grid.");
equation
  history.u = u;
  history.valid = valid;
  dataState = history.dataState;
  bins = if dataState==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Internal.oneSidedDFT(history.samples,nBins,window,amplitudeFloor) else zeros(nBins+1,2);
  amplitude = bins[:,1];
  phase = bins[:,2];
  dominantFrequency = dominantBin*resolution;
algorithm
  strongest := amplitudeFloor;
  dominantBin := 0;
  for k in 1:nBins loop
    if amplitude[k+1] > strongest then
      strongest := amplitude[k+1];
      dominantBin := k;
    end if;
  end for;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-34},{65,-34}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-43,-34},{-43,-17}}, color={0,0,127}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{-15,-34},{-15,23}}, color={0,0,127}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{13,-34},{13,43}}, color={0,0,127}, thickness=1.3, pattern=LinePattern.Solid),
        Line(points={{41,-34},{41,-3}}, color={0,0,127}, thickness=1.3, pattern=LinePattern.Solid),
        Ellipse(extent={{-46,-20},{-40,-14}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-18,20},{-12,26}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{10,40},{16,46}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{38,-6},{44,0}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Text(extent={{50,-36},{68,-49}}, textString="f", textColor={128,128,128}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="A(f)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>有限均匀窗的一侧离散幅度谱和相位谱</p>
<p><b>行为</b> 按 1/samplePeriod 均匀采集 nSamples 点，结束后计算一次 DFT。频率分辨率为 1/(nSamples·samplePeriod)，最高频点不超过 Nyquist。非直流及非 Nyquist 幅值双边合并并除窗权重和。</p>
<p><b>最小用法</b> 对 8 Hz 信号取 samplePeriod=0.005、nSamples=200、nBins≥8，则 8 Hz 为第 8 个非直流频点。</p>
<p><b>适用边界</b> 最多 1024 点，直接 DFT 的计算量与点数及保留频点数的乘积成正比。谱泄漏与混叠取决于窗、采样率和前置滤波。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>Integer nSamples(min=4,max=1024) = 128 \"Uniform sample count\"</code></li>
<li><code>Integer nBins(min=1,max=div(nSamples,2)) = min(32,div(nSamples,2)) \"Highest retained nonnegative bin\"</code></li>
<li><code>Modelica.Units.SI.Time startTime = 0 \"First sample, s\"</code></li>
<li><code>Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.01 \"Tick period, s\"</code></li>
<li><code>EvaluationLibrary.Utilities.Types.SpectralWindow window = EvaluationLibrary.Utilities.Types.SpectralWindow.Rectangular \"Weighting\"</code></li>
<li><code>Real amplitudeFloor(min=0) = 1e-9 \"Smallest reportable amplitude, input unit\"</code></li>
<li><code>Boolean applicable = true \"Whether this record applies\"</code></li>
<li><code>final parameter Modelica.Units.SI.Frequency resolution = 1/(nSamples*samplePeriod) \"Bin width, Hz\"</code></li>
</ul>
<p>接口及方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.RealInput u \"Trajectory\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Clocked data validity\"</code></li>
<li><code>output Real amplitude[nBins+1] \"One-sided peak amplitude, including DC\"</code></li>
<li><code>output Modelica.Units.SI.Angle phase[nBins+1] \"Phase of cosine reference at startTime\"</code></li>
<li><code>output Modelica.Units.SI.Frequency frequency[nBins+1] = {(i-1)*resolution for i in 1:nBins+1}</code></li>
<li><code>Modelica.Blocks.Interfaces.IntegerOutput dominantBin \"Strongest non-DC bin, or zero\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput dominantFrequency(unit=\"Hz\")</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState</code></li>
</ul>
<p><a href=\"modelica://EvaluationLibrary.Examples.AnalyticStatistics\">ElectricalPowerQualityEvaluation</a> 提供同域宿主参考。</p>
</html>"));
end ToneSpectrum;
