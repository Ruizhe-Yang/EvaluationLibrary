within EvaluationLibrary.Utilities.Types;
type SpectralWindow = enumeration(Rectangular "矩形窗", Hann "周期 Hann 窗") "均匀样本的离散频谱窗函数"
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-61,74},{61,0}}, textString="E", textColor={255,255,255}, fontSize=0),
        Line(points={{-58,-48},{-58,-14},{-8,-14},{-8,-48}}, color={255,255,255}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{5,-48},{13,-27},{26,-16},{39,-27},{47,-48}}, color={255,255,255}, thickness=0.8, pattern=LinePattern.Solid)
      }),
    Documentation(info="<html>
<p>均匀样本的离散频谱窗函数</p>
</html>"));
