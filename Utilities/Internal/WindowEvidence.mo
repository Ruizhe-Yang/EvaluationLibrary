within EvaluationLibrary.Utilities.Internal;
block WindowEvidence "Qualify the first requested window and track data coverage independently"
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime;
  parameter Modelica.Units.SI.Time windowStart=0;
  parameter Modelica.Units.SI.Time windowStop=5;
  parameter Boolean applicable=true;
  parameter Boolean useValidInput=false;

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01;
  parameter Modelica.Units.SI.Time sampleStart=0;

  parameter Boolean sampled=false;
    Modelica.Blocks.Interfaces.BooleanInput rawWindow annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput dataOK annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput overflow annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  output Boolean inWindow;
  output Boolean complete;
  output Boolean unexpectedWindow;
  output Boolean tick;
  output Boolean sampleInWindow;
  output Modelica.Units.SI.Time actualStart;
  output Modelica.Units.SI.Time actualStop;
  output Modelica.Units.SI.Time observedDuration(start=0,fixed=true);
  output Modelica.Units.SI.Time validDuration(start=0,fixed=true);
  output Integer expectedSamples;
  output Integer receivedSamples(start=0,fixed=true);
  output Integer validSamples(start=0,fixed=true);
  output EvaluationLibrary.Utilities.Types.DataStatus status;
protected
  discrete Boolean entered(start=false,fixed=true);
  discrete Boolean closed(start=false,fixed=true);
  discrete Boolean secondWindow(start=false,fixed=true);
  discrete Boolean terminalSeen(start=false,fixed=true);
  discrete Boolean invalidSeen(start=false,fixed=true);
  discrete Modelica.Units.SI.Time startObserved(start=0,fixed=true);
  discrete Modelica.Units.SI.Time stopObserved(start=0,fixed=true);
  Boolean windowClosed;
  Boolean invalidNow;
  Boolean fullCoverage;
  Integer gridIndex;
  Integer firstIndex;
  Integer stopIndex;
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
        Rectangle(extent={{-49,-24},{49,37}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-49,51},{-49,-37}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{49,51},{49,-37}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Ellipse(extent={{-42.5,5.5},{-35.5,12.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{-16.5,5.5},{-9.5,12.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{9.5,5.5},{16.5,12.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{35.5,5.5},{42.5,12.5}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Line(points={{20.75,-28},{29.3,-37},{45.95,-15.4}}, color={75,138,73}, thickness=1.5, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="[t0, t1)", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Qualify the first requested window and track data coverage independently.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput rawWindow; Modelica.Blocks.Interfaces.BooleanInput dataOK; Modelica.Blocks.Interfaces.BooleanInput overflow; output Boolean inWindow; output Boolean complete; output Boolean unexpectedWindow; output Boolean tick; output Boolean sampleInWindow; output Modelica.Units.SI.Time actualStart; output Modelica.Units.SI.Time actualStop; output Modelica.Units.SI.Time observedDuration(start=0,fixed=true); output Modelica.Units.SI.Time validDuration(start=0,fixed=true); output Integer expectedSamples; output Integer receivedSamples(start=0,fixed=true); output Integer validSamples(start=0,fixed=true); output EvaluationLibrary.Utilities.Types.DataStatus status</p><p><b>Parameters</b> parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime; parameter Modelica.Units.SI.Time windowStart=0; parameter Modelica.Units.SI.Time windowStop=5; parameter Boolean applicable=true; parameter Boolean useValidInput=false; parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01; parameter Modelica.Units.SI.Time sampleStart=0; parameter Boolean sampled=false</p><p><b>Behavior</b> A fixed window is half-open. An external window records its first open and close. A later opening marks unexpectedWindow.</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> An early terminal event closes evidence as incomplete. Invalid samples never turn into complete coverage.</p><p><b>Observables</b> inWindow, complete, unexpectedWindow, tick, sampleInWindow, expectedSamples, receivedSamples, validSamples</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p></html>"));
end WindowEvidence;
