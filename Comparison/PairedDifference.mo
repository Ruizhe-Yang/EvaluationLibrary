within EvaluationLibrary.Comparison;
block PairedDifference "Signed difference between comparable completed results"
parameter String comparisonId="comparison" "Stable identity of the comparison interpretation";
  parameter String referenceComparisonId=comparisonId "Declared reference comparison identity";
  parameter String candidateComparisonId=comparisonId "Declared candidate comparison identity";
  parameter String referenceUnit="1" "Declared reference engineering unit";
  parameter String candidateUnit=referenceUnit "Declared candidate engineering unit";
  parameter Real referenceStart=0 "Inclusive declared reference observation start";
  parameter Real candidateStart=referenceStart "Inclusive declared candidate observation start";
  parameter Real referenceStop=5 "Exclusive declared reference observation stop";
  parameter Real candidateStop=referenceStop "Exclusive declared candidate observation stop";
  parameter Real timeTolerance(min=0)=1e-9 "Non-negative allowance when matching observation bounds";

  EvaluationLibrary.Utilities.Interfaces.MetricInput reference "Reference result record" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Interfaces.MetricInput candidate "Candidate result record" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Result record with value, status and observation metadata" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Interfaces.RealOutput difference "Candidate value minus reference value" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True when the numerical value is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
  output Boolean metadataMatch "True when the paired metadata agree";
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus "Status of the observation data";
initial equation
  assert(timeTolerance>=0 and referenceStop>referenceStart and candidateStop>candidateStart,"Invalid comparison windows or tolerance.");
equation
  result.metricId=comparisonId;
  result.requirementId="";
  result.requirementVersion="";
  result.unit=candidate.unit;
  result.windowStart=reference.windowStart;
  result.windowStop=reference.windowStop;
  result.observedDuration=min(reference.observedDuration,candidate.observedDuration);
  result.samplePeriod=max(reference.samplePeriod,candidate.samplePeriod);
  result.evidenceKind=4;
  result.message=if metadataMatch then "Matched qualified paired difference" else "Comparison identity, unit or window mismatch";
  result.eventCountsAvailable=false; result.eventCount=0; result.matchedCount=0; result.timedOutCount=0; result.censoredCount=0;
  result.levelAvailable=false; result.level=0; result.level0Upper=0; result.level1Upper=0;
  metadataMatch=comparisonId<>"" and referenceComparisonId==comparisonId and candidateComparisonId==comparisonId
    and reference.unit==candidate.unit and abs(reference.windowStart-candidate.windowStart)<=timeTolerance and abs(reference.windowStop-candidate.windowStop)<=timeTolerance and referenceUnit==candidateUnit and abs(referenceStart-candidateStart)<=timeTolerance
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
        Rectangle(extent={{-65,24},{-18,56}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-65,-32},{-18,0}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.6, radius=0),
        Text(extent={{-62,52},{-21,28}}, textString="ref", textColor={128,128,128}, fontSize=0),
        Text(extent={{-64,-3},{-19,-29}}, textString="cand", textColor={0,0,127}, fontSize=0),
        Line(points={{-11,-35},{-5,-35},{-5,59},{-11,59}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-18,40},{16,40},{30,20}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{-18,-16},{16,-16},{30,4}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Ellipse(extent={{23,-6},{57,30}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.65),
        Line(points={{31,12},{49,12}}, color={64,64,64}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{57,12},{71,12}}, color={64,64,64}, thickness=0.75, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="cand - ref", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Computes <code>candidate.value - reference.value</code> when both results are complete and available. Comparison identifiers, declared units and declared observation intervals must agree; the connected results must also have matching units and intervals within <code>timeTolerance</code>. A metadata mismatch gives <code>INVALID</code>.</p><p>Set the declared metadata to describe the connected results. The block compares each metadata pair but does not verify every declaration against its producer. The difference retains the common unit and does not itself define a requirement threshold.</p></html>"));
end PairedDifference;
