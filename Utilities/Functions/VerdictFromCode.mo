within EvaluationLibrary.Utilities.Functions;
function VerdictFromCode "Decode the fixed verdict ordinal"
  extends Modelica.Icons.Function;
input Integer code;
  output EvaluationLibrary.Utilities.Types.Verdict verdict;
algorithm
  verdict:=if code==1 then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED elseif code==2 then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED elseif code==3 then EvaluationLibrary.Utilities.Types.Verdict.VIOLATED
    elseif code==5 then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE else EvaluationLibrary.Utilities.Types.Verdict.INVALID;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Line(points={{-6.8,3.44},{11.56,3.44}}, color={108,88,49}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-40.8,26.56},{-12.24,-16.28}}, textString="n", textColor={108,88,49}, fontSize=0),
        Line(points={{20.06,4.12},{25.4864,-1.592},{36.0536,12.1168}}, color={108,88,49}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-65,-55},{65,-78}}, textString="verdict", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Decode the fixed verdict ordinal.</p><p><b>Interfaces</b> input Integer code; output EvaluationLibrary.Utilities.Types.Verdict verdict</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Decode the fixed verdict ordinal</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Outputs retain the units declared at the interface. Numerical values depend on the supplied input and parameter range.</p><p><b>Observables</b> Public outputs and the stated input conditions.</p></html>"));
end VerdictFromCode;
