within EvaluationLibrary.Results;
block VerdictAggregator "Aggregate required verdicts, preserving witnesses"
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
  annotation(
  Icon(coordinateSystem(extent={{-100,-100},{100,100}},
grid={2,2}),graphics = {Rectangle(origin={0,0},
lineColor={64,64,64},
fillColor={255,255,255},
fillPattern=FillPattern.Solid,
lineThickness=0.5,
extent={{-90,-85},{90,85}}), Rectangle(origin={20,3.9},
lineColor={64,64,64},
fillColor={245,245,245},
fillPattern=FillPattern.Solid,
lineThickness=0.5,
extent={{-42.12,-35.1},{42.12,35.1}}), Line(origin={0,0},
points={{-22.12,15.6},{62.12,15.6}},
color={128,128,128},
thickness=0.6), Line(origin={0,0},
points={{-22.12,-7.8},{62.12,-7.8}},
color={128,128,128},
thickness=0.6), Line(origin={0,0},
points={{5.96,-31.2},{5.96,39}},
color={128,128,128},
thickness=0.6), Line(origin={0,0},
points={{34.04,-31.2},{34.04,39}},
color={128,128,128},
thickness=0.6), Line(origin={0,0},
points={{-65,38},{-29,38}},
color={0,0,127},
thickness=0.8,
arrow={Arrow.None,Arrow.Filled}), Line(origin={0,0},
points={{-65,4},{-29,4}},
color={0,0,127},
thickness=0.8,
arrow={Arrow.None,Arrow.Filled}), Line(origin={0,0},
points={{-65,-29},{-29,-29}},
color={0,0,127},
thickness=0.8,
arrow={Arrow.None,Arrow.Filled}), Text(origin={0,-62.5},
lineColor={64,64,64},
extent={{-65,12.5},{65,-12.5}},
textString="Aggregator",
textColor={64,64,64}), Text(origin={0,140},
lineColor={0,0,255},
extent={{-150,15},{150,-15}},
textString="%name",
textColor={0,0,255})}),
    Documentation(info="<html><p>Required verdicts use INVALID, VIOLATED, UNDECIDED, SATISFIED priority. Retains the earliest qualified violation witness, even if later data are invalid. Logs once on completion; creates no file.</p></html>"));
end VerdictAggregator;