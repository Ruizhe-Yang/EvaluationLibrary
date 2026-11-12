within EvaluationLibrary.Statistics;
block GatedPeak "只对危险标记内的采样计算严重度峰值"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 "Sampling interval, s";
  parameter Modelica.Units.SI.Time sampleOffset(min=0) = 0 "First tick offset from windowStart, s";
  parameter Integer minimumSamples(min=1) = 2 "Minimum valid observations";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.IntegerOutput validSamples "Accepted observations" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  parameter Real peakLimit = 1 "可接受的危险严重度峰值上界";
  Modelica.Blocks.Interfaces.BooleanInput hazard "独立的危险标记" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealInput severity "严重度轨迹" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.IntegerOutput hazardSamples(start=0,fixed=true) "有效危险样本数" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput peak(start=0,fixed=true) "危险样本最大值" annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  Modelica.Blocks.Interfaces.RealOutput peakTime(unit="s",start=0,fixed=true) "峰值最早时刻" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "采样危险峰值判定";
protected
  EvaluationLibrary.Utilities.Internal.SampledEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable,samplePeriod=samplePeriod,sampleOffset=sampleOffset,minimumSamples=minimumSamples);
  Boolean dataOK "Validity combined with the metric data domain";

  final parameter Modelica.Units.SI.Time firstSample = windowStart+sampleOffset;
  Boolean takeTick "Only the scheduled half-open grid is accepted";
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  validSamples = evidence.validSamples;
  takeTick = evidence.takeTick;
  dataOK = valid and (not hazard or abs(severity) < Modelica.Constants.inf);
  when sample(firstSample,samplePeriod) then
    hazardSamples = pre(hazardSamples)+(if takeTick and dataOK and hazard then 1 else 0);
    if takeTick and dataOK and hazard and (pre(hazardSamples) == 0 or severity > pre(peak)) then
      peak = severity;
      peakTime = time;
    else
      peak = pre(peak);
      peakTime = pre(peakTime);
    end if;
  end when;
  verdict = if dataState == EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif dataState == EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif dataState <> EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED
    else if hazardSamples == 0 then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE elseif peak <= peakLimit then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED else EvaluationLibrary.Utilities.Types.Verdict.VIOLATED;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Rectangle(extent={{-20,-34},{38,46}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Dash, lineThickness=0.5, radius=0),
        Line(points={{-58,-14},{-34,42},{-18,8},{2,21},{17,36},{35,-9},{59,16}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Ellipse(extent={{12,31},{22,41}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Text(extent={{-65,-50},{65,-75}}, textString="gated max", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="GatedPeak")}),
    Documentation(info="<html><p><b>Purpose</b> 只对危险标记内的采样计算严重度峰值</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.IntegerOutput validSamples \"Accepted observations\"; Modelica.Blocks.Interfaces.BooleanInput hazard \"独立的危险标记\"; Modelica.Blocks.Interfaces.RealInput severity \"严重度轨迹\"; Modelica.Blocks.Interfaces.IntegerOutput hazardSamples(start=0,fixed=true) \"有效危险样本数\"; Modelica.Blocks.Interfaces.RealOutput peak(start=0,fixed=true) \"危险样本最大值\"; Modelica.Blocks.Interfaces.RealOutput peakTime(unit=\"s\",start=0,fixed=true) \"峰值最早时刻\"; output EvaluationLibrary.Utilities.Types.Verdict verdict \"采样危险峰值判定\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"; parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 \"Sampling interval, s\"; parameter Modelica.Units.SI.Time sampleOffset(min=0) = 0 \"First tick offset from windowStart, s\"; parameter Integer minimumSamples(min=1) = 2 \"Minimum valid observations\"; parameter Real peakLimit = 1 \"可接受的危险严重度峰值上界\"</p><p><b>Behavior</b> 只对危险标记内的采样计算严重度峰值</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.AnalyticStatistics\">EvaluationLibrary.Examples.AnalyticStatistics</a></p>
<p>只对危险标记内的采样计算严重度峰值</p>
<p>专业分类为 SignalAnalysis.Extrema。</p>
<p>接口与方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.IntegerOutput validSamples \"Accepted observations\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput hazard \"独立的危险标记\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput severity \"严重度轨迹\"</code></li>
<li><code>Modelica.Blocks.Interfaces.IntegerOutput hazardSamples(start=0,fixed=true) \"有效危险样本数\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput peak(start=0,fixed=true) \"危险样本最大值\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput peakTime(unit=\"s\",start=0,fixed=true) \"峰值最早时刻\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.Verdict verdict \"采样危险峰值判定\"</code></li>
</ul>
<p>参数、类型、默认值及约束</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 \"Sampling interval, s\"</code></li>
<li><code>Modelica.Units.SI.Time sampleOffset(min=0) = 0 \"First tick offset from windowStart, s\"</code></li>
<li><code>Integer minimumSamples(min=1) = 2 \"Minimum valid observations\"</code></li>
<li><code>Real peakLimit = 1 \"可接受的危险严重度峰值上界\"</code></li>
</ul>
<p><b>时序与基准行为</b> 仅在危险样本上更新，等峰保留最早时刻。无危险样本时峰值证据不适用。</p>
<p><b>最小用法</b> 接压力、速度或温度与独立危险标记。 <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">MissionAndProtectionEvaluation</a> 展示同域接线。</p>
<p><b>适用边界</b> 此判定限于采样点。未采到的危险脉冲由连续判据补充。</p>
</html>"));
end GatedPeak;
