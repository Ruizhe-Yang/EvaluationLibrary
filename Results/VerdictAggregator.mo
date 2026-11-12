within EvaluationLibrary.Results;
block VerdictAggregator "Aggregate required verdicts, preserving witnesses"
  extends Modelica.Icons.Block;
  parameter Integer n(min=1)=1;
  parameter Boolean required[n]=fill(true,n);
  parameter String runId="run";
  parameter String resultSetId="aggregate";
  parameter Boolean logOnComplete=true;
  EvaluationLibrary.Utilities.Interfaces.MetricInput u[n]
    annotation(Placement(transformation(extent={{-110,-10},{-90,10}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict;
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus;
  output Boolean complete;
  output Boolean everViolated;
  output Modelica.Units.SI.Time firstViolationTime;
  output Integer nApplicable;
  output Boolean logged(start=false,fixed=true);
equation
  nApplicable=sum({if required[i] and u[i].verdict<>5 then 1 else 0 for i in 1:n});
  complete=sum({if not required[i] or u[i].complete then 1 else 0 for i in 1:n})==n;
  everViolated=sum({if required[i] and u[i].everViolated then 1 else 0 for i in 1:n})>0;
  firstViolationTime=if everViolated then min(
    {if required[i] and u[i].everViolated then u[i].firstViolationTime
      else Modelica.Constants.inf for i in 1:n}) else 0;
  verdict=EvaluationLibrary.Utilities.Functions.Aggregate(
    {u[i].verdict for i in 1:n},required);
  dataStatus=if nApplicable==0 then EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE
    elseif sum({if required[i] and u[i].dataStatus==4 then 1 else 0 for i in 1:n})>0 then EvaluationLibrary.Utilities.Types.DataStatus.INVALID
    elseif sum({if required[i] and u[i].dataStatus==3 then 1 else 0 for i in 1:n})>0 then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE
    elseif not complete then EvaluationLibrary.Utilities.Types.DataStatus.PENDING
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
  annotation(Documentation(info="<html><p>Required verdicts use INVALID, VIOLATED, UNDECIDED, SATISFIED priority. Retains the earliest qualified violation witness, even if later data are invalid. Logs once on completion; creates no file.</p></html>"));
end VerdictAggregator;
