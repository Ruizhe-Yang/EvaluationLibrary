# Changelog

## 0.4.0

- Expanded the existing complete-result connectors and record. Metadata originates at evaluators and travels with numeric evidence; writer-side metadata arrays and field-mapping wrappers were removed.
- Added SignalAssessment with one window and clock, independent channels, internal wrapped-angle interpretation, event-based or sampled bounds, explicit sampled extrema and engineering Level 0/1/2.
- Added EventAssessment with shared coverage, event roles, first occurrences, finite FIFO matching, explicit actual feedback, deadline witnesses, censored follow-up and recovery dwell.
- Made all retained specialist metrics directly reportable, and exposed eight complete diagnostic count/ratio results. Their original scalar algorithms and numerical outputs are retained.
- Refused aggregate satisfaction from invalid or incomplete input qualification; retained explicit INVALID > VIOLATED > UNDECIDED > SATISFIED priority.
- Fixed the 0.3.1 RecoveryTime discrete algebraic cycle by separating current event updates from prior state. The baseline cannot compile that regression under the tested compiler; the repaired model is checked against the analytic dwell time rather than claiming a nonexistent numerical baseline match.
- Replaced ten legacy examples by exactly nine internally stimulated and connected models. All ordinary output paths directly connect results to ConsoleWriter.
- Redrew the Results package and all ten public Results blocks, including matching Icon/Diagram port geometry; removed protected internal connector placements from EvidenceMonitor.
- Replaced mixed-language copied-interface documentation with English contracts and added missing declaration descriptions. Preserved only two semantic library inheritance relations, Improvement/PairedDifference and ResponseDeadline/RepeatedResponse; writer leaves are independent.

Intentional interface semantics: early normal termination is explicitly INCOMPLETE in the new complete result; undemanded EventAssessment tasks are NOT_APPLICABLE, not successful. Existing RepeatedResponse numerical pairing remains unchanged. Sampled extrema never claim strict continuous maxima. Internal metadata expansion does not change legacy scalar mathematical definitions. Case-specific severity is not an accreditation grade.

Final metadata checks also separate received samples from valid samples and total observation from finite valid duration. Known temporal quantities default to seconds, circular errors to radians, and percentages retain their percentage label. Optional event counters have an explicit availability flag; unavailable counters are printed as N/A. The retained FIFO now calls the pure explicit-state AdvanceFIFO transition, shared with ResponseDeadline, to avoid initialization cycles introduced by observing additional metadata. Its pairing order, deadline convention and stored-delay mathematics are unchanged.

- Removed the redundant Requirements.Conjunction in favor of VerdictAggregator; the obsolete eleven-field relay could not preserve complete child metadata. Corrected occupancy-budget and step-baseline descriptions and documented retained specialist algorithms, availability and boundary conditions.

- Complete results now preserve each retained requirement decision, including UNDECIDED for undefined denominators, INVALID for nonfinite evidence and NOT_APPLICABLE for undemanded tasks. Metadata no longer recomputes SATISFIED from coverage alone. The original scalar algorithms and verdicts are unchanged.
