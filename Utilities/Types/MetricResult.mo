within EvaluationLibrary.Utilities.Types;
record MetricResult "Store metric value, eligibility, window and witness evidence"
  extends Modelica.Icons.Record;
String metricId;
String requirementId;
String requirementVersion;
Real value;
Boolean valueAvailable;
String unit;
EvaluationLibrary.Utilities.Types.DataStatus dataStatus;
EvaluationLibrary.Utilities.Types.Verdict verdict;
Modelica.Units.SI.Time windowStart;
Modelica.Units.SI.Time windowStop;
Modelica.Units.SI.Time observedDuration;
Modelica.Units.SI.Time validDuration;
Integer expectedSamples;
Integer receivedSamples;
Integer validSamples;
Boolean everViolated;
Modelica.Units.SI.Time firstViolationTime;
Modelica.Units.SI.Time samplePeriod;
EvaluationLibrary.Utilities.Types.EvidenceKind evidenceKind;
String message;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-100,48},{100,48}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Rectangle(extent={{-50.16,-41.96},{50.16,38.12}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-50.16,12.6},{50.16,12.6}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-50.16,-14.68},{50.16,-14.68}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-17.6,-41.96},{-17.6,38.12}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-43.12,35.48},{-22,16.12}}, textString="id", textColor={108,88,49}, fontSize=0),
        Text(extent={{-43.12,8.2},{-22,-10.28}}, textString="x", textColor={108,88,49}, fontSize=0),
        Text(extent={{-43.12,-19.08},{-22,-37.56}}, textString="t", textColor={108,88,49}, fontSize=0),
        Line(points={{20.68,-30.52},{27.7024,-37.912},{41.3776,-20.1712}}, color={75,138,73}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-70,80},{70,52}}, textString="Result", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Store metric value, eligibility, window and witness evidence.</p><p><b>Interfaces</b> The declared record fields or function arguments form the interface.</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Store metric value, eligibility, window and witness evidence</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Unavailable values and absent witness times use a placeholder numeric field. Use the accompanying flags.</p><p><b>Observables</b> Public outputs and the stated input conditions.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.ResultAggregationAndFiles\">EvaluationLibrary.Examples.ResultAggregationAndFiles</a></p></html>"));
end MetricResult;
