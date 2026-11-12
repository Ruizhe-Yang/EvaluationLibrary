within EvaluationLibrary.Comparison;
block PairedDifference "Compare two qualified results with an explicitly matched interpretation"
parameter String comparisonId="comparison";
  parameter String referenceComparisonId=comparisonId;
  parameter String candidateComparisonId=comparisonId;
  parameter String referenceUnit="1";
  parameter String candidateUnit=referenceUnit;
  parameter Real referenceStart=0;
  parameter Real candidateStart=referenceStart;
  parameter Real referenceStop=5;
  parameter Real candidateStop=referenceStop;
  parameter Real timeTolerance(min=0)=1e-9;

  EvaluationLibrary.Utilities.Interfaces.MetricInput reference annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Interfaces.MetricInput candidate annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Interfaces.RealOutput difference annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
  output Boolean metadataMatch;
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus;
initial equation
  assert(timeTolerance>=0 and referenceStop>referenceStart and candidateStop>candidateStart,"Invalid comparison windows or tolerance.");
equation
  metadataMatch=comparisonId<>"" and referenceComparisonId==comparisonId and candidateComparisonId==comparisonId
    and referenceUnit==candidateUnit and abs(referenceStart-candidateStart)<=timeTolerance
    and abs(referenceStop-candidateStop)<=timeTolerance;
  result.complete=reference.complete and candidate.complete;
  dataStatus=if not metadataMatch or reference.dataStatus==4 or candidate.dataStatus==4 then EvaluationLibrary.Utilities.Types.DataStatus.INVALID
    elseif reference.dataStatus==5 or candidate.dataStatus==5 then EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE
    elseif not result.complete then EvaluationLibrary.Utilities.Types.DataStatus.PENDING
    elseif reference.dataStatus==2 and candidate.dataStatus==2 and reference.valueAvailable and candidate.valueAvailable then EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE
    else EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE;
  available=dataStatus==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE;
  difference=if available then candidate.value-reference.value else 0;
  result.value=difference;
  result.valueAvailable=available;
  result.dataStatus=Integer(dataStatus);
  result.verdict=Integer(EvaluationLibrary.Utilities.Functions.ToVerdict(dataStatus,false,false));
  result.everViolated=false;
  result.firstViolationTime=0;
  result.validDuration=min(reference.validDuration,candidate.validDuration);
  result.expectedSamples=0;
  result.receivedSamples=0;
  result.validSamples=0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-59,16},{-15,43}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-59,-31},{-15,-4}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-15,30},{10,30},{33,7}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-15,-17},{10,-17},{33,7}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Ellipse(extent={{22,-12},{62,27}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{28,24},{55,-9}}, textString="−", textColor={0,0,127}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="paired Δ", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Compare two qualified results with an explicitly matched interpretation.</p><p><b>Interfaces</b> EvaluationLibrary.Utilities.Interfaces.MetricInput reference; EvaluationLibrary.Utilities.Interfaces.MetricInput candidate; EvaluationLibrary.Utilities.Interfaces.MetricOutput result; Modelica.Blocks.Interfaces.RealOutput difference; Modelica.Blocks.Interfaces.BooleanOutput available; output Boolean metadataMatch; output EvaluationLibrary.Utilities.Types.DataStatus dataStatus</p><p><b>Parameters</b> parameter String comparisonId=\"comparison\"; parameter String referenceComparisonId=comparisonId; parameter String candidateComparisonId=comparisonId; parameter String referenceUnit=\"1\"; parameter String candidateUnit=referenceUnit; parameter Real referenceStart=0; parameter Real candidateStart=referenceStart; parameter Real referenceStop=5; parameter Real candidateStop=referenceStop; parameter Real timeTolerance(min=0)=1e-9</p><p><b>Behavior</b> Compare two qualified results with an explicitly matched interpretation</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Metadata is supplied by the caller. Paired results do not establish causality.</p><p><b>Observables</b> result, difference, available, metadataMatch</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.PairedPerformance\">EvaluationLibrary.Examples.PairedPerformance</a></p></html>"));
end PairedDifference;
