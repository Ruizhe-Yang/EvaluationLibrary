within EvaluationLibrary.Comparison;
block Improvement "Report absolute and relative improvement with an explicit preferred direction"
extends EvaluationLibrary.Comparison.PairedDifference;
  parameter EvaluationLibrary.Utilities.Types.Sense sense=EvaluationLibrary.Utilities.Types.Sense.LowerIsBetter;
  parameter Real referenceFloor(min=0)=1e-12;
    Modelica.Blocks.Interfaces.RealOutput absoluteImprovement annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput relativeImprovement annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput relativeAvailable annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
initial equation
  assert(referenceFloor>=0,"Negative baseline floor.");
equation
  absoluteImprovement=if sense==EvaluationLibrary.Utilities.Types.Sense.LowerIsBetter then -difference else difference;
  relativeAvailable=available and abs(reference.value)>referenceFloor;
  relativeImprovement=if relativeAvailable then absoluteImprovement/abs(reference.value) else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-45,-34},{-15,37}}, lineColor={64,64,64}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{14,-34},{44,7}}, lineColor={0,0,127}, fillColor={215,225,238}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-55,-34},{59,-34}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-30,49},{29,49},{29,20}}, color={75,138,73}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="gain / ref", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Report absolute and relative improvement with an explicit preferred direction.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.RealOutput absoluteImprovement; Modelica.Blocks.Interfaces.RealOutput relativeImprovement; Modelica.Blocks.Interfaces.BooleanOutput relativeAvailable</p><p><b>Parameters</b> parameter EvaluationLibrary.Utilities.Types.Sense sense=EvaluationLibrary.Utilities.Types.Sense.LowerIsBetter; parameter Real referenceFloor(min=0)=1e-12</p><p><b>Behavior</b> Report absolute and relative improvement with an explicit preferred direction</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Relative improvement is a fraction and is unavailable for a near-zero baseline.</p><p><b>Observables</b> absoluteImprovement, relativeImprovement, relativeAvailable</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.PairedPerformance\">EvaluationLibrary.Examples.PairedPerformance</a></p></html>"));
end Improvement;
