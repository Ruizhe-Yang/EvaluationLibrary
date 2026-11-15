within EvaluationLibrary.Response;
block MovingAverage "Mean over a complete continuously valid trailing window"
  parameter String metricId=getInstanceName() "Stable identity of this retained specialist";
  parameter String requirementId="" "Requirement identity, when configured";
  parameter String requirementVersion="" "Interpreted requirement version";
  parameter String unitName="1" "Engineering unit of the reported specialist value";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Complete specialist result" annotation(Placement(transformation(extent={{90,80},{110,100}}),iconTransformation(extent={{90,80},{110,100}})));
  Boolean terminalSeen(start=false,fixed=true) "Terminal seen";
  discrete Boolean qualifiedViolation(start=false,fixed=true) "Qualified violation";
  discrete Real qualifiedViolationTime(start=0,fixed=true) "Qualified violation time";
  EvaluationLibrary.Utilities.Types.DataStatus resultStatus "Result status";
  parameter Modelica.Units.SI.Time length(min=Modelica.Constants.small) = 1 "Trailing window duration, s";
  parameter Modelica.Units.SI.Time coverageTolerance(min=0) = 1e-7 "Numerical integration tolerance, s";
  Modelica.Blocks.Interfaces.RealInput u "Signal" annotation(Placement(transformation(extent={{-106,18},{-94,30}}), iconTransformation(extent={{-106,18},{-94,30}})));
  Modelica.Blocks.Interfaces.BooleanInput valid "Input validity" annotation(Placement(transformation(extent={{-106,-30},{-94,-18}}), iconTransformation(extent={{-106,-30},{-94,-18}})));
  Modelica.Blocks.Interfaces.RealOutput mean "Trailing average, same unit as u" annotation(Placement(transformation(extent={{94,42},{106,54}}), iconTransformation(extent={{94,42},{106,54}})));
  Modelica.Blocks.Interfaces.BooleanOutput ready "A full valid duration is available" annotation(Placement(transformation(extent={{94,-6},{106,6}}), iconTransformation(extent={{94,-6},{106,6}})));
  Modelica.Blocks.Interfaces.RealOutput coveredDuration(unit="s") "Valid duration within the current window" annotation(Placement(transformation(extent={{94,-54},{106,-42}}), iconTransformation(extent={{94,-54},{106,-42}})));
protected
  Real integral(start=0,fixed=true) "Integral";
  Real duration(unit="s",start=0,fixed=true) "Duration";
  parameter Modelica.Units.SI.Time startTime(fixed=false) "First observation or stimulus time in seconds";
  Boolean dataOK "Data ok";
initial equation
  startTime = time;
  assert(length > 0 and coverageTolerance >= 0 and coverageTolerance < length, "Invalid moving window.");
equation
  when terminal() then terminalSeen=true; end when;
  resultStatus=if (if ready then EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE else EvaluationLibrary.Utilities.Types.DataStatus.PENDING)==EvaluationLibrary.Utilities.Types.DataStatus.PENDING and terminalSeen then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else (if ready then EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE else EvaluationLibrary.Utilities.Types.DataStatus.PENDING);
  when {initial(),false} then
    qualifiedViolation=pre(qualifiedViolation) or false;
    qualifiedViolationTime=if not pre(qualifiedViolation) and false then time else pre(qualifiedViolationTime);
  end when;
  result.metricId=metricId; result.requirementId=requirementId; result.requirementVersion=requirementVersion; result.unit=unitName;
  result.value=mean; result.valueAvailable=(ready) and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and resultStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(resultStatus);
  result.verdict=Integer(EvaluationLibrary.Utilities.Functions.ToVerdict(resultStatus,qualifiedViolation,false));
  result.complete=terminalSeen;
  result.windowStart=startTime; result.windowStop=time;
  result.observedDuration=0;
  result.validDuration=0;
  result.expectedSamples=0; result.receivedSamples=0; result.validSamples=0;
  result.everViolated=qualifiedViolation; result.firstViolationTime=qualifiedViolationTime;
  result.samplePeriod=0; result.evidenceKind=4;
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable)+"; retained specialist; no unsupplied duration or count inferred";
  result.eventCountsAvailable=false; result.eventCount=0; result.matchedCount=0; result.timedOutCount=0; result.censoredCount=0;
  result.levelAvailable=false; result.level=0; result.level0Upper=0; result.level1Upper=0;
  dataOK = valid and noEvent(abs(u) < Modelica.Constants.inf);
  der(integral) = if dataOK then u else 0;
  der(duration) = if dataOK then 1 else 0;
  coveredDuration = min(length,max(0,duration-delay(duration,length)));
  ready = dataOK and time >= startTime+length and noEvent(coveredDuration >= length-coverageTolerance);
  mean = if ready then (integral-delay(integral,length))/length else 0;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-7,-32},{64,54}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.35, radius=0),
        Line(points={{-66,5},{-56,29},{-44,-9},{-30,38},{-17,8},{-2,22},{12,-9},{25,41},{40,16},{53,28},{64,1}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{-7,17},{64,17}}, color={0,0,127}, thickness=1.4, pattern=LinePattern.Solid),
        Line(points={{64,-37},{64,61}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-7,-41},{64,-41}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Line(points={{-7,-46},{-7,-36}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{64,-46},{64,-36}}, color={64,64,64}, thickness=0.55, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="mean(T)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Use delayed integrals to form the mean over the trailing length seconds, default 1 s. coveredDuration is valid time inside that interval; ready requires the full history and current validity. coverageTolerance defaults to 1e-7 s, is nonnegative and must be smaller than length. An invalid gap removes readiness until complete valid trailing coverage is restored. This rolling statistic does not declare a safety threshold.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end MovingAverage;
