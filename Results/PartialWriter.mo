within EvaluationLibrary.Results;
partial block PartialWriter "Common finalised result-export contract"
  extends Modelica.Icons.Block;
  parameter Integer n(min=1)=1;
  parameter String runId="run" "ASCII letters, digits, underscore or dash";
  parameter String resultSetId="results" "ASCII letters, digits, underscore or dash";
  parameter String outputDirectory="." "Existing directory for exported files";
  parameter EvaluationLibrary.Utilities.Types.WritePolicy writePolicy=
    EvaluationLibrary.Utilities.Types.WritePolicy.RejectExisting;
  parameter Boolean logToConsole=true "Print the timestamped outcome";
  parameter Boolean isCSV=false;
  parameter Boolean isConsole=false;
  parameter String extension=".txt";
  parameter String filePath=outputDirectory+"/"+runId+"_"+resultSetId+extension
    "Actual file target; ignored by ConsoleWriter";
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
  output Boolean ready;
  output Boolean written(start=false,fixed=true);
  output Boolean skippedExisting(start=false,fixed=true);
protected
  EvaluationLibrary.Utilities.Types.MetricResult records[n];
initial equation
  assert(EvaluationLibrary.Utilities.Functions.SafeIdentifier(runId) and
    EvaluationLibrary.Utilities.Functions.SafeIdentifier(resultSetId),
    "runId and resultSetId may contain only ASCII letters, digits, '_' or '-'.");
equation
  ready=sum({if u[i].complete then 1 else 0 for i in 1:n})==n;
  for i in 1:n loop
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
algorithm
  when ready then
    (written,skippedExisting):=EvaluationLibrary.Utilities.Internal.WriteRows(
      filePath,runId,records,writePolicy,isCSV,isConsole,
      resultSetId,time,logToConsole);
  end when;
  annotation(Documentation(info="<html><p>One-shot export after all metric inputs have finalised. Default file: outputDirectory/runId_resultSetId plus the format extension. The directory must exist. RejectExisting skips an existing file; Overwrite replaces it. A terminal message distinguishes SUCCESS from SKIPPED and includes host-local wall time, simulation time, record count and absolute file path. The observedDuration field is not carried by MetricInput and is not used by the exported rows.</p></html>"));
end PartialWriter;
