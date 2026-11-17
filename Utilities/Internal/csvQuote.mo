within EvaluationLibrary.Utilities.Internal;
function csvQuote "Quote and escape an internal CSV field"
  input String raw "Unescaped field content";
  output String field "Quoted field with embedded quotes doubled";
algorithm
  field := "\"" + Modelica.Utilities.Strings.replace(raw,"\"","\"\"") + "\"";
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Line(points={{-45.5285,10.424},{-45.5285,1.063},{-48.0815,-5.745}}, color={108,88,49}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{-39.5715,10.424},{-39.5715,1.063},{-42.1245,-5.745}}, color={108,88,49}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{-28.083,0.212},{-5.106,0.212}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{13.1905,10.424},{13.1905,1.063},{10.6375,-5.745}}, color={108,88,49}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{19.1475,10.424},{19.1475,1.063},{16.5945,-5.745}}, color={108,88,49}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{25.1045,10.424},{25.1045,1.063},{22.5515,-5.745}}, color={108,88,49}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{31.0615,10.424},{31.0615,1.063},{28.5085,-5.745}}, color={108,88,49}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{37.0185,10.424},{37.0185,1.063},{34.4655,-5.745}}, color={108,88,49}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{42.9755,10.424},{42.9755,1.063},{40.4225,-5.745}}, color={108,88,49}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{48.9325,10.424},{48.9325,1.063},{46.3795,-5.745}}, color={108,88,49}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{54.8895,10.424},{54.8895,1.063},{52.3365,-5.745}}, color={108,88,49}, thickness=1.4, pattern=LinePattern.Solid),
        Text(extent={{-39.146,-43.189},{39.146,-68.719}}, textString="CSV", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Enclose <code>raw</code> in double quotation marks and double each embedded quotation mark. Commas and line breaks are retained inside the quoted field. This helper is used by internal output routines.</p></html>"));
end csvQuote;
