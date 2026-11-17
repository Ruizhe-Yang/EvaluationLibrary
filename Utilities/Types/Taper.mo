within EvaluationLibrary.Utilities.Types;
type Taper = enumeration(Rectangular,Hann) "Weighting for a finite sinusoidal projection" annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-48,77},{48,23}}, textString="E", textColor={255,255,255}, fontSize=0),
        Line(points={{-58,-48},{-58,-1},{58,-1},{58,-48}}, color={255,255,255}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-58,-48},{-53.1667,-47.1993},{-48.3333,-44.8516},{-43.5,-41.117},{-38.6667,-36.25},{-33.8333,-30.5822},{-29,-24.5},{-24.1667,-18.4178},{-19.3333,-12.75},{-14.5,-7.88299},{-9.66667,-4.1484},{-4.83333,-1.80074},{0,-1},{4.83333,-1.80074},{9.66667,-4.1484},{14.5,-7.88299},{19.3333,-12.75},{24.1667,-18.4178},{29,-24.5},{33.8333,-30.5822},{38.6667,-36.25},{43.5,-41.117},{48.3333,-44.8516},{53.1667,-47.1993},{58,-48}}, color={255,255,255}, thickness=1.4, pattern=LinePattern.Solid),
        Text(extent={{-50,-60},{50,-79}}, textString="w[n]", textColor={255,255,255}, fontSize=0)
      }),Documentation(info="<html><p>Select rectangular or Hann weighting for <code>Functions.Tone</code>. The Hann option uses a symmetric taper over the retained samples. Amplitudes are normalised by the sum of weights.</p></html>"));
