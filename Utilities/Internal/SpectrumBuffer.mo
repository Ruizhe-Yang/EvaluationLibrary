within EvaluationLibrary.Utilities.Internal;
block SpectrumBuffer "Retain a declared finite set of same-grid samples"
parameter Integer n(min=16,max=1024)=200 "Number of channels, records or configured items; at least one";
    Modelica.Blocks.Interfaces.RealInput u "Observed real signal in the declared engineering unit" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput take "Take" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput ready "Ready" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput overflow(start=false,fixed=true) "Overflow" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
  output Real samples[n](each start=0,each fixed=true) "Samples";
  output Integer count(start=0,fixed=true) "Count";
initial equation
  assert(n>=16 and n<=1024,"Spectral cache must contain 16 to 1024 samples.");
equation
  ready=count==n;
algorithm
  when take then
    if pre(count)<n then
      count:=pre(count)+1;
      samples[count]:=u;
    else overflow:=true;
    end if;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-63,-19.5},{63,43.5}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-37.8,-19.5},{-37.8,43.5}}, color={64,64,64}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-12.6,-19.5},{-12.6,43.5}}, color={64,64,64}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{12.6,-19.5},{12.6,43.5}}, color={64,64,64}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{37.8,-19.5},{37.8,43.5}}, color={64,64,64}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-50,-14},{-50,7}}, color={0,0,127}, thickness=0.7, pattern=LinePattern.Solid),
        Ellipse(extent={{-53,4},{-47,10}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{-25,-14},{-25,29}}, color={0,0,127}, thickness=0.7, pattern=LinePattern.Solid),
        Ellipse(extent={{-28,26},{-22,32}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{0,-14},{0,17}}, color={0,0,127}, thickness=0.7, pattern=LinePattern.Solid),
        Ellipse(extent={{-3,14},{3,20}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{25,-14},{25,-1}}, color={0,0,127}, thickness=0.7, pattern=LinePattern.Solid),
        Ellipse(extent={{22,-4},{28,2}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{50,-14},{50,24}}, color={0,0,127}, thickness=0.7, pattern=LinePattern.Solid),
        Ellipse(extent={{47,21},{53,27}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{-67,64},{66,64}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-67,57},{-67,70}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{66,57},{66,70}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Text(extent={{-21,80},{21,65}}, textString="N", textColor={64,64,64}, fontSize=0),
        Text(extent={{-55,-48},{55,-76}}, textString="finite", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Bounded ordered sample buffer for finite spectra. Inputs retain the physical units or logical meaning stated by their declarations. Domain assertions and explicit availability flags are part of the contract.</p></html>"));
end SpectrumBuffer;
