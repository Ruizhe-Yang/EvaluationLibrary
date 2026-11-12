within EvaluationLibrary.Comparison;
block LabelPerformance "Accumulate sample-level binary classification counts and denominator flags"
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime;
  parameter Modelica.Units.SI.Time windowStart=0;
  parameter Modelica.Units.SI.Time windowStop=5;
  parameter Boolean applicable=true;
  parameter Boolean useValidInput=false;

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01;
  parameter Modelica.Units.SI.Time sampleStart=0;
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus;
  output EvaluationLibrary.Utilities.Types.Verdict verdict;
  output Boolean complete;
  output Boolean everViolated;
  output Modelica.Units.SI.Time firstViolationTime;
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));

    Modelica.Blocks.Interfaces.BooleanInput truth annotation(Placement(transformation(origin={-100,35},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,35},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput decision annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  output Integer TP(start=0,fixed=true);
  output Integer TN(start=0,fixed=true);
  output Integer FP(start=0,fixed=true);
  output Integer FN(start=0,fixed=true);
  output Real accuracy;
  output Real recall;
  output Real precision;
  output Real specificity;
  output Boolean accuracyAvailable;
  output Boolean recallAvailable;
  output Boolean precisionAvailable;
  output Boolean specificityAvailable;

  Modelica.Blocks.Interfaces.RealOutput value annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted annotation(Placement(transformation(origin={-100,-35},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-35},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=true,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable);
  Boolean dataOK;
  Boolean violationNow;

equation
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
        Rectangle(extent={{-51,-38},{51,52}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-51,7},{51,7}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{0,-38},{0,52}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-47,46},{-4,14}}, textString="TP", textColor={0,0,127}, fontSize=0),
        Text(extent={{4,46},{47,14}}, textString="FN", textColor={64,64,64}, fontSize=0),
        Text(extent={{-47,0},{-4,-31}}, textString="FP", textColor={64,64,64}, fontSize=0),
        Text(extent={{4,0},{47,-31}}, textString="TN", textColor={0,0,127}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="labels", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Accumulate sample-level binary classification counts and denominator flags.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput; Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle; output EvaluationLibrary.Utilities.Types.DataStatus dataStatus; output EvaluationLibrary.Utilities.Types.Verdict verdict; output Boolean complete; output Boolean everViolated; output Modelica.Units.SI.Time firstViolationTime; EvaluationLibrary.Utilities.Interfaces.MetricOutput result; Modelica.Blocks.Interfaces.BooleanInput truth; Modelica.Blocks.Interfaces.BooleanInput decision; output Integer TP(start=0,fixed=true); output Integer TN(start=0,fixed=true); output Integer FP(start=0,fixed=true); output Integer FN(start=0,fixed=true); output Real accuracy; output Real recall; output Real precision; output Real specificity; output Boolean accuracyAvailable; output Boolean recallAvailable; output Boolean precisionAvailable; output Boolean specificityAvailable; Modelica.Blocks.Interfaces.RealOutput value; Modelica.Blocks.Interfaces.BooleanOutput available</p><p><b>Parameters</b> parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime; parameter Modelica.Units.SI.Time windowStart=0; parameter Modelica.Units.SI.Time windowStop=5; parameter Boolean applicable=true; parameter Boolean useValidInput=false; parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01; parameter Modelica.Units.SI.Time sampleStart=0</p><p><b>Behavior</b> Accumulate sample-level binary classification counts and denominator flags</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> All denominators are counts of qualified grid samples, not independent episodes.</p><p><b>Observables</b> complete, everViolated, result, TP, TN, FP, FN, accuracy, recall, precision</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.ConsistencyAndLabels\">EvaluationLibrary.Examples.ConsistencyAndLabels</a></p></html>"));
end LabelPerformance;
