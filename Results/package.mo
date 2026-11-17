within EvaluationLibrary;
package Results "Result aggregation, qualification and reporting"
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),graphics={Rectangle(extent={{-86,86},{86,-86}},lineColor={95,95,95},fillColor={255,255,255},fillPattern=FillPattern.Solid,lineThickness=0.5),Rectangle(extent={{-58,52},{58,-48}},lineColor={95,95,95},fillColor={255,255,255},fillPattern=FillPattern.Solid,lineThickness=0.5),Line(points={{-58,20},{58,20}},color={95,95,95},thickness=0.8),Line(points={{-58,-10},{58,-10}},color={95,95,95},thickness=0.8),Line(points={{-18,52},{-18,-48}},color={95,95,95},thickness=0.8),Line(points={{20,52},{20,-48}},color={95,95,95},thickness=0.8),Line(points={{-7,-30},{8,-43},{41,-2}},color={0,120,60},thickness=1.4)}),Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-100,-100},{100,100}}, lineColor={200,200,200}, fillColor={248,248,248}, fillPattern=FillPattern.HorizontalCylinder, pattern=LinePattern.Solid, lineThickness=0.5, radius=25),
        Rectangle(extent={{-100,-100},{100,100}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.None, pattern=LinePattern.Solid, lineThickness=0.5, radius=25),
        Polygon(points={{-38.64,-34.96},{39.56,-34.96},{39.56,30.36},{23,48.76},{-38.64,48.76},{-38.64,-34.96}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{23,48.76},{23,30.36},{39.56,30.36}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-25.76,19.32},{23,19.32}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-25.76,0.92},{23,0.92}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-25.76,-17.48},{23,-17.48}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-61.64,3.68},{-38.64,3.68}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled})
      }),Documentation(info="<html><p>Blocks for inspecting observation coverage, combining verdicts, calculating finite-set summaries, grading normalised scores, and reporting result records to the console or files.</p><p>Connect result producers directly to writer inputs. Data status, numerical availability and requirement verdict are separate fields. Output completion flags describe reporting and do not change the evaluation.</p></html>"));
end Results;
