within EvaluationLibrary.Utilities.Internal;
impure function LogCompletion "Print one audit message when an output has been finalised"
  extends Modelica.Icons.Function;
  input String operation "Created, overwritten, skipped, or finalised artefact";
  input String outputType "CSV, text, console, in-memory table, or aggregate";
  input String destination "Absolute file path or non-file output location";
  input String runId="" "User-defined experiment identifier";
  input String resultSetId="" "Identifier of this result set";
  input Integer recordCount(min=0)=0 "Number of reported records";
  input Modelica.Units.SI.Time simulationTime=0 "Simulation time when finalised";
  input String status="SUCCESS" "SUCCESS or SKIPPED";
  output Boolean logged "Logged";
protected
  Integer ms "Ms";
  Integer sec "Sec";
  Integer minute "Minute";
  Integer hour "Hour";
  Integer day "Day";
  Integer month "Month";
  Integer year "Year";
  String timestamp "Timestamp";
algorithm
  (ms,sec,minute,hour,day,month,year):=Modelica.Utilities.System.getTime();
  timestamp:=String(year)+"-"+(if month<10 then "0" else "")+String(month)
    +"-"+(if day<10 then "0" else "")+String(day)
    +" "+(if hour<10 then "0" else "")+String(hour)
    +":"+(if minute<10 then "0" else "")+String(minute)
    +":"+(if sec<10 then "0" else "")+String(sec)
    +"."+(if ms<100 then "0" else "")+(if ms<10 then "0" else "")+String(ms);
  Modelica.Utilities.Streams.print(
    "[EvaluationLibrary]["+status+"] "+operation+"\n"
    +"  generated_at: "+timestamp+" (host local time)\n"
    +"  simulation_time: "+String(simulationTime,significantDigits=8)+" s\n"
    +"  output_type: "+outputType+"\n"
    +"  destination: "+destination+"\n"
    +"  run_id: "+runId+"\n"
    +"  result_set_id: "+resultSetId+"\n"
    +"  record_count: "+String(recordCount));
  logged:=true;
  annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Rectangle(extent={{-55.315,-29.573},{40.848,26.593}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-42.55,12.126},{-32.338,3.616},{-42.55,-4.894}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-24.679,-5.745},{7.659,-5.745}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-42.55,-17.659},{0.851,-17.659}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Ellipse(extent={{11.063,-57.656},{53.613,-15.106}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{32.338,-22.5523},{32.338,-36.381},{44.0393,-42.7635}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Text(extent={{-52.762,-47.444},{-6.808,-69.57}}, textString="log", textColor={108,88,49}, fontSize=0)
      }),
    Documentation(info="<html><p>Log completion. Inputs retain the physical units or logical meaning stated by their declarations. Domain assertions and explicit availability flags are part of the contract.</p></html>"));
end LogCompletion;
