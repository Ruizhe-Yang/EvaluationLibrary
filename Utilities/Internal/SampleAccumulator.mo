within EvaluationLibrary.Utilities.Internal;
block SampleAccumulator "Accumulate qualified samples with stable online variance"
Modelica.Blocks.Interfaces.RealInput u "Observed real signal in the declared engineering unit" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput take "Take" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput count(start=0,fixed=true) "Count" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput average(start=0,fixed=true) "Average" annotation(Placement(transformation(origin={100,50},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,50},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput m2(start=0,fixed=true) "M2" annotation(Placement(transformation(origin={100,30},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,30},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput sumSquare(start=0,fixed=true) "Sum square" annotation(Placement(transformation(origin={100,10},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,10},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput minimum(start=0,fixed=true) "Minimum" annotation(Placement(transformation(origin={100,-10},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-10},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput maximum(start=0,fixed=true) "Maximum" annotation(Placement(transformation(origin={100,-30},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-30},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput argminTime(unit="s",start=0,fixed=true) "Argmin time" annotation(Placement(transformation(origin={100,-50},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-50},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput argmaxTime(unit="s",start=0,fixed=true) "Argmax time" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
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
        Line(points={{-66,-26},{66,-26}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-55,-26},{-55,3}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Ellipse(extent={{-59,-1},{-51,7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{-31,-26},{-31,28}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Ellipse(extent={{-35,24},{-27,32}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{-7,-26},{-7,14}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Ellipse(extent={{-11,10},{-3,18}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{17,-26},{17,41}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Ellipse(extent={{13,37},{21,45}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Text(extent={{26,24},{68,-6}}, textString="sum", textColor={64,64,64}, fontSize=0),
        Line(points={{-44,-48},{46,-48}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid),
        Text(extent={{-70,-59},{70,-80}}, textString="n, mean, M2", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Shared uniform-sample accumulation with extrema. Inputs retain the physical units or logical meaning stated by their declarations. Domain assertions and explicit availability flags are part of the contract.</p></html>"));
end SampleAccumulator;
