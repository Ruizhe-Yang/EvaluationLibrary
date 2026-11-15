within EvaluationLibrary.Utilities.Functions;
function EvidenceMessage "Explain qualification without implying a missing numerical value"
 input Integer status "DataStatus code";
 input Integer verdict "Verdict code";
 input Boolean available "Whether the value is available";
 output String message "Explanation independent of the numeric placeholder";
algorithm
 message:=if status==5 then "Not applicable or not demanded" elseif status==4 then "Invalid input, domain or observation history" elseif status==3 then "Observation or sample coverage is incomplete" elseif status==1 then "Observation pending" elseif verdict==3 then "A qualified requirement violation was observed" elseif not available then "No eligible numerical observation" elseif verdict==2 then "The complete applicable requirement is satisfied" else "Qualified statistic; no requirement decision requested";
  annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Rectangle(extent={{-56.166,0.212},{-28.934,27.444}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{-53.613,24.891},{-31.487,2.765}}, textString="Q", textColor={64,64,64}, fontSize=0),
        Polygon(points={{-60.421,-27.871},{-42.55,-8.298},{-24.679,-27.871},{-42.55,-47.444},{-60.421,-27.871}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-53.613,-16.808},{-31.487,-38.934}}, textString="V", textColor={64,64,64}, fontSize=0),
        Line(points={{-22.126,-6.596},{-3.404,-6.596}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Polygon(points={{3.404,26.593},{57.017,26.593},{57.017,-27.871},{25.53,-27.871},{12.765,-40.636},{12.765,-27.871},{3.404,-27.871},{3.404,26.593}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{12.765,12.977},{46.805,12.977}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{12.765,-0.639},{46.805,-0.639}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{12.765,-14.255},{37.444,-14.255}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>EvidenceMessage supports the single complete-result and explicit qualification contract. See the parameter and field descriptions for its numerical or logical meaning.</p></html>"));
end EvidenceMessage;
