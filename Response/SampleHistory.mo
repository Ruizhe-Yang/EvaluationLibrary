within EvaluationLibrary.Response;
block SampleHistory "Finite ordered samples and scheduled timestamps"
  parameter String metricId=getInstanceName() "Stable identity of this retained specialist";
  parameter String requirementId="" "Requirement identity, when configured";
  parameter String requirementVersion="" "Interpreted requirement version";
  parameter String unitName="1" "Engineering unit of the reported specialist value";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Complete specialist result" annotation(Placement(transformation(extent={{90,80},{110,100}}),iconTransformation(extent={{90,80},{110,100}})));
  Boolean terminalSeen(start=false,fixed=true) "Terminal seen";
  discrete Boolean qualifiedViolation(start=false,fixed=true) "Qualified violation";
  discrete Real qualifiedViolationTime(start=0,fixed=true) "Qualified violation time";
  EvaluationLibrary.Utilities.Types.DataStatus resultStatus "Result status";
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
      minimumSamples=n,applicable=applicable) "Evidence";
  Boolean dataOK "Data ok";
initial equation
  assert(n>=2 and n<=4096 and samplePeriod>0, "History length or period outside supported range.");
equation
  when terminal() then terminalSeen=true; end when;
  resultStatus=if (dataState)==EvaluationLibrary.Utilities.Types.DataStatus.PENDING and terminalSeen then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else (dataState);
  when {initial(),false} then
    qualifiedViolation=pre(qualifiedViolation) or false;
    qualifiedViolationTime=if not pre(qualifiedViolation) and false then time else pre(qualifiedViolationTime);
  end when;
  result.metricId=metricId; result.requirementId=requirementId; result.requirementVersion=requirementVersion; result.unit=unitName;
  result.value=count; result.valueAvailable=(count>0) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(resultStatus);
  result.verdict=Integer(EvaluationLibrary.Utilities.Functions.ToVerdict(resultStatus,qualifiedViolation,false));
  result.complete=time>=endTime or terminalSeen;
  result.windowStart=startTime; result.windowStop=endTime;
  result.observedDuration=evidence.observedDuration;
  result.validDuration=evidence.validDuration;
  result.expectedSamples=n; result.receivedSamples=evidence.receivedSamples; result.validSamples=count;
  result.everViolated=qualifiedViolation; result.firstViolationTime=qualifiedViolationTime;
  result.samplePeriod=samplePeriod; result.evidenceKind=2;
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable)+"; retained specialist; no unsupplied duration or count inferred";
  result.eventCountsAvailable=false; result.eventCount=0; result.matchedCount=0; result.timedOutCount=0; result.censoredCount=0;
  result.levelAvailable=false; result.level=0; result.level0Upper=0; result.level1Upper=0;
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
        Line(points={{-65,-24},{65,-24}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-66,45},{-66,57},{66,57},{66,45}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{-55,-24},{-55,-4}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-33,-24},{-33,17}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-11,-24},{-11,7}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{11,-24},{11,37}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{33,-24},{33,26}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{55,-24},{55,12}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Ellipse(extent={{-58.4,-7.4},{-51.6,-0.6}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{-36.4,13.6},{-29.6,20.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{-14.4,3.6},{-7.6,10.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{7.6,33.6},{14.4,40.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{29.6,22.6},{36.4,29.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{51.6,8.6},{58.4,15.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Text(extent={{-64,-29},{-46,-46}}, textString="1", textColor={128,128,128}, fontSize=0),
        Text(extent={{46,-29},{64,-46}}, textString="N", textColor={128,128,128}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="u[k], t[k]", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Retain n samples and scheduled timestamps beginning at startTime with samplePeriod spacing. Defaults are n=128, startTime=0 s and samplePeriod=0.02 s; n is between 2 and 4096 and the period is positive. The exclusive record end is startTime+n*samplePeriod. The result value is accepted count, while samples remains the trajectory. Full scheduled coverage and validity are required for COMPLETE.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end SampleHistory;
