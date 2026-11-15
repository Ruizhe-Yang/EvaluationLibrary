within EvaluationLibrary.Results;
block VerdictAggregator "Aggregate required verdicts, preserving witnesses"
  parameter Integer n(min=1)=1 "Number of channels, records or configured items; at least one";
  parameter Boolean required[n]=fill(true,n) "Which child requirements enter the overall conjunction";
  parameter String runId="run" "Stable run identity";
  parameter String resultSetId="aggregate" "Stable output-set identity";
  parameter Boolean logOnComplete=true "Print one completion audit message";
  EvaluationLibrary.Utilities.Interfaces.MetricInput u[n] 
    "U" annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement decision independent of observation completeness";
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus "Evidence qualification independent of requirement verdict";
  output Boolean complete "Collection has closed; inspect DataStatus before assuming full evidence";
  output EvaluationLibrary.Utilities.Types.MetricResult children[n] "All children including optional and inapplicable items";
  output Boolean everViolated "A qualified violation witness exists";
  output Modelica.Units.SI.Time firstViolationTime "First qualified violation instant; meaningful only when everViolated";
  output Integer nApplicable "N applicable";
  output Boolean logged(start=false,fixed=true) "Logged";
equation
  for i in 1:n loop
    children[i].metricId=u[i].metricId;
    children[i].requirementId=u[i].requirementId;
    children[i].requirementVersion=u[i].requirementVersion;
    children[i].value=u[i].value;
    children[i].valueAvailable=u[i].valueAvailable;
    children[i].dataStatus=EvaluationLibrary.Utilities.Functions.StatusFromCode(u[i].dataStatus);
    children[i].verdict=EvaluationLibrary.Utilities.Functions.VerdictFromCode(EvaluationLibrary.Utilities.Functions.QualifiedCode(u[i].dataStatus,u[i].verdict));
    children[i].unit=u[i].unit;
    children[i].windowStart=u[i].windowStart;
    children[i].windowStop=u[i].windowStop;
    children[i].observedDuration=u[i].observedDuration;
    children[i].validDuration=u[i].validDuration;
    children[i].expectedSamples=u[i].expectedSamples;
    children[i].receivedSamples=u[i].receivedSamples;
    children[i].validSamples=u[i].validSamples;
    children[i].everViolated=u[i].everViolated;
    children[i].firstViolationTime=u[i].firstViolationTime;
    children[i].samplePeriod=u[i].samplePeriod;
    children[i].evidenceKind=if u[i].evidenceKind==1 then EvaluationLibrary.Utilities.Types.EvidenceKind.Continuous elseif u[i].evidenceKind==2 then EvaluationLibrary.Utilities.Types.EvidenceKind.Sampled elseif u[i].evidenceKind==3 then EvaluationLibrary.Utilities.Types.EvidenceKind.Event else EvaluationLibrary.Utilities.Types.EvidenceKind.Derived;
    children[i].message=u[i].message;
    children[i].complete=u[i].complete;
    children[i].eventCountsAvailable=u[i].eventCountsAvailable;
    children[i].eventCount=u[i].eventCount;
    children[i].matchedCount=u[i].matchedCount;
    children[i].timedOutCount=u[i].timedOutCount;
    children[i].censoredCount=u[i].censoredCount;
    children[i].levelAvailable=u[i].levelAvailable;
    children[i].level=u[i].level;
    children[i].level0Upper=u[i].level0Upper;
    children[i].level1Upper=u[i].level1Upper;
  end for;
  nApplicable=sum({if required[i] and u[i].verdict<>5 then 1 else 0 for i in 1:n});
  complete=sum({if not required[i] or u[i].complete then 1 else 0 for i in 1:n})==n;
  everViolated=sum({if required[i] and u[i].everViolated then 1 else 0 for i in 1:n})>0;
  firstViolationTime=if everViolated then min(
    {if required[i] and u[i].everViolated then u[i].firstViolationTime 
      else Modelica.Constants.inf for i in 1:n}) else 0;
  verdict=EvaluationLibrary.Utilities.Functions.Aggregate(
    {EvaluationLibrary.Utilities.Functions.QualifiedCode(u[i].dataStatus,u[i].verdict) for i in 1:n},required);
  dataStatus=if nApplicable==0 then EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE 
    else if sum({if required[i] and u[i].dataStatus==4 then 1 else 0 for i in 1:n})>0 then EvaluationLibrary.Utilities.Types.DataStatus.INVALID 
    else if sum({if required[i] and u[i].dataStatus==3 then 1 else 0 for i in 1:n})>0 then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE 
    else if not complete then EvaluationLibrary.Utilities.Types.DataStatus.PENDING 
    else EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE;
algorithm
  when complete then
    if logOnComplete then
      logged:=EvaluationLibrary.Utilities.Internal.LogCompletion(
        "Aggregate verdict finalised: "+
          EvaluationLibrary.Utilities.Functions.VerdictText(verdict),
        "aggregate verdict","Modelica variable: verdict",
        runId,resultSetId,nApplicable,time,"SUCCESS");
    else
      logged:=false;
    end if;
  end when;
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-86,86},{86,-86}},lineColor={95,95,95},fillColor={255,255,255},fillPattern=FillPattern.Solid,lineThickness=0.5),Line(points={{-68,45},{-30,45},{-10,5}},color={0,0,127},thickness=0.8),Line(points={{-68,0},{-10,0}},color={0,0,127},thickness=0.8),Line(points={{-68,-45},{-30,-45},{-10,-5}},color={0,0,127},thickness=0.8),Rectangle(extent={{-10,22},{45,-22}},lineColor={95,95,95},fillColor={255,255,255},fillPattern=FillPattern.Solid,lineThickness=0.5),Line(points={{1,0},{13,-12},{33,13}},color={0,120,60},thickness=1.4)}),
  Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-59,24},{-28,44}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-28,34},{-7,34}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Rectangle(extent={{-59,-10},{-28,10}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-28,0},{-7,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Rectangle(extent={{-59,-44},{-28,-24}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-28,-34},{-7,-34}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-7,34},{-7,-34}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-7,0},{14,0}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Rectangle(extent={{15,-19},{60,21}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{20,18},{55,-15}}, textString="&", textColor={0,0,127}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="required ∧", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Consume complete child results in declaration order. required defaults to all true; optional and NOT_APPLICABLE children remain inspectable. Explicit qualification makes INVALID dominate VIOLATED, then UNDECIDED; all required applicable items must be SATISFIED to pass. No applicable items give NOT_APPLICABLE. children retains all fields and witnesses, nApplicable counts active requirements, and the earliest required violation is retained. logOnComplete defaults to true and emits one audit event; it does not alter verdicts.</p></html>"));
end VerdictAggregator;