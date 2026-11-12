within EvaluationLibrary.Utilities.Functions;
function StatusText "Convert a data qualification to its stable output label"
  extends Modelica.Icons.Function;
input EvaluationLibrary.Utilities.Types.DataStatus status;
  output String text;
algorithm
  text:=if status==EvaluationLibrary.Utilities.Types.DataStatus.PENDING then "PENDING" elseif status==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then "COMPLETE"
    elseif status==EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE then "INCOMPLETE" elseif status==EvaluationLibrary.Utilities.Types.DataStatus.INVALID then "INVALID" else "NOT_APPLICABLE";
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Line(points={{-6.8,3.44},{11.56,3.44}}, color={108,88,49}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Ellipse(extent={{-38.08,-5.4},{-19.72,12.96}}, lineColor={108,88,49}, fillColor={108,88,49}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{14.96,23.16},{40.8,-15.6}}, textString="A", textColor={108,88,49}, fontSize=0),
        Text(extent={{-65,-55},{65,-78}}, textString="status", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Convert a data qualification to its stable output label.</p><p><b>Interfaces</b> input EvaluationLibrary.Utilities.Types.DataStatus status; output String text</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Convert a data qualification to its stable output label</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Outputs retain the units declared at the interface. Numerical values depend on the supplied input and parameter range.</p><p><b>Observables</b> text</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.ResultAggregationAndFiles\">EvaluationLibrary.Examples.ResultAggregationAndFiles</a></p></html>"));
end StatusText;
