within EvaluationLibrary.Requirements;
block Conjunction "Combine required child verdicts with explicit qualification priority"
parameter Integer n(min=1)=3;
  parameter Boolean required[n]=fill(true,n);
  EvaluationLibrary.Utilities.Interfaces.MetricInput u[n] annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Interfaces.MetricOutput child[n] annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.Verdict verdict;
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus;
  output Boolean everViolated;
  output Modelica.Units.SI.Time firstViolationTime;
protected
  Real witnesses[n];
  Boolean requiredActive[n];
initial equation
  assert(n>=1,"At least one result is required.");
equation
  for i in 1:n loop
    child[i].value=u[i].value;
    child[i].valueAvailable=u[i].valueAvailable;
    child[i].dataStatus=u[i].dataStatus;
    child[i].verdict=u[i].verdict;
    child[i].everViolated=u[i].everViolated;
    child[i].firstViolationTime=u[i].firstViolationTime;
    child[i].validDuration=u[i].validDuration;
    child[i].expectedSamples=u[i].expectedSamples;
    child[i].receivedSamples=u[i].receivedSamples;
    child[i].validSamples=u[i].validSamples;
    child[i].complete=u[i].complete;
    requiredActive[i]=required[i] and u[i].dataStatus<>Integer(EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE);
    witnesses[i]=if requiredActive[i] and u[i].everViolated then u[i].firstViolationTime else Modelica.Constants.inf;
  end for;
  verdict=EvaluationLibrary.Utilities.Functions.Aggregate({u[i].verdict for i in 1:n},required);
  everViolated=min(witnesses)<Modelica.Constants.inf;
  firstViolationTime=if everViolated then min(witnesses) else 0;
  result.complete=sum({if requiredActive[i] and not u[i].complete then 1 else 0 for i in 1:n})==0;
  dataStatus=if sum({if requiredActive[i] then 1 else 0 for i in 1:n})==0 then EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE
    elseif sum({if requiredActive[i] and u[i].dataStatus==4 then 1 else 0 for i in 1:n})>0 then EvaluationLibrary.Utilities.Types.DataStatus.INVALID
    elseif not result.complete then EvaluationLibrary.Utilities.Types.DataStatus.PENDING
    elseif sum({if requiredActive[i] and u[i].dataStatus<>2 then 1 else 0 for i in 1:n})>0 then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE
    else EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE;
  result.value=0;
  result.valueAvailable=false;
  result.dataStatus=Integer(dataStatus);
  result.verdict=Integer(verdict);
  result.everViolated=everViolated;
  result.firstViolationTime=firstViolationTime;
  result.validDuration=if dataStatus==EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then 0 else min({if requiredActive[i] then u[i].validDuration else Modelica.Constants.inf for i in 1:n});
  result.expectedSamples=0;
  result.receivedSamples=0;
  result.validSamples=0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,37},{-22,37},{-4,9}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-62,9},{-4,9}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-62,-19},{-22,-19},{-4,9}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Rectangle(extent={{-5,-15},{38,34}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{1,29},{32,-9}}, textString="&", textColor={0,0,127}, fontSize=0),
        Line(points={{38,9},{65,9}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="required", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Combine required child verdicts with explicit qualification priority.</p><p><b>Interfaces</b> EvaluationLibrary.Utilities.Interfaces.MetricInput u[n]; EvaluationLibrary.Utilities.Interfaces.MetricOutput child[n]; EvaluationLibrary.Utilities.Interfaces.MetricOutput result; output EvaluationLibrary.Utilities.Types.Verdict verdict; output EvaluationLibrary.Utilities.Types.DataStatus dataStatus; output Boolean everViolated; output Modelica.Units.SI.Time firstViolationTime</p><p><b>Parameters</b> parameter Integer n(min=1)=3; parameter Boolean required[n]=fill(true,n)</p><p><b>Behavior</b> Combine required child verdicts with explicit qualification priority</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> No applicable required children yields NOT_APPLICABLE. Children are copied field for field.</p><p><b>Observables</b> child, result, everViolated</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.ResultAggregationAndFiles\">EvaluationLibrary.Examples.ResultAggregationAndFiles</a></p></html>"));
end Conjunction;
