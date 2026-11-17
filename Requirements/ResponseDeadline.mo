within EvaluationLibrary.Requirements;
block ResponseDeadline "Check repeated request-response deadlines using FIFO pairing"
extends EvaluationLibrary.Response.RepeatedResponse(final qualifyDeadline=true);
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-65,40},{-56,40},{-56,60},{-48,60},{-48,40},{-39,40},{-39,60},{-31,60},{-31,40}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{-20,49},{-5,49}}, color={64,64,64}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{4,62},{42,39}}, textString="req", textColor={128,128,128}, fontSize=0),
        Rectangle(extent={{-44,-7},{-16,23}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.65, radius=0),
        Rectangle(extent={{-8,-7},{20,23}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.65, radius=0),
        Rectangle(extent={{28,-7},{56,23}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.65, radius=0),
        Text(extent={{-41,21},{-19,-5}}, textString="1", textColor={0,0,127}, fontSize=0),
        Text(extent={{-5,21},{17,-5}}, textString="2", textColor={0,0,127}, fontSize=0),
        Text(extent={{31,21},{53,-5}}, textString="3", textColor={0,0,127}, fontSize=0),
        Line(points={{-55,-35},{-30,-35},{-30,-20}}, color={64,64,64}, thickness=0.75, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-51,8},{-66,8}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-13,-23},{65,-43}}, textString="feedback", textColor={64,64,64}, fontSize=0),
        Line(points={{65,-14},{65,30}}, color={191,0,0}, thickness=0.9, pattern=LinePattern.Dash),
        Text(extent={{51,53},{77,29}}, textString="T", textColor={191,0,0}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="FIFO <= T", textColor={64,64,64}, fontSize=0)
      }),
    Documentation(info="<html><p>Uses <code>Response.RepeatedResponse</code> with <code>qualifyDeadline=true</code>. Each response is matched to the oldest outstanding request. Responses at the inclusive deadline are accepted; observed timeouts violate the requirement.</p><p>Connect request and actual response signals, then set <code>deadline</code>, <code>capacity</code> and the observation window. Unfinished follow-up is censored. Without any matched or timed-out request, the deadline assessment remains incomplete. Queue or record overflow invalidates the evidence.</p></html>"));
end ResponseDeadline;
