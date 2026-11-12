# Changelog

## 0.3.1 — 12 November 2026

- Restore the `Results` package entry points required by `ResultAggregationAndFiles`: typed result table, verdict aggregation and CSV, text and console writers.
- Add `Utilities.Internal.LogCompletion` and one-shot, timestamped terminal audit messages after successful exports or finalised in-memory summaries.
- Report host-local wall-clock time, simulation time, output type, absolute file location (or terminal/in-memory destination), run ID, result-set ID and record count.
- Print `SKIPPED` rather than success when the default `RejectExisting` policy prevents overwriting a file. Do not log success before file closure and existence confirmation.
- Fix console routing so that `ConsoleWriter` does not accidentally write to a file.
- Correct the model catalogue by removing `Results.*` entries not present in the shipped package. No other Modelica component equations were changed.

**Verification:** Source/package consistency and export-path checks performed statically. A current OpenModelica compilation or simulation was not available in the editing environment; run the provided smoke script before treating the new export workflow as execution-verified.



## 0.3.0

- Rename `IndicatorEvaluationLibrary` to `EvaluationLibrary`.
- Separate signal metrics, statistics, response, requirements, comparison, frequency and results.
- Add independent evidence qualification, explicit witness and censored-event semantics.
- Introduce typed result connections and one-shot writer policies.
- Retain distinct existing capabilities such as two-signal tone response and paired arrival skew.

### Migration

- The standard bound blocks use upper, lower and tolerance. Set windowStart and windowStop for the observation period. Set useValidInput=true to connect explicit validity.
- Use Utilities.Types.DataStatus and Verdict instead of assuming the former enum ordinals. Typed metric connectors carry evidence fields and numerical codes. String IDs and units are static metadata.
- Use CSVWriter or TextWriter with runId and resultSetId. Existing-file policy is explicit. The former append option was retired.
