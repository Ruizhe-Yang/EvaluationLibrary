within EvaluationLibrary.Utilities.Functions;
function FormatRow "Format a result as a CSV record or concise text"
 input String runId "Run identity";
 input EvaluationLibrary.Utilities.Types.MetricResult r "Complete result record";
 input Boolean csv=false "Use CSV when true; otherwise use concise text";
 output String text "Formatted result record";
algorithm
 if csv then
  text:=EvaluationLibrary.Utilities.Functions.QuoteCSV(runId)+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(r.metricId)+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(r.requirementId)+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(r.requirementVersion)+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(if r.valueAvailable then String(r.value,significantDigits=16) else "N/A")+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.valueAvailable))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.dataStatus))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.verdict))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(r.unit)+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.windowStart))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.windowStop))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.observedDuration))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.validDuration))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.expectedSamples))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.receivedSamples))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.validSamples))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.everViolated))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(if r.everViolated then String(r.firstViolationTime,significantDigits=16) else "N/A")+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.samplePeriod))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.evidenceKind))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(r.message)+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.complete))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.eventCountsAvailable))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(if r.eventCountsAvailable then String(r.eventCount) else "N/A")+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(if r.eventCountsAvailable then String(r.matchedCount) else "N/A")+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(if r.eventCountsAvailable then String(r.timedOutCount) else "N/A")+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(if r.eventCountsAvailable then String(r.censoredCount) else "N/A")+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.levelAvailable))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(if r.levelAvailable then String(r.level) else "N/A")+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.level0Upper))+","+EvaluationLibrary.Utilities.Functions.QuoteCSV(String(r.level1Upper));
 else
  text:=r.metricId+" : "+(if r.valueAvailable then String(r.value,significantDigits=8)+" "+r.unit else "N/A")+" | "+String(r.dataStatus)+" | "+String(r.verdict)+" | "+r.message;
 end if;
  annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Rectangle(extent={{-55.315,-26.169},{-19.573,24.891}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-55.315,-9.149},{-19.573,-9.149}}, color={64,64,64}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-55.315,7.871},{-19.573,7.871}}, color={64,64,64}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-37.444,-26.169},{-37.444,24.891}}, color={64,64,64}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-16.169,-0.639},{1.702,-0.639}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Rectangle(extent={{8.51,-12.553},{59.57,11.275}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{25.53,-12.553},{25.53,11.275}}, color={64,64,64}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{42.55,-12.553},{42.55,11.275}}, color={64,64,64}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-34.891,-47.444},{45.954,-72.123}}, textString="N/A", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Format <code>r</code> with the supplied <code>runId</code>. With <code>csv=true</code>, all record fields are written in the order used by <code>Internal.WriteRows</code>, with each field quoted. Otherwise, return the metric identifier, value, data status, verdict and message.</p><p>Unavailable values, absent violation times and unavailable optional counters or levels are represented by <code>N/A</code>. The function returns text and performs no output operation.</p></html>"));
end FormatRow;
