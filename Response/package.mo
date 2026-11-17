within EvaluationLibrary;
package Response "Event timing, response measurements and duration statistics"
  extends Modelica.Icons.Package;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Line(points={{-55.2,22.08},{-29.44,22.08},{-29.44,48.76},{-9.2,48.76},{-9.2,22.08},{55.2,22.08}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-55.2,-26.68},{7.36,-26.68},{7.36,0},{27.6,0},{27.6,-26.68},{55.2,-26.68}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-29.44,16.56},{-29.44,-39.56}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dot),
        Line(points={{7.36,15.64},{7.36,-39.56}}, color={128,128,128}, thickness=0.45, pattern=LinePattern.Dot),
        Line(points={{-29.44,-36.8},{7.36,-36.8}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled})
      }));
  annotation(Documentation(info="<html><p>Blocks for event counts, request-response delays, transition times, recovery, settling and condition duration. <code>EventAssessment</code> combines multiple event tasks in one fixed window. Individual blocks provide specialised outputs or configurable observation windows.</p></html>"));
end Response;
