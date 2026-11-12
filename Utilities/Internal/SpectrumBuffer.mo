within EvaluationLibrary.Utilities.Internal;
block SpectrumBuffer "Retain a declared finite set of same-grid samples"
parameter Integer n(min=16,max=1024)=200;
    Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput take annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput ready annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput overflow(start=false,fixed=true) annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
  output Real samples[n](each start=0,each fixed=true);
  output Integer count(start=0,fixed=true);
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
        Rectangle(extent={{-52,-36},{52,38}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-26,-36},{-26,38}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{0,-36},{0,38}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{26,-36},{26,38}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{-43,-12},{-35,-4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-17,16},{-9,24}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{9,3},{17,11}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{35,22},{43,30}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Text(extent={{-65,-50},{65,-75}}, textString="x[1:N]", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Retain a declared finite set of same-grid samples.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.RealInput u; Modelica.Blocks.Interfaces.BooleanInput take; Modelica.Blocks.Interfaces.BooleanOutput ready; Modelica.Blocks.Interfaces.BooleanOutput overflow(start=false,fixed=true); output Real samples[n](each start=0,each fixed=true); output Integer count(start=0,fixed=true)</p><p><b>Parameters</b> parameter Integer n(min=16,max=1024)=200</p><p><b>Behavior</b> Retain a declared finite set of same-grid samples</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Outputs retain the units declared at the interface. Numerical values depend on the supplied input and parameter range.</p><p><b>Observables</b> ready, overflow, samples, count</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.HarmonicMeasurements\">EvaluationLibrary.Examples.HarmonicMeasurements</a></p></html>"));
end SpectrumBuffer;
