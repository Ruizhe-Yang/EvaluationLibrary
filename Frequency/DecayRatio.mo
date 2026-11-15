within EvaluationLibrary.Frequency;
block DecayRatio "Measure attenuation across qualified positive sampled peaks"
  parameter String metricId=getInstanceName() "Stable metric identity";
  parameter String requirementId="" "Requirement identity; empty for a statistic";
  parameter String requirementVersion="" "Interpreted requirement version";
  parameter String unitName="1" "Engineering unit of the reported value";
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime "Fixed-time or first externally gated observation window";
  parameter Modelica.Units.SI.Time windowStart=0 "Inclusive observation start in seconds";
  parameter Modelica.Units.SI.Time windowStop=5 "Exclusive observation stop in seconds";
  parameter Boolean applicable=true "Whether this evaluation applies";
  parameter Boolean useValidInput=false "Expose the host-provided validity connector";

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Positive uniform sampling interval in seconds";
  parameter Modelica.Units.SI.Time sampleStart=0 "Uniform sample grid origin in seconds";
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "Host declares the observed inputs valid" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle "External observation gate; only the first contiguous interval is accepted" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus "Evidence qualification independent of requirement verdict";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement decision independent of observation completeness";
  output Boolean complete "Collection has closed; inspect DataStatus before assuming full evidence";
  output Boolean everViolated "A qualified violation witness exists";
  output Modelica.Units.SI.Time firstViolationTime "First qualified violation instant; meaningful only when everViolated";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Complete directly reportable evidence result" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));

  parameter Real peakFloor(min=0)=1e-8 "Minimum eligible oscillation peak magnitude";
  parameter Real growthTolerance(min=0)=1e-5 "Numerical tolerance for increasing peak envelopes";
    Modelica.Blocks.Interfaces.RealInput u "Observed real signal in the declared engineering unit" annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  output Integer peakCount(start=0,fixed=true) "Peak count";
  output Real ratio "Ratio";
  output Real logarithmicDecrement "Logarithmic decrement";
  Modelica.Blocks.Interfaces.RealOutput value "Numerical metric; meaningful only when available" annotation(Placement(transformation(origin={100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "The numerical output exists in the current data domain" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Trusted" annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "External window" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=true,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Gate";
  Boolean dataOK "Data ok";
  Boolean violationNow "Violation now";
  discrete Real secondLast(start=0,fixed=true) "Second last";
  discrete Real last(start=0,fixed=true) "Last";
  discrete Integer seen(start=0,fixed=true) "Seen";
  discrete Real previousPeak(start=0,fixed=true) "Previous peak";
  discrete Real ratioSum(start=0,fixed=true) "Ratio sum";
  discrete Real logSum(start=0,fixed=true) "Log sum";
  discrete Boolean grew(start=false,fixed=true) "Grew";
initial equation
  assert(peakFloor>0 and growthTolerance>=0,"Invalid peak thresholds.");
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted and abs(u)<Modelica.Constants.inf;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=grew;
  violationNow=(if true then gate.sampleInWindow else gate.inWindow) and dataOK and (false);
  when {initial(),violationNow} then
    everViolated=(not initial() and pre(everViolated)) or violationNow;
    firstViolationTime=if violationNow and (initial() or not pre(everViolated)) then time
      else if initial() then 0 else pre(firstViolationTime);
  end when;
  dataStatus=gate.status;
  verdict=EvaluationLibrary.Utilities.Functions.ToVerdict(dataStatus,everViolated,false);
  complete=gate.complete;
  result.value=value;
  result.valueAvailable=available and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  result.dataStatus=Integer(dataStatus);
  result.verdict=Integer(verdict);
  result.everViolated=everViolated;
  result.firstViolationTime=firstViolationTime;
  result.validDuration=gate.validDuration;
  result.expectedSamples=gate.expectedSamples;
  result.receivedSamples=gate.receivedSamples;
  result.validSamples=gate.validSamples;
  result.metricId=metricId;
  result.requirementId=requirementId;
  result.requirementVersion=requirementVersion;
  result.unit=unitName;
  result.windowStart=gate.actualStart;
  result.windowStop=gate.actualStop;
  result.observedDuration=gate.observedDuration;
  result.samplePeriod=if gate.sampled then samplePeriod else 0;
  result.evidenceKind=Integer(EvaluationLibrary.Utilities.Types.EvidenceKind.Sampled);
  result.message=EvaluationLibrary.Utilities.Functions.EvidenceMessage(result.dataStatus,result.verdict,result.valueAvailable);
  result.eventCountsAvailable=false; result.eventCount=0;
  result.matchedCount=0;
  result.timedOutCount=0;
  result.censoredCount=0;
  result.levelAvailable=false;
  result.level=0;
  result.level0Upper=0;
  result.level1Upper=0;
  result.complete=complete;

  available=peakCount>=3 and not grew and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.INVALID and dataStatus<>EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE;
  ratio=if available then ratioSum/(peakCount-1) else 0;
  logarithmicDecrement=if available then logSum/(peakCount-1) else 0;
  value=ratio;
algorithm

  when gate.tick and gate.sampleInWindow and dataOK then
    if seen>=2 and last>peakFloor and last>secondLast and last>=u then
      if peakCount>0 then
        grew:=pre(grew) or last>previousPeak*(1+growthTolerance);
        ratioSum:=pre(ratioSum)+last/previousPeak;
        logSum:=pre(logSum)+log(previousPeak/last);
      end if;
      peakCount:=pre(peakCount)+1;
      previousPeak:=last;
    end if;
    secondLast:=last;
    last:=u;
    seen:=pre(seen)+1;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,0},{64,0}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Line(points={{-56,0},{-55.0667,6.9637},{-54.1333,13.6077},{-53.2,19.7763},{-52.2667,25.3286},{-51.3333,30.1421},{-50.4,34.1147},{-49.4667,37.1672},{-48.5333,39.2446},{-47.6,40.317},{-46.6667,40.3798},{-45.7333,39.4529},{-44.8,37.5803},{-43.8667,34.8281},{-42.9333,31.2826},{-42,27.0473},{-41.0667,22.241},{-40.1333,16.9933},{-39.2,11.4421},{-38.2667,5.72997},{-37.3333,4.43738e-15},{-36.4,-5.60716},{-35.4667,-10.9569},{-34.5333,-15.9238},{-33.6,-20.3946},{-32.6667,-24.2704},{-31.7333,-27.4691},{-30.8,-29.9269},{-29.8667,-31.5997},{-28.9333,-32.4632},{-28,-32.5137},{-27.0667,-31.7674},{-26.1333,-30.2596},{-25.2,-28.0436},{-24.2667,-25.1887},{-23.3333,-21.7785},{-22.4,-17.9084},{-21.4667,-13.6829},{-20.5333,-9.2132},{-19.6,-4.61377},{-18.6667,-7.14594e-15},{-17.7333,4.51488},{-16.8,8.82248},{-15.8667,12.8218},{-14.9333,16.4217},{-14,19.5424},{-13.0667,22.118},{-12.1333,24.0971},{-11.2,25.444},{-10.2667,26.1393},{-9.33333,26.18},{-8.4,25.5791},{-7.46667,24.365},{-6.53333,22.5806},{-5.6,20.2819},{-4.66667,17.536},{-3.73333,14.4198},{-2.8,11.0175},{-1.86667,7.41845},{-0.933333,3.715},{0,8.63084e-15},{0.933333,-3.63537},{1.86667,-7.10385},{2.8,-10.3241},{3.73333,-13.2227},{4.66667,-15.7355},{5.6,-17.8094},{6.53333,-19.403},{7.46667,-20.4875},{8.4,-21.0473},{9.33333,-21.0801},{10.2667,-20.5962},{11.2,-19.6187},{12.1333,-18.1819},{13.0667,-16.3309},{14,-14.12},{14.9333,-11.6108},{15.8667,-8.87126},{16.8,-5.97332},{17.7333,-2.99131},{18.6667,-9.26605e-15},{19.6,2.92719},{20.5333,5.72001},{21.4667,8.31297},{22.4,10.6469},{23.3333,12.6702},{24.2667,14.3401},{25.2,15.6232},{26.1333,16.4965},{27.0667,16.9473},{28,16.9737},{28.9333,16.584},{29.8667,15.7969},{30.8,14.64},{31.7333,13.1496},{32.6667,11.3694},{33.6,9.349},{34.5333,7.14312},{35.4667,4.80971},{36.4,2.4086},{37.3333,9.32626e-15},{38.2667,-2.35697},{39.2,-4.60574},{40.1333,-6.69359},{41.0667,-8.57287},{42,-10.2021},{42.9333,-11.5466},{43.8667,-12.5798},{44.8,-13.2829},{45.7333,-13.6459},{46.6667,-13.6672},{47.6,-13.3534},{48.5333,-12.7196},{49.4667,-11.7881},{50.4,-10.5881},{51.3333,-9.15459},{52.2667,-7.5278},{53.2,-5.75163},{54.1333,-3.87277},{55.0667,-1.9394},{56,-9.01139e-15}}, color={0,0,127}, thickness=0.95, pattern=LinePattern.Solid),
        Ellipse(extent={{-50.1667,36.8798},{-43.1667,43.8798}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{-12.8333,22.68},{-5.83333,29.68}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Ellipse(extent={{24.5,13.4737},{31.5,20.4737}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45),
        Line(points={{-46.6667,40.3798},{-9.33333,26.18},{28,16.9737}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Dash),
        Text(extent={{-65,-50},{65,-75}}, textString="mean peak ratio", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Detect finite sampled oscillation peaks above peakFloor, default 1e-8 in the input unit, and compare successive peak magnitudes. growthTolerance defaults to 1e-5. Insufficient eligible peaks leave the estimate unavailable. The value describes the observed sampled envelope rather than proving a continuous asymptotic stability rate.</p><p>The default fixed observation is [0,5) s. ExternalSingle instead observes only the first contiguous external gate; a later gate invalidates the history. useValidInput defaults to false; when enabled, false validity or nonfinite in-window data latch INVALID. Early normal termination or missing coverage is INCOMPLETE. DataStatus qualifies evidence independently of Verdict. Numeric availability and violation witnesses must be inspected separately. Stable identity, unitName and optional requirement metadata originate here and travel directly with result to a writer.</p><p>The complete result connects directly to ConsoleWriter. Unavailable numeric values are guarded by valueAvailable; placeholder storage is not evidence. Unit metadata must match the actual input interpretation. A complete descriptive statistic does not automatically have a SATISFIED requirement verdict.</p></html>"));
end DecayRatio;
