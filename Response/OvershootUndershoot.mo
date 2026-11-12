within EvaluationLibrary.Response;
block OvershootUndershoot "测量阶跃基准区间之外的归一化超调和反向欠调"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 "Sampling interval, s";
  parameter Modelica.Units.SI.Time sampleOffset(min=0) = 0 "First tick offset from windowStart, s";
  parameter Integer minimumSamples(min=1) = 2 "Minimum valid observations";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,66},{106,78}}), iconTransformation(extent={{94,66},{106,78}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.IntegerOutput validSamples "Accepted observations" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  parameter Real initialValue = 0 "Pre-step baseline";
  parameter Real target = 1 "Final target, different from initialValue";
  Modelica.Blocks.Interfaces.RealInput u "Measured response" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.RealOutput overshootPercent(unit="%") "Largest excursion past target" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  Modelica.Blocks.Interfaces.RealOutput undershootPercent(unit="%") "Largest excursion opposite the step" annotation(Placement(transformation(extent={{94,-78},{106,-66}}), iconTransformation(extent={{94,-78},{106,-66}})));
  output Modelica.Units.SI.Time overshootAt(start=0,fixed=true);
  output Modelica.Units.SI.Time undershootAt(start=0,fixed=true);
protected
  EvaluationLibrary.Utilities.Internal.SampledEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable,samplePeriod=samplePeriod,sampleOffset=sampleOffset,minimumSamples=minimumSamples);
  Boolean dataOK "Validity combined with the metric data domain";

  final parameter Modelica.Units.SI.Time firstSample = windowStart+sampleOffset;
  Boolean takeTick "Only the scheduled half-open grid is accepted";
  discrete Real high(start=1,fixed=true);
  discrete Real low(start=0,fixed=true);
  Real normalized;
initial equation
  assert(abs(target-initialValue)>Modelica.Constants.small, "Target and initial value must differ.");
equation
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  validSamples = evidence.validSamples;
  takeTick = evidence.takeTick;
  dataOK = valid and noEvent(abs(u) < Modelica.Constants.inf);
  normalized = if dataOK then (u-initialValue)/(target-initialValue) else 0;
  when sample(firstSample,samplePeriod) then
    high = if takeTick and dataOK then max(pre(high),normalized) else pre(high);
    low = if takeTick and dataOK then min(pre(low),normalized) else pre(low);
    overshootAt = if takeTick and dataOK and normalized > pre(high) then time else pre(overshootAt);
    undershootAt = if takeTick and dataOK and normalized < pre(low) then time else pre(undershootAt);
  end when;
  overshootPercent = 100*(high-1);
  undershootPercent = -100*low;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-58,28},{62,28}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Line(points={{-56,-30},{-53.1,-25.2384},{-50.2,-16.5548},{-47.3,-5.44051},{-44.4,6.66478},{-41.5,18.4934},{-38.6,29.0324},{-35.7,37.5681},{-32.8,43.6966},{-29.9,47.3033},{-27,48.5213},{-24.1,47.6739},{-21.2,45.2118},{-18.3,41.649},{-15.4,37.5052},{-12.5,33.2582},{-9.6,29.3084},{-6.7,25.957},{-3.8,23.3967},{-0.9,21.7143},{2,20.9018},{4.9,20.8746},{7.8,21.4928},{10.7,22.5838},{13.6,23.9639},{16.5,25.4565},{19.4,26.9072},{22.3,28.1932},{25.2,29.2287},{28.1,29.966},{31,30.393},{33.9,30.5275},{36.8,30.4104},{39.7,30.0979},{42.6,29.6535},{45.5,29.141},{48.4,28.6189},{51.3,28.1358},{54.2,27.728},{57.1,27.4186},{60,27.2176}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-18,28},{-18,47}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-42,44},{-9,44}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="OS / US", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p><b>Purpose</b> 测量阶跃基准区间之外的归一化超调和反向欠调</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"; Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"; output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"; Modelica.Blocks.Interfaces.IntegerOutput validSamples \"Accepted observations\"; Modelica.Blocks.Interfaces.RealInput u \"Measured response\"; Modelica.Blocks.Interfaces.RealOutput overshootPercent(unit=\"%\") \"Largest excursion past target\"; Modelica.Blocks.Interfaces.RealOutput undershootPercent(unit=\"%\") \"Largest excursion opposite the step\"; output Modelica.Units.SI.Time overshootAt(start=0,fixed=true); output Modelica.Units.SI.Time undershootAt(start=0,fixed=true)</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"; parameter Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"; parameter Boolean applicable = true \"Whether the analysis applies\"; parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 \"Sampling interval, s\"; parameter Modelica.Units.SI.Time sampleOffset(min=0) = 0 \"First tick offset from windowStart, s\"; parameter Integer minimumSamples(min=1) = 2 \"Minimum valid observations\"; parameter Real initialValue = 0 \"Pre-step baseline\"; parameter Real target = 1 \"Final target, different from initialValue\"</p><p><b>Behavior</b> 测量阶跃基准区间之外的归一化超调和反向欠调</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.FirstOrderResponse\">EvaluationLibrary.Examples.FirstOrderResponse</a></p>
<p>测量阶跃基准区间之外的归一化超调和反向欠调</p>
<p><b>行为</b> 相对于有方向的阶跃幅度计算两个超出量。无相应超调时数值为零。</p>
<p><b>最小用法</b> 把位置或转速接 u，明确 pre-step 与目标值。下降阶跃同样可用。</p>
<p><b>适用边界</b> 只比较采样点。发生时间在对应百分比大于零时有效。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>Modelica.Units.SI.Time windowStart = 0 \"Inclusive window start, s\"</code></li>
<li><code>Modelica.Units.SI.Time windowEnd = 5 \"Exclusive window end, s\"</code></li>
<li><code>Boolean applicable = true \"Whether the analysis applies\"</code></li>
<li><code>Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 \"Sampling interval, s\"</code></li>
<li><code>Modelica.Units.SI.Time sampleOffset(min=0) = 0 \"First tick offset from windowStart, s\"</code></li>
<li><code>Integer minimumSamples(min=1) = 2 \"Minimum valid observations\"</code></li>
<li><code>Real initialValue = 0 \"Pre-step baseline\"</code></li>
<li><code>Real target = 1 \"Final target, different from initialValue\"</code></li>
</ul>
<p>接口及方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Host-provided input validity\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput inWindow \"Current point lies in applicable window\"</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState \"Collection and data validity state\"</code></li>
<li><code>Modelica.Blocks.Interfaces.IntegerOutput validSamples \"Accepted observations\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput u \"Measured response\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput overshootPercent(unit=\"%\") \"Largest excursion past target\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput undershootPercent(unit=\"%\") \"Largest excursion opposite the step\"</code></li>
<li><code>output Modelica.Units.SI.Time overshootAt(start=0,fixed=true)</code></li>
<li><code>output Modelica.Units.SI.Time undershootAt(start=0,fixed=true)</code></li>
</ul>
<p><a href=\"modelica://EvaluationLibrary.Examples.PairedPerformance\">MechanicalResponseEvaluation</a> 提供同域宿主参考。</p>
</html>"));
end OvershootUndershoot;
