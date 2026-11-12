within EvaluationLibrary.Utilities.Functions;
function QuoteCSV "Quote one CSV text field including newlines and quotes"
  extends Modelica.Icons.Function;
input String text;
  output String escaped;
algorithm
  escaped:="\""+Modelica.Utilities.Strings.replace(text,"\"","\"\"")+"\"";
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Text(extent={{-40.12,22.48},{40.12,-7.44}}, textString="\"x\"", textColor={108,88,49}, fontSize=0),
        Line(points={{-24.48,-20.36},{24.48,-20.36}}, color={108,88,49}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-65,-55},{65,-78}}, textString="CSV", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Quote one CSV text field including newlines and quotes.</p><p><b>Interfaces</b> input String text; output String escaped</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Quote one CSV text field including newlines and quotes</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Outputs retain the units declared at the interface. Numerical values depend on the supplied input and parameter range.</p><p><b>Observables</b> escaped</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.ResultAggregationAndFiles\">EvaluationLibrary.Examples.ResultAggregationAndFiles</a></p></html>"));
end QuoteCSV;
