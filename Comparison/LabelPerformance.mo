within EvaluationLibrary.Comparison;
block LabelPerformance "Sampled binary classification counts and performance ratios"
  parameter String metricId=getInstanceName() "Metric identifier";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Requirement version";
  parameter String unitName="1" "Engineering unit of the reported value";
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime "Fixed interval or first contiguous external window";
  parameter Modelica.Units.SI.Time windowStart=0 "Inclusive observation start";
  parameter Modelica.Units.SI.Time windowStop=5 "Exclusive observation stop";
  parameter Boolean applicable=true "Whether this evaluation applies";
  parameter Boolean useValidInput=false "Enable the external validity input";

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Uniform sampling interval; must be positive";
  parameter Modelica.Units.SI.Time sampleStart=0 "Origin of the uniform sampling grid";
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "External input-validity condition" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle "External observation gate; only the first contiguous interval is accepted" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus "Status of the observation data";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement verdict";
  output Boolean complete "True when collection has closed; check data status for completeness";
  output Boolean everViolated "True if a valid violation has been observed";
  output Modelica.Units.SI.Time firstViolationTime "First valid violation time; meaningful when everViolated is true";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Result record with value, status and observation metadata" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));

    Modelica.Blocks.Interfaces.BooleanInput truth "Reference binary label" annotation(Placement(transformation(origin={-100,35},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,35},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput decision "Predicted binary label" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  output Integer TP(start=0,fixed=true) "True positive sample count";
  output Integer TN(start=0,fixed=true) "True negative sample count";
  output Integer FP(start=0,fixed=true) "False positive sample count";
  output Integer FN(start=0,fixed=true) "False negative sample count";
  output Real accuracy "Correctly labelled fraction; see accuracyAvailable";
  output Real recall "TP divided by TP+FN; see recallAvailable";
  output Real precision "TP divided by TP+FP; see precisionAvailable";
  output Real specificity "TN divided by TN+FP; see specificityAvailable";
  output Boolean accuracyAvailable "True when accuracy is defined and data are not invalid";
  output Boolean recallAvailable "True when recall is defined and data are not invalid";
  output Boolean precisionAvailable "True when precision is defined and data are not invalid";
  output Boolean specificityAvailable "True when specificity is defined and data are not invalid";

  Modelica.Blocks.Interfaces.RealOutput value "Numerical value; check result.valueAvailable" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True when the numerical value is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Interfaces.MetricOutput y[8] "TP, TN, FP, FN, accuracy, precision, recall and specificity as complete results" annotation(Placement(transformation(extent={{90,-40},{110,-20}}),iconTransformation(extent={{90,-40},{110,-20}})));

protected
  constant String labels[8]={"TP","TN","FP","FN","accuracy","precision","recall","specificity"} "Names of the eight reported measures";
  Real metrics[8] "Values of the eight reported measures";
  Boolean denominators[8] "Numerical availability of each reported measure";
  Modelica.Blocks.Interfaces.BooleanInput trusted "Internal validity signal" annotation(Placement(transformation(origin={-100,-35},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-35},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "Internal external-window signal" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=true,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Observation-window qualification";
  Boolean dataOK "Combined input validity";
  Boolean violationNow "Current valid violation condition";

equation
  metrics={TP,TN,FP,FN,accuracy,precision,recall,specificity};
  denominators={gate.validSamples>0,gate.validSamples>0,gate.validSamples>0,gate.validSamples>0,accuracyAvailable,precisionAvailable,recallAvailable,specificityAvailable};
  for j in 1:8 loop
    y[j].metricId=metricId+"."+labels[j];
    y[j].requirementId=requirementId; y[j].requirementVersion=requirementVersion; y[j].unit="1";
    y[j].value=metrics[j];
    y[j].valueAvailable=denominators[j] and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID;
    y[j].dataStatus=if dataStatus==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE and not y[j].valueAvailable then 3 else Integer(dataStatus);
    y[j].verdict=Integer(EvaluationLibrary.Utilities.Functions.ToVerdict(EvaluationLibrary.Utilities.Functions.StatusFromCode(y[j].dataStatus),false,false));
    y[j].windowStart=gate.actualStart; y[j].windowStop=gate.actualStop; y[j].observedDuration=gate.observedDuration; y[j].validDuration=gate.validDuration;
    y[j].expectedSamples=gate.expectedSamples; y[j].receivedSamples=gate.receivedSamples; y[j].validSamples=gate.validSamples;
    y[j].everViolated=false; y[j].firstViolationTime=0; y[j].samplePeriod=samplePeriod; y[j].evidenceKind=2; y[j].complete=complete;
    y[j].message=if not y[j].valueAvailable and dataStatus==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then "Metric denominator is zero; no ratio is defined" else EvaluationLibrary.Utilities.Functions.EvidenceMessage(y[j].dataStatus,y[j].verdict,y[j].valueAvailable);
    y[j].eventCountsAvailable=false; y[j].eventCount=0; y[j].matchedCount=0; y[j].timedOutCount=0; y[j].censoredCount=0; y[j].levelAvailable=false; y[j].level=0; y[j].level0Upper=0; y[j].level1Upper=0;
  end for;
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=false;
  violationNow=(if true then gate.sampleInWindow else gate.inWindow) and dataOK and (false);
  when {initial(),violationNow} then
    everViolated=(not initial() and pre(everViolated)) or violationNow;
    firstViolationTime=if violationNow and (initial() or not pre(everViolated)) then time
      else if initial() then 0 else pre(firstViolationTime);
  end when;
  dataStatus=gate.status;
  verdict=EvaluationLibrary.Utilities.Functions.ToVerdict(dataStatus,everViolated,false);
  complete=gate.complete;
  result.value=value;
  result.valueAvailable=available and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(dataStatus);
  result.verdict=Integer(verdict);
  result.everViolated=everViolated;
  result.firstViolationTime=firstViolationTime;
  result.validDuration=gate.validDuration;
  result.expectedSamples=gate.expectedSamples;
  result.receivedSamples=gate.receivedSamples;
  result.validSamples=gate.validSamples;
  result.metricId=metricId;
  result.requirementId=requirementId;
  result.requirementVersion=requirementVersion;
  result.unit=unitName;
  result.windowStart=gate.actualStart;
  result.windowStop=gate.actualStop;
  result.observedDuration=gate.observedDuration;
  result.samplePeriod=if gate.sampled then samplePeriod else 0;
  result.evidenceKind=Integer(EvaluationLibrary.Utilities.Types.EvidenceKind.Sampled);
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable);
  result.eventCountsAvailable=false; result.eventCount=0;
  result.matchedCount=0;
  result.timedOutCount=0;
  result.censoredCount=0;
  result.levelAvailable=false;
  result.level=0;
  result.level0Upper=0;
  result.level1Upper=0;
  result.complete=complete;

  accuracyAvailable=TP+TN+FP+FN>0 and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID;
  recallAvailable=TP+FN>0 and accuracyAvailable;
  precisionAvailable=TP+FP>0 and accuracyAvailable;
  specificityAvailable=TN+FP>0 and accuracyAvailable;
  accuracy=if accuracyAvailable then (TP+TN)/(TP+TN+FP+FN) else 0;
  recall=if recallAvailable then TP/(TP+FN) else 0;
  precision=if precisionAvailable then TP/(TP+FP) else 0;
  specificity=if specificityAvailable then TN/(TN+FP) else 0;
  value=accuracy;
  available=accuracyAvailable;
algorithm

  when gate.tick and gate.sampleInWindow and dataOK then
    TP:=pre(TP)+(if truth and decision then 1 else 0);
    TN:=pre(TN)+(if not truth and not decision then 1 else 0);
    FP:=pre(FP)+(if not truth and decision then 1 else 0);
    FN:=pre(FN)+(if truth and not decision then 1 else 0);
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-52,-33},{52,56}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.6, radius=0),
        Rectangle(extent={{-52,11},{0,56}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4, radius=0),
        Rectangle(extent={{0,-33},{52,11}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4, radius=0),
        Line(points={{-52,11},{52,11}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{0,-33},{0,56}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-49,49},{-4,19}}, textString="TP", textColor={0,0,127}, fontSize=0),
        Text(extent={{4,49},{49,19}}, textString="FN", textColor={64,64,64}, fontSize=0),
        Text(extent={{-49,4},{-4,-26}}, textString="FP", textColor={64,64,64}, fontSize=0),
        Text(extent={{4,4},{49,-26}}, textString="TN", textColor={0,0,127}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="TP TN FP FN", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Counts <code>truth</code> and <code>decision</code> pairs as true positives, true negatives, false positives and false negatives. <code>y[1:8]</code> reports these four counts followed by accuracy, precision, recall and specificity. The scalar <code>result</code> reports accuracy.</p><p>Each ratio has its own denominator check. A zero denominator leaves that ratio unavailable without discarding the valid counts. Configure the observation window and uniform sample grid, and optionally connect <code>valid</code>. The block measures classification performance without imposing an acceptance threshold.</p></html>"));
end LabelPerformance;
