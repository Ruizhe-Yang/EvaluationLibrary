within EvaluationLibrary.Utilities.Internal;
function AdvanceFIFO "Update a bounded request-response queue"
 input Boolean initializing "Reset every stored state before processing initial observations";
 input Boolean collecting "Current instant belongs to the half-open observation window";
 input Boolean closing "Observation has closed";
 input Boolean valid "Current observations are qualified";
 input Boolean requestEdge "Qualified request rising edge candidate";
 input Boolean responseEdge "Actual response rising edge candidate";
 input Modelica.Units.SI.Time currentTime "Current simulation instant";
 input Modelica.Units.SI.Time windowStop "Exclusive observation stop";
 input Modelica.Units.SI.Time deadline "Inclusive maximum response delay";
 input Integer capacity "Finite queue capacity";
 input Integer oldQueue "Previous queue length";
 input Integer oldMatched "Previous stored pair count";
 input Integer oldTimedOut "Previous timeout count";
 input Integer oldCensored "Previous censored count";
 input Integer oldUnmatched "Previous response-without-request count";
 input Boolean oldOverflow "Previously latched overflow";
 input Real oldTimestamps[:] "Previous request timestamps in FIFO order";
 input Real oldDelays[:] "Previous retained matched delays";
 input Real oldTotal "Previous sum of retained delays";
 input Real oldFirstMissed "First recorded missed deadline";
 output Integer queued "New queue length";
 output Integer matched "New retained pair count";
 output Integer timedOut "New timeout count";
 output Integer censored "New censored count";
 output Integer unmatched "New unmatched response count";
 output Boolean overflow "New latched overflow";
 output Real timestamps[size(oldTimestamps,1)] "Updated FIFO request times";
 output Real delays[size(oldDelays,1)] "Updated retained delay history";
 output Real total "Updated retained delay sum";
 output Real firstMissed "Updated first missed deadline";
algorithm
 queued:=if initializing then 0 else oldQueue;
 matched:=if initializing then 0 else oldMatched;
 timedOut:=if initializing then 0 else oldTimedOut;
 censored:=if initializing then 0 else oldCensored;
 unmatched:=if initializing then 0 else oldUnmatched;
 overflow:=not initializing and oldOverflow;
 timestamps:=if initializing then zeros(size(oldTimestamps,1)) else oldTimestamps;
 delays:=if initializing then zeros(size(oldDelays,1)) else oldDelays;
 total:=if initializing then 0 else oldTotal;
 firstMissed:=if initializing then 0 else oldFirstMissed;
 if collecting then
   while queued>0 and timestamps[1]+deadline<currentTime-1e-10 loop
     if timedOut==0 then firstMissed:=timestamps[1]+deadline; end if;
     timedOut:=timedOut+1;
     for j in 1:queued-1 loop timestamps[j]:=timestamps[j+1]; end for;
     queued:=queued-1;
   end while;
   if valid and requestEdge then
     if queued>=capacity then overflow:=true;
     else queued:=queued+1; timestamps[queued]:=currentTime; end if;
   end if;
   if valid and responseEdge then
     if queued<=0 then unmatched:=unmatched+1;
     elseif matched>=size(delays,1) then
       overflow:=true;
       for j in 1:queued-1 loop timestamps[j]:=timestamps[j+1]; end for;
       queued:=queued-1;
     else
       matched:=matched+1; delays[matched]:=currentTime-timestamps[1]; total:=total+delays[matched];
       for j in 1:queued-1 loop timestamps[j]:=timestamps[j+1]; end for;
       queued:=queued-1;
     end if;
   end if;
   while queued>0 and timestamps[1]+deadline<=currentTime+1e-10 loop
     if timedOut==0 then firstMissed:=timestamps[1]+deadline; end if;
     timedOut:=timedOut+1;
     for j in 1:queued-1 loop timestamps[j]:=timestamps[j+1]; end for;
     queued:=queued-1;
   end while;
 elseif closing then
   for j in 1:queued loop
     if timestamps[j]+deadline<windowStop and timestamps[j]+deadline<=currentTime then
       if timedOut==0 then firstMissed:=timestamps[j]+deadline; end if;
       timedOut:=timedOut+1;
     else censored:=censored+1; end if;
   end for;
   queued:=0;
 end if;
 annotation(Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Rectangle(extent={{-53.613,-9.149},{53.613,26.593}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-17.871,-9.149},{-17.871,26.593}}, color={64,64,64}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{17.871,-9.149},{17.871,26.593}}, color={64,64,64}, thickness=0.5, pattern=LinePattern.Solid),
        Text(extent={{-50.209,19.785},{-22.977,-4.043}}, textString="n", textColor={64,64,64}, fontSize=0),
        Text(extent={{-13.616,19.785},{13.616,-4.043}}, textString="...", textColor={64,64,64}, fontSize=0),
        Text(extent={{22.977,19.785},{50.209,-4.043}}, textString="1", textColor={64,64,64}, fontSize=0),
        Line(points={{-65.527,8.722},{-55.315,8.722}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{54.464,8.722},{67.229,8.722}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-46.805,-28.722},{1.702,-28.722}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Ellipse(extent={{12.765,-57.656},{51.911,-18.51}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{32.338,-25.3605},{32.338,-38.083},{43.1031,-43.9549}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Text(extent={{-54.464,-50.848},{-0.851,-72.123}}, textString="FIFO", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Inline=false,Documentation(info="<html><p>Advance the request queue and retained response-delay history from the supplied previous state. Valid rising edges are paired in first-in, first-out order. A request is admitted before a response at the same instant, and a response at its deadline is accepted.</p><p>Queue capacity and retained-delay capacity are checked separately; exceeding either latches <code>overflow</code>. At closing, an outstanding request is timed out only if its deadline lies before <code>windowStop</code> and has been observed. Remaining requests are censored. The caller supplies correctly sized arrays and the observation-window state.</p></html>"));
end AdvanceFIFO;
