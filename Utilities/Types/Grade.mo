within EvaluationLibrary.Utilities.Types;
type Grade = enumeration(UNGRADED "未分级", A "达到 A 门限", B "达到 B 门限", C "达到 C 门限", D "有效但低于 C 门限") "外部准则映射的等级"
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-61,74},{61,0}}, textString="E", textColor={255,255,255}, fontSize=0),
        Text(extent={{-68,-10},{68,-62}}, textString="A–D", textColor={255,255,255}, fontSize=0)
      }),
    Documentation(info="<html>
<p>等级由用户提供的阈值或本库明确的示例默认值映射。</p>
</html>"));
