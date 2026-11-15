within EvaluationLibrary.Statistics;
block SignalAssessment "Assess related signals with one observation window and one sample clock"
 parameter Integer n(min=1)=1 "Number of independently interpreted channels";
 parameter String metricId[n]={"signal"+String(i) for i in 1:n} "Stable channel metric IDs";
 parameter String requirementId[n]=metricId "Channel requirement IDs";
 parameter String requirementVersion[n]=fill("1",n) "Interpreted requirement versions";
 parameter String unitName[n]=fill("1",n) "Engineering unit of each interpreted channel";
 parameter EvaluationLibrary.Utilities.Types.InputInterpretation interpretation[n]=fill(EvaluationLibrary.Utilities.Types.InputInterpretation.SignedValue,n) "Absolute, signed, difference, or radian wrapped difference";
 parameter EvaluationLibrary.Utilities.Types.AssessmentDirection direction[n]=fill(EvaluationLibrary.Utilities.Types.AssessmentDirection.WithinBand,n) "Inclusive band or one-sided acceptance";
 parameter Real reference[n]=zeros(n) "Per-channel reference in the original engineering unit";
 parameter Real lower[n]=fill(-1,n) "Inclusive lower acceptance bound";
 parameter Real upper[n]=fill(1,n) "Inclusive upper acceptance bound";
 parameter Modelica.Units.SI.Time windowStart=0 "Inclusive shared start";
 parameter Modelica.Units.SI.Time windowStop=5 "Exclusive shared stop";
 parameter Boolean applicable=true "Whether this assessment applies";
 parameter Boolean useValidInput=false "Expose one shared host validity condition";
 parameter Boolean sampled=false "Check bounds only at ticks; false uses continuous event inequalities";
 parameter Modelica.Units.SI.Time samplePeriod(min=Modelica.Constants.small)=0.01 "Shared extrema and optional judgment grid spacing";
 parameter Modelica.Units.SI.Time sampleStart=0 "Shared grid origin";
 parameter Integer minimumSamples(min=1)=1 "Minimum finite observations for each sampled extremum";
 parameter Boolean classifySeverity[n]=fill(false,n) "Report case-specific sampled Level 0, 1 or 2";
 parameter Real level0Upper[n]=fill(0.1,n) "Inclusive absolute-error upper bound for Level 0";
 parameter Real level1Upper[n]=fill(1,n) "Inclusive absolute-error upper bound for Level 1; larger values are Level 2";
 Modelica.Blocks.Interfaces.RealInput u[n] "Observed signals; this block cannot intervene in the host" annotation(Placement(transformation(extent={{-110,-10},{-90,10}}),iconTransformation(extent={{-110,-10},{-90,10}})));
 Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "Shared host validity" annotation(Placement(transformation(extent={{-10,90},{10,110}}),iconTransformation(extent={{-10,90},{10,110}})));
 EvaluationLibrary.Utilities.Interfaces.MetricOutput y[n] "One complete independent result per channel" annotation(Placement(transformation(extent={{90,-10},{110,10}}),iconTransformation(extent={{90,-10},{110,10}})));
 output Real evaluated[n] "Interpreted signals before reduction";
 output Real minimum[n](each start=0,each fixed=true) "Sampled minimum; see validSamples";
 output Real maximum[n](each start=0,each fixed=true) "Sampled maximum; see validSamples";
 output Real maximumAbsolute[n](each start=0,each fixed=true) "Sampled maximum absolute interpreted value";
 output Modelica.Units.SI.Time violationDuration[n](each start=0,each fixed=true) "Continuous violation duration; unavailable in sampled judgment mode";
 output Boolean violationDurationAvailable=not sampled "Whether violationDuration has a continuous-time interpretation";
protected
 Modelica.Blocks.Interfaces.BooleanInput trusted "Trusted";
 EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowStart=windowStart,windowStop=windowStop,sampled=true,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Gate";
 Boolean finite[n] "Finite";
 Boolean bad[n] "Bad";
 Boolean failing[n] "Failing";
 Boolean violation[n] "Violation";
 discrete Boolean invalidSeen[n](each start=false,each fixed=true) "Invalid seen";
 discrete Boolean violated[n](each start=false,each fixed=true) "Violated";
 discrete Real firstViolation[n](each start=0,each fixed=true) "First violation";
 discrete Integer samples[n](each start=0,each fixed=true) "Samples";
 Real validTime[n](each start=0,each fixed=true) "Valid time";
 EvaluationLibrary.Utilities.Types.DataStatus status[n] "Status";
 EvaluationLibrary.Utilities.Types.Verdict verdict[n] "Requirement decision independent of observation completeness";
equation
 connect(valid,trusted);
 if not useValidInput then trusted=true; end if;
 gate.rawWindow=false; gate.dataOK=trusted; gate.overflow=false;
 for i in 1:n loop
   evaluated[i]=if interpretation[i]==EvaluationLibrary.Utilities.Types.InputInterpretation.AbsoluteValue then abs(u[i]) elseif interpretation[i]==EvaluationLibrary.Utilities.Types.InputInterpretation.SignedValue then u[i] elseif interpretation[i]==EvaluationLibrary.Utilities.Types.InputInterpretation.Difference then u[i]-reference[i] else Modelica.Math.atan2(sin(u[i]-reference[i]),cos(u[i]-reference[i]));
   finite[i]=abs(u[i])<Modelica.Constants.inf and abs(evaluated[i])<Modelica.Constants.inf;
   bad[i]=gate.inWindow and (not trusted or not finite[i]);
   failing[i]=if direction[i]==EvaluationLibrary.Utilities.Types.AssessmentDirection.UpperBound then evaluated[i]>upper[i] elseif direction[i]==EvaluationLibrary.Utilities.Types.AssessmentDirection.LowerBound then evaluated[i]<lower[i] else evaluated[i]<lower[i] or evaluated[i]>upper[i];
   violation[i]=gate.inWindow and trusted and finite[i] and failing[i] and (if sampled then gate.tick and gate.sampleInWindow else true);
   der(validTime[i])=if gate.inWindow and trusted and finite[i] then 1 else 0;
   der(violationDuration[i])=if not sampled and gate.inWindow and trusted and finite[i] and failing[i] then 1 else 0;
   status[i]=if not applicable then EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE elseif invalidSeen[i] or gate.status==EvaluationLibrary.Utilities.Types.DataStatus.INVALID then EvaluationLibrary.Utilities.Types.DataStatus.INVALID elseif not gate.complete then EvaluationLibrary.Utilities.Types.DataStatus.PENDING elseif gate.status<>EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE or samples[i]<minimumSamples or samples[i]<>gate.expectedSamples then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE;
   verdict[i]=EvaluationLibrary.Utilities.Functions.ToVerdict(status[i],violated[i],true);
   y[i].metricId=metricId[i]; y[i].requirementId=requirementId[i]; y[i].requirementVersion=requirementVersion[i]; y[i].unit=unitName[i];
   y[i].value=if direction[i]==EvaluationLibrary.Utilities.Types.AssessmentDirection.LowerBound then minimum[i] elseif interpretation[i]==EvaluationLibrary.Utilities.Types.InputInterpretation.WrappedAngleDifference then maximumAbsolute[i] else maximum[i];
   y[i].valueAvailable=samples[i]>0 and status[i]<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and applicable;
   y[i].dataStatus=Integer(status[i]); y[i].verdict=Integer(verdict[i]); y[i].complete=gate.complete;
   y[i].windowStart=gate.actualStart; y[i].windowStop=gate.actualStop; y[i].observedDuration=gate.observedDuration; y[i].validDuration=validTime[i];
   y[i].expectedSamples=gate.expectedSamples; y[i].receivedSamples=gate.receivedSamples; y[i].validSamples=samples[i];
   y[i].everViolated=violated[i]; y[i].firstViolationTime=firstViolation[i]; y[i].samplePeriod=samplePeriod;
   y[i].evidenceKind=if sampled then 2 else 4;
   y[i].eventCountsAvailable=false; y[i].eventCount=0; y[i].matchedCount=0; y[i].timedOutCount=0; y[i].censoredCount=0;
   y[i].levelAvailable=classifySeverity[i] and y[i].valueAvailable;
   y[i].level=if maximumAbsolute[i]<=level0Upper[i] then 0 elseif maximumAbsolute[i]<=level1Upper[i] then 1 else 2;
   y[i].level0Upper=level0Upper[i]; y[i].level1Upper=level1Upper[i];
   y[i].message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(y[i].dataStatus,y[i].verdict,y[i].valueAvailable)+(if sampled then "; sampled extrema and sampled bounds" else "; sampled extrema; continuous event-based bounds");
 end for;
initial equation
 assert(windowStop>windowStart and samplePeriod>0 and minimumSamples>=1,"Invalid shared window or sample grid.");
 for i in 1:n loop
   assert((direction[i]<>EvaluationLibrary.Utilities.Types.AssessmentDirection.WithinBand or lower[i]<=upper[i]) and abs(lower[i])<Modelica.Constants.inf and abs(upper[i])<Modelica.Constants.inf and abs(reference[i])<Modelica.Constants.inf,"Channel bounds and reference must be finite; two-sided bands must be ordered.");
   assert(not classifySeverity[i] or (level0Upper[i]>=0 and level1Upper[i]>=level0Upper[i]),"Severity bounds must be nonnegative and ordered.");
 end for;
algorithm
 when {initial(),gate.tick,sum({if change(bad[i]) or change(violation[i]) then 1 else 0 for i in 1:n})>0} then
   for i in 1:n loop
     invalidSeen[i]:=pre(invalidSeen[i]) or bad[i];
     if violation[i] and not pre(violated[i]) then firstViolation[i]:=time; end if;
     violated[i]:=pre(violated[i]) or violation[i];
     if gate.tick and gate.sampleInWindow and trusted and finite[i] then
       minimum[i]:=if pre(samples[i])==0 then evaluated[i] else min(pre(minimum[i]),evaluated[i]);
       maximum[i]:=if pre(samples[i])==0 then evaluated[i] else max(pre(maximum[i]),evaluated[i]);
       maximumAbsolute[i]:=if pre(samples[i])==0 then abs(evaluated[i]) else max(pre(maximumAbsolute[i]),abs(evaluated[i]));
       samples[i]:=pre(samples[i])+1;
     end if;
   end for;
 end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Ellipse(extent={{-72,54},{-52,74}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Line(points={{-62,71},{-62,64},{-56.5,60.5}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{-44,65},{-44,73},{29,73},{29,65}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-72,38},{-49,38}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Rectangle(extent={{-46,27},{31,49}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-43,42},{-28,34},{-13,43},{2,38},{17,35},{28,42}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{34,38},{48,38}}, color={0,0,127}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Rectangle(extent={{52,26},{75,50}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55, radius=0),
        Line(points={{57,43},{70,43}}, color={0,0,127}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{57,38},{70,38}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{57,33},{65,33}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-72,1},{-49,1}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Rectangle(extent={{-46,-10},{31,12}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-43,-3},{-28,5},{-13,-4},{2,1},{17,4},{28,-3}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{34,1},{48,1}}, color={0,0,127}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Rectangle(extent={{52,-11},{75,13}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55, radius=0),
        Line(points={{57,6},{70,6}}, color={0,0,127}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{57,1},{70,1}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{57,-4},{65,-4}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{-72,-36},{-49,-36}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Rectangle(extent={{-46,-47},{31,-25}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-43,-32},{-28,-40},{-13,-31},{2,-36},{17,-39},{28,-32}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{34,-36},{48,-36}}, color={0,0,127}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Rectangle(extent={{52,-48},{75,-24}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55, radius=0),
        Line(points={{57,-31},{70,-31}}, color={0,0,127}, thickness=0.65, pattern=LinePattern.Solid),
        Line(points={{57,-36},{70,-36}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Line(points={{57,-41},{65,-41}}, color={128,128,128}, thickness=0.55, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="[n]", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),Documentation(info="<html><p>Assess related channels without combining unlike units. AbsoluteValue uses abs(u); SignedValue uses u; Difference uses u-reference; WrappedAngleDifference uses atan2(sin(u-reference),cos(u-reference)) in radians. Band bounds are inclusive. A channel may fail independently of other channels.</p><p>The single clock reports sampled minima and maxima; these are never continuous strict extrema. With sampled=false, bound crossings and violation duration are evaluated continuously through Modelica events, between reporting ticks. With sampled=true only tick observations decide bounds and violationDurationAvailable is false. A valid=false interval invalidates the evidence history; a nonfinite channel invalidates that channel. Normal termination before the exclusive stop yields INCOMPLETE, never SATISFIED without coverage. The sample grid is [windowStart,windowStop); minimumSamples also applies.</p><p>Optional Level 0/1/2 classification uses the largest sampled absolute interpreted value: equality belongs to the lower level. Thresholds, raw interpreted values, extrema, numeric availability and verdict remain inspectable. These are case-specific engineering categories, not certification levels. Connect y directly to ConsoleWriter.u.</p></html>"));
end SignalAssessment;
