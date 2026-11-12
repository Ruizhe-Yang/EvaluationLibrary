within EvaluationLibrary.Utilities.Internal;
impure function WriteRows "Write one complete result set and report its outcome to the terminal"
  extends Modelica.Icons.Function;
  input String path "Output path; ignored for console output";
  input String runId;
  input EvaluationLibrary.Utilities.Types.MetricResult records[:];
  input EvaluationLibrary.Utilities.Types.WritePolicy writePolicy=EvaluationLibrary.Utilities.Types.WritePolicy.RejectExisting;
  input Boolean csv=false;
  input Boolean console=false;
  input String resultSetId="" "Identifier included in the audit message";
  input Modelica.Units.SI.Time simulationTime=0 "Simulation instant of export";
  input Boolean logToConsole=true "Log success or skip once per call";
  output Boolean written;
  output Boolean skippedExisting;
protected
  Boolean exists;
  Boolean logged;
  String target;
  String formatName;
  String action;
algorithm
  assert(console or Modelica.Utilities.Strings.length(path)>0,
    "WriteRows requires a non-empty destination path for file exports.");
  target:=if console then "" else path;
  formatName:=if csv then "CSV" elseif console then "console text" else "text";
  exists:=if console then false else Modelica.Utilities.Files.exist(path);
  skippedExisting:=exists and writePolicy==EvaluationLibrary.Utilities.Types.WritePolicy.RejectExisting;
  written:=false;

  if not skippedExisting then
    if exists then
      Modelica.Utilities.Files.removeFile(path);
    end if;
    if csv then
      Modelica.Utilities.Streams.print(
        "runId,metricId,requirementVersion,value,valueAvailable,unit,dataStatus,verdict,windowStart,windowStop,everViolated,firstViolationTime,message",target);
    end if;
    for i in 1:size(records,1) loop
      Modelica.Utilities.Streams.print(
        EvaluationLibrary.Utilities.Functions.FormatRow(runId,records[i],csv),target);
    end for;
    if not console then
      Modelica.Utilities.Streams.close(path);
      assert(Modelica.Utilities.Files.exist(path),
        "WriteRows could not confirm the requested output file: "+path);
    end if;
    written:=true;
  end if;

  if logToConsole then
    action:=if skippedExisting then "Export skipped: destination already exists"
      elseif console then "Console result set generated"
      elseif exists then "Result file overwritten" else "Result file created";
    logged:=EvaluationLibrary.Utilities.Internal.LogCompletion(
      action,formatName,
      if console then "terminal (stdout)" else Modelica.Utilities.Files.fullPathName(path),
      runId,resultSetId,size(records,1),simulationTime,
      if skippedExisting then "SKIPPED" else "SUCCESS");
  end if;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Polygon(points={{-31.28,-33.96},{-31.28,37.44},{16.32,37.44},{31.96,21.8},{31.96,-33.96},{-31.28,-33.96}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{16.32,37.44},{16.32,21.8},{31.96,21.8}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-20.4,15},{17.68,15}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-20.4,3.44},{20.4,3.44}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-20.4,-8.12},{11.56,-8.12}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-20.4,-19.68},{20.4,-19.68}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-44.2,1.4},{-15.64,1.4}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-65,-55},{65,-78}}, textString="write rows", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Write a whole result set once with an explicit file policy.</p><p><b>Interfaces</b> input String path; input String runId; input EvaluationLibrary.Utilities.Types.MetricResult records[:]; input EvaluationLibrary.Utilities.Types.WritePolicy writePolicy=EvaluationLibrary.Utilities.Types.WritePolicy.RejectExisting; input Boolean csv=false; input Boolean console=false; output Boolean written; output Boolean skippedExisting</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Write a whole result set once with an explicit file policy</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Outputs retain the units declared at the interface. Numerical values depend on the supplied input and parameter range.</p><p><b>Observables</b> written, skippedExisting</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.ResultAggregationAndFiles\">EvaluationLibrary.Examples.ResultAggregationAndFiles</a></p></html>"));
end WriteRows;
