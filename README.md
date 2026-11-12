# EvaluationLibrary

## Name and purpose

Read-only metrics, explicit evidence qualification and structured result reporting.

## Scope and non-goals

Read-only statistics, response and requirement evidence, finite spectral measurements and structured results.

## Requirements

- Modelica Standard Library 4.0.0.
- Tested with OpenModelica 1.25.5 (64-bit), DASSL and relative tolerance 1e-6. 10/10 default examples completed in the recorded runs.
- Other Modelica tools are compatibility targets pending separate verification.

## Installation

Extract the source tree, load Modelica 4.0.0, then open `EvaluationLibrary/package.mo`. Confirm the Modelica version in your tool. Open an example from the package tree and use its declared experiment settings.

## Package structure

```text
EvaluationLibrary/
    UsersGuide/
    Signals/
    Statistics/
    Response/
    Requirements/
    Comparison/
    Frequency/
    Results/
    Utilities/
    Examples/
```

The model catalog lists each class, its interfaces, an example and its recorded validation level.

## Core concepts and usage

- Set the fixed half-open window or connect the first single external window. Supply validity separately from the window and specify a sample grid for sampled assets.
- Read dataStatus for coverage and verdict for decision. Check everViolated before using firstViolationTime. A later invalid window can retain a prior qualified witness.
- Connect MetricOutput to MetricInput on the table, aggregator or writer. Set static IDs, units and window metadata. Use a distinct runId and resultSetId for each output file.

## Examples

| Example | Stop time (s) | Purpose | Suggested observables |
|---|---:|---|---|
| AnalyticStatistics | 2.1 | Compare continuous and sample statistics of a ramp | Integral, timeMean, timeRMS, timeVariance, sampleMean, sampleRange.maximum, sampleMean.nValid. |
| FirstOrderResponse | 4.1 | Measure rise and terminal settling of a first-order response | rise.value, settling.value, settling.settled and both timestamps. |
| BoundsAndValidWitness | 2.1 | Retain a valid witness independently of subsequent bad data | Each result dataStatus and verdict, everViolated and firstViolationTime. |
| IncompleteWindow | 1 | Close an under-observed window at normal termination | noWitness and withWitness dataStatus, verdict and firstViolationTime. |
| RepeatedRequestResponse | 4.1 | Pair requests with responses and separate timeout from censoring | paired.matched, paired.timedOut, paired.censored, paired.unmatchedResponse, paired.delays[1:2], requirement.verdict. |
| PairedPerformance | 2.1 | Compare integrals for two declared comparable trajectories | baseline.value, candidate.value, improvement.absoluteImprovement and improvement.relativeImprovement. |
| ConsistencyAndLabels | 4.1 | Separate label statistics from simultaneous numeric consistency | labels.TP, TN, FP, FN, accuracy, recall and denominator flags. range.value while its window is open. |
| HarmonicMeasurements | 2.1 | Resolve a finite window containing two coherent sinusoidal tones | spectrum.amplitude[11], spectrum.amplitude[21], frequencyResolution, fundamental.value and distortion.thd. |
| DecayMeasurement | 3.1 | Measure the decay between positive peaks of a known oscillation | decay.peakCount, decay.ratio and decay.logarithmicDecrement. |
| ResultAggregationAndFiles | 2.1 | Route three structured results through a table, aggregation and one-shot writers | aggregate.verdict, aggregate.firstViolationTime, all child results, csv.written and csv.skippedExisting. |

## Limitations and numerical assumptions

- Sampled statistics refer to their grid. The finite DFT can leak off-grid energy and has spacing 1/(N Ts).
- A completed window and a qualified result are separate. Unresolved requests may be censored at closure.
- Writers preserve existing files by default and attempt output once. Abrupt interruption can prevent terminal processing.

## Version and license

Version 0.3.0. See LICENSE for the terms supplied with the original source.
