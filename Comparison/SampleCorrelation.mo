within EvaluationLibrary.Comparison;
block SampleCorrelation "Pearson correlation of paired uniform samples"
  parameter String metricId=getInstanceName() "Metric identifier";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Requirement version";
  parameter String unitName="1" "Engineering unit of the reported value";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Result record with value, status and observation metadata" annotation(Placement(transformation(extent={{90,80},{110,100}}),iconTransformation(extent={{90,80},{110,100}})));
  Boolean terminalSeen(start=false,fixed=true) "True after normal simulation termination";
  discrete Boolean qualifiedViolation(start=false,fixed=true) "Retained valid violation flag";
  discrete Real qualifiedViolationTime(start=0,fixed=true) "First valid violation time";
  EvaluationLibrary.Utilities.Types.DataStatus resultStatus "Status used in the result record";
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive observation start";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive observation end";
  parameter Boolean applicable = true "Whether this evaluation applies";

  parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small) = 0.02 "Sampling interval";
  parameter Modelica.Units.SI.Time sampleOffset(min=0) = 0 "First sample offset from windowStart";
  parameter Integer minimumSamples(min=1) = 2 "Minimum valid observations";

  Modelica.Blocks.Interfaces.BooleanInput valid "External input-validity condition" annotation(Placement(transformation(extent={{-106,42},{-94,54}}), iconTransformation(extent={{-106,42},{-94,54}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "True while the observation window is active" annotation(Placement(transformation(extent={{94,66},{106,78}}), iconTransformation(extent={{94,66},{106,78}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Status of the observation data";
  Modelica.Blocks.Interfaces.IntegerOutput validSamples "Number of valid samples" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  Modelica.Blocks.Interfaces.RealInput x "First signal" annotation(Placement(transformation(extent={{-106,-6},{-94,6}}), iconTransformation(extent={{-106,-6},{-94,6}})));
  Modelica.Blocks.Interfaces.RealInput y "Second signal" annotation(Placement(transformation(extent={{-106,-54},{-94,-42}}), iconTransformation(extent={{-106,-54},{-94,-42}})));
  Modelica.Blocks.Interfaces.RealOutput correlation(min=-1,max=1) "Pearson correlation on the observed samples" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  Modelica.Blocks.Interfaces.BooleanOutput defined "Both signals have nonzero variance and valid observations" annotation(Placement(transformation(extent={{94,-78},{106,-66}}), iconTransformation(extent={{94,-78},{106,-66}})));
protected
  EvaluationLibrary.Utilities.Internal.SampledEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable,samplePeriod=samplePeriod,sampleOffset=sampleOffset,minimumSamples=minimumSamples) "Observation coverage and qualification";
  Boolean dataOK "External validity and numerical-domain checks";

  final parameter Modelica.Units.SI.Time firstSample = windowStart+sampleOffset "First scheduled sampling instant";
  Boolean takeTick "True at eligible sample instants";
  discrete Real meanX(start=0,fixed=true) "Mean of accepted x samples";
  discrete Real meanY(start=0,fixed=true) "Mean of accepted y samples";
  discrete Real squareX(start=0,fixed=true) "Centred sum of squares for x";
  discrete Real squareY(start=0,fixed=true) "Centred sum of squares for y";
  discrete Real covariance(start=0,fixed=true) "Accumulated centred cross-product";
equation
  when terminal() then terminalSeen=true; end when;
  resultStatus=if (dataState)==EvaluationLibrary.Utilities.Types.DataStatus.PENDING and terminalSeen then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else (dataState);
  when {initial(),false} then
    qualifiedViolation=pre(qualifiedViolation) or false;
    qualifiedViolationTime=if not pre(qualifiedViolation) and false then time else pre(qualifiedViolationTime);
  end when;
  result.metricId=metricId; result.requirementId=requirementId; result.requirementVersion=requirementVersion; result.unit=unitName;
  result.value=correlation; result.valueAvailable=(defined) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(resultStatus);
  result.verdict=Integer(EvaluationLibrary.Utilities.Functions.ToVerdict(resultStatus,qualifiedViolation,false));
  result.complete=time>=windowEnd or terminalSeen;
  result.windowStart=windowStart; result.windowStop=windowEnd;
  result.observedDuration=evidence.observedDuration;
  result.validDuration=evidence.validDuration;
  result.expectedSamples=EvaluationLibrary.Utilities.Functions.SampleCount(windowStart,windowEnd,windowStart+sampleOffset,samplePeriod); result.receivedSamples=evidence.receivedSamples; result.validSamples=validSamples;
  result.everViolated=qualifiedViolation; result.firstViolationTime=qualifiedViolationTime;
  result.samplePeriod=samplePeriod; result.evidenceKind=2;
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable)+"; retained specialist; no unsupplied duration or count inferred";
  result.eventCountsAvailable=false; result.eventCount=0; result.matchedCount=0; result.timedOutCount=0; result.censoredCount=0;
  result.levelAvailable=false; result.level=0; result.level0Upper=0; result.level1Upper=0;
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
        Line(points={{-60,58},{-60,-35},{66,-35}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-48,-26},{56,47}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Dash),
        Ellipse(extent={{-51.2,-21.2},{-44.8,-14.8}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{-37.2,-26.2},{-30.8,-19.8}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{-31.2,-1.2},{-24.8,5.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{-15.2,-4.2},{-8.8,2.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{-0.2,18.8},{6.2,25.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{13.8,11.8},{20.2,18.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{27.8,32.8},{34.2,39.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{40.8,28.8},{47.2,35.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{51.8,48.8},{58.2,55.2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Text(extent={{-65,-50},{65,-75}}, textString="r(x,y)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Uses one-pass centred sums to calculate the Pearson correlation of <code>x</code> and <code>y</code>. The dimensionless result requires at least two accepted pairs and positive variance in both signals. A constant signal leaves <code>defined=false</code>; <code>result.value</code> reports the correlation.</p><p>Connect <code>valid</code> and configure the half-open interval <code>[windowStart, windowEnd)</code>. The first sample is <code>windowStart + sampleOffset</code>; subsequent samples use <code>samplePeriod</code>. Invalid scheduled samples invalidate the result. The result connector carries the sample counts, data status and numerical availability.</p></html>"));
end SampleCorrelation;
