within EvaluationLibrary.Utilities.Types;
type EvidenceKind = enumeration(Continuous,Sampled,Event,Derived) "Basis of an evaluation result" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Line(points={{-59,1},{-56.05,2.719},{-53.1,4.387},{-50.15,5.955},{-47.2,7.374},{-44.25,8.604},{-41.3,9.607},{-38.35,10.354},{-35.4,10.823},{-32.45,10.999},{-29.5,10.877},{-26.55,10.461},{-23.6,9.763},{-20.65,8.804},{-17.7,7.613},{-14.75,6.225},{-11.8,4.681},{-8.85,3.028},{-5.9,1.314},{-2.95,-0.409},{0,-2.09},{2.95,-3.679},{5.9,-5.129},{8.85,-6.396},{11.8,-7.443},{14.75,-8.239},{17.7,-8.759},{20.65,-8.989},{23.6,-8.921},{26.55,-8.558},{29.5,-7.91},{32.45,-6.997},{35.4,-5.845},{38.35,-4.49},{41.3,-2.971},{44.25,-1.334},{47.2,0.372},{50.15,2.097},{53.1,3.79},{56.05,5.399},{59,6.878}}, color={255,255,255}, thickness=1.1, pattern=LinePattern.Solid),
        Ellipse(extent={{-54,-37},{-48,-31}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Ellipse(extent={{-28,-37},{-22,-31}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Ellipse(extent={{-2,-37},{4,-31}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Ellipse(extent={{24,-37},{30,-31}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Ellipse(extent={{50,-37},{56,-31}}, lineColor={255,255,255}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{30,-60},{30,-45}}, color={255,255,255}, thickness=1.1, pattern=LinePattern.Solid)
      }),Documentation(info="<html><p>Identify evidence as <code>Continuous</code>, <code>Sampled</code>, <code>Event</code> or <code>Derived</code>. <code>Derived</code> covers results combined from other observations or calculations. The type describes the basis of the result, independently of validity or requirement satisfaction.</p><p>The result connectors use ordinals 1 through 4 in the declared order.</p></html>"));
