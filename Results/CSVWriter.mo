within EvaluationLibrary.Results;
block CSVWriter "Export one finalised metric set to CSV"
  extends EvaluationLibrary.Results.PartialWriter(
    final isCSV=true,final isConsole=false,final extension=".csv");
  annotation(Icon(coordinateSystem(extent={{-100,-100},{100,100}},
grid={2,2}),graphics = {Text(origin={2.5,-59},
lineColor={0,0,127},
extent={{-77.5,-21},{77.5,21}},
textString="CSV",
textColor={0,0,127})}),
    Documentation(info="<html><p>Writes a CSV header and qualified metric rows. Reports successful creation or overwrite only after the file has been closed and confirmed to exist; reports skipped files separately.</p></html>"));
end CSVWriter;