within EvaluationLibrary.Response;
block EventIntervals "Successive qualified event intervals"
  parameter String metricId=getInstanceName() "Stable identity of this retained specialist";
  parameter String requirementId="" "Requirement identity, when configured";
  parameter String requirementVersion="" "Interpreted requirement version";
  parameter String unitName="s" "Engineering unit of the reported specialist value";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Complete specialist result" annotation(Placement(transformation(extent={{90,80},{110,100}}),iconTransformation(extent={{90,80},{110,100}})));
  Boolean terminalSeen(start=false,fixed=true) "Terminal seen";
  discrete Boolean qualifiedViolation(start=false,fixed=true) "Qualified violation";
  discrete Real qualifiedViolationTime(start=0,fixed=true) "Qualified violation time";
  EvaluationLibrary.Utilities.Types.DataStatus resultStatus "Result status";
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  Modelica.Blocks.Interfaces.BooleanInput valid "Host-provided input validity" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,76},{106,88}}), iconTransformation(extent={{94,76},{106,88}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,43},{106,55}}), iconTransformation(extent={{94,43},{106,55}})));
  Modelica.Blocks.Interfaces.BooleanInput eventSignal "An event is a rising edge" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.IntegerOutput count(start=0,fixed=true) "Events observed in the window" annotation(Placement(transformation(extent={{94,10},{106,22}}), iconTransformation(extent={{94,10},{106,22}})));
  Modelica.Blocks.Interfaces.RealOutput lastInterval(unit="s",start=0,fixed=true) "Most recent complete interval" annotation(Placement(transformation(extent={{94,-22},{106,-10}}), iconTransformation(extent={{94,-22},{106,-10}})));
  Modelica.Blocks.Interfaces.RealOutput minInterval(unit="s",start=0,fixed=true) "Shortest complete interval" annotation(Placement(transformation(extent={{94,-55},{106,-43}}), iconTransformation(extent={{94,-55},{106,-43}})));
  Modelica.Blocks.Interfaces.BooleanOutput intervalDefined "At least two events have occurred" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable) "Evidence";
  Boolean dataOK "Validity combined with the metric data domain";
  discrete Modelica.Units.SI.Time lastTime(start=0,fixed=true) "Last time";
equation
  when terminal() then terminalSeen=true; end when;
  resultStatus=if (dataState)==EvaluationLibrary.Utilities.Types.DataStatus.PENDING and terminalSeen then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else (dataState);
  when {initial(),false} then
    qualifiedViolation=pre(qualifiedViolation) or false;
    qualifiedViolationTime=if not pre(qualifiedViolation) and false then time else pre(qualifiedViolationTime);
  end when;
  result.metricId=metricId; result.requirementId=requirementId; result.requirementVersion=requirementVersion; result.unit=unitName;
  result.value=lastInterval; result.valueAvailable=(intervalDefined) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(resultStatus);
  result.verdict=Integer(EvaluationLibrary.Utilities.Functions.ToVerdict(resultStatus,qualifiedViolation,false));
  result.complete=time>=windowEnd or terminalSeen;
  result.windowStart=windowStart; result.windowStop=windowEnd;
  result.observedDuration=evidence.totalObservedDuration;
  result.validDuration=observedDuration;
  result.expectedSamples=0; result.receivedSamples=0; result.validSamples=0;
  result.everViolated=qualifiedViolation; result.firstViolationTime=qualifiedViolationTime;
  result.samplePeriod=0; result.evidenceKind=1;
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable)+"; retained specialist; no unsupplied duration or count inferred";
  result.eventCountsAvailable=false; result.eventCount=0; result.matchedCount=0; result.timedOutCount=0; result.censoredCount=0;
  result.levelAvailable=false; result.level=0; result.level0Upper=0; result.level1Upper=0;
  evidence.dataOK = dataOK;
  dataState = evidence.dataState;
  inWindow = evidence.inWindow;
  observedDuration = evidence.observedDuration;
  dataOK = valid;
  when {initial(),eventSignal} then
    if not initial() and inWindow and dataOK then
      count = pre(count)+1;
      lastInterval = if pre(count)>0 then time-pre(lastTime) else 0;
      minInterval = if pre(count)==1 then lastInterval elseif pre(count)>1 then min(pre(minInterval),lastInterval) else 0;
      lastTime = time;
    else
      count = pre(count);
      lastInterval = pre(lastInterval);
      minInterval = pre(minInterval);
      lastTime = pre(lastTime);
    end if;
  end when;
  intervalDefined = count > 1;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,-18},{64,-18}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-49,-22},{-49,44}}, color={0,0,127}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{-4,-22},{-4,44}}, color={0,0,127}, thickness=1.2, pattern=LinePattern.Solid),
        Line(points={{55,-22},{55,44}}, color={0,0,127}, thickness=1.2, pattern=LinePattern.Solid),
        Ellipse(extent={{-51.5,41.5},{-46.5,46.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{-6.5,41.5},{-1.5,46.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{52.5,41.5},{57.5,46.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Line(points={{-49,11},{-4,11}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-49,6},{-49,16}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-4,6},{-4,16}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-4,-34},{55,-34}}, color={0,0,127}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-4,-39},{-4,-29}}, color={0,0,127}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{55,-39},{55,-29}}, color={0,0,127}, thickness=0.55, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="dt, min(dt)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Count qualified rising eventSignal edges after initialization. lastInterval is the latest interarrival time and minInterval is the smallest observed interarrival time, both in seconds. At least two observed events are needed for intervalDefined; a true initial condition is not an event in this retained metric.</p><p>The fixed observation defaults to [0,5) s. valid is host-provided and false validity or a failed numeric-domain check inside the window latches INVALID. Positive valid duration is needed for duration-normalized values. A normal stop before full observation gives an INCOMPLETE complete result; DataStatus and Verdict remain separate.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end EventIntervals;
