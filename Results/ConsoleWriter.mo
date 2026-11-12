within EvaluationLibrary.Results;
block ConsoleWriter "Print finalised metric rows to the terminal"
  extends EvaluationLibrary.Results.PartialWriter(
    final isCSV=false,final isConsole=true,final extension="");
  annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}},
grid={2,2}),graphics = {Text(origin={0,-58},
lineColor={0,0,127},
extent={{-75,20},{75,-20}},
textString="LOG",
textColor={0,0,127})}),
    Documentation(info="<html><p>Prints the result rows to standard output and logs a single completion message with terminal (stdout) as the destination. Does not generate a file.</p></html>"));
end ConsoleWriter;