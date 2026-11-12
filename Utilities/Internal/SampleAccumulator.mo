within EvaluationLibrary.Utilities.Internal;
block SampleAccumulator "Accumulate qualified samples with stable online variance"
Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput take annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput count(start=0,fixed=true) annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput average(start=0,fixed=true) annotation(Placement(transformation(origin={100,50},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,50},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput m2(start=0,fixed=true) annotation(Placement(transformation(origin={100,30},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,30},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput sumSquare(start=0,fixed=true) annotation(Placement(transformation(origin={100,10},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,10},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput minimum(start=0,fixed=true) annotation(Placement(transformation(origin={100,-10},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-10},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput maximum(start=0,fixed=true) annotation(Placement(transformation(origin={100,-30},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-30},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput argminTime(unit="s",start=0,fixed=true) annotation(Placement(transformation(origin={100,-50},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-50},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput argmaxTime(unit="s",start=0,fixed=true) annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
algorithm
  when take then
    count:=pre(count)+1;
    average:=pre(average)+(u-pre(average))/count;
    m2:=pre(m2)+(u-pre(average))*(u-average);
    sumSquare:=pre(sumSquare)+u*u;
    minimum:=if pre(count)==0 or u<pre(minimum) then u else pre(minimum);
    maximum:=if pre(count)==0 or u>pre(maximum) then u else pre(maximum);
    argminTime:=if pre(count)==0 or u<pre(minimum) then time else pre(argminTime);
    argmaxTime:=if pre(count)==0 or u>pre(maximum) then time else pre(argmaxTime);
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-58,54},{-3,-18}}, textString="Σ", textColor={0,0,127}, fontSize=0),
        Ellipse(extent={{13,21},{21,29}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{34,1},{42,9}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{53,32},{61,40}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Line(points={{17,-26},{17,25}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{38,-26},{38,5}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{57,-26},{57,36}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{46,51},{60,51},{60,-29}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="Σ, n", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Accumulate qualified samples with stable online variance.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.RealInput u; Modelica.Blocks.Interfaces.BooleanInput take; Modelica.Blocks.Interfaces.IntegerOutput count(start=0,fixed=true); Modelica.Blocks.Interfaces.RealOutput average(start=0,fixed=true); Modelica.Blocks.Interfaces.RealOutput m2(start=0,fixed=true); Modelica.Blocks.Interfaces.RealOutput sumSquare(start=0,fixed=true); Modelica.Blocks.Interfaces.RealOutput minimum(start=0,fixed=true); Modelica.Blocks.Interfaces.RealOutput maximum(start=0,fixed=true); Modelica.Blocks.Interfaces.RealOutput argminTime(unit=\"s\",start=0,fixed=true); Modelica.Blocks.Interfaces.RealOutput argmaxTime(unit=\"s\",start=0,fixed=true)</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Accumulate qualified samples with stable online variance</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Use a pulse on the explicit sampling grid. Tied extrema retain the earliest sample.</p><p><b>Observables</b> count, average, m2, sumSquare, minimum, maximum, argminTime, argmaxTime</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p></html>"));
end SampleAccumulator;
