within EvaluationLibrary.Frequency;
block ToneResponse "以共同采样窗估计单频增益和相位差"
  parameter Integer nSamples(min=4,max=1024) = 200;
  parameter Modelica.Units.SI.Time startTime = 0;
  parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.005;
  parameter Integer bin(min=1,max=div(nSamples-1,2)) = min(8,div(nSamples-1,2));
  parameter EvaluationLibrary.Utilities.Types.SpectralWindow window = EvaluationLibrary.Utilities.Types.SpectralWindow.Rectangular;
  parameter Real minInputAmplitude(min=Modelica.Constants.small) = 1e-6 "Amplitude floor, input units";
  parameter Real minOutputAmplitude(min=Modelica.Constants.small) = 1e-6 "Phase amplitude floor, output units";
  Modelica.Blocks.Interfaces.RealInput excitation annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));
  Modelica.Blocks.Interfaces.RealInput response annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.BooleanInput valid "Common validity flag" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput gain "Output amplitude / input amplitude" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  Modelica.Blocks.Interfaces.RealOutput phaseDifference(unit="rad") "Output minus input phase in [-pi,pi]" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  Modelica.Blocks.Interfaces.BooleanOutput gainDefined annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.BooleanOutput phaseDefined annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  Modelica.Blocks.Interfaces.RealOutput frequency(unit="Hz") annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState;
protected
  EvaluationLibrary.Utilities.Internal.ToneSpectrum x(nSamples=nSamples,nBins=bin,startTime=startTime,samplePeriod=samplePeriod,window=window,amplitudeFloor=minInputAmplitude);
  EvaluationLibrary.Utilities.Internal.ToneSpectrum y(nSamples=nSamples,nBins=bin,startTime=startTime,samplePeriod=samplePeriod,window=window,amplitudeFloor=minOutputAmplitude);
  Real delta(unit="rad");
initial equation
  assert(bin>=1 and 2*bin<nSamples and minInputAmplitude>0 and minOutputAmplitude>0, "A non-Nyquist positive bin and positive floors are required.");
equation
  x.u = excitation;
  y.u = response;
  x.valid = valid;
  y.valid = valid;
  dataState = if x.dataState==EvaluationLibrary.Utilities.Types.DataStatus.INVALID or y.dataState==EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.DataStatus.INVALID
    elseif x.dataState==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE and y.dataState==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE
    elseif x.dataState==EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE or y.dataState==EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else EvaluationLibrary.Utilities.Types.DataStatus.PENDING;
  gainDefined = dataState == EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE and x.amplitude[bin+1]>minInputAmplitude;
  phaseDefined = gainDefined and y.amplitude[bin+1]>minOutputAmplitude;
  gain = if gainDefined then y.amplitude[bin+1]/x.amplitude[bin+1] else 0;
  delta = y.phase[bin+1]-x.phase[bin+1];
  phaseDifference = if phaseDefined then Modelica.Math.atan2(sin(delta),cos(delta)) else 0;
  frequency = bin*x.resolution;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-56,18},{-53.15,22.4972},{-50.3,26.835},{-47.45,30.8598},{-44.6,34.4291},{-41.75,37.4164},{-38.9,39.7158},{-36.05,41.246},{-33.2,41.9526},{-30.35,41.8108},{-27.5,40.8254},{-24.65,39.0314},{-21.8,36.4923},{-18.95,33.2982},{-16.1,29.5621},{-13.25,25.4164},{-10.4,21.008},{-7.55,16.493},{-4.7,12.0314},{-1.85,7.7813},{1,3.89315},{3.85,0.504753},{6.7,-2.26387},{9.55,-4.31464},{12.4,-5.57489},{15.25,-6},{18.1,-5.57489},{20.95,-4.31464},{23.8,-2.26387},{26.65,0.504753},{29.5,3.89315},{32.35,7.7813},{35.2,12.0314},{38.05,16.493},{40.9,21.008},{43.75,25.4164},{46.6,29.5621},{49.45,33.2982},{52.3,36.4923},{55.15,39.0314},{58,40.8254}}, color={128,128,128}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-56,-21.3075},{-53.15,-18.8318},{-50.3,-16.0787},{-47.45,-13.1457},{-44.6,-10.1367},{-41.75,-7.15826},{-38.9,-4.31591},{-36.05,-1.71035},{-33.2,0.566115},{-30.35,2.43285},{-27.5,3.82372},{-24.65,4.68945},{-21.8,4.99937},{-18.95,4.74251},{-16.1,3.92796},{-13.25,2.58459},{-10.4,0.759968},{-7.55,-1.48125},{-4.7,-4.05968},{-1.85,-6.88397},{1,-9.85408},{3.85,-12.8648},{6.7,-15.8094},{9.55,-18.5837},{12.4,-21.0893},{15.25,-23.2375},{18.1,-24.9521},{20.95,-26.1726},{23.8,-26.8555},{26.65,-26.9767},{29.5,-26.5319},{32.35,-25.537},{35.2,-24.027},{38.05,-22.0555},{40.9,-19.6924},{43.75,-17.0214},{46.6,-14.1371},{49.45,-11.1416},{52.3,-8.1411},{55.15,-5.24189},{58,-2.54666}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-30,-30},{-13,-30}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="G, φ", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p><b>Purpose</b> 以共同采样窗估计单频增益和相位差</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.RealInput excitation; Modelica.Blocks.Interfaces.RealInput response; Modelica.Blocks.Interfaces.BooleanInput valid \"Common validity flag\"; Modelica.Blocks.Interfaces.RealOutput gain \"Output amplitude / input amplitude\"; Modelica.Blocks.Interfaces.RealOutput phaseDifference(unit=\"rad\") \"Output minus input phase in [-pi,pi]\"; Modelica.Blocks.Interfaces.BooleanOutput gainDefined; Modelica.Blocks.Interfaces.BooleanOutput phaseDefined; Modelica.Blocks.Interfaces.RealOutput frequency(unit=\"Hz\"); output EvaluationLibrary.Utilities.Types.DataStatus dataState</p><p><b>Parameters</b> parameter Integer nSamples(min=4,max=1024) = 200; parameter Modelica.Units.SI.Time startTime = 0; parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.005; parameter Integer bin(min=1,max=div(nSamples-1,2)) = min(8,div(nSamples-1,2)); parameter EvaluationLibrary.Utilities.Types.SpectralWindow window = EvaluationLibrary.Utilities.Types.SpectralWindow.Rectangular; parameter Real minInputAmplitude(min=Modelica.Constants.small) = 1e-6 \"Amplitude floor, input units\"; parameter Real minOutputAmplitude(min=Modelica.Constants.small) = 1e-6 \"Phase amplitude floor, output units\"</p><p><b>Behavior</b> 以共同采样窗估计单频增益和相位差</p><p><b>Initialization</b> Use the declared initial values and host state modifiers.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use the declared parameter range. The catalog identifies simulation coverage.</p><p><b>Observables</b> Inspect the declared output variables.</p><p><b>Evidence kind</b> Inspect applicability, coverage and validity before interpreting the result.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.HarmonicMeasurements\">EvaluationLibrary.Examples.HarmonicMeasurements</a></p>
<p>以共同采样窗估计单频增益和相位差</p>
<p><b>行为</b> 共同窗口结束后估计输出与输入的同频幅值比。两路幅值均充分时给最短相位差。</p>
<p><b>最小用法</b> 对已进入稳态的正弦激励和响应设置整周期采样窗。</p>
<p><b>适用边界</b> 这是单频观测的频率响应特征。暂态、非线性和非相干采样会改变结果。</p>
<p>参数的类型、默认值和取值见下列声明。</p>
<ul>
<li><code>Integer nSamples(min=4,max=1024) = 200</code></li>
<li><code>Modelica.Units.SI.Time startTime = 0</code></li>
<li><code>Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.005</code></li>
<li><code>Integer bin(min=1,max=div(nSamples-1,2)) = min(8,div(nSamples-1,2))</code></li>
<li><code>EvaluationLibrary.Utilities.Types.SpectralWindow window = EvaluationLibrary.Utilities.Types.SpectralWindow.Rectangular</code></li>
<li><code>Real minInputAmplitude(min=Modelica.Constants.small) = 1e-6 \"Amplitude floor, input units\"</code></li>
<li><code>Real minOutputAmplitude(min=Modelica.Constants.small) = 1e-6 \"Phase amplitude floor, output units\"</code></li>
</ul>
<p>接口及方向</p>
<ul>
<li><code>Modelica.Blocks.Interfaces.RealInput excitation</code></li>
<li><code>Modelica.Blocks.Interfaces.RealInput response</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanInput valid \"Common validity flag\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput gain \"Output amplitude / input amplitude\"</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput phaseDifference(unit=\"rad\") \"Output minus input phase in [-pi,pi]\"</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput gainDefined</code></li>
<li><code>Modelica.Blocks.Interfaces.BooleanOutput phaseDefined</code></li>
<li><code>Modelica.Blocks.Interfaces.RealOutput frequency(unit=\"Hz\")</code></li>
<li><code>output EvaluationLibrary.Utilities.Types.DataStatus dataState</code></li>
</ul>
<p><a href=\"modelica://EvaluationLibrary.Examples.AnalyticStatistics\">ElectricalPowerQualityEvaluation</a> 提供同域宿主参考。</p>
</html>"));
end ToneResponse;
