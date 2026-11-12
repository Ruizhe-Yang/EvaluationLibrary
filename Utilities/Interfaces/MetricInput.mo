within EvaluationLibrary.Utilities.Interfaces;
connector MetricInput "Typed input for a qualified metric"
input Real value;
input Boolean valueAvailable;
input Integer dataStatus;
input Integer verdict;
input Boolean everViolated;
input Real firstViolationTime(unit="s");
input Real validDuration(unit="s");
input Integer expectedSamples;
input Integer receivedSamples;
input Integer validSamples;
input Boolean complete;
  annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
      graphics={
        Polygon(points={{-100,-100},{100,0},{-100,100},{-100,-100}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.7),
        Line(points={{-65,32},{-17,32}}, color={255,255,255}, thickness=3, pattern=LinePattern.Solid),
        Line(points={{-65,0},{19,0}}, color={255,255,255}, thickness=3, pattern=LinePattern.Solid),
        Line(points={{-65,-32},{-17,-32}}, color={255,255,255}, thickness=3, pattern=LinePattern.Solid)
      }),
    Documentation(info="<html><p><b>Purpose</b> Typed input for a qualified metric.</p><p><b>Interfaces</b> input Real value; input Boolean valueAvailable; input Integer dataStatus; input Integer verdict; input Boolean everViolated; input Real firstViolationTime(unit=\"s\"); input Real validDuration(unit=\"s\"); input Integer expectedSamples; input Integer receivedSamples; input Integer validSamples; input Boolean complete</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Numeric codes are the fixed enumeration ordinals. Complete means the evaluation has closed.</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> String identifiers and units are component parameters rather than connector fields.</p><p><b>Observables</b> Public outputs and the stated input conditions.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.ResultAggregationAndFiles\">EvaluationLibrary.Examples.ResultAggregationAndFiles</a></p></html>"));
end MetricInput;
