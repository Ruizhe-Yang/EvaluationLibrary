within EvaluationLibrary.Response;
block EventAssessment "Evaluate related event tasks with one window and explicit feedback"
 parameter Integer n(min=1)=1 "Number of independent event tasks";
 parameter String metricId[n]={"event"+String(i) for i in 1:n} "Stable metric identities";
 parameter String requirementId[n]=metricId "Requirement identities";
 parameter String requirementVersion[n]=fill("1",n) "Requirement versions";
 parameter EvaluationLibrary.Utilities.Types.EventMode mode[n]=fill(EvaluationLibrary.Utilities.Types.EventMode.RequestResponse,n) "Occurrence, FIFO request-response, or recovery";
 parameter EvaluationLibrary.Utilities.Types.EventRole role[n]=fill(EvaluationLibrary.Utilities.Types.EventRole.Observation,n) "Descriptive event role, retained in explanations";
 parameter Modelica.Units.SI.Time windowStart=0 "Inclusive shared observation start";
 parameter Modelica.Units.SI.Time windowStop=5 "Exclusive shared observation stop";
 parameter Boolean applicable=true "Whether this task set applies";
 parameter Boolean useValidInput=false "Expose shared host validity";
 parameter Modelica.Units.SI.Time deadline[n]=fill(0.2,n) "Maximum allowed request-response delay, inclusive";
 parameter Integer capacity(min=1)=32 "Maximum queued requests per task";
 parameter Modelica.Units.SI.Time recoveryDwell[n]=fill(0.2,n) "Required uninterrupted valid time in the recovery band";
 parameter Boolean useRecoverySignal=false "Use a real signal and internal band test for recovery tasks";
 parameter Real recoveryReference[n]=zeros(n) "Center of each recovery band";
 parameter Real recoveryTolerance[n]=fill(0.1,n) "Inclusive absolute recovery band radius";
 Modelica.Blocks.Interfaces.BooleanInput request[n] "Observed event, protection request, or danger indication" annotation(Placement(transformation(extent={{-110,40},{-90,60}}),iconTransformation(extent={{-110,40},{-90,60}})));
 Modelica.Blocks.Interfaces.BooleanInput response[n] "Actual action feedback; recovery-band state if useRecoverySignal=false" annotation(Placement(transformation(extent={{-110,-60},{-90,-40}}),iconTransformation(extent={{-110,-60},{-90,-40}})));
 Modelica.Blocks.Interfaces.RealInput recoverySignal[n] if useRecoverySignal "Observed recovery signal; never a command" annotation(Placement(transformation(extent={{-110,-10},{-90,10}}),iconTransformation(extent={{-110,-10},{-90,10}})));
 Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "Shared observation validity" annotation(Placement(transformation(extent={{-10,90},{10,110}}),iconTransformation(extent={{-10,90},{10,110}})));
 EvaluationLibrary.Utilities.Interfaces.MetricOutput y[n] "Complete results including counts and witnesses" annotation(Placement(transformation(extent={{90,-10},{110,10}}),iconTransformation(extent={{90,-10},{110,10}})));
 output Integer eventCount[n](each start=0,each fixed=true) "Qualified request/event rising edges";
 output Real firstEventTime[n](each start=0,each fixed=true) "First event instant; present only when eventCount>0";
 output Integer matched[n](each start=0,each fixed=true) "FIFO pairs or confirmed recovery";
 output Integer timedOut[n](each start=0,each fixed=true) "Observed expired requests";
 output Integer censored[n](each start=0,each fixed=true) "Requests lacking complete follow-up";
 output Integer unmatchedResponse[n](each start=0,each fixed=true) "Response edges without a queued request";
 output Real maximumDelay[n](each start=0,each fixed=true) "Largest matched delay";
 output Boolean recovered[n](each start=false,each fixed=true) "A full uninterrupted recovery dwell was observed";
protected
 Real validTime[n](each start=0,each fixed=true) "Independent finite valid duration per event task";
 Modelica.Blocks.Interfaces.BooleanInput trusted "Trusted";
 EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowStart=windowStart,windowStop=windowStop,sampled=false,applicable=applicable) "Gate";
 Boolean inBand[n] "In band";
 Boolean inDwell[n] "In dwell";
 Boolean dwellComplete[n] "Dwell complete";
 Boolean expired[n] "Expired";
 Boolean dataOK[n] "Data ok";
 discrete Boolean invalidSeen[n](each start=false,each fixed=true) "Invalid seen";
 discrete Boolean overflow[n](each start=false,each fixed=true) "Overflow";
 discrete Integer queued[n](each start=0,each fixed=true) "Queued";
 discrete Real timestamps[n,capacity](each start=0,each fixed=true) "Timestamps";
 discrete Real delaySum[n](each start=0,each fixed=true) "Delay sum";
 discrete Real firstMissed[n](each start=0,each fixed=true) "First missed";
 discrete Real dwellStart[n](each start=0,each fixed=true) "Dwell start";
 discrete Real recoveryDelay[n](each start=0,each fixed=true) "Recovery delay";
 EvaluationLibrary.Utilities.Types.DataStatus status[n] "Status";
 EvaluationLibrary.Utilities.Types.Verdict verdict[n] "Requirement decision independent of observation completeness";
 Boolean violated[n] "Violated";
equation
 connect(valid,trusted);
 if not useValidInput then trusted=true; end if;
 gate.rawWindow=false; gate.dataOK=trusted; gate.overflow=false;
 for i in 1:n loop
   if useRecoverySignal then
     inBand[i]=abs(recoverySignal[i]-recoveryReference[i])<=recoveryTolerance[i];
     dataOK[i]=trusted and (mode[i]<>EvaluationLibrary.Utilities.Types.EventMode.Recovery or abs(recoverySignal[i])<Modelica.Constants.inf);
   else
     inBand[i]=response[i]; dataOK[i]=trusted;
   end if;
   der(validTime[i])=if gate.inWindow and dataOK[i] then 1 else 0;
   inDwell[i]=mode[i]==EvaluationLibrary.Utilities.Types.EventMode.Recovery and gate.inWindow and dataOK[i] and pre(eventCount[i])>0 and not request[i] and inBand[i];
   dwellComplete[i]=pre(inDwell[i]) and inDwell[i] and time>=pre(dwellStart[i])+recoveryDwell[i];
   expired[i]=pre(queued[i])>0 and time>=pre(timestamps[i,1])+deadline[i];
   violated[i]=timedOut[i]>0 or (mode[i]==EvaluationLibrary.Utilities.Types.EventMode.Recovery and gate.complete and eventCount[i]>0 and not recovered[i]);
   status[i]=if not applicable then EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE elseif invalidSeen[i] or overflow[i] or gate.status==EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.DataStatus.INVALID elseif not gate.complete then EvaluationLibrary.Utilities.Types.DataStatus.PENDING elseif mode[i]<>EvaluationLibrary.Utilities.Types.EventMode.Occurrence and eventCount[i]==0 and gate.status==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE then EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE elseif gate.status<>EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE or censored[i]>0 then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE;
   verdict[i]=EvaluationLibrary.Utilities.Functions.ToVerdict(status[i],violated[i],mode[i]<>EvaluationLibrary.Utilities.Types.EventMode.Occurrence);
   y[i].metricId=metricId[i]; y[i].requirementId=requirementId[i]; y[i].requirementVersion=requirementVersion[i];
   y[i].unit=if mode[i]==EvaluationLibrary.Utilities.Types.EventMode.Occurrence then "1" else "s";
   y[i].value=if mode[i]==EvaluationLibrary.Utilities.Types.EventMode.Occurrence then eventCount[i] elseif mode[i]==EvaluationLibrary.Utilities.Types.EventMode.Recovery then recoveryDelay[i] else if matched[i]>0 then delaySum[i]/matched[i] else 0;
   y[i].valueAvailable=(if mode[i]==EvaluationLibrary.Utilities.Types.EventMode.Occurrence then gate.observedDuration>0 else matched[i]>0) and status[i]<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and status[i]<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
   y[i].dataStatus=Integer(status[i]); y[i].verdict=Integer(verdict[i]); y[i].complete=gate.complete;
   y[i].windowStart=gate.actualStart; y[i].windowStop=gate.actualStop; y[i].observedDuration=gate.observedDuration; y[i].validDuration=validTime[i];
   y[i].expectedSamples=0; y[i].receivedSamples=0; y[i].validSamples=0;
   y[i].everViolated=violated[i]; y[i].firstViolationTime=if timedOut[i]>0 then firstMissed[i] elseif violated[i] then windowStop else 0;
   y[i].samplePeriod=0; y[i].evidenceKind=3;
   y[i].eventCountsAvailable=validTime[i]>0 or eventCount[i]>0; y[i].eventCount=eventCount[i]; y[i].matchedCount=matched[i]; y[i].timedOutCount=timedOut[i]; y[i].censoredCount=censored[i];
   y[i].levelAvailable=false; y[i].level=0; y[i].level0Upper=0; y[i].level1Upper=0;
   y[i].message=(if overflow[i] then "Queue capacity exceeded; event history is invalid" elseif censored[i]>0 then "Request follow-up is censored by the observation boundary or an invalid gap" elseif timedOut[i]>0 then "No actual response by the requested deadline" elseif mode[i]==EvaluationLibrary.Utilities.Types.EventMode.Recovery and violated[i] then "The recovery-band dwell was not completed" elseif status[i]==EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE then "Not demanded: no qualified request or danger" else EvaluationLibrary.Utilities.Functions.EvidenceMessage(y[i].dataStatus,y[i].verdict,y[i].valueAvailable))+"; role="+String(role[i])+"; "+String(mode[i]);
 end for;
initial equation
 assert(windowStop>windowStart and capacity>=1,"Invalid event window or queue capacity.");
 for i in 1:n loop
   assert(deadline[i]>=0 and deadline[i]<Modelica.Constants.inf and recoveryDwell[i]>=0 and recoveryDwell[i]<Modelica.Constants.inf and recoveryTolerance[i]>=0 and recoveryTolerance[i]<Modelica.Constants.inf and abs(recoveryReference[i])<Modelica.Constants.inf,"Negative deadline, dwell or recovery tolerance.");
 end for;
algorithm
 when {initial(),gate.inWindow,gate.complete,sum({if change(request[i]) or change(response[i]) or change(expired[i]) or change(dataOK[i]) or change(inDwell[i]) or change(dwellComplete[i]) then 1 else 0 for i in 1:n})>0} then
   for i in 1:n loop
     if gate.inWindow and not dataOK[i] then
       invalidSeen[i]:=true;
       censored[i]:=censored[i]+queued[i]; queued[i]:=0;
     end if;
     if gate.inWindow and dataOK[i] then
       while mode[i]==EvaluationLibrary.Utilities.Types.EventMode.RequestResponse and queued[i]>0 and timestamps[i,1]+deadline[i]<time-1e-10 loop
         if timedOut[i]==0 then firstMissed[i]:=timestamps[i,1]+deadline[i]; end if;
         timedOut[i]:=timedOut[i]+1;
         for j in 1:queued[i]-1 loop timestamps[i,j]:=timestamps[i,j+1]; end for;
         queued[i]:=queued[i]-1;
       end while;
       if request[i] and (initial() or not pre(request[i])) then
         if eventCount[i]==0 then firstEventTime[i]:=time; end if;
         eventCount[i]:=eventCount[i]+1;
         if mode[i]==EvaluationLibrary.Utilities.Types.EventMode.RequestResponse then
           if queued[i]>=capacity then overflow[i]:=true;
           else queued[i]:=queued[i]+1; timestamps[i,queued[i]]:=time; end if;
         end if;
       end if;
       if mode[i]==EvaluationLibrary.Utilities.Types.EventMode.RequestResponse and response[i] and (initial() or not pre(response[i])) then
         if queued[i]==0 then unmatchedResponse[i]:=unmatchedResponse[i]+1;
         else
           matched[i]:=matched[i]+1;
           delaySum[i]:=delaySum[i]+time-timestamps[i,1]; maximumDelay[i]:=max(maximumDelay[i],time-timestamps[i,1]);
           for j in 1:queued[i]-1 loop timestamps[i,j]:=timestamps[i,j+1]; end for;
           queued[i]:=queued[i]-1;
         end if;
       end if;
       while mode[i]==EvaluationLibrary.Utilities.Types.EventMode.RequestResponse and queued[i]>0 and timestamps[i,1]+deadline[i]<=time+1e-10 loop
         if timedOut[i]==0 then firstMissed[i]:=timestamps[i,1]+deadline[i]; end if;
         timedOut[i]:=timedOut[i]+1;
         for j in 1:queued[i]-1 loop timestamps[i,j]:=timestamps[i,j+1]; end for;
         queued[i]:=queued[i]-1;
       end while;
       if mode[i]==EvaluationLibrary.Utilities.Types.EventMode.Recovery then
         if inDwell[i] and (initial() or not pre(inDwell[i])) then dwellStart[i]:=time; end if;
         if dwellComplete[i] and not recovered[i] then
           recovered[i]:=true; matched[i]:=1; recoveryDelay[i]:=time-firstEventTime[i]; maximumDelay[i]:=recoveryDelay[i];
         end if;
       end if;
     elseif gate.complete and queued[i]>0 then
       for j in 1:queued[i] loop
         if timestamps[i,j]+deadline[i]<gate.actualStop and timestamps[i,j]+deadline[i]<=time then
           if timedOut[i]==0 then firstMissed[i]:=timestamps[i,j]+deadline[i]; end if;
           timedOut[i]:=timedOut[i]+1;
         else censored[i]:=censored[i]+1; end if;
       end for;
       queued[i]:=0;
     end if;
   end for;
 end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-63,53},{-63,64},{63,64},{63,53}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid),
        Text(extent={{-38,80},{38,64}}, textString="[t0,t1)", textColor={128,128,128}, fontSize=0),
        Line(points={{-70,27},{-70,-40}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-70,27},{-60,27}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-70,-5},{-60,-5}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-70,-37},{-60,-37}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-55,20},{-43,20},{-43,39},{-31,39},{-31,20},{5,20},{5,39},{17,39},{17,20},{58,20}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid),
        Ellipse(extent={{-45.4,17.6},{-40.6,22.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{2.6,17.6},{7.4,22.4}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Rectangle(extent={{-49,-14},{-29,5}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.6, radius=0),
        Rectangle(extent={{-24,-14},{-4,5}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.6, radius=0),
        Rectangle(extent={{1,-14},{21,5}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.6, radius=0),
        Line(points={{30,-5},{56,-5}}, color={0,0,127}, thickness=0.75, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-49,-21},{-49,-5},{-56,-5}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Rectangle(extent={{-54,-42},{60,-26}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.3, radius=0),
        Line(points={{-54,-34},{-40,-17},{-24,-40},{-5,-23},{13,-26},{21,-34},{58,-34}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid),
        Line(points={{13,-45},{13,-49},{58,-49},{58,-45}}, color={64,64,64}, thickness=0.6, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="events[n]", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),Documentation(info="<html><p>Use separate request and actual response inputs: issuing a protection command is not action feedback. Each task is an occurrence count, a finite FIFO of one-to-one request-response pairs, or recovery after the first danger. Roles are descriptive and cannot change the evidence rules. FirstEventTime is available only when eventCount is positive; counters and delays are delivered directly with every result.</p><p>The window is half open. Requests at a response instant are queued before responses; equality with a deadline is accepted. Older expired requests are removed first; responses cannot satisfy more than one request. A request with insufficient remaining window is censored. No demand yields NOT_APPLICABLE after a complete observation, not successful protection. Invalid intervals invalidate history and flush pending pairs, preventing evidence across the gap. Queue overflow is INVALID.</p><p>Recovery requires danger to cease and a contiguous valid dwell in the recovery band. With useRecoverySignal=true, the band test is internal and uses the finite real signal, reference and inclusive tolerance; otherwise response is the observed band state. Leaving the band or losing validity restarts the dwell. A danger without recovery by a complete window is VIOLATED. Event counts need no TimeMean or record-building intermediate.</p></html>"));
end EventAssessment;
