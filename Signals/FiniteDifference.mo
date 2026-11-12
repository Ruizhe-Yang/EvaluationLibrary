within EvaluationLibrary.Signals;
block FiniteDifference "Compute a finite difference only after two qualified samples"
parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01;
  parameter Modelica.Units.SI.Time sampleStart=0;
  parameter Boolean useValidInput=false;
    Modelica.Blocks.Interfaces.RealInput u annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y(start=0,fixed=true) annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available(start=false,fixed=true) annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trust annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  discrete Real previous(start=0,fixed=true);
  discrete Boolean wasValid(start=false,fixed=true);
  Boolean eligible;
initial equation
  assert(samplePeriod>0,"Positive sample period required.");
equation
  connect(valid,trust);
  if not useValidInput then trust=true; end if;
  eligible=trust and abs(u)<Modelica.Constants.inf;
  when sample(sampleStart,samplePeriod) then
    available=eligible and pre(wasValid);
    y=if available then (u-pre(previous))/samplePeriod else 0;
    previous=u;
    wasValid=eligible;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-40},{65,-40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-42,-21},{32,39}}, color={0,0,127}, thickness=1.1, pattern=LinePattern.Solid),
        Line(points={{-42,-21},{32,-21},{32,39}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Dash),
        Ellipse(extent={{-46,-25},{-38,-17}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{28,35},{36,43}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Text(extent={{-65,-50},{65,-75}}, textString="Δu / Δt", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Compute a finite difference only after two qualified samples.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.RealInput u; Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput; Modelica.Blocks.Interfaces.RealOutput y(start=0,fixed=true); Modelica.Blocks.Interfaces.BooleanOutput available(start=false,fixed=true)</p><p><b>Parameters</b> parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01; parameter Modelica.Units.SI.Time sampleStart=0; parameter Boolean useValidInput=false</p><p><b>Behavior</b> Compute a finite difference only after two qualified samples</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Outputs retain the units declared at the interface. Numerical values depend on the supplied input and parameter range.</p><p><b>Observables</b> y, available</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">EvaluationLibrary.Examples.BoundsAndValidWitness</a></p></html>"));
end FiniteDifference;
