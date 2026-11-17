within EvaluationLibrary.Utilities.Functions;
function QualifiedCode "Qualify a verdict using its data status"
 input Integer status "DataStatus ordinal";
 input Integer verdict "Verdict ordinal";
 output Integer code "Qualified Verdict ordinal";
algorithm
 code:=if status<1 or status>5 or verdict<1 or verdict>5 or status==4 or verdict==4 then 4 elseif status==5 or verdict==5 then 5 elseif verdict==3 then 3 elseif status<>2 then 1 else verdict;
 annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Rectangle(extent={{-57.868,1.914},{-30.636,29.146}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-55.315,26.593},{-33.189,4.467}}, textString="Q", textColor={64,64,64}, fontSize=0),
        Polygon(points={{-62.123,-30.424},{-44.252,-10.851},{-26.381,-30.424},{-44.252,-49.997},{-62.123,-30.424}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-55.315,-19.361},{-33.189,-41.487}}, textString="V", textColor={64,64,64}, fontSize=0),
        Line(points={{-28.934,15.53},{-6.808,15.53},{-6.808,-5.745}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-24.679,-30.424},{-6.808,-30.424},{-6.808,-5.745}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Rectangle(extent={{-6.808,-22.765},{11.914,11.275}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{11.914,-5.745},{30.636,-5.745}}, color={64,64,64}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{34.891,12.977},{57.868,-25.318}}, textString="#", textColor={108,88,49}, fontSize=0),
        Text(extent={{-50.209,-59.358},{50.209,-78.08}}, textString="Q + V", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Return a verdict code consistent with the supplied data-status code. Invalid or unrecognised codes give <code>INVALID</code>; not-applicable inputs give <code>NOT_APPLICABLE</code>. A recorded violation remains <code>VIOLATED</code>.</p><p>A status other than <code>COMPLETE</code> cannot supply a satisfied verdict and is returned as <code>UNDECIDED</code> unless a higher-priority outcome applies. Codes use the declared enumeration ordinals.</p></html>"));
end QualifiedCode;
