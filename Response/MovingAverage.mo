within EvaluationLibrary.Response;
block MovingAverage "Compute a continuous mean over a trailing window"
  parameter String metricId=getInstanceName() "Identifier carried by the result";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Optional requirement version";
  parameter String unitName="1" "Unit label for the reported value";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Value, qualification and requirement outcome" annotation(Placement(transformation(extent={{90,80},{110,100}}),iconTransformation(extent={{90,80},{110,100}})));
  Boolean terminalSeen(start=false,fixed=true) "True after normal simulation termination";
  discrete Boolean qualifiedViolation(start=false,fixed=true) "Latched valid requirement violation";
  discrete Real qualifiedViolationTime(start=0,fixed=true) "Time of the first valid requirement violation";
  EvaluationLibrary.Utilities.Types.DataStatus resultStatus "Qualification of the reported result";
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
  Boolean dataOK "True if input validity and numerical checks pass";
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
    Documentation(info="<html><p>Computes the mean of <code>u</code> over the preceding <code>length</code> seconds using delayed integrals. <code>coveredDuration</code> reports the valid duration within that trailing interval. The mean has the same unit as the input.</p><p>Connect <code>valid</code> and wait for <code>ready</code>. Readiness requires a complete elapsed window, a valid current input and valid coverage within <code>coverageTolerance</code>. The output is zero while unavailable; an invalid gap prevents readiness until sufficient valid coverage returns.</p></html>"));
end MovingAverage;
