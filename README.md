# EvaluationLibrary 0.4.0

Read-only Modelica evaluation, explicit evidence qualification and directly connected results. Only Modelica Standard Library 4.0.0 is required by the library and its nine examples.

## Start with a complete example

Load EvaluationLibrary/package.mo, open Examples.MultiSignalAssessment and simulate its declared experiment. All excitation, observation and reporting are internal. The console prints each channel, its evidence status, its verdict, and an explicit overall verdict once. No external ports need binding.

For a host model, instantiate Statistics.SignalAssessment, connect the observed real-signal array to assessment.u, and connect assessment.y to Results.ConsoleWriter.u with the same n. Supply each signal's unit, interpretation and inclusive bounds once at the evaluator. WrappedAngleDifference performs the radian normalization internally. Ordinary positions use Difference or SignedValue. No result-field assignments, ResultTable, TimeMean counter relay or CSVWriter are required.

Response.EventAssessment handles related event tasks on one window. Its request and actual response are different inputs. Select Occurrence, RequestResponse or Recovery per task. Optional useRecoverySignal performs the recovery-band test internally; recovery requires uninterrupted valid dwell. An undemanded barrier is NOT_APPLICABLE. Event counts, matches, timeouts and censored requests travel with the result.

## Result and evidence contract

MetricInput, MetricOutput and MetricResult are the existing interfaces expanded to one canonical complete contract. The 30 fields include stable identities, requirement version, value and availability, unit, DataStatus, Verdict, observation window, durations, sample coverage, violation witness, evidence kind, explanation, completion, event counts with an explicit availability flag and optional engineering severity. Connector status fields retain the fixed integer enumeration ordinals from 0.3.1 for standard fixed-size connector portability; the record uses the corresponding enumerations. No parallel legacy record, expandable connector or executable expression string is used.

DataStatus is PENDING, COMPLETE, INCOMPLETE, INVALID or NOT_APPLICABLE. Verdict is UNDECIDED, SATISFIED, VIOLATED, INVALID or NOT_APPLICABLE. A complete statistic need not be a satisfied requirement. Unavailable numbers are guarded by availability flags and printed as N/A, never treated as zero evidence. A recorded violation remains inspectable even if later evidence becomes invalid.

The half-open window is [start,stop). Sampled extrema are explicitly sampled extrema, not strict continuous extrema. SignalAssessment can use continuous event inequalities for bound violations and continuous violation duration while sharing one sampling grid for reported extrema. Its result message states that distinction. With sampled=true, duration is unavailable and only ticks decide bounds. Optional Level 0/1/2 uses sampled absolute interpreted peaks; equality belongs to the lower level. These are case-specific engineering categories, not certification levels.

Required INVALID dominates VIOLATED, then UNDECIDED. All required applicable items must be SATISFIED to obtain SATISFIED. Non-applicable items are retained and excluded; no applicable items gives NOT_APPLICABLE. Invalid or incomplete data cannot supply an aggregate satisfied verdict even if an inconsistent upstream verdict code says otherwise.

## Event boundaries

At the same instant requests enter the FIFO before responses; equality with a deadline is accepted inside the observation window. Responses cannot satisfy more than one request. Older expired requests are removed first. A deadline at the exclusive window stop lacks in-window follow-up and is censored. Queue overflow is INVALID. Invalid gaps invalidate history and flush pending requests; they cannot splice two valid intervals into one response or dwell proof. Recovery stops and restarts its dwell when the band or validity is lost.

## Retained specialist capability

Continuous and sampled moments, sampled extrema, paired and finite multi-run comparisons, diagnostic TP/TN/FP/FN with denominator flags, finite DFT and tone response, specialized crossing and response metrics, and explicit finite-set summaries remain available. LabelPerformance.y directly reports all eight counts/ratios; its scalar result remains the accuracy result using the same protocol. Specialist scalar outputs are retained; complete result outputs remove the need for record-builder models. Finite candidate summaries are not probabilities or continuous-domain global worst-case proofs.

## Output and files

ConsoleWriter can be used alone. Results follow declaration order and include every child. CSVWriter and TextWriter are optional and consume the same complete results. Existing files are preserved by default; choose Overwrite explicitly to replace a file. The output directory must already exist. written and skippedExisting describe export only and never alter safety. MSL file-system errors may terminate a simulation; there is no portable exception recovery in this library, and a failed export is not evidence of satisfaction.

## Verification and portability

See verification for the baseline inventory, nine example checks, 28 boundary/negative scenarios, numerical 0.3.1 regressions and an Icon/Diagram overview for every Results class. Actual compiler: OpenModelica 1.27.1 in command-line mode, standard Modelica 3.4. No GUI was started. OpenModelica 1.25.x and MWorks execution were not performed; their runtime compatibility is unverified, despite avoiding dynamic connectors and nonstandard language constructs. No Python or extra runtime is required to run an Example. Optional verification automation uses Python's standard library and an explicitly supplied compiler.

See migration.md for breaking result-interface changes, removed redundant wrappers and the replacement example paths. This library observes signals; it does not inject faults, control protection, run external simulations, calculate accident probabilities, perform Monte Carlo analysis or automatically complete FMEA/FTA/STPA reasoning.

Retained scalar response specialists are not duplicate aliases: RepeatedResponse exposes a bounded individual-delay history and externally gated windows; ResponseDelay measures only the first accepted pair; RecoveryTime is a non-requirement elapsed-time measurement with external gating. The integrated EventAssessment provides shared fixed-window task summaries. Their distinct interpretations and retained numerical definitions are preserved.

Coverage-only verdict reconstruction is not used for retained requirements: undemanded tasks remain NOT_APPLICABLE, undefined denominators remain unresolved, and nonfinite evidence is INVALID. Requirements.Conjunction is removed in favor of the existing child-preserving VerdictAggregator.
