within EvaluationLibrary.UsersGuide;
class GettingStarted "Load Modelica 4.0.0, then load this package and open an Example."
  extends Modelica.Icons.Information;
  annotation(Documentation(info="<html><p>Load the library and run MultiSignalAssessment with its declared experiment. For a host, connect observed signals to SignalAssessment.u, declare each channel interpretation and bounds, then connect the complete y array to ConsoleWriter.u. Use EventAssessment for separately observed requests and actual feedback. Configure identities and units once, at producers. No result-field equations or output relay blocks are needed.</p></html>"));
end GettingStarted;
