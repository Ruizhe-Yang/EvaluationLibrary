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
  output Boolean logged;
protected
  Integer ms;
  Integer sec;
  Integer minute;
  Integer hour;
  Integer day;
  Integer month;
  Integer year;
  String timestamp;
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
  annotation(Documentation(info="<html><p>Emit a single console audit message after an output action has completed. The timestamp is host local wall-clock time, while simulation_time is Modelica simulation time. This function never creates a log file.</p></html>"));
end LogCompletion;
