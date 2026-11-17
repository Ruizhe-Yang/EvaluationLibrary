within EvaluationLibrary.Signals;
block FiniteDifference "Backward difference of consecutive valid samples"
parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Uniform sampling interval; must be positive";
  parameter Modelica.Units.SI.Time sampleStart=0 "Origin of the uniform sampling grid";
  parameter Boolean useValidInput=false "Enable the external validity input";
    Modelica.Blocks.Interfaces.RealInput u "Observed signal" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "External input-validity condition" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y(start=0,fixed=true) "Backward-difference derivative estimate" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available(start=false,fixed=true) "True when the numerical value is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trust "Internal validity signal" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  discrete Real previous(start=0,fixed=true) "Previous sampled value";
  discrete Boolean wasValid(start=false,fixed=true) "Validity at the previous sample";
  Boolean eligible "Current sample validity";
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
        Line(points={{-64,61},{-64,-38},{65,-38}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-46,-17},{35,40}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{-46,-17},{35,-17},{35,40}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Dash),
        Line(points={{-46,-38},{-46,-17}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{35,-38},{35,40}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Ellipse(extent={{-50,-21},{-42,-13}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{31,36},{39,44}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Text(extent={{-65,-50},{65,-75}}, textString="Δu / Δt", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Estimates the derivative as <code>(u - previous)/samplePeriod</code> on the grid <code>sampleStart + k*samplePeriod</code>. The output unit is the input unit per second.</p><p>The sampling period must be positive. The first sample and any pair containing an invalid or non-finite sample produce <code>available=false</code> and <code>y=0</code>. Enable <code>useValidInput</code> to supply an external validity condition. The output is held between ticks.</p></html>"));
end FiniteDifference;
