within EvaluationLibrary.Utilities.Functions;
function SafeIdentifier "Check a filename-safe identifier"
  extends Modelica.Icons.Function;
input String value "Identifier to check";
  output Boolean accepted "True if every character is permitted and the identifier is non-empty";
protected
  String ch "Current character";
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
        Rectangle(extent={{-57.017,-16.808},{11.914,24.04}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-51.911,17.232},{6.808,-10.851}}, textString="a_1", textColor={108,88,49}, fontSize=0),
        Line(points={{19.9985,-1.49},{31.3168,-13.404},{53.3577,15.1896}}, color={75,138,73}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-37.444,-45.742},{37.444,-69.57}}, textString="ID", textColor={108,88,49}, fontSize=0)
      }),
    Documentation(info="<html><p>Return true for a non-empty identifier containing only ASCII letters, digits, underscores and hyphens. This function checks an identifier, not a complete filesystem path.</p></html>"));
end SafeIdentifier;
