within EvaluationLibrary;
package Requirements "Numerical, logical and timing requirements"
  extends Modelica.Icons.Package;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-51.52,-24.84},{51.52,34.04}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Dash, lineThickness=0.5, radius=0),
        Line(points={{-50.6,2.76},{-47.4375,8.5037},{-44.275,13.8161},{-41.1125,18.2983},{-37.95,21.6137},{-34.7875,23.5134},{-31.625,23.8548},{-28.4625,22.6121},{-25.3,19.8788},{-22.1375,15.86},{-18.975,10.8576},{-15.8125,5.2471},{-12.65,-0.5502},{-9.4875,-6.0988},{-6.325,-10.9823},{-3.1625,-14.8339},{0,-17.3644},{3.1625,-18.3837},{6.325,-17.8153},{9.4875,-15.702},{12.65,-12.2024},{15.8125,-7.5792},{18.975,-2.1797},{22.1375,3.5907},{25.3,9.2988},{28.4625,14.5159},{31.625,18.8502},{34.7875,21.9763},{37.95,23.6595},{41.1125,23.7733},{44.275,22.3093},{47.4375,19.3773},{50.6,15.1975}}, color={0,0,127}, thickness=1, pattern=LinePattern.Solid),
        Line(points={{-59.8,-39.56},{59.8,-39.56}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid)
      }));
  annotation(Documentation(info="<html><p>Blocks for inclusive bounds, Boolean conditions, persistence limits, response deadlines and objective completion. Each assessment keeps evidence quality separate from its requirement verdict. Select a block by its acceptance rule and supply the required observation and validity signals.</p></html>"));
end Requirements;
