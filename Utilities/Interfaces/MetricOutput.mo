within EvaluationLibrary.Utilities.Interfaces;
connector MetricOutput "Typed output for a qualified metric"
output Real value;
output Boolean valueAvailable;
output Integer dataStatus;
output Integer verdict;
output Boolean everViolated;
output Real firstViolationTime(unit="s");
output Real validDuration(unit="s");
output Integer expectedSamples;
output Integer receivedSamples;
output Integer validSamples;
output Boolean complete;
  annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
      graphics={
        Polygon(points={{-100,-100},{100,0},{-100,100},{-100,-100}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.7),
        Line(points={{-65,32},{-17,32}}, color={0,0,127}, thickness=3, pattern=LinePattern.Solid),
        Line(points={{-65,0},{19,0}}, color={0,0,127}, thickness=3, pattern=LinePattern.Solid),
        Line(points={{-65,-32},{-17,-32}}, color={0,0,127}, thickness=3, pattern=LinePattern.Solid)
      }),
    Documentation(info="<html><p><b>Purpose</b> Typed output for a qualified metric.</p><p><b>Interfaces</b> output Real value; output Boolean valueAvailable; output Integer dataStatus; output Integer verdict; output Boolean everViolated; output Real firstViolationTime(unit=\"s\"); output Real validDuration(unit=\"s\"); output Integer expectedSamples; output Integer receivedSamples; output Integer validSamples; output Boolean complete</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Numeric codes are the fixed enumeration ordinals. Complete means the evaluation has closed.</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> String identifiers and units are component parameters rather than connector fields.</p><p><b>Observables</b> value, valueAvailable, dataStatus, verdict, everViolated, firstViolationTime, validDuration, expectedSamples, receivedSamples, validSamples</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.ResultAggregationAndFiles\">EvaluationLibrary.Examples.ResultAggregationAndFiles</a></p></html>"));
end MetricOutput;
