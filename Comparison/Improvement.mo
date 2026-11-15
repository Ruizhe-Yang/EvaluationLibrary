within EvaluationLibrary.Comparison;
block Improvement "Report absolute and relative improvement with an explicit preferred direction"
extends EvaluationLibrary.Comparison.PairedDifference;
  parameter EvaluationLibrary.Utilities.Types.Sense sense=EvaluationLibrary.Utilities.Types.Sense.LowerIsBetter "Explicit direction of desirable change";
  parameter Real referenceFloor(min=0)=1e-12 "Positive reference magnitude floor; smaller magnitudes are undefined";
    Modelica.Blocks.Interfaces.RealOutput absoluteImprovement "Absolute improvement" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput relativeImprovement "Relative improvement" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput relativeAvailable "Relative available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
initial equation
  assert(referenceFloor>=0,"Negative baseline floor.");
equation
  absoluteImprovement=if sense==EvaluationLibrary.Utilities.Types.Sense.LowerIsBetter then -difference else difference;
  relativeAvailable=available and abs(reference.value)>referenceFloor;
  relativeImprovement=if relativeAvailable then absoluteImprovement/abs(reference.value) else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,-28},{64,-28}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Rectangle(extent={{-48,-28},{-16,48}}, lineColor={128,128,128}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.6, radius=0),
        Rectangle(extent={{9,-28},{41,16}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.7, radius=0),
        Line(points={{51,47},{51,17}}, color={0,0,127}, thickness=0.95, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-55,69},{-8,48}}, textString="ref", textColor={128,128,128}, fontSize=0),
        Text(extent={{1,38},{48,17}}, textString="cand", textColor={0,0,127}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="gain / |ref|", textColor={64,64,64}, fontSize=0)
      }),
    Documentation(info="<html><p>Reuse the qualified PairedDifference contract and specify whether lower or higher is better; LowerIsBetter is the default. absoluteImprovement changes sign according to this direction. referenceFloor defaults to 1e-12 in the reference unit and guards relative improvement when the reference is too small. This semantic inheritance preserves shared pair matching instead of duplicating it.</p></html>"));
end Improvement;
