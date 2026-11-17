within EvaluationLibrary.Utilities.Internal;
impure function WriteRows "Write a result set to a file or the console"
  extends Modelica.Icons.Function;
  input String path "Output path; ignored for console output";
  input String runId "Stable run identity";
  input EvaluationLibrary.Utilities.Types.MetricResult records[:] "Result records to write";
  input EvaluationLibrary.Utilities.Types.WritePolicy writePolicy=EvaluationLibrary.Utilities.Types.WritePolicy.RejectExisting "Explicit existing-file replacement policy";
  input Boolean csv=false "Write CSV with a header instead of concise text";
  input Boolean console=false "Write to the terminal instead of a file";
  input String resultSetId="" "Identifier included in the audit message";
  input Modelica.Units.SI.Time simulationTime=0 "Simulation instant of export";
  input Boolean logToConsole=true "Log success or skip once per call";
  output Boolean written "The result set was written successfully";
  output Boolean skippedExisting "An existing destination was preserved";
protected
  Boolean exists "The destination file already exists";
  Boolean logged "The output-operation message was printed";
  String target "Output destination; empty for the terminal";
  String formatName "Human-readable output format";
  String action "Description of the completed or skipped operation";
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
        "runId,metricId,requirementId,requirementVersion,value,valueAvailable,dataStatus,verdict,unit,windowStart,windowStop,observedDuration,validDuration,expectedSamples,receivedSamples,validSamples,everViolated,firstViolationTime,samplePeriod,evidenceKind,message,complete,eventCountsAvailable,eventCount,matchedCount,timedOutCount,censoredCount,levelAvailable,level,level0Upper,level1Upper",target);
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
        Rectangle(extent={{-56.5915,-22.765},{-25.1045,24.891}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-56.5915,-6.8796},{-25.1045,-6.8796}}, color={64,64,64}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-56.5915,9.0056},{-25.1045,9.0056}}, color={64,64,64}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-40.848,-22.765},{-40.848,24.891}}, color={64,64,64}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-22.126,1.063},{0,1.063}}, color={64,64,64}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Polygon(points={{6.3825,-29.9985},{53.1875,-29.9985},{53.1875,17.6575},{40.4225,30.4225},{6.3825,30.4225},{6.3825,-29.9985}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{40.4225,30.4225},{40.4225,17.6575},{53.1875,17.6575}}, color={64,64,64}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{14.0415,9.1475},{45.5285,9.1475}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{14.0415,-6.596},{45.5285,-6.596}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{14.0415,-22.3395},{45.5285,-22.3395}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{29.785,-32.126},{29.785,-53.401}}, color={108,88,49}, thickness=1.1, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{7.659,-58.507},{51.911,-58.507}}, color={108,88,49}, thickness=1.2, pattern=LinePattern.Solid),
        Text(extent={{-55.315,-49.146},{-10.212,-72.123}}, textString="I/O", textColor={108,88,49}, fontSize=0)
      }),
    Documentation(info="<html><p>Write every supplied result as CSV or concise text using <code>Functions.FormatRow</code>. CSV output includes a header. <code>console=true</code> sends the output to the terminal and ignores <code>path</code>.</p><p>For file output, <code>RejectExisting</code> leaves an existing destination unchanged and returns <code>skippedExisting=true</code>; <code>Overwrite</code> removes it before writing. <code>written</code> reports completion. Optional console logging describes the outcome. File errors may stop the simulation; this function does not change result verdicts.</p></html>"));
end WriteRows;
