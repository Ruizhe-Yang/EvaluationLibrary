within EvaluationLibrary.Comparison;
block SampleCorrelation "双信号的中心化样本相关系数"
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
  Modelica.Blocks.Interfaces.RealInput x "First signal" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealInput y "Second signal" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput correlation(min=-1,max=1) "Pearson correlation on the observed samples" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  Modelica.Blocks.Interfaces.BooleanOutput defined "Both signals have nonzero variance and valid observations" annotation(Placement(transformation(extent={{94,-78},{106,-66}}), iconTransformation(extent={{94,-78},{106,-66}})));
protected
  EvaluationLibrary.Utilities.Internal.SampledEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable,samplePeriod=samplePeriod,sampleOffset=sampleOffset,minimumSamples=minimumSamples);
  Boolean dataOK "Validity combined with the metric data domain";

  final parameter Modelica.Units.SI.Time firstSample = windowStart+sampleOffset;
  Boolean takeTick "Only the scheduled half-open grid is accepted";
  discrete Real meanX(start=0,fixed=true);
  discrete Real meanY(start=0,fixed=true);
  discrete Real squareX(start=0,fixed=true);
  discrete Real squareY(start=0,fixed=true);
  discrete Real covariance(start=0,fixed=true);
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  validSamples = evidence.validSamples;
  takeTick = evidence.takeTick;
  dataOK = valid and noEvent(abs(x) < Modelica.Constants.inf) and noEvent(abs(y) < Modelica.Constants.inf);
  when sample(firstSample,samplePeriod) then
    if takeTick and dataOK then
      meanX = pre(meanX)+(x-pre(meanX))/max(1,validSamples);
      meanY = pre(meanY)+(y-pre(meanY))/max(1,validSamples);
      squareX = pre(squareX)+(x-pre(meanX))*(x-meanX);
      squareY = pre(squareY)+(y-pre(meanY))*(y-meanY);
      covariance = pre(covariance)+(x-pre(meanX))*(y-meanY);
    else
      meanX = pre(meanX);
      meanY = pre(meanY);
      squareX = pre(squareX);
      squareY = pre(squareY);
      covariance = pre(covariance);
    end if;
  end when;
  defined = validSamples >= 2 and squareX > 0 and squareY > 0 and dataState <> EvaluationLibrary.Utilities.Types.DataStatus.INVALID;
  correlation = if defined then min(1,max(-1,(covariance/sqrt(squareX))/sqrt(squareY))) else 0;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-53,-26},{56,47}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Dash),
        Ellipse(extent={{-50.5,-23.5},{-43.5,-16.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-38.5,-8.5},{-31.5,-1.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-23.5,-16.5},{-16.5,-9.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-11.5,9.5},{-4.5,16.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{4.5,4.5},{11.5,11.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{18.5,30.5},{25.5,37.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{38.5,26.5},{45.5,33.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{49.5,43.5},{56.5,50.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Text(extent={{-65,-50},{65,-75}}, textString="ρ", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p><b>Purpose</b> 双信号的中心化样本相关系数</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.IntegerOutput validSamples \"Accepted observations\"; Modelica.Blocks.Interfaces.RealInput x \"First signal\"; Modelica.Blocks.Interfaces.RealInput y \"Second signal\"; Modelica.Blocks.Interfaces.RealOutput correlation(min=-1,max=1) \"Pearson correlation on the observed samples\"; Modelica.Blocks.Interfaces.BooleanOutput defined \"Both signals have nonzero variance and valid observations\"</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"; parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 \"Sampling interval, s\"; parameter Modelica.Units.SI.Time sampleOffset(min=0) = 0 \"First tick offset from windowStart, s\"; parameter Integer minimumSamples(min=1) = 2 \"Minimum valid observations\"</p><p><b>Behavior</b> 双信号的中心化样本相关系数</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.PairedPerformance\">EvaluationLibrary.Examples.PairedPerformance</a></p>
<p>双信号的中心化样本相关系数</p>
<p><b>行为</b> 只使用同刻的有效样本对，增量计算中心矩。常值信号没有定义的相关系数。</p>
<p><b>最小用法</b> 接入两路对齐轨迹，允许不同物理单位。读取 defined 和 dataState。</p>
<p><b>适用边界</b> 相关系数描述所观测样本的线性关系。窗口及滞后须由使用者定义。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 \"Sampling interval, s\"</code></li>
<li><code>Modelica.Units.SI.Time sampleOffset(min=0) = 0 \"First tick offset from windowStart, s\"</code></li>
<li><code>Integer minimumSamples(min=1) = 2 \"Minimum valid observations\"</code></li>
</ul>
<p>接口及方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.IntegerOutput validSamples \"Accepted observations\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput x \"First signal\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput y \"Second signal\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput correlation(min=-1,max=1) \"Pearson correlation on the observed samples\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput defined \"Both signals have nonzero variance and valid observations\"</code></li>
</ul>
<p><a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">IntegratedResultsReporting</a> 提供同域宿主参考。</p>
</html>"));
end SampleCorrelation;
