within EvaluationLibrary.Utilities.Functions;
function Aggregate "Combine required verdicts with an explicit priority"
  extends Modelica.Icons.Function;
input Integer codes[:] "Verdict codes to combine";
  input Boolean required[size(codes,1)] "Which child requirements enter the overall conjunction";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement decision independent of observation completeness";
protected
  Integer applicableCount "Number of required applicable verdicts";
  Boolean invalid "At least one required code is invalid";
  Boolean violated "At least one required requirement is violated";
  Boolean undecided "At least one required verdict is undecided";
algorithm
  applicableCount:=0; invalid:=false; violated:=false; undecided:=false;
  for i in 1:size(codes,1) loop
    if required[i] and codes[i]<>5 then
      applicableCount:=applicableCount+1;
      invalid:=invalid or EvaluationLibrary.Utilities.Functions.VerdictFromCode(codes[i])==EvaluationLibrary.Utilities.Types.Verdict.INVALID;
      violated:=violated or codes[i]==3;
      undecided:=undecided or codes[i]==1;
    end if;
  end for;
  verdict:=if applicableCount==0 then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE elseif invalid then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif violated then EvaluationLibrary.Utilities.Types.Verdict.VIOLATED elseif undecided then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED else EvaluationLibrary.Utilities.Types.Verdict.SATISFIED;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Rectangle(extent={{-57.868,7.871},{-30.636,35.103}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-55.315,32.55},{-33.189,10.424}}, textString="c", textColor={64,64,64}, fontSize=0),
        Line(points={{-28.934,21.487},{-7.659,21.487},{10.212,-9.149}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Rectangle(extent={{-57.868,-22.765},{-30.636,4.467}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-55.315,1.914},{-33.189,-20.212}}, textString="c", textColor={64,64,64}, fontSize=0),
        Line(points={{-28.934,-9.149},{-7.659,-9.149},{10.212,-9.149}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Rectangle(extent={{-57.868,-53.401},{-30.636,-26.169}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-55.315,-28.722},{-33.189,-50.848}}, textString="c", textColor={64,64,64}, fontSize=0),
        Line(points={{-28.934,-39.785},{-7.659,-39.785},{10.212,-9.149}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Polygon(points={{15.318,-9.149},{33.189,10.424},{51.06,-9.149},{33.189,-28.722},{15.318,-9.149}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{22.126,1.914},{44.252,-20.212}}, textString="V", textColor={64,64,64}, fontSize=0),
        Line(points={{-64.676,26.593},{-64.676,-46.593}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-51.911,-60.209},{51.911,-78.08}}, textString="priority", textColor={64,64,64}, fontSize=0)
      }),
    Documentation(info="<html><p>Combine the entries of <code>codes</code> for which <code>required</code> is true. Ignore <code>NOT_APPLICABLE</code> entries. The priority is <code>INVALID</code>, <code>VIOLATED</code>, <code>UNDECIDED</code>, then <code>SATISFIED</code>; no applicable entries gives <code>NOT_APPLICABLE</code>.</p><p>Codes use the ordinals of <code>Types.Verdict</code>. Unrecognised codes are invalid. Apply <code>QualifiedCode</code> first when data status must also be considered.</p></html>"));
end Aggregate;
