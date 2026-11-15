within EvaluationLibrary.Utilities.Functions;
function StatusText "Convert a data qualification to its stable output label"
  extends Modelica.Icons.Function;
input EvaluationLibrary.Utilities.Types.DataStatus status "Status";
  output String text "Text";
algorithm
  text:=if status==EvaluationLibrary.Utilities.Types.DataStatus.PENDING then "PENDING" elseif status==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then "COMPLETE"
    elseif status==EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE then "INCOMPLETE" elseif status==EvaluationLibrary.Utilities.Types.DataStatus.INVALID then "INVALID" else "NOT_APPLICABLE";
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Rectangle(extent={{-52.762,-14.255},{-25.53,12.977}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-50.209,10.424},{-28.083,-11.702}}, textString="Q", textColor={64,64,64}, fontSize=0),
        Line(points={{-17.871,-0.639},{10.212,-0.639}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{2.553,17.232},{59.57,-17.659}}, textString="\"abc\"", textColor={108,88,49}, fontSize=0)
      }),
    Documentation(info="<html><p>Status text. Inputs retain the physical units or logical meaning stated by their declarations. Domain assertions and explicit availability flags are part of the contract.</p></html>"));
end StatusText;
