within EvaluationLibrary.Results;
block TextWriter "Export one finalised metric set as readable text"
  extends EvaluationLibrary.Results.PartialWriter(
    final isCSV=false,final isConsole=false,final extension=".txt");
  annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}},
grid={2,2}),graphics = {Text(origin={0,-58},
lineColor={0,0,127},
extent={{-75,20},{75,-20}},
textString="TXT",
textColor={0,0,127})}),
    Documentation(info="<html><p>Writes a plain-text result file once and reports its creation, overwrite or skip to the terminal.</p></html>"));
end TextWriter;