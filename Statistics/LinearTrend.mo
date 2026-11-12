within EvaluationLibrary.Statistics;
block LinearTrend "均匀窗的最小二乘线性趋势"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 "Sampling interval, s";
  parameter Modelica.Units.SI.Time sampleOffset(min=0) = 0 "First tick offset from windowStart, s";
  parameter Integer minimumSamples(min=1) = 2 "Minimum valid observations";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.IntegerOutput validSamples "Accepted observations" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  parameter Real referenceOffset = 0 "Numerical centering in the input unit";
  Modelica.Blocks.Interfaces.RealInput u "Observed signal" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.RealOutput slope "Least-squares slope, input unit per second" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput intercept "Fit at the first clock instant" annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  Modelica.Blocks.Interfaces.BooleanOutput defined "At least two time-distinct valid samples" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
protected
  EvaluationLibrary.Utilities.Internal.SampledEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable,samplePeriod=samplePeriod,sampleOffset=sampleOffset,minimumSamples=minimumSamples);
  Boolean dataOK "Validity combined with the metric data domain";

  final parameter Modelica.Units.SI.Time firstSample = windowStart+sampleOffset;
  Boolean takeTick "Only the scheduled half-open grid is accepted";
  discrete Real sumT(start=0,fixed=true);
  discrete Real sumTT(start=0,fixed=true);
  discrete Real sumX(start=0,fixed=true);
  discrete Real sumTX(start=0,fixed=true);
  Real tRelative(unit="s");
  Real xCentered;
  Real denominator;
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  validSamples = evidence.validSamples;
  takeTick = evidence.takeTick;
  dataOK = valid and noEvent(abs(u) < Modelica.Constants.inf);
  tRelative = time-firstSample;
  xCentered = if dataOK then u-referenceOffset else 0;
  when sample(firstSample,samplePeriod) then
    sumT = pre(sumT)+(if takeTick and dataOK then tRelative else 0);
    sumTT = pre(sumTT)+(if takeTick and dataOK then tRelative^2 else 0);
    sumX = pre(sumX)+(if takeTick and dataOK then xCentered else 0);
    sumTX = pre(sumTX)+(if takeTick and dataOK then tRelative*xCentered else 0);
  end when;
  denominator = validSamples*sumTT-sumT^2;
  defined = validSamples >= 2 and noEvent(denominator > 0) and dataState <> EvaluationLibrary.Utilities.Types.DataStatus.INVALID;
  slope = if defined then (validSamples*sumTX-sumT*sumX)/denominator else 0;
  intercept = if defined then referenceOffset+(sumX-slope*sumT)/validSamples else 0;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{-54,-25},{-48,-19}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-37,-5},{-31,1}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-20,-9},{-14,-3}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-1,20},{5,26}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{19,17},{25,23}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{45,41},{51,47}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Line(points={{-57,-27},{58,48}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="fit", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p><b>Purpose</b> 均匀窗的最小二乘线性趋势</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.IntegerOutput validSamples \"Accepted observations\"; Modelica.Blocks.Interfaces.RealInput u \"Observed signal\"; Modelica.Blocks.Interfaces.RealOutput slope \"Least-squares slope, input unit per second\"; Modelica.Blocks.Interfaces.RealOutput intercept \"Fit at the first clock instant\"; Modelica.Blocks.Interfaces.BooleanOutput defined \"At least two time-distinct valid samples\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"; parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 \"Sampling interval, s\"; parameter Modelica.Units.SI.Time sampleOffset(min=0) = 0 \"First tick offset from windowStart, s\"; parameter Integer minimumSamples(min=1) = 2 \"Minimum valid observations\"; parameter Real referenceOffset = 0 \"Numerical centering in the input unit\"</p><p><b>Behavior</b> 均匀窗的最小二乘线性趋势</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.AnalyticStatistics\">EvaluationLibrary.Examples.AnalyticStatistics</a></p>
<p>均匀窗的最小二乘线性趋势</p>
<p><b>行为</b> 在每个有效刻度累积回归矩。截距以首刻度为零，终点冻结。</p>
<p><b>最小用法</b> 输入有慢变趋势的实测轨迹，参考偏置可设为典型信号值。</p>
<p><b>适用边界</b> 采用等权线性拟合。无独立时间方差时输出未定义。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 \"Sampling interval, s\"</code></li>
<li><code>Modelica.Units.SI.Time sampleOffset(min=0) = 0 \"First tick offset from windowStart, s\"</code></li>
<li><code>Integer minimumSamples(min=1) = 2 \"Minimum valid observations\"</code></li>
<li><code>Real referenceOffset = 0 \"Numerical centering in the input unit\"</code></li>
</ul>
<p>接口及方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.IntegerOutput validSamples \"Accepted observations\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput u \"Observed signal\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput slope \"Least-squares slope, input unit per second\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput intercept \"Fit at the first clock instant\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput defined \"At least two time-distinct valid samples\"</code></li>
</ul>
<p><a href=\"modelica://EvaluationLibrary.Examples.PairedPerformance\">MechanicalResponseEvaluation</a> 提供同域宿主参考。</p>
</html>"));
end LinearTrend;
