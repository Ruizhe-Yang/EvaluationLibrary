within EvaluationLibrary.Utilities.Functions;
function FormatSummary "Format complete results and an explicit overall verdict"
 input String runId "Run identity";
 input EvaluationLibrary.Utilities.Types.MetricResult records[:] "Complete records";
 input Boolean required[size(records,1)]=fill(true,size(records,1)) "Required items";
 output String text "One concise terminal report";
protected
 EvaluationLibrary.Utilities.Types.Verdict overall "Overall";
algorithm
 overall:=EvaluationLibrary.Utilities.Functions.Aggregate({EvaluationLibrary.Utilities.Functions.QualifiedCode(Integer(records[i].dataStatus),Integer(records[i].verdict)) for i in 1:size(records,1)},required);
 text:="EvaluationLibrary | Run: "+runId+"\n--------------------------------------------------";
 for i in 1:size(records,1) loop
   text:=text+"\n"+records[i].metricId+" : "+(if records[i].valueAvailable then String(records[i].value,significantDigits=8)+" "+records[i].unit else "N/A")+" | "+String(records[i].dataStatus)+" | "+String(records[i].verdict);
   if records[i].everViolated then text:=text+" | first violation="+String(records[i].firstViolationTime)+" s"; end if;
   if records[i].levelAvailable then text:=text+" | Level "+String(records[i].level)+" (<= "+String(records[i].level0Upper)+", <= "+String(records[i].level1Upper)+")"; end if;
   if records[i].eventCountsAvailable then text:=text+" | events="+String(records[i].eventCount)+", matched="+String(records[i].matchedCount)+", timed out="+String(records[i].timedOutCount)+", censored="+String(records[i].censoredCount); end if;
   text:=text+" | "+records[i].message;
 end for;
 text:=text+"\nOVERALL : "+String(overall)+"\nSUMMARY : Required applicable children retained; output status is separate from safety.\n--------------------------------------------------";
  annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Polygon(points={{-55.7405,-10.851},{-25.9555,-10.851},{-25.9555,17.232},{-38.7205,29.997},{-55.7405,29.997},{-55.7405,-10.851}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{-38.7205,29.997},{-38.7205,17.232},{-25.9555,17.232}}, color={64,64,64}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-48.0815,8.722},{-33.6145,8.722}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-48.0815,-3.192},{-33.6145,-3.192}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Polygon(points={{-48.0815,-27.871},{-18.2965,-27.871},{-18.2965,0.212},{-31.0615,12.977},{-48.0815,12.977},{-48.0815,-27.871}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{-31.0615,12.977},{-31.0615,0.212},{-18.2965,0.212}}, color={64,64,64}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-40.4225,-8.298},{-25.9555,-8.298}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-40.4225,-20.212},{-25.9555,-20.212}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-11.914,-5.745},{4.255,-5.745}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Polygon(points={{7.659,-45.742},{57.017,-45.742},{57.017,16.381},{44.252,29.146},{7.659,29.146},{7.659,-45.742}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{44.252,29.146},{44.252,16.381},{57.017,16.381}}, color={64,64,64}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{15.318,7.871},{49.358,7.871}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{15.318,-7.447},{49.358,-7.447}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{15.318,-22.765},{49.358,-22.765}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{15.318,-38.083},{49.358,-38.083}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{14.467,-33.828},{50.209,-33.828}}, color={108,88,49}, thickness=1.2, pattern=LinePattern.Solid),
        Text(extent={{-54.464,-56.805},{-10.212,-75.527}}, textString="all", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Build one English report for all complete result records without dropping optional or inapplicable children. Read values and all metadata from the records, show unavailable values as N/A, and append available event counts, engineering severity and violation witnesses. required defaults to all true; QualifiedCode and Aggregate compute an explicit qualified overall verdict. This pure formatting function performs no file or console I/O and never alters evidence.</p></html>"));
end FormatSummary;
