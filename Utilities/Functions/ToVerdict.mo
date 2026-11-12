within EvaluationLibrary.Utilities.Functions;
function ToVerdict "Decide requirement evidence without discarding a recorded witness"
  extends Modelica.Icons.Function;
input EvaluationLibrary.Utilities.Types.DataStatus status;
  input Boolean everViolated;
  input Boolean isRequirement=true;
  output EvaluationLibrary.Utilities.Types.Verdict verdict;
algorithm
  verdict:=if status==EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif status==EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif everViolated then EvaluationLibrary.Utilities.Types.Verdict.VIOLATED
    elseif isRequirement and status==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED
    else EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Rectangle(extent={{-39.44,-7.44},{-14.28,17.72}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-13.6,4.8},{6.12,4.8}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{12.75,6.16},{21.148,-2.68},{37.502,18.536}}, color={75,138,73}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-65,-55},{65,-78}}, textString="verdict", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Decide requirement evidence without discarding a recorded witness.</p><p><b>Interfaces</b> input EvaluationLibrary.Utilities.Types.DataStatus status; input Boolean everViolated; input Boolean isRequirement=true; output EvaluationLibrary.Utilities.Types.Verdict verdict</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Decide requirement evidence without discarding a recorded witness</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Outputs retain the units declared at the interface. Numerical values depend on the supplied input and parameter range.</p><p><b>Observables</b> Public outputs and the stated input conditions.</p></html>"));
end ToVerdict;
