within EvaluationLibrary.Results;
block ResultTable "Collect qualified metrics in an inspectable result table"
  extends Modelica.Icons.Block;
  parameter Integer n(min=1)=1;
  parameter String runId="run";
  parameter String resultSetId="table";
  parameter Boolean logOnComplete=true;
  parameter String metricId[n]=fill("metric",n);
  parameter String requirementId[n]=fill("",n);
  parameter String requirementVersion[n]=fill("",n);
  parameter String unitName[n]=fill("1",n);
  parameter String message[n]=fill("",n);
  parameter Modelica.Units.SI.Time windowStart[n]=fill(0,n);
  parameter Modelica.Units.SI.Time windowStop[n]=fill(0,n);
  parameter Modelica.Units.SI.Time samplePeriod[n]=fill(0,n);
  parameter EvaluationLibrary.Utilities.Types.EvidenceKind evidenceKind[n]=
    fill(EvaluationLibrary.Utilities.Types.EvidenceKind.Derived,n);
  EvaluationLibrary.Utilities.Interfaces.MetricInput u[n]
    annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));
  EvaluationLibrary.Utilities.Interfaces.MetricOutput rows[n]
    annotation(Placement(transformation(extent={{90,-10},{110,10}})));
  output EvaluationLibrary.Utilities.Types.MetricResult records[n];
  output Boolean allComplete;
  output Boolean complete;
  output Integer finalisedCount;
  output Boolean logged(start=false,fixed=true);
equation
  for i in 1:n loop
    connect(u[i],rows[i]);
    records[i].metricId=metricId[i];
    records[i].requirementId=requirementId[i];
    records[i].requirementVersion=requirementVersion[i];
    records[i].value=u[i].value;
    records[i].valueAvailable=u[i].valueAvailable;
    records[i].unit=unitName[i];
    records[i].dataStatus=EvaluationLibrary.Utilities.Functions.StatusFromCode(u[i].dataStatus);
    records[i].verdict=EvaluationLibrary.Utilities.Functions.VerdictFromCode(u[i].verdict);
    records[i].windowStart=windowStart[i];
    records[i].windowStop=windowStop[i];
    records[i].observedDuration=0;
    records[i].validDuration=u[i].validDuration;
    records[i].expectedSamples=u[i].expectedSamples;
    records[i].receivedSamples=u[i].receivedSamples;
    records[i].validSamples=u[i].validSamples;
    records[i].everViolated=u[i].everViolated;
    records[i].firstViolationTime=u[i].firstViolationTime;
    records[i].samplePeriod=samplePeriod[i];
    records[i].evidenceKind=evidenceKind[i];
    records[i].message=message[i];
  end for;
  finalisedCount=sum({if u[i].complete then 1 else 0 for i in 1:n});
  allComplete=finalisedCount==n;
  complete=allComplete;
algorithm
  when allComplete then
    if logOnComplete then
      logged:=EvaluationLibrary.Utilities.Internal.LogCompletion(
        "Result table finalised","in-memory table","Modelica variable: records",
        runId,resultSetId,n,time,"SUCCESS");
    else
      logged:=false;
    end if;
  end when;
  annotation(Documentation(info="<html><p>Pass-through typed result table with record metadata. On completion, emits one terminal log (not a file). observedDuration is not present on the metric connector, so the corresponding record field is zero and must not be interpreted as measured duration.</p></html>"));
end ResultTable;
