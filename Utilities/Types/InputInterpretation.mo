within EvaluationLibrary.Utilities.Types;
type InputInterpretation=enumeration(AbsoluteValue,SignedValue,Difference,WrappedAngleDifference) "Interpret each real signal before assessment" annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Text(extent={{-70,-5},{70,-57}}, textString="|x|, x, dx", textColor={255,255,255}, fontSize=0),
        Line(points={{-43,-75},{-18,-56},{-18,-76},{17,-56},{17,-76},{43,-58}}, color={255,255,255}, thickness=1, pattern=LinePattern.Solid)
      }),
    Documentation(info="<html><p>InputInterpretation supports the single complete-result and explicit qualification contract. See the parameter and field descriptions for its numerical or logical meaning.</p></html>"));
