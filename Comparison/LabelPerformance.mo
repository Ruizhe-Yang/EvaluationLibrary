within EvaluationLibrary.Comparison;
block LabelPerformance "Accumulate sample-level binary classification counts and denominator flags"
  parameter String metricId=getInstanceName() "Stable metric identity";
  parameter String requirementId="" "Requirement identity; empty for a statistic";
  parameter String requirementVersion="" "Interpreted requirement version";
  parameter String unitName="1" "Engineering unit of the reported value";
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime "Fixed-time or first externally gated observation window";
  parameter Modelica.Units.SI.Time windowStart=0 "Inclusive observation start in seconds";
  parameter Modelica.Units.SI.Time windowStop=5 "Exclusive observation stop in seconds";
  parameter Boolean applicable=true "Whether this evaluation applies";
  parameter Boolean useValidInput=false "Expose the host-provided validity connector";

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Positive uniform sampling interval in seconds";
  parameter Modelica.Units.SI.Time sampleStart=0 "Uniform sample grid origin in seconds";
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "Host declares the observed inputs valid" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle "External observation gate; only the first contiguous interval is accepted" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus "Evidence qualification independent of requirement verdict";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement decision independent of observation completeness";
  output Boolean complete "Collection has closed; inspect DataStatus before assuming full evidence";
  output Boolean everViolated "A qualified violation witness exists";
  output Modelica.Units.SI.Time firstViolationTime "First qualified violation instant; meaningful only when everViolated";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Complete directly reportable evidence result" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));

    Modelica.Blocks.Interfaces.BooleanInput truth "Truth" annotation(Placement(transformation(origin={-100,35},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,35},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput decision "Decision" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  output Integer TP(start=0,fixed=true) "True positive sample count";
  output Integer TN(start=0,fixed=true) "True negative sample count";
  output Integer FP(start=0,fixed=true) "False positive sample count";
  output Integer FN(start=0,fixed=true) "False negative sample count";
  output Real accuracy "Correctly labelled fraction; see accuracyAvailable";
  output Real recall "TP divided by TP+FN; see recallAvailable";
  output Real precision "TP divided by TP+FP; see precisionAvailable";
  output Real specificity "TN divided by TN+FP; see specificityAvailable";
  output Boolean accuracyAvailable "Accuracy available";
  output Boolean recallAvailable "Recall available";
  output Boolean precisionAvailable "Precision available";
  output Boolean specificityAvailable "Specificity available";

  Modelica.Blocks.Interfaces.RealOutput value "Numerical metric; meaningful only when available" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "The numerical output exists in the current data domain" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Interfaces.MetricOutput y[8] "TP, TN, FP, FN, accuracy, precision, recall and specificity as complete results" annotation(Placement(transformation(extent={{90,-40},{110,-20}}),iconTransformation(extent={{90,-40},{110,-20}})));

protected
  constant String labels[8]={"TP","TN","FP","FN","accuracy","precision","recall","specificity"} "Labels";
  Real metrics[8] "Metrics";
  Boolean denominators[8] "Denominators";
  Modelica.Blocks.Interfaces.BooleanInput trusted "Trusted" annotation(Placement(transformation(origin={-100,-35},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-35},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "External window" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=true,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Gate";
  Boolean dataOK "Data ok";
  Boolean violationNow "Violation now";

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
    Documentation(info="<html><p>At each declared tick count truth/decision pairs as TP, TN, FP or FN. y contains these four dimensionless counts followed by accuracy, precision, recall and specificity; the scalar result remains accuracy. Each ratio has its own denominator availability. A zero denominator is unavailable and unresolved, while a valid count can still be reported. This evaluator does not infer a classification acceptance threshold.</p><p>The default fixed observation is [0,5) s. ExternalSingle instead observes only the first contiguous external gate; a later gate invalidates the history. useValidInput defaults to false; when enabled, false validity or nonfinite in-window data latch INVALID. Early normal termination or missing coverage is INCOMPLETE. DataStatus qualifies evidence independently of Verdict. Numeric availability and violation witnesses must be inspected separately. Stable identity, unitName and optional requirement metadata originate here and travel directly with result to a writer.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end LabelPerformance;
