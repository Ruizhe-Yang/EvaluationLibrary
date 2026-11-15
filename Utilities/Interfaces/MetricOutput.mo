within EvaluationLibrary.Utilities.Interfaces;
connector MetricOutput "Complete, fixed-size qualified-result output"
  output String metricId "Stable metric identity";
  output String requirementId "Requirement identity; empty for a statistic";
  output String requirementVersion "Version of the interpreted requirement";
  output Real value "Numerical value; meaningful only when valueAvailable";
  output Boolean valueAvailable "A qualified numerical value is available";
  output Integer dataStatus "DataStatus ordinal, independently of verdict";
  output Integer verdict "Verdict ordinal, independently of data status";
  output String unit "Engineering unit of value";
  output Real windowStart "Inclusive observation start in seconds";
  output Real windowStop "Exclusive observation stop in seconds";
  output Real observedDuration "Observed duration in seconds";
  output Real validDuration "Duration with valid input in seconds";
  output Integer expectedSamples "Expected grid samples; zero for non-sampled evidence";
  output Integer receivedSamples "Observed grid samples";
  output Integer validSamples "Valid grid samples";
  output Boolean everViolated "A qualified violation has been observed";
  output Real firstViolationTime "First violation time; meaningful only when everViolated";
  output Real samplePeriod "Grid spacing in seconds; zero if not sampled";
  output Integer evidenceKind "EvidenceKind ordinal";
  output String message "Readable qualification and interpretation";
  output Boolean complete "The observation has closed, including a censored normal stop";
  output Boolean eventCountsAvailable "Event counters are measured by this producer; otherwise they are not applicable";
  output Integer eventCount "Qualified event or request count";
  output Integer matchedCount "One-to-one request-response pairs";
  output Integer timedOutCount "Requests with an observed expired deadline";
  output Integer censoredCount "Requests without sufficient observation";
  output Boolean levelAvailable "A sampled engineering severity level is available";
  output Integer level "Case-specific severity level, 0, 1 or 2";
  output Real level0Upper "Inclusive absolute-value upper bound for level 0";
  output Real level1Upper "Inclusive absolute-value upper bound for level 1";
  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Polygon(points={{-100,-80},{52,-80},{100,0},{52,80},{-100,80},{-100,-80}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=2),
        Rectangle(extent={{-70,-53},{51,53}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=2.5, radius=0),
        Line(points={{-26,-53},{-26,53}}, color={0,0,127}, thickness=2.5, pattern=LinePattern.Solid),
        Line(points={{-70,-17},{-26,-17}}, color={0,0,127}, thickness=2.5, pattern=LinePattern.Solid),
        Line(points={{-70,18},{-26,18}}, color={0,0,127}, thickness=2.5, pattern=LinePattern.Solid),
        Text(extent={{-20,28},{45,-28}}, textString="30", textColor={0,0,127}, fontSize=0)
      }),Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),Documentation(info="<html><p>Metric output. Inputs retain the physical units or logical meaning stated by their declarations. Domain assertions and explicit availability flags are part of the contract.</p></html>"));
end MetricOutput;
