# Changelog

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
