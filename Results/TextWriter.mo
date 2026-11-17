within EvaluationLibrary.Results;
block TextWriter "Write connected result records to a text file"
  parameter Integer n(min=1)=1 "Number of complete connected results";
  parameter String runId="run" "Run identifier";
  parameter Boolean required[n]=fill(true,n) "Records included in the overall verdict";
  parameter String outputDirectory="." "Existing output directory";
  parameter String resultSetId="results" "Identifier used in the output file name";
  parameter String filePath=outputDirectory+"/"+runId+"_"+resultSetId+".txt" "Destination file; no overwrite by default";
  parameter EvaluationLibrary.Utilities.Types.WritePolicy writePolicy=EvaluationLibrary.Utilities.Types.WritePolicy.RejectExisting "Explicit file replacement policy";
  EvaluationLibrary.Utilities.Interfaces.MetricInput u[n] "Input result records" annotation(Placement(transformation(extent={{-110,-10},{-90,10}}),iconTransformation(extent={{-110,-10},{-90,10}})));
  output Boolean ready "Every result has closed";
  output Boolean written(start=false,fixed=true) "True after output has been written";
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
      (written,skippedExisting):=EvaluationLibrary.Utilities.Internal.WriteRows(filePath,runId,records,writePolicy,false,false,"",time,false);
    end if;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Polygon(points={{-42,-38},{43,-38},{43,33},{25,53},{-42,53},{-42,-38}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{25,53},{25,33},{43,33}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-28,21},{25,21}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-28,7},{25,7}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-28,-7},{25,-7}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-28,-21},{5,-21}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-68,6},{-42,6}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="TXT", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-86,86},{86,-86}},lineColor={95,95,95},fillColor={255,255,255},fillPattern=FillPattern.Solid,lineThickness=0.5),Rectangle(extent={{-50,64},{42,-62}},lineColor={95,95,95},fillColor={255,255,255},fillPattern=FillPattern.Solid,lineThickness=0.5),Line(points={{-34,39},{23,39}},color={0,0,127},thickness=0.8),Line(points={{-34,16},{23,16}},color={95,95,95},thickness=0.8),Line(points={{-34,-7},{23,-7}},color={95,95,95},thickness=0.8),Line(points={{-34,-30},{6,-30}},color={95,95,95},thickness=0.8)}),Documentation(info="<html><p>Writes a text summary of <code>n</code> connected result records when all collections close or at normal termination. Producer metadata and unavailable-value explanations are retained in input order. <code>required</code> configures the exposed <code>overall</code> verdict.</p><p>The destination directory must already exist. <code>RejectExisting</code> preserves an existing file; select <code>Overwrite</code> explicitly to replace it. <code>written</code> and <code>skippedExisting</code> report file handling separately from the requirement decision.</p></html>"));
end TextWriter;
