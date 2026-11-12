![EvaluationLibrary: observation windows, qualified metrics and explicit requirement verdicts](docs/assets/overview.svg)

# EvaluationLibrary

**Modelica metrics and requirement assessment with explicit evidence qualification.**

**English** · [简体中文](README_zh.md)

<!-- learning-guide:start -->
> **[Detailed bilingual learning and usage guide](docs/LearningGuide.html)** — Chinese and British English in one offline-readable HTML file, with a complete component reference and every example explained. Download the HTML and open it in a browser to use language switching and search.
<!-- learning-guide:end -->

[![Source version 0.3.1](https://img.shields.io/badge/source-v0.3.1-5453a4)](package.mo)
[![Modelica Standard Library 4.0.0](https://img.shields.io/badge/MSL-4.0.0-536478)](package.mo)

[Purpose](#purpose) · [Evidence semantics](#evidence-semantics) · [Quick start](#quick-start) · [Examples](#examples) · [Research use](#research-use)

## Purpose

EvaluationLibrary turns observed simulation signals into numerical measures and explicit requirement verdicts. It covers time and sample statistics, transient response, bounds and deadlines, paired comparisons, classification labels and selected frequency-domain measures.

Its central concern is the relationship between a result and the evidence supporting it. A numerical value, a completed observation window, an invalid measurement and a witnessed violation are different facts. The library represents those facts separately so that an attractive curve or an available number is not automatically interpreted as a satisfied requirement.

The blocks read signals from the host model. They can therefore be connected as an observation layer for comparative experiments, response characterisation and simulation-based requirement assessment.

| At a glance | Current source |
| :--- | :--- |
| Modelica package | `EvaluationLibrary` |
| Package version | **0.3.1**, declared in [package.mo](package.mo) |
| Declared library dependency | Modelica Standard Library **4.0.0** |
| Example definitions | **10**, including structured result reporting |
| Documentation and source review | **12 November 2026**; see the Git revision of the version used |

## Evidence semantics

The standard evaluators share a typed [`MetricOutput`](Utilities/Interfaces/MetricOutput.mo) containing the numerical value and its availability, data status, verdict, violation witness, first violation time, valid duration, sample counts and finalisation flag. The [`MetricResult`](Utilities/Types/MetricResult.mo) record additionally defines identifiers, units, window metadata and requirement-version fields.

| Question | Source representation |
| :--- | :--- |
| Is a numerical value available? | `valueAvailable` |
| What is the observation's coverage and validity? | `DataStatus`: `PENDING`, `COMPLETE`, `INCOMPLETE`, `INVALID`, `NOT_APPLICABLE` |
| What does the requirement conclude? | `Verdict`: `UNDECIDED`, `SATISFIED`, `VIOLATED`, `INVALID`, `NOT_APPLICABLE` |
| Was a qualified violation observed? | `everViolated` and `firstViolationTime` |
| Has collection been finalised? | `complete`; inspect `dataStatus` separately for coverage |

[`WindowEvidence`](Utilities/Internal/WindowEvidence.mo) supports a fixed half-open interval `[start, stop)` or the first externally supplied window. A subsequent external window is flagged as invalid. Normal simulation termination can finalise an incompletely observed interval: **`complete=true` does not imply `dataStatus=COMPLETE`**.

The [verdict function](Utilities/Functions/ToVerdict.mo) gives invalid data precedence over a requirement verdict while retaining any previously recorded violation witness. An incomplete window without such a witness remains undecided. A fully observed numerical metric is also not automatically a satisfied requirement; a criterion is needed to make that judgement.

## Model organisation

| Package | Available source functionality |
| :--- | :--- |
| [Signals](Signals) | Paired errors, wrapped angular error, finite differences and validity gating |
| [Statistics](Statistics) | Continuous integrals and duration-weighted statistics; statistics on an explicit sample grid |
| [Response](Response) | Rise/fall time, terminal settling, event counts, recovery and request–response timing |
| [Requirements](Requirements) | Bounds, persistence, deadlines and conjunction of qualified results |
| [Comparison](Comparison) | Paired improvement, channel consistency and binary label statistics |
| [Frequency](Frequency) | Finite DFT, selected-frequency amplitude/phase, harmonic distortion and peak decay |
| [Results](Results) | Qualified result tables, aggregate verdicts and one-shot CSV, text and console outputs |
| [Utilities](Utilities) | Evidence qualification, typed connectors, records, numerical and formatting helpers |
| [Examples](Examples) | Connected demonstrations with explicit observation windows |
| [UsersGuide](UsersGuide) | In-tool information pages |

## Current source status

`Results` now includes the result table, verdict aggregation, one-shot CSV/TXT writers and a console writer. The earlier missing-package blocker for [`ResultAggregationAndFiles`](Examples/ResultAggregationAndFiles.mo) has been addressed at source level. Other `Results.*` classes appearing in the previous catalogue were not present in the source snapshot and have been removed from the catalogue rather than represented as supported components. **The newly restored workflow has not yet been compiled or simulated in OpenModelica in this editing environment.**

### Completion logs (v0.3.1)

When a result set is finalised, the output components print an audit message **once**, not on every simulation time step. Successful file exports are logged after closing and verifying the file. Messages contain the host-local timestamp, simulation time, output type, absolute destination path, run ID, result-set ID and record count. Console outputs identify `terminal (stdout)`; in-memory result tables and aggregated verdicts identify their Modelica variable, not a fictitious file.

The default file policy is `RejectExisting`: an existing target produces a `SKIPPED` message, and no success is claimed. Set `writePolicy=EvaluationLibrary.Utilities.Types.WritePolicy.Overwrite` when replacement is intentional. The `outputDirectory` must already exist; file names default to `runId_resultSetId.csv` or `.txt`.

## Quick start

```bash
git clone https://github.com/Ruizhe-Yang/EvaluationLibrary.git
cd EvaluationLibrary
```

Load **Modelica 4.0.0** and open the root `package.mo`. For the core metric implementation, start with `EvaluationLibrary.Examples.AnalyticStatistics`, which is independent of the export components. Its experiment is **0–2.1 s**, with tolerance **1e-6**.

From the repository directory, run the following OpenModelica commands to check the package and simulate the analytical example (the commands are provided for reproduction and have **not** been executed in this edit):

```modelica
loadModel(Modelica, {"4.0.0"});
loadFile("package.mo");
checkModel(EvaluationLibrary.Examples.AnalyticStatistics);
simulate(EvaluationLibrary.Examples.AnalyticStatistics,
  startTime=0, stopTime=2.1, numberOfIntervals=500, tolerance=1e-6);
getErrorString();
```

The input is `u=time`, and the observation window is `[0, 2)`. Analytical reference values are **2** for the integral, **1** for the time mean, **2/√3** for the time RMS and **1/3** for the time variance. The sample grid is `0, 0.01, …, 1.99`: its **200** observations have a sample mean of **0.995**. These reference values follow from the example definition; they are not new execution results. Inspect the matching availability and data-status fields after the window closes.

## Examples

| Example | Research question | Useful outputs | Declared stop |
| :--- | :--- | :--- | ---: |
| [AnalyticStatistics](Examples/AnalyticStatistics.mo) | How do continuous and sampled statistics differ? | `integralValue`, `timeMeanValue`, `sampleMeanValue`, `sampleMean.nValid` | 2.1 s |
| [BoundsAndValidWitness](Examples/BoundsAndValidWitness.mo) | What happens when invalid data follow a valid violation? | Evaluator `dataStatus`, `verdict`, `everViolated`, `firstViolationTime` | 2.1 s |
| [FirstOrderResponse](Examples/FirstOrderResponse.mo) | How are rise and terminal settling times measured? | `riseSeconds`, `settlingSeconds`, `settling.settled` | 4.1 s |
| [RepeatedRequestResponse](Examples/RepeatedRequestResponse.mo) | Which requests match, time out or become censored? | `paired.matched`, `.timedOut`, `.censored`, `.unmatchedResponse` | 4.1 s |
| [PairedPerformance](Examples/PairedPerformance.mo) | How is improvement computed for comparable trajectories? | `absoluteChange`, `relativeChange` | 2.1 s |
| [ConsistencyAndLabels](Examples/ConsistencyAndLabels.mo) | How do numeric consistency and label accuracy differ? | `spread`, `accuracy`, `labels.TP`, `.TN`, `.FP`, `.FN` | 4.1 s |
| [HarmonicMeasurements](Examples/HarmonicMeasurements.mo) | What can a finite coherent sample window reveal? | `spectrum.amplitude`, `fundamentalValue`, `distortion.thd` | 2.1 s |
| [DecayMeasurement](Examples/DecayMeasurement.mo) | How do qualified positive peaks attenuate? | `decay.peakCount`, `decay.ratio`, `decay.logarithmicDecrement` | 3.1 s |
| [IncompleteWindow](Examples/IncompleteWindow.mo) | How does termination before the requested end affect evidence? | `noWitness.dataStatus`, `.verdict`; `withWitness.everViolated` | 1 s |
| [ResultAggregationAndFiles](Examples/ResultAggregationAndFiles.mo) | Intended structured result and writer workflow | `Results` entry points restored in v0.3.1; execution not yet re-verified | 2.1 s |

### Export smoke test

Run [the supplied OpenModelica script](Resources/Scripts/export_smoke.mos) from the repository root to exercise the three result writers. Inspect the terminal for the `SUCCESS` messages and the absolute paths of `demo_csv.csv` and `demo_text.txt`. Run it again without deleting the files to inspect `SKIPPED` behaviour, or configure `Overwrite`. The script is provided for verification; its outcome has not been asserted here.

## Research use

Choose the observation window and criterion before interpreting a result. Record signal definitions and units, requirement thresholds and versions, validity rules, sampling period, host-model revision, solver settings and the library commit. Preserve both the verdict and its supporting qualification fields.

For comparisons, establish matching units, windows and interpretations. For settling time, [`Response.SettlingTime`](Response/SettlingTime.mo) confirms the final band entry only at the end of a fully observed window with the required dwell. For repeated responses, [`Response.RepeatedResponse`](Response/RepeatedResponse.mo) uses a finite FIFO queue and distinguishes timeouts, unmatched responses and requests censored by the end of observation. These distinctions should remain visible in reported results.

When citing the software, identify **EvaluationLibrary, version 0.3.1**, the repository URL and the commit used. The [change log](CHANGELOG.md) and [commit history](https://github.com/Ruizhe-Yang/EvaluationLibrary/commits/main/) support maintenance and replication.

## Scope and assumptions

Assessment depends on the supplied signals, their validity and the chosen observation conditions. A result does not independently establish the fidelity of the host model or certify a physical system. Frequency analysis depends on the declared finite sampling grid and window; event pairing has explicit queue and record capacities. The newly restored export components still require independent tool-based verification. Reproduce the selected example and its numerical expectations in the intended Modelica tool before using it in an experiment.

## Licence and contributions

The repository contains the [GNU General Public License, version 3](LICENSE). For an issue or contribution, provide the version or commit, tool version, minimal model, observation-window settings, expected result and actual qualification fields. Evidence semantics, numerical reference cases and package completeness are valuable areas for improvement.
