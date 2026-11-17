within EvaluationLibrary.Utilities.Types;
record MetricResult "Structured metric result with qualification and observation metadata"
  String metricId "Stable metric identity";
  String requirementId "Requirement identity; empty for a statistic";
  String requirementVersion "Version identifier of the assessed requirement";
  Real value "Numerical value; meaningful only when valueAvailable";
  Boolean valueAvailable "A qualified numerical value is available";
  EvaluationLibrary.Utilities.Types.DataStatus dataStatus "DataStatus enumeration, independently of verdict";
  EvaluationLibrary.Utilities.Types.Verdict verdict "Verdict enumeration, independently of data status";
  String unit "Engineering unit of value";
  Real windowStart "Inclusive observation start in seconds";
  Real windowStop "Exclusive observation stop in seconds";
  Real observedDuration "Observed duration in seconds";
  Real validDuration "Duration with valid input in seconds";
  Integer expectedSamples "Expected grid samples; zero for non-sampled evidence";
  Integer receivedSamples "Observed grid samples";
  Integer validSamples "Valid grid samples";
  Boolean everViolated "A qualified violation has been observed";
  Real firstViolationTime "First violation time; meaningful only when everViolated";
  Real samplePeriod "Grid spacing in seconds; zero if not sampled";
  EvaluationLibrary.Utilities.Types.EvidenceKind evidenceKind "Continuous, sampled, event or derived evidence enumeration";
  String message "Readable qualification and interpretation";
  Boolean complete "The producing block has closed observation";
  Boolean eventCountsAvailable "Event counters are available, independently of valueAvailable";
  Integer eventCount "Qualified event or request count";
  Integer matchedCount "One-to-one request-response pairs";
  Integer timedOutCount "Requests with an observed expired deadline";
  Integer censoredCount "Requests without sufficient observation";
  Boolean levelAvailable "A sampled engineering severity level is available";
  Integer level "Engineering severity level, 0, 1 or 2";
  Real level0Upper "Inclusive absolute-value upper bound for level 0";
  Real level1Upper "Inclusive absolute-value upper bound for level 1";
  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-83,-88},{83,88}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-83,47},{83,47}}, color={108,88,49}, thickness=0.6, pattern=LinePattern.Solid),
        Text(extent={{-45,82},{45,52}}, textString="30", textColor={108,88,49}, fontSize=0),
        Rectangle(extent={{-66,-69},{66,39}}, lineColor={108,88,49}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-66,-51},{66,-51}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-66,-33},{66,-33}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-66,-15},{66,-15}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-66,3},{66,3}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-66,21},{66,21}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-39.6,-69},{-39.6,39}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-13.2,-69},{-13.2,39}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{13.2,-69},{13.2,39}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{39.6,-69},{39.6,39}}, color={108,88,49}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),Documentation(info="<html><p>Store a numerical result together with its identity, unit, data status, verdict, observation coverage and optional violation, event and severity information. <code>valueAvailable</code> qualifies <code>value</code>; <code>everViolated</code> qualifies <code>firstViolationTime</code>; <code>eventCountsAvailable</code> and <code>levelAvailable</code> qualify their respective fields.</p><p><code>complete</code> means collection has closed and does not imply <code>DataStatus.COMPLETE</code>. The record uses enumeration types; the corresponding <code>MetricInput</code> and <code>MetricOutput</code> connectors use integer ordinals for these fields.</p></html>"));
end MetricResult;
