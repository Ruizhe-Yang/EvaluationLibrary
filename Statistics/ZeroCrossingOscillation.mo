within EvaluationLibrary.Statistics;
block ZeroCrossingOscillation "Qualified zero crossings and estimated oscillation period"
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
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s") "Accumulated valid duration" annotation(Placement(transformation(extent={{94,35},{106,47}}), iconTransformation(extent={{94,35},{106,47}})));
  parameter Real level = 0 "Reference level in the signal unit";
  Modelica.Blocks.Interfaces.RealInput u "Observed waveform" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.IntegerOutput crossings(start=0,fixed=true) "Observed upward crossings" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput meanPeriod(unit="s") "First-to-last span divided by complete cycles" annotation(Placement(transformation(extent={{94,-47},{106,-35}}), iconTransformation(extent={{94,-47},{106,-35}})));
  Modelica.Blocks.Interfaces.BooleanOutput defined "At least one complete observed cycle" annotation(Placement(transformation(extent={{94,-88},{106,-76}}), iconTransformation(extent={{94,-88},{106,-76}})));
  output Modelica.Units.SI.Time firstCrossing(start=0,fixed=true) "First crossing";
  output Modelica.Units.SI.Time lastCrossing(start=0,fixed=true) "Last crossing";
protected
  EvaluationLibrary.Utilities.Internal.ContinuousEvidence evidence(windowStart=windowStart,windowEnd=windowEnd,applicable=applicable) "Evidence";
  Boolean dataOK "Validity combined with the metric data domain";
  Boolean high "High";
equation
  when terminal() then terminalSeen=true; end when;
  resultStatus=if (dataState)==EvaluationLibrary.Utilities.Types.DataStatus.PENDING and terminalSeen then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else (dataState);
  when {initial(),false} then
    qualifiedViolation=pre(qualifiedViolation) or false;
    qualifiedViolationTime=if not pre(qualifiedViolation) and false then time else pre(qualifiedViolationTime);
  end when;
  result.metricId=metricId; result.requirementId=requirementId; result.requirementVersion=requirementVersion; result.unit=unitName;
  result.value=meanPeriod; result.valueAvailable=(defined) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
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
  dataOK = valid and noEvent(abs(u) < Modelica.Constants.inf);
  high = u > level;
  when {initial(),high} then
    if not initial() and inWindow and dataOK then
      crossings = pre(crossings)+1;
      firstCrossing = if pre(crossings)==0 then time else pre(firstCrossing);
      lastCrossing = time;
    else
      crossings = pre(crossings);
      firstCrossing = pre(firstCrossing);
      lastCrossing = pre(lastCrossing);
    end if;
  end when;
  defined = crossings >= 2 and dataState <> EvaluationLibrary.Utilities.Types.DataStatus.INVALID;
  meanPeriod = if defined then (lastCrossing-firstCrossing)/(crossings-1) else 0;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-63,0},{65,0}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-56,-18.1898},{-54.8,-15.0522},{-53.6,-11.5863},{-52.4,-7.86752},{-51.2,-3.97715},{-50,0},{-48.8,3.97715},{-47.6,7.86752},{-46.4,11.5863},{-45.2,15.0522},{-44,18.1898},{-42.8,20.9305},{-41.6,23.2146},{-40.4,24.9922},{-39.2,26.2246},{-38,26.8848},{-36.8,26.9585},{-35.6,26.4441},{-34.4,25.3527},{-33.2,23.7082},{-32,21.5465},{-30.8,18.9147},{-29.6,15.8702},{-28.4,12.4795},{-27.2,8.81655},{-26,4.96124},{-24.8,0.99769},{-23.6,-2.98762},{-22.4,-6.90775},{-21.2,-10.6772},{-20,-14.2137},{-18.8,-17.4401},{-17.6,-20.286},{-16.4,-22.6893},{-15.2,-24.5976},{-14,-25.9693},{-12.8,-26.7744},{-11.6,-26.9954},{-10.4,-26.6274},{-9.2,-25.6785},{-8,-24.1694},{-6.8,-22.133},{-5.6,-19.6137},{-4.4,-16.6665},{-3.2,-13.3557},{-2,-9.75352},{-0.8,-5.93855},{0.4,-1.99402},{1.6,1.99402},{2.8,5.93855},{4,9.75352},{5.2,13.3557},{6.4,16.6665},{7.6,19.6137},{8.8,22.133},{10,24.1694},{11.2,25.6785},{12.4,26.6274},{13.6,26.9954},{14.8,26.7744},{16,25.9693},{17.2,24.5976},{18.4,22.6893},{19.6,20.286},{20.8,17.4401},{22,14.2137},{23.2,10.6772},{24.4,6.90775},{25.6,2.98762},{26.8,-0.99769},{28,-4.96124},{29.2,-8.81655},{30.4,-12.4795},{31.6,-15.8702},{32.8,-18.9147},{34,-21.5465},{35.2,-23.7082},{36.4,-25.3527},{37.6,-26.4441},{38.8,-26.9585},{40,-26.8848},{41.2,-26.2246},{42.4,-24.9922},{43.6,-23.2146},{44.8,-20.9305},{46,-18.1898},{47.2,-15.0522},{48.4,-11.5863},{49.6,-7.86752},{50.8,-3.97715},{52,-1.32262e-14},{53.2,3.97715},{54.4,7.86752},{55.6,11.5863},{56.8,15.0522},{58,18.1898}}, color={0,0,127}, thickness=0.95, pattern=LinePattern.Solid),
        Line(points={{-50,-35},{-50,44}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Line(points={{1,-35},{1,44}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dot),
        Line(points={{-50,48},{1,48}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-37,74},{-11,52}}, textString="T", textColor={64,64,64}, fontSize=0),
        Ellipse(extent={{-53.4,-3.4},{-46.6,3.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{-2.4,-3.4},{4.4,3.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{48.6,-3.4},{55.4,3.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Text(extent={{-65,-50},{65,-75}}, textString="N↑, period", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Observe rising crossings of u above level, whose default is zero in the input unit. Initial truth is not counted as a crossing. At least two accepted crossings are required; meanPeriod is the first-to-last span divided by crossings minus one, in seconds. Nonperiodic signals still yield only this finite observed estimate.</p><p>The fixed observation defaults to [0,5) s. valid is host-provided and false validity or a failed numeric-domain check inside the window latches INVALID. Positive valid duration is needed for duration-normalized values. A normal stop before full observation gives an INCOMPLETE complete result; DataStatus and Verdict remain separate.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end ZeroCrossingOscillation;
