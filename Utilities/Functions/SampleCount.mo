within EvaluationLibrary.Utilities.Functions;
function SampleCount "Count a finite half-open window on an explicit sample grid"
  extends Modelica.Icons.Function;
input Modelica.Units.SI.Time left;
  input Modelica.Units.SI.Time right;
  input Modelica.Units.SI.Time origin;
  input Modelica.Units.SI.Time period;
  output Integer n;
algorithm
  assert(period>0,"Sample period must be positive.");
  n:=max(0,integer(ceil((right-origin)/period-1e-9))-max(0,integer(ceil((left-origin)/period-1e-9))));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Line(points={{-33.32,25.88},{-33.32,-20.36}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{33.32,25.88},{33.32,-20.36}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Ellipse(extent={{-27.2,0.04},{-21.76,5.48}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-10.88,0.04},{-5.44,5.48}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{5.44,0.04},{10.88,5.48}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{21.76,0.04},{27.2,5.48}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Text(extent={{-65,-55},{65,-78}}, textString="N ticks", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Count a finite half-open window on an explicit sample grid.</p><p><b>Interfaces</b> input Modelica.Units.SI.Time left; input Modelica.Units.SI.Time right; input Modelica.Units.SI.Time origin; input Modelica.Units.SI.Time period; output Integer n</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Count a finite half-open window on an explicit sample grid</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> The rounding guard applies to fractions of one sample period at floating-point grid boundaries.</p><p><b>Observables</b> n</p></html>"));
end SampleCount;
