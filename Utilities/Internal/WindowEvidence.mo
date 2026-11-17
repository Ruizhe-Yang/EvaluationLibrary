within EvaluationLibrary.Utilities.Internal;
block WindowEvidence "Track one observation window and its data coverage"
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime "Fixed-time or first externally gated observation window";
  parameter Modelica.Units.SI.Time windowStart=0 "Inclusive observation start in seconds";
  parameter Modelica.Units.SI.Time windowStop=5 "Exclusive observation stop in seconds";
  parameter Boolean applicable=true "Whether this evaluation applies";
  parameter Boolean useValidInput=false "Does not change the unconditional dataOK input";

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Positive uniform sampling interval in seconds";
  parameter Modelica.Units.SI.Time sampleStart=0 "Uniform sample grid origin in seconds";

  parameter Boolean sampled=false "Use the declared sample grid rather than continuous event checking";
    Modelica.Blocks.Interfaces.BooleanInput rawWindow "External observation-window request" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput dataOK "Current input validity and numerical-domain condition" annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput overflow "Storage or event-queue capacity has been exceeded" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  output Boolean inWindow "The active observation window includes the current instant";
  output Boolean complete "Collection has closed; inspect DataStatus before assuming full evidence";
  output Boolean unexpectedWindow "An external window was opened more than once";
  output Boolean tick "Pulse from the configured uniform sample clock";
  output Boolean sampleInWindow "Current grid point belongs to the applicable window";
  output Modelica.Units.SI.Time actualStart "Configured or first externally observed window start";
  output Modelica.Units.SI.Time actualStop "Configured stop or observed external-window end";
  output Modelica.Units.SI.Time observedDuration(start=0,fixed=true) "Total time observed inside the window";
  output Modelica.Units.SI.Time validDuration(start=0,fixed=true) "Time observed with valid input inside the window";
  output Integer expectedSamples "Number of grid points in the declared window";
  output Integer receivedSamples(start=0,fixed=true) "Number of observed in-window grid ticks";
  output Integer validSamples(start=0,fixed=true) "Number of observed in-window ticks with valid data";
  output EvaluationLibrary.Utilities.Types.DataStatus status "Current observation qualification";
protected
  discrete Boolean entered(start=false,fixed=true) "An external window has been entered";
  discrete Boolean closed(start=false,fixed=true) "The first external window has closed";
  discrete Boolean secondWindow(start=false,fixed=true) "An additional external window has been requested";
  discrete Boolean terminalSeen(start=false,fixed=true) "Normal simulation termination has occurred";
  discrete Boolean invalidSeen(start=false,fixed=true) "Invalidity has been latched";
  discrete Modelica.Units.SI.Time startObserved(start=0,fixed=true) "First external-window entry time";
  discrete Modelica.Units.SI.Time stopObserved(start=0,fixed=true) "First external-window closing time";
  Boolean windowClosed "The selected observation window has closed";
  Boolean invalidNow "Input is invalid inside the observation window";
  Boolean fullCoverage "The closed window has sufficient duration and sample coverage";
  Integer gridIndex "Index of the nearest sample-grid point";
  Integer firstIndex "First eligible fixed-window grid index";
  Integer stopIndex "First excluded fixed-window grid index";
initial equation
  assert(windowStop>=windowStart,"Reversed evaluation window.");
  assert(samplePeriod>0,"Sample period must be positive.");
equation
  when {initial(),change(rawWindow)} then
    entered=(if initial() then false else pre(entered)) or rawWindow;
    closed=not initial() and (pre(closed) or (pre(entered) and not rawWindow));
    secondWindow=not initial() and (pre(secondWindow) or (rawWindow and pre(closed)));
    startObserved=if rawWindow and (initial() or not pre(entered)) then time else pre(startObserved);
    stopObserved=if not rawWindow and not initial() and pre(entered) and not pre(closed) then time else pre(stopObserved);
  end when;
  when terminal() then terminalSeen=true; end when;
  actualStart=if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.FixedTime then windowStart else startObserved;
  actualStop=if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.FixedTime then windowStop else if closed then stopObserved else if entered then time else 0;
  windowClosed=if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.FixedTime then time>=windowStop else closed;
  inWindow=applicable and (if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.FixedTime then time>=windowStart and time<windowStop else entered and not closed and rawWindow);
  complete=not applicable or windowClosed or terminalSeen;
  unexpectedWindow=windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle and secondWindow;
  invalidNow=inWindow and not dataOK;
  when {initial(),invalidNow,overflow,unexpectedWindow} then
    invalidSeen=(not initial() and pre(invalidSeen)) or invalidNow or overflow or unexpectedWindow;
  end when;
  der(observedDuration)=if inWindow then 1 else 0;
  der(validDuration)=if inWindow and dataOK then 1 else 0;
  tick=sampled and sample(sampleStart,samplePeriod);
  gridIndex=noEvent(integer(floor((time-sampleStart)/samplePeriod+0.5)));
  firstIndex=max(0,integer(ceil((windowStart-sampleStart)/samplePeriod-1e-9)));
  stopIndex=max(0,integer(ceil((windowStop-sampleStart)/samplePeriod-1e-9)));
  sampleInWindow=applicable and (if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.FixedTime then gridIndex>=firstIndex and gridIndex<stopIndex else inWindow);
  when tick then
    receivedSamples=pre(receivedSamples)+(if sampleInWindow then 1 else 0);
    validSamples=pre(validSamples)+(if sampleInWindow and dataOK then 1 else 0);
  end when;
  expectedSamples=if sampled then EvaluationLibrary.Utilities.Functions.SampleCount(actualStart,actualStop,sampleStart,samplePeriod) else 0;
  fullCoverage=windowClosed and actualStop>actualStart and observedDuration>=actualStop-actualStart-1e-7
    and (not sampled or (expectedSamples>0 and validSamples==expectedSamples));
  status=if not applicable then EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE elseif invalidSeen then EvaluationLibrary.Utilities.Types.DataStatus.INVALID
    elseif not complete then EvaluationLibrary.Utilities.Types.DataStatus.PENDING elseif fullCoverage then EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE else EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-67,47},{-43,47},{-43,68},{-25,68},{-25,47},{-8,47}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{0,69},{0,33}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-56,5},{-56,29},{56,29},{56,5}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid),
        Ellipse(extent={{-60,25},{-52,33}}, lineColor={64,64,64}, fillColor={64,64,64}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Ellipse(extent={{52,25},{60,33}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{-56,-8},{56,-8}}, color={128,128,128}, thickness=3, pattern=LinePattern.Solid),
        Line(points={{-56,-28},{16,-28}}, color={0,0,127}, thickness=3, pattern=LinePattern.Solid),
        Text(extent={{-65,-52},{65,-79}}, textString="window", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Use a fixed half-open interval or the first true interval of <code>rawWindow</code>, according to <code>windowMode</code>. An external window is accepted once; reopening it latches invalidity. Invalid input anywhere in the active window, or <code>overflow</code>, also latches invalidity.</p><p>Track total and valid durations and, when <code>sampled=true</code>, received and valid samples on the declared grid. <code>COMPLETE</code> requires a closed window of positive duration, full duration coverage and, for sampled evidence, every expected sample. <code>complete</code> also becomes true at normal termination; an unfinished observation is then <code>INCOMPLETE</code>.</p></html>"));
end WindowEvidence;
