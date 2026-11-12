within EvaluationLibrary.Utilities.Functions;
function SafeIdentifier "Check an identifier used in an output filename"
  extends Modelica.Icons.Function;
input String value;
  output Boolean accepted;
protected
  String ch;
algorithm
  accepted:=Modelica.Utilities.Strings.length(value)>0;
  for i in 1:Modelica.Utilities.Strings.length(value) loop
    ch:=Modelica.Utilities.Strings.substring(value,i,i);
    accepted:=accepted and Modelica.Utilities.Strings.find("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-",ch)>0;
  end for;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Text(extent={{-38.76,23.84},{17,-10.16}}, textString="id", textColor={108,88,49}, fontSize=0),
        Line(points={{12.92,-15.6},{20.672,-23.76},{35.768,-4.176}}, color={75,138,73}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-65,-55},{65,-78}}, textString="A–Z  0–9", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Check an identifier used in an output filename.</p><p><b>Interfaces</b> input String value; output Boolean accepted</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Check an identifier used in an output filename</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> The path identifiers allow ASCII letters, digits, underscore and dash.</p><p><b>Observables</b> accepted</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.ResultAggregationAndFiles\">EvaluationLibrary.Examples.ResultAggregationAndFiles</a></p></html>"));
end SafeIdentifier;
