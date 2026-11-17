within EvaluationLibrary.Frequency;
block ToneResponse "Finite-record input-output gain and phase difference"
  parameter String metricId=getInstanceName() "Metric identifier";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Requirement version";
  parameter String unitName="1" "Engineering unit of the reported value";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Result record with value, status and observation metadata" annotation(Placement(transformation(extent={{90,80},{110,100}}),iconTransformation(extent={{90,80},{110,100}})));
  Boolean terminalSeen(start=false,fixed=true) "True after normal simulation termination";
  discrete Boolean qualifiedViolation(start=false,fixed=true) "Retained valid violation flag";
  discrete Real qualifiedViolationTime(start=0,fixed=true) "First valid violation time";
  EvaluationLibrary.Utilities.Types.DataStatus resultStatus "Status used in the result record";
  parameter Integer nSamples(min=4,max=1024) = 200 "Number of uniformly spaced observations in the finite record";
  parameter Modelica.Units.SI.Time startTime = 0 "First observation or stimulus time in seconds";
  parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.005 "Uniform sampling interval; must be positive";
  parameter Integer bin(min=1,max=div(nSamples-1,2)) = min(8,div(nSamples-1,2)) "Positive coherent Fourier bin below the Nyquist bin";
  parameter EvaluationLibrary.Utilities.Types.SpectralWindow window = EvaluationLibrary.Utilities.Types.SpectralWindow.Rectangular "Finite spectral window selection";
  parameter Real minInputAmplitude(min=Modelica.Constants.small) = 1e-6 "Amplitude floor, input units";
  parameter Real minOutputAmplitude(min=Modelica.Constants.small) = 1e-6 "Phase amplitude floor, output units";
  Modelica.Blocks.Interfaces.RealInput excitation "Input excitation signal" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));
  Modelica.Blocks.Interfaces.RealInput response "Observed response signal" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.BooleanInput valid "Common validity flag" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput gain "Output amplitude / input amplitude" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  Modelica.Blocks.Interfaces.RealOutput phaseDifference(unit="rad") "Output minus input phase in [-pi,pi]" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  Modelica.Blocks.Interfaces.BooleanOutput gainDefined "True when the input amplitude supports a gain estimate" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.BooleanOutput phaseDefined "True when both amplitudes support a phase estimate" annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  Modelica.Blocks.Interfaces.RealOutput frequency(unit="Hz") "Selected frequency in hertz, not above Nyquist" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Status of the observation data";
protected
  EvaluationLibrary.Utilities.Internal.ToneSpectrum x(nSamples=nSamples,nBins=bin,startTime=startTime,samplePeriod=samplePeriod,window=window,amplitudeFloor=minInputAmplitude) "Excitation spectrum";
  EvaluationLibrary.Utilities.Internal.ToneSpectrum y(nSamples=nSamples,nBins=bin,startTime=startTime,samplePeriod=samplePeriod,window=window,amplitudeFloor=minOutputAmplitude) "Response spectrum";
  Real delta(unit="rad") "Unwrapped response-minus-excitation phase";
initial equation
  assert(bin>=1 and 2*bin<nSamples and minInputAmplitude>0 and minOutputAmplitude>0, "A non-Nyquist positive bin and positive floors are required.");
equation
  when terminal() then terminalSeen=true; end when;
  resultStatus=if (dataState)==EvaluationLibrary.Utilities.Types.DataStatus.PENDING and terminalSeen then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else (dataState);
  when {initial(),false} then
    qualifiedViolation=pre(qualifiedViolation) or false;
    qualifiedViolationTime=if not pre(qualifiedViolation) and false then time else pre(qualifiedViolationTime);
  end when;
  result.metricId=metricId; result.requirementId=requirementId; result.requirementVersion=requirementVersion; result.unit=unitName;
  result.value=gain; result.valueAvailable=(gainDefined) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(resultStatus);
  result.verdict=Integer(EvaluationLibrary.Utilities.Functions.ToVerdict(resultStatus,qualifiedViolation,false));
  result.complete=time>=startTime+nSamples*samplePeriod or terminalSeen;
  result.windowStart=startTime; result.windowStop=startTime+nSamples*samplePeriod;
  result.observedDuration=min(x.observedDuration,y.observedDuration);
  result.validDuration=min(x.validDuration,y.validDuration);
  result.expectedSamples=nSamples; result.receivedSamples=min(x.receivedSamples,y.receivedSamples); result.validSamples=min(x.validSamples,y.validSamples);
  result.everViolated=qualifiedViolation; result.firstViolationTime=qualifiedViolationTime;
  result.samplePeriod=samplePeriod; result.evidenceKind=2;
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable)+"; retained specialist; no unsupplied duration or count inferred";
  result.eventCountsAvailable=false; result.eventCount=0; result.matchedCount=0; result.timedOutCount=0; result.censoredCount=0;
  result.levelAvailable=false; result.level=0; result.level0Upper=0; result.level1Upper=0;
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
        Line(points={{-60,29},{60,29}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-60,-20},{60,-20}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-56,29},{-54.4444,31.2862},{-52.8889,33.5452},{-51.3333,35.7502},{-49.7778,37.875},{-48.2222,39.8942},{-46.6667,41.784},{-45.1111,43.5218},{-43.5556,45.0869},{-42,46.4609},{-40.4444,47.6272},{-38.8889,48.5722},{-37.3333,49.2844},{-35.7778,49.7556},{-34.2222,49.98},{-32.6667,49.955},{-31.1111,49.681},{-29.5556,49.161},{-28,48.4015},{-26.4444,47.4113},{-24.8889,46.2022},{-23.3333,44.7886},{-21.7778,43.1874},{-20.2222,41.4175},{-18.6667,39.5},{-17.1111,37.4577},{-15.5556,35.3148},{-14,33.0969},{-12.4444,30.8303},{-10.8889,28.5419},{-9.33333,26.2589},{-7.77778,24.0086},{-6.22222,21.8176},{-4.66667,19.7119},{-3.11111,17.7167},{-1.55556,15.8556},{0,14.1508},{1.55556,12.6224},{3.11111,11.2888},{4.66667,10.1657},{6.22222,9.26645},{7.77778,8.60182},{9.33333,8.17966},{10.8889,8.005},{12.4444,8.07991},{14,8.40351},{15.5556,8.97194},{17.1111,9.77846},{18.6667,10.8135},{20.2222,12.0647},{21.7778,13.5172},{23.3333,15.1537},{24.8889,16.9549},{26.4444,18.8992},{28,20.9636},{29.5556,23.1236},{31.1111,25.3534},{32.6667,27.6265},{34.2222,29.916},{35.7778,32.1946},{37.3333,34.4352},{38.8889,36.6112},{40.4444,38.6967},{42,40.667},{43.5556,42.4985},{45.1111,44.1696},{46.6667,45.6604},{48.2222,46.9531},{49.7778,48.0325},{51.3333,48.8855},{52.8889,49.5022},{54.4444,49.8752},{56,50}}, color={128,128,128}, thickness=0.95, pattern=LinePattern.Solid),
        Line(points={{-56,-30.043},{-54.4444,-28.9214},{-52.8889,-27.6938},{-51.3333,-26.3747},{-49.7778,-24.9799},{-48.2222,-23.5258},{-46.6667,-22.0298},{-45.1111,-20.5097},{-43.5556,-18.9836},{-42,-17.4695},{-40.4444,-15.9855},{-38.8889,-14.5493},{-37.3333,-13.1778},{-35.7778,-11.8874},{-34.2222,-10.6935},{-32.6667,-9.61015},{-31.1111,-8.65034},{-29.5556,-7.82546},{-28,-7.14529},{-26.4444,-6.61794},{-24.8889,-6.24966},{-23.3333,-6.04483},{-21.7778,-6.0059},{-20.2222,-6.13332},{-18.6667,-6.42557},{-17.1111,-6.87919},{-15.5556,-7.48878},{-14,-8.2471},{-12.4444,-9.14512},{-10.8889,-10.1722},{-9.33333,-11.3161},{-7.77778,-12.5632},{-6.22222,-13.8987},{-4.66667,-15.3068},{-3.11111,-16.7706},{-1.55556,-18.2728},{0,-19.7956},{1.55556,-21.3208},{3.11111,-22.8303},{4.66667,-24.3061},{6.22222,-25.7308},{7.77778,-27.0873},{9.33333,-28.3596},{10.8889,-29.5325},{12.4444,-30.5921},{14,-31.5258},{15.5556,-32.3224},{17.1111,-32.9726},{18.6667,-33.4686},{20.2222,-33.8045},{21.7778,-33.9763},{23.3333,-33.9819},{24.8889,-33.8213},{26.4444,-33.4965},{28,-33.0112},{29.5556,-32.3712},{31.1111,-31.5842},{32.6667,-30.6594},{34.2222,-29.608},{35.7778,-28.4423},{37.3333,-27.1763},{38.8889,-25.825},{40.4444,-24.4044},{42,-22.9315},{43.5556,-21.4237},{45.1111,-19.899},{46.6667,-18.3755},{48.2222,-16.8713},{49.7778,-15.4043},{51.3333,-13.992},{52.8889,-12.651},{54.4444,-11.3974},{56,-10.2461}}, color={0,0,127}, thickness=0.95, pattern=LinePattern.Solid),
        Line(points={{-56,4},{-56,-42}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dot),
        Line(points={{-44.6,4},{-44.6,-42}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dot),
        Line(points={{-56,-42},{-44.6,-42}}, color={64,64,64}, thickness=0.6, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="Ay/Ax, Δφ", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Samples <code>excitation</code> and <code>response</code> on a common grid beginning at <code>startTime</code>. The selected coherent frequency is <code>bin/(nSamples*samplePeriod)</code>, with a positive bin below Nyquist. The default period is 0.005 s for 200 samples.</p><p>Connect the shared <code>valid</code> input. Gain requires an input amplitude greater than <code>minInputAmplitude</code>; phase also requires an output amplitude greater than <code>minOutputAmplitude</code>. The phase difference is wrapped to plus or minus pi. Gain has output units divided by input units; set <code>unitName</code> accordingly. <code>result.value</code> reports gain.</p></html>"));
end ToneResponse;
