within EvaluationLibrary.Utilities.Functions;
function ToVerdict "Decide requirement evidence without discarding a recorded witness"
  extends Modelica.Icons.Function;
input EvaluationLibrary.Utilities.Types.DataStatus status "Status";
  input Boolean everViolated "A qualified violation witness exists";
  input Boolean isRequirement=true "Is requirement";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement decision independent of observation completeness";
algorithm
  verdict:=if status==EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE
    elseif status==EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif everViolated then EvaluationLibrary.Utilities.Types.Verdict.VIOLATED
    elseif isRequirement and status==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.Verdict.SATISFIED
    else EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Rectangle(extent={{-57.017,1.063},{-29.785,28.295}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-54.464,25.742},{-32.338,3.616}}, textString="Q", textColor={64,64,64}, fontSize=0),
        Rectangle(extent={{-57.017,-44.891},{-29.785,-17.659}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-54.464,-20.212},{-32.338,-42.338}}, textString="!", textColor={64,64,64}, fontSize=0),
        Line(points={{-28.934,14.679},{-4.255,14.679},{7.659,-7.447}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-28.934,-31.275},{-4.255,-31.275},{7.659,-7.447}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Polygon(points={{11.914,-7.447},{29.785,12.126},{47.656,-7.447},{29.785,-27.02},{11.914,-7.447}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{18.722,3.616},{40.848,-18.51}}, textString="V", textColor={64,64,64}, fontSize=0),
        Text(extent={{-53.613,-59.358},{53.613,-78.08}}, textString="witness", textColor={64,64,64}, fontSize=0)
      }),
    Documentation(info="<html><p>Map evidence qualification and a recorded requirement violation into a verdict: not applicable and invalid statuses retain their meaning, an observed violation remains VIOLATED, and only complete requirement evidence with no violation may be SATISFIED. Descriptive statistics remain UNDECIDED. Callers whose algorithms can report no demand or undefined evidence must retain those explicit decisions rather than infer satisfaction from coverage alone.</p></html>"));
end ToVerdict;
