within EvaluationLibrary.Signals;
block FiniteDifference "Compute a finite difference only after two qualified samples"
parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Positive uniform sampling interval in seconds";
  parameter Modelica.Units.SI.Time sampleStart=0 "Uniform sample grid origin in seconds";
  parameter Boolean useValidInput=false "Expose the host-provided validity connector";
    Modelica.Blocks.Interfaces.RealInput u "Observed real signal in the declared engineering unit" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "Host declares the observed inputs valid" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.RealOutput y(start=0,fixed=true) "Y" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available(start=false,fixed=true) "The numerical output exists in the current data domain" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trust "Trust" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  discrete Real previous(start=0,fixed=true) "Previous";
  discrete Boolean wasValid(start=false,fixed=true) "Was valid";
  Boolean eligible "Eligible";
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
    Documentation(info="<html><p>At sampleStart+k*samplePeriod, return the difference of two consecutive qualified samples divided by samplePeriod. Defaults are 0 s and 0.01 s; the interval must be positive. y has the input unit per second. The first tick or an invalid preceding/current tick is unavailable, so a bad sample cannot be bridged into a derivative.</p></html>"));
end FiniteDifference;
