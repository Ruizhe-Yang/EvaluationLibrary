within EvaluationLibrary.Comparison;
block MultiRunSummary "Summarize explicitly connected complete and comparable runs"
  parameter String metricId=getInstanceName() "Stable identity of this retained specialist";
  parameter String requirementId="" "Requirement identity, when configured";
  parameter String requirementVersion="" "Interpreted requirement version";
  parameter String unitName=unit "Engineering unit of the reported specialist value";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Complete specialist result" annotation(Placement(transformation(extent={{90,80},{110,100}}),iconTransformation(extent={{90,80},{110,100}})));
  Boolean terminalSeen(start=false,fixed=true) "Terminal seen";
  discrete Boolean qualifiedViolation(start=false,fixed=true) "Qualified violation";
  discrete Real qualifiedViolationTime(start=0,fixed=true) "Qualified violation time";
  EvaluationLibrary.Utilities.Types.DataStatus resultStatus "Result status";
parameter Integer n(min=1)=3 "Number of channels, records or configured items; at least one";
  parameter String comparisonId="comparison" "Stable identity of the comparison interpretation";
  parameter String comparisonIds[n]=fill(comparisonId,n) "Comparison interpretation identity for each input";
  parameter String unit="1" "Declared common engineering unit";
  parameter String units[n]=fill(unit,n) "Engineering units of the compared inputs";
  parameter Modelica.Units.SI.Time windowStart=0 "Inclusive observation start in seconds";
  parameter Modelica.Units.SI.Time windowStop=5 "Exclusive observation stop in seconds";
  parameter Modelica.Units.SI.Time runStart[n]=fill(windowStart,n) "Inclusive start of each compared run";
  parameter Modelica.Units.SI.Time runStop[n]=fill(windowStop,n) "Exclusive stop of each compared run";
  EvaluationLibrary.Utilities.Interfaces.MetricInput u[n] "Complete child evidence and producer metadata" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  output Integer nInputs "N inputs";
  output Integer nValid "N valid";
  output Boolean available "Available";
  output Real minimum "Minimum";
  output Real maximum "Maximum";
  output Real mean "Mean";
protected
  Boolean accepted[n] "Accepted";
initial equation
  assert(n>=1 and comparisonId<>"" and windowStop>windowStart,"Invalid comparison metadata.");
equation
  when terminal() then terminalSeen=true; end when;
  resultStatus=if (if available and min({if u[i].complete then 1 else 0 for i in 1:n})==1 then EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE else EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE)==EvaluationLibrary.Utilities.Types.DataStatus.PENDING and terminalSeen then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else (if available and min({if u[i].complete then 1 else 0 for i in 1:n})==1 then EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE else EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE);
  when {initial(),false} then
    qualifiedViolation=pre(qualifiedViolation) or false;
    qualifiedViolationTime=if not pre(qualifiedViolation) and false then time else pre(qualifiedViolationTime);
  end when;
  result.metricId=metricId; result.requirementId=requirementId; result.requirementVersion=requirementVersion; result.unit=unitName;
  result.value=mean; result.valueAvailable=(available) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(resultStatus);
  result.verdict=Integer(EvaluationLibrary.Utilities.Functions.ToVerdict(resultStatus,qualifiedViolation,false));
  result.complete=time>=windowStop or terminalSeen;
  result.windowStart=windowStart; result.windowStop=windowStop;
  result.observedDuration=0;
  result.validDuration=0;
  result.expectedSamples=0; result.receivedSamples=0; result.validSamples=0;
  result.everViolated=qualifiedViolation; result.firstViolationTime=qualifiedViolationTime;
  result.samplePeriod=0; result.evidenceKind=4;
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable)+"; retained specialist; no unsupplied duration or count inferred";
  result.eventCountsAvailable=false; result.eventCount=0; result.matchedCount=0; result.timedOutCount=0; result.censoredCount=0;
  result.levelAvailable=false; result.level=0; result.level0Upper=0; result.level1Upper=0;
  for i in 1:n loop
    accepted[i]=comparisonIds[i]==comparisonId and units[i]==unit and abs(runStart[i]-windowStart)<=1e-9
      and abs(runStop[i]-windowStop)<=1e-9 and u[i].complete and u[i].dataStatus==2 and u[i].valueAvailable
      and abs(u[i].value)<Modelica.Constants.inf;
  end for;
  nInputs=n;
  nValid=sum({if accepted[i] then 1 else 0 for i in 1:n});
  available=nValid>0;
  minimum=if available then min({if accepted[i] then u[i].value else Modelica.Constants.inf for i in 1:n}) else 0;
  maximum=if available then max({if accepted[i] then u[i].value else -Modelica.Constants.inf for i in 1:n}) else 0;
  mean=if available then sum({if accepted[i] then u[i].value else 0 for i in 1:n})/nValid else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-64,-29},{64,-29}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-65,20},{64,20}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Dash),
        Line(points={{-52,-29},{-52,-2}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-31,-29},{-31,43}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-10,-29},{-10,26}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{11,-29},{11,8}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{32,-29},{32,33}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{53,-29},{53,12}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Ellipse(extent={{-55.4,-5.4},{-48.6,1.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{-34.4,39.6},{-27.6,46.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{-13.4,22.6},{-6.6,29.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{7.6,4.6},{14.4,11.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{28.6,29.6},{35.4,36.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{49.6,8.6},{56.4,15.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Line(points={{70,-2},{70,43}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{66,-2},{74,-2}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{66,43},{74,43}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="min, mean, max", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>For the finite configured n runs, accept only complete available values with the declared comparison identity, engineering unit and matching windows. n defaults to 3 and identity to comparison. Return accepted count, minimum, maximum and arithmetic mean; the complete result reports mean. A subset may have a numeric mean but does not establish complete batch qualification. This finite summary is not a probability distribution or continuous-domain worst-case proof.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end MultiRunSummary;
