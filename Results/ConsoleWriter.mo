within EvaluationLibrary.Results;
block ConsoleWriter "Write complete connected results once, without field or metadata mapping"
  parameter Integer n(min=1)=1 "Number of complete connected results";
  parameter String runId="run" "Stable run identity";
  parameter Boolean required[n]=fill(true,n) "Items required by the overall conjunction";
  EvaluationLibrary.Utilities.Interfaces.MetricInput u[n] "Complete result array" annotation(Placement(transformation(extent={{-110,-10},{-90,10}}),iconTransformation(extent={{-110,-10},{-90,10}})));
  output Boolean ready "Every result has closed";
  output Boolean written(start=false,fixed=true) "Output operation completed; never a safety verdict";
  output Boolean skippedExisting(start=false,fixed=true) "An existing destination was preserved";
  output EvaluationLibrary.Utilities.Types.Verdict overall "Conjunction of required applicable items";
protected
  EvaluationLibrary.Utilities.Types.MetricResult records[n] "Records";
equation
  ready=sum({if u[i].complete then 1 else 0 for i in 1:n})==n;
  overall=EvaluationLibrary.Utilities.Functions.Aggregate({EvaluationLibrary.Utilities.Functions.QualifiedCode(u[i].dataStatus,u[i].verdict) for i in 1:n},required);
  for i in 1:n loop
    records[i].metricId=u[i].metricId;
    records[i].requirementId=u[i].requirementId;
    records[i].requirementVersion=u[i].requirementVersion;
    records[i].value=u[i].value;
    records[i].valueAvailable=u[i].valueAvailable;
    records[i].dataStatus=EvaluationLibrary.Utilities.Functions.StatusFromCode(u[i].dataStatus);
    records[i].verdict=EvaluationLibrary.Utilities.Functions.VerdictFromCode(EvaluationLibrary.Utilities.Functions.QualifiedCode(u[i].dataStatus,u[i].verdict));
    records[i].unit=u[i].unit;
    records[i].windowStart=u[i].windowStart;
    records[i].windowStop=u[i].windowStop;
    records[i].observedDuration=u[i].observedDuration;
    records[i].validDuration=u[i].validDuration;
    records[i].expectedSamples=u[i].expectedSamples;
    records[i].receivedSamples=u[i].receivedSamples;
    records[i].validSamples=u[i].validSamples;
    records[i].everViolated=u[i].everViolated;
    records[i].firstViolationTime=u[i].firstViolationTime;
    records[i].samplePeriod=u[i].samplePeriod;
    records[i].evidenceKind=if u[i].evidenceKind==1 then EvaluationLibrary.Utilities.Types.EvidenceKind.Continuous elseif u[i].evidenceKind==2 then EvaluationLibrary.Utilities.Types.EvidenceKind.Sampled elseif u[i].evidenceKind==3 then EvaluationLibrary.Utilities.Types.EvidenceKind.Event else EvaluationLibrary.Utilities.Types.EvidenceKind.Derived;
    records[i].message=u[i].message;
    records[i].complete=u[i].complete;
    records[i].eventCountsAvailable=u[i].eventCountsAvailable;
    records[i].eventCount=u[i].eventCount;
    records[i].matchedCount=u[i].matchedCount;
    records[i].timedOutCount=u[i].timedOutCount;
    records[i].censoredCount=u[i].censoredCount;
    records[i].levelAvailable=u[i].levelAvailable;
    records[i].level=u[i].level;
    records[i].level0Upper=u[i].level0Upper;
    records[i].level1Upper=u[i].level1Upper;
  end for;
algorithm
  when {ready,terminal()} then
    if not pre(written) and not pre(skippedExisting) then
      Modelica.Utilities.Streams.print(EvaluationLibrary.Utilities.Functions.FormatSummary(runId,records,required));
      written:=true;
      skippedExisting:=false;
    end if;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-58,-32},{58,53}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-43,34},{-29,24},{-43,14}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-19,14},{0,14}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-42,-4},{38,-4}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-42,-18},{18,-18}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-15,-32},{-15,-43},{15,-43},{15,-32}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="console", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-86,86},{86,-86}},lineColor={95,95,95},fillColor={255,255,255},fillPattern=FillPattern.Solid,lineThickness=0.5),Rectangle(extent={{-66,50},{66,-48}},lineColor={95,95,95},fillColor={248,248,248},fillPattern=FillPattern.Solid,lineThickness=0.5),Rectangle(extent={{-66,50},{66,30}},lineColor={95,95,95},fillColor={230,234,240},fillPattern=FillPattern.Solid,lineThickness=0.5),Line(points={{-47,15},{-35,4},{-47,-7}},color={0,0,127},thickness=0.8),Line(points={{-25,-10},{4,-10}},color={0,0,127},thickness=1.4),Line(points={{-47,-29},{43,-29}},color={95,95,95},thickness=0.8)}),Documentation(info="<html><p>Connect the n complete result inputs directly; n defaults to 1 and required to all true. runId labels the single report. Producer identities, units, windows and explanations are read from u, not repeated writer parameters. Print each child in declaration order, unavailable values as N/A and any violation witness. Print once when collection closes or at normal termination, never once per solver step. Explicit qualified aggregation distinguishes invalid, violated, unresolved, satisfied and inapplicable evidence. written records output activity only and cannot change a safety decision. File output is not required.</p></html>"));
end ConsoleWriter;
