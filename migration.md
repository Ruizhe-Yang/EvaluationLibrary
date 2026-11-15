# Migration from EvaluationLibrary 0.3.1 to 0.4.0

## One result protocol

Keep MetricInput, MetricOutput and MetricResult. Their existing names now carry complete producer metadata and evidence. Recompile connected models together; an old eleven-field manual connection is incomplete. Integer connector status codes retain the existing enumeration ordinals. LegacyMetricResult and its formatter are removed, not kept as a competing protocol.

Set metricId, unitName and optional requirement metadata at the evaluator. Connect its result, or assessment.y array, directly to writer.u. Writer parameters metricId, unitName, windowStart/windowStop, message and similar parallel arrays are removed. ConsoleWriter only needs n, optional runId and required flags. A result array must have exactly the same size as its writer input.

## Removed wrappers and duplicate summaries

| Old path | Replacement |
|---|---|
| Requirements.Conjunction | Results.VerdictAggregator; share the same complete inputs with ConsoleWriter and inspect verdict/children |
| Results.BuildResult | Complete producer result |
| Results.RecordBuilder | Complete producer result |
| Results.ResultSelector | Connect the desired array element directly |
| Results.ResultTable | Connect arrays directly; VerdictAggregator.children retains an inspectable qualified batch |
| Results.TextSummary | Results.ConsoleWriter, optional TextWriter, or Functions.FormatSummary |
| Results.VerdictSummary | Results.VerdictAggregator |
| Results.PartialWriter | Independent ConsoleWriter, CSVWriter and TextWriter sharing pure formatting and internal file functions |
| Utilities.Types.LegacyMetricResult | Utilities.Types.MetricResult |
| Utilities.Internal.formatResults | Utilities.Functions.FormatSummary / FormatRow |

Retained specialist scalar ports remain available. New complete results are supplied alongside them. Improvement retains semantic inheritance from PairedDifference; ResponseDeadline specializes the finite FIFO requirement. No other public leaf relies on library inheritance.

## Simpler evaluation

- Use Statistics.SignalAssessment for related real signals on one window. Select AbsoluteValue, SignedValue, Difference or WrappedAngleDifference per channel, then set inclusive band/one-sided bounds and units. Classification thresholds are explicit and evaluated internally.
- Use Response.EventAssessment for Occurrence, RequestResponse and Recovery tasks. Do not connect a protection command as if it were actual action feedback. With useRecoverySignal, connect the observed real signal and let the evaluator apply the recovery band and dwell.
- LabelPerformance.y reports TP, TN, FP, FN, accuracy, precision, recall and specificity as eight complete results. Do not average counters through TimeMean. A zero ratio denominator gives unavailable numerical evidence, not zero precision or a satisfied requirement.
- Retain separate DataStatus and Verdict decisions. Statistics may be COMPLETE/UNDECIDED. A normal stop before a required window is INCOMPLETE. No request in a complete EventAssessment observation is NOT_APPLICABLE.

## Examples

The ten previous example paths are replaced by MultiSignalAssessment, WrappedAngleAndSeverity, ContinuousAndSampleStatistics, RequestResponseDeadline, RepeatedEventMatching, RecoveryAndDwell, MultiResultSummary, DiagnosticLabelPerformance and FrequencyOrFileOutput. Examples contain their own sources and writers. They need no external input connections and no result-field mapping equations.

CSV now includes all canonical fields plus runId. Existing output is preserved by default, so use a new run directory/name for repeated experiments or explicitly select Overwrite. Export state is independent of requirement truth. See README and verification for exact boundary rules, the RecoveryTime baseline defect, numerical regressions and untested platform scope.
