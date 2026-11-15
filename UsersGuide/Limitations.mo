within EvaluationLibrary.UsersGuide;
class Limitations "Use only within the component assumptions and the documented evidence coverage."
  extends Modelica.Icons.Information;
  annotation(Documentation(info="<html><p>Finite samples are not strict continuous extrema; finite candidates are not global worst-case proofs or probabilities. Levels 0/1/2 are engineering categories. Event queues are bounded and overflow invalidates evidence. Only the first externally gated window is accepted by retained gate-based metrics. A file output error may stop a simulation without changing the computed verdict. OpenModelica 1.27.1 command-line execution was tested; OpenModelica 1.25.x and MWorks runtime execution remain unverified.</p></html>"));
end Limitations;
