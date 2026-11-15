within EvaluationLibrary.Results;
block CSVWriter "Write complete connected results once, without field or metadata mapping"
  parameter Integer n(min=1)=1 "Number of complete connected results";
  parameter String runId="run" "Stable run identity";
  parameter Boolean required[n]=fill(true,n) "Items required by the overall conjunction";
  parameter String outputDirectory="." "Existing output directory";
  parameter String resultSetId="results" "File-name identity";
  parameter String filePath=outputDirectory+"/"+runId+"_"+resultSetId+".csv" "Destination file; no overwrite by default";
  parameter EvaluationLibrary.Utilities.Types.WritePolicy writePolicy=EvaluationLibrary.Utilities.Types.WritePolicy.RejectExisting "Explicit file replacement policy";
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
      (written,skippedExisting):=EvaluationLibrary.Utilities.Internal.WriteRows(filePath,runId,records,writePolicy,true,false,"",time,false);
    end if;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Polygon(points={{-42,-38},{43,-38},{43,33},{25,53},{-42,53},{-42,-38}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{25,53},{25,33},{43,33}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-31,22},{31,22}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-31,4},{31,4}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-31,-14},{31,-14}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-8,22},{-8,-30}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{14,22},{14,-30}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-68,6},{-42,6}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="CSV", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-86,86},{86,-86}},lineColor={95,95,95},fillColor={255,255,255},fillPattern=FillPattern.Solid,lineThickness=0.5),Rectangle(extent={{-53,64},{42,-63}},lineColor={95,95,95},fillColor={255,255,255},fillPattern=FillPattern.Solid,lineThickness=0.5),Line(points={{-53,34},{42,34}},color={95,95,95},thickness=0.8),Line(points={{-53,7},{42,7}},color={95,95,95},thickness=0.8),Line(points={{-53,-20},{42,-20}},color={95,95,95},thickness=0.8),Line(points={{-53,-47},{42,-47}},color={95,95,95},thickness=0.8),Line(points={{-22,34},{-22,-63}},color={95,95,95},thickness=0.8),Line(points={{10,34},{10,-63}},color={95,95,95},thickness=0.8),Text(extent={{-45,60},{35,36}},textString="CSV",textColor={0,0,127},fontSize=14)}),Documentation(info="<html><p>Optionally export the n complete results in declaration order to filePath, default ./run_results.csv, when collection closes or at normal termination. The default name combines outputDirectory, runId and resultSetId. The destination directory must already exist. The 31-column CSV contains runId and all 30 canonical result fields; unavailable values, counters, grades and witnesses use N/A where appropriate. writePolicy defaults to RejectExisting; an existing destination is preserved unless Overwrite is selected explicitly. written and skippedExisting describe file handling, independently of overall safety. MSL file errors can terminate simulation; no portable exception recovery is claimed.</p></html>"));
end CSVWriter;
