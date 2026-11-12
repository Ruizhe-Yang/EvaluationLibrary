within EvaluationLibrary.Utilities.Types;
type ReportFormat = enumeration(CSV "逗号分隔表", Text "文字摘要") "终点文件的表示格式"
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-85,-85},{85,85}}, lineColor={128,128,128}, fillColor={160,160,164}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=18),
        Text(extent={{-61,74},{61,0}}, textString="E", textColor={255,255,255}, fontSize=0),
        Text(extent={{-68,-10},{68,-62}}, textString="CSV / TXT", textColor={255,255,255}, fontSize=0)
      }),
    Documentation(info="<html>
<p>终点文件的表示格式</p>
</html>"));
