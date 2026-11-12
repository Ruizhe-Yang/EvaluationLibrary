within EvaluationLibrary.Utilities.Functions;
function FormatRow "Render a finalized row without fabricating an unavailable value"
  extends Modelica.Icons.Function;
input String runId;
  input EvaluationLibrary.Utilities.Types.MetricResult row;
  input Boolean csv=false;
  output String text;
protected
  String numeric;
  String witness;
  String status;
  String verdict;
algorithm
  numeric:=if row.valueAvailable then String(row.value,significantDigits=14) else "";
  witness:=if row.everViolated then String(row.firstViolationTime,significantDigits=14) else "";
  status:=EvaluationLibrary.Utilities.Functions.StatusText(row.dataStatus);
  verdict:=EvaluationLibrary.Utilities.Functions.VerdictText(row.verdict);
  text:=if csv then EvaluationLibrary.Utilities.Functions.QuoteCSV(runId)+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(row.metricId)+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(row.requirementVersion)+
    ","+numeric+","+String(row.valueAvailable)+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(row.unit)+","+status+","+verdict+","+
    String(row.windowStart)+","+String(row.windowStop)+","+String(row.everViolated)+","+witness+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(row.message)
    else runId+" | "+row.metricId+" | "+status+" | "+verdict+
      (if row.valueAvailable then " | "+numeric+" "+row.unit else " | unavailable")+
      (if row.everViolated then " | first witness at "+witness+" s" else "")+
      (if row.message<>"" then " | "+row.message else "");
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Polygon(points={{-31.28,-33.96},{-31.28,37.44},{16.32,37.44},{31.96,21.8},{31.96,-33.96},{-31.28,-33.96}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{16.32,37.44},{16.32,21.8},{31.96,21.8}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-20.4,15},{17.68,15}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-20.4,3.44},{20.4,3.44}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-20.4,-8.12},{11.56,-8.12}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-20.4,-19.68},{20.4,-19.68}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-44.2,1.4},{-15.64,1.4}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-65,-55},{65,-78}}, textString="format", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Render a finalized row without fabricating an unavailable value.</p><p><b>Interfaces</b> input String runId; input EvaluationLibrary.Utilities.Types.MetricResult row; input Boolean csv=false; output String text</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Render a finalized row without fabricating an unavailable value</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Outputs retain the units declared at the interface. Numerical values depend on the supplied input and parameter range.</p><p><b>Observables</b> text</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.ResultAggregationAndFiles\">EvaluationLibrary.Examples.ResultAggregationAndFiles</a></p></html>"));
end FormatRow;
