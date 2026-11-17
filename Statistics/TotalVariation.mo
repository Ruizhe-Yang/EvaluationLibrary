within EvaluationLibrary.Statistics;
block TotalVariation "Sum of absolute changes between consecutive samples"
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

  Modelica.Blocks.Interfaces.BooleanInput valid "External input-validity condition" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "True while the observation window is active" annotation(Placement(transformation(extent={{94,42},{106,54}}), iconTransformation(extent={{94,42},{106,54}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Status of the observation data";
  Modelica.Blocks.Interfaces.IntegerOutput validSamples "Number of valid samples" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealInput u "Observed signal" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.RealOutput value(start=0,fixed=true) "Numerical value; check result.valueAvailable" annotation(Placement(transformation(extent={{94,-54},{106,-42}}), iconTransformation(extent={{94,-54},{106,-42}})));
protected
  EvaluationLibrary.Utilities.Internal.SampledEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable,samplePeriod=samplePeriod,sampleOffset=sampleOffset,minimumSamples=minimumSamples) "Observation coverage and qualification";
  Boolean dataOK "External validity and numerical-domain checks";

  final parameter Modelica.Units.SI.Time firstSample = windowStart+sampleOffset "First scheduled sampling instant";
  Boolean takeTick "True at eligible sample instants";
  discrete Real previousValue(start=0,fixed=true) "Previous valid sampled value";
  discrete Boolean previousValid(start=false,fixed=true) "Validity of the previous scheduled sample";
equation
  when terminal() then terminalSeen=true; end when;
  resultStatus=if (dataState)==EvaluationLibrary.Utilities.Types.DataStatus.PENDING and terminalSeen then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else (dataState);
  when {initial(),false} then
    qualifiedViolation=pre(qualifiedViolation) or false;
    qualifiedViolationTime=if not pre(qualifiedViolation) and false then time else pre(qualifiedViolationTime);
  end when;
  result.metricId=metricId; result.requirementId=requirementId; result.requirementVersion=requirementVersion; result.unit=unitName;
  result.value=value; result.valueAvailable=(validSamples>1) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
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
  dataOK = valid and abs(u) < Modelica.Constants.inf;
  when sample(firstSample,samplePeriod) then
    previousValid = takeTick and dataOK;
    previousValue = if previousValid then u else pre(previousValue);
    value = if previousValid and pre(previousValid) then pre(value)+abs(u-pre(previousValue)) else pre(value);
  end when;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,61},{-64,-38},{65,-38}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-53,-6},{-26,34}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{15,-17},{51,24}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid),
        Ellipse(extent={{-56.4,-9.4},{-49.6,-2.6}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{-29.4,30.6},{-22.6,37.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{11.6,-20.4},{18.4,-13.6}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{47.6,20.6},{54.4,27.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{-41,-6},{-41,34}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{37,-17},{37,24}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-8,-31},{-2,-23},{4,-31},{10,-23}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="Σ |Δu|", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=true), graphics={Text(extent={{-96,99},{96,88}}, textColor={73,53,132}, textString="TotalVariation")}),
    Documentation(info="<html><p>Accumulates <code>abs(u - previousValue)</code> for consecutive valid samples. Invalid samples interrupt the sequence, so differences are not taken across missing data. The reported value has the input unit and requires at least two accepted samples.</p><p>Connect <code>valid</code> and configure the half-open interval <code>[windowStart, windowEnd)</code>. The first sample is <code>windowStart + sampleOffset</code>; subsequent samples use <code>samplePeriod</code>. Invalid scheduled samples invalidate the result. The result connector carries the sample counts, data status and numerical availability.</p></html>"));
end TotalVariation;
