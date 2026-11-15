within EvaluationLibrary.Utilities.Interfaces;
connector MetricInput "Complete, fixed-size qualified-result input"
  input String metricId "Stable metric identity";
  input String requirementId "Requirement identity; empty for a statistic";
  input String requirementVersion "Version of the interpreted requirement";
  input Real value "Numerical value; meaningful only when valueAvailable";
  input Boolean valueAvailable "A qualified numerical value is available";
  input Integer dataStatus "DataStatus ordinal, independently of verdict";
  input Integer verdict "Verdict ordinal, independently of data status";
  input String unit "Engineering unit of value";
  input Real windowStart "Inclusive observation start in seconds";
  input Real windowStop "Exclusive observation stop in seconds";
  input Real observedDuration "Observed duration in seconds";
  input Real validDuration "Duration with valid input in seconds";
  input Integer expectedSamples "Expected grid samples; zero for non-sampled evidence";
  input Integer receivedSamples "Observed grid samples";
  input Integer validSamples "Valid grid samples";
  input Boolean everViolated "A qualified violation has been observed";
  input Real firstViolationTime "First violation time; meaningful only when everViolated";
  input Real samplePeriod "Grid spacing in seconds; zero if not sampled";
  input Integer evidenceKind "EvidenceKind ordinal";
  input String message "Readable qualification and interpretation";
  input Boolean complete "The observation has closed, including a censored normal stop";
  input Boolean eventCountsAvailable "Event counters are measured by this producer; otherwise they are not applicable";
  input Integer eventCount "Qualified event or request count";
  input Integer matchedCount "One-to-one request-response pairs";
  input Integer timedOutCount "Requests with an observed expired deadline";
  input Integer censoredCount "Requests without sufficient observation";
  input Boolean levelAvailable "A sampled engineering severity level is available";
  input Integer level "Case-specific severity level, 0, 1 or 2";
  input Real level0Upper "Inclusive absolute-value upper bound for level 0";
  input Real level1Upper "Inclusive absolute-value upper bound for level 1";
  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Polygon(points={{-100,-80},{52,-80},{100,0},{52,80},{-100,80},{-100,-80}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=2),
        Rectangle(extent={{-70,-53},{51,53}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=2.5, radius=0),
        Line(points={{-26,-53},{-26,53}}, color={255,255,255}, thickness=2.5, pattern=LinePattern.Solid),
        Line(points={{-70,-17},{-26,-17}}, color={255,255,255}, thickness=2.5, pattern=LinePattern.Solid),
        Line(points={{-70,18},{-26,18}}, color={255,255,255}, thickness=2.5, pattern=LinePattern.Solid),
        Text(extent={{-20,28},{45,-28}}, textString="30", textColor={255,255,255}, fontSize=0)
      }),Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),Documentation(info="<html><p>Metric input. Inputs retain the physical units or logical meaning stated by their declarations. Domain assertions and explicit availability flags are part of the contract.</p></html>"));
end MetricInput;
