within EvaluationLibrary.Requirements;
block VectorBounds "Evaluate independent finite numeric channel bounds"
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime;
  parameter Modelica.Units.SI.Time windowStart=0;
  parameter Modelica.Units.SI.Time windowStop=5;
  parameter Boolean applicable=true;
  parameter Boolean useValidInput=false;

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01;
  parameter Modelica.Units.SI.Time sampleStart=0;
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus;
  output EvaluationLibrary.Utilities.Types.Verdict verdict;
  output Boolean complete;
  output Boolean everViolated(start=false,fixed=true);
  output Modelica.Units.SI.Time firstViolationTime(start=0,fixed=true);
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));

  parameter Integer n(min=1)=3;
  parameter Real lower[n]=fill(0,n);
  parameter Real upper[n]=fill(1,n);
  parameter Real tolerance[n]=fill(0,n);
  parameter String channelUnit[n]=fill("1",n);
  parameter Boolean useChannelValid=false;
    Modelica.Blocks.Interfaces.RealInput u[n] annotation(Placement(transformation(origin={-100,42},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,42},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput channelValid[n] if useChannelValid annotation(Placement(transformation(origin={-100,14},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,14},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput perChannelVerdict[n] annotation(Placement(transformation(origin={100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,23.33333},extent={{-10,-10},{10,10}})));
  output Boolean channelViolated[n](each start=false,each fixed=true);
  output Modelica.Units.SI.Time channelFirstViolation[n](each start=0,each fixed=true);
  Modelica.Blocks.Interfaces.RealOutput value annotation(Placement(transformation(origin={100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted annotation(Placement(transformation(origin={-100,-14},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-14},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow annotation(Placement(transformation(origin={-100,-42},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-42},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=false,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable);
  Boolean dataOK;
  Boolean violationNow;
  Modelica.Blocks.Interfaces.BooleanInput validity[n] annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Boolean qualifiedChannel[n];
  Boolean violation[n];
  Boolean invalid[n];
  discrete Boolean invalidSeen[n](each start=false,each fixed=true);
initial equation
  assert(n>=1,"At least one channel is required.");
  for i in 1:n loop
    assert(lower[i]<=upper[i] and tolerance[i]>=0 and abs(lower[i])<Modelica.Constants.inf and
      abs(upper[i])<Modelica.Constants.inf and tolerance[i]<Modelica.Constants.inf,"Invalid channel bound.");
  end for;
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=sum({if qualifiedChannel[i] then 1 else 0 for i in 1:n})==n;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=false;
  violationNow=(if false then gate.sampleInWindow else gate.inWindow) and dataOK and (false);
  dataStatus=gate.status;
  verdict=EvaluationLibrary.Utilities.Functions.ToVerdict(dataStatus,everViolated,true);
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
  result.complete=complete;

  connect(channelValid,validity);
  if not useChannelValid then validity=fill(true,n); end if;
  for i in 1:n loop
    qualifiedChannel[i]=trusted and validity[i] and abs(u[i])<Modelica.Constants.inf;
    violation[i]=gate.inWindow and qualifiedChannel[i] and (u[i]<lower[i]-tolerance[i] or u[i]>upper[i]+tolerance[i]);
    invalid[i]=gate.inWindow and not qualifiedChannel[i];
    when {initial(),violation[i],invalid[i]} then
      channelViolated[i]=(not initial() and pre(channelViolated[i])) or violation[i];
      channelFirstViolation[i]=if violation[i] and (initial() or not pre(channelViolated[i])) then time
        elseif initial() then 0 else pre(channelFirstViolation[i]);
      invalidSeen[i]=(not initial() and pre(invalidSeen[i])) or invalid[i];
    end when;
    perChannelVerdict[i]=Integer(EvaluationLibrary.Utilities.Functions.ToVerdict(if invalidSeen[i] then EvaluationLibrary.Utilities.Types.DataStatus.INVALID
      elseif gate.status==EvaluationLibrary.Utilities.Types.DataStatus.INVALID then (if gate.complete and gate.actualStop>gate.actualStart and
      gate.observedDuration>=gate.actualStop-gate.actualStart-1e-7 then EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE else EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE)
      else gate.status,channelViolated[i],true));
  end for;
  value=sum({if channelViolated[i] then 1 else 0 for i in 1:n});
  available=gate.observedDuration>0 or everViolated;
algorithm
  when {initial(),sum({if violation[i] then 1 else 0 for i in 1:n})>0} then
    if sum({if violation[i] then 1 else 0 for i in 1:n})>0 and not pre(everViolated) then
      everViolated:=true;
      firstViolationTime:=time;
    end if;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-48,-22},{46,-22}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-48,-31},{-48,-13}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{46,-31},{46,-13}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-48,10},{46,10}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-48,1},{-48,19}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{46,1},{46,19}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{-48,42},{46,42}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Line(points={{-48,33},{-48,51}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Line(points={{46,33},{46,51}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Ellipse(extent={{-24,38},{-16,46}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{2,6},{10,14}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Ellipse(extent={{56,-26},{64,-18}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.4),
        Text(extent={{-65,-50},{65,-75}}, textString="bounds[n]", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Evaluate independent finite numeric channel bounds.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput; Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle; output EvaluationLibrary.Utilities.Types.DataStatus dataStatus; output EvaluationLibrary.Utilities.Types.Verdict verdict; output Boolean complete; output Boolean everViolated(start=false,fixed=true); output Modelica.Units.SI.Time firstViolationTime(start=0,fixed=true); EvaluationLibrary.Utilities.Interfaces.MetricOutput result; Modelica.Blocks.Interfaces.RealInput u[n]; Modelica.Blocks.Interfaces.BooleanInput channelValid[n] if useChannelValid; Modelica.Blocks.Interfaces.IntegerOutput perChannelVerdict[n]; output Boolean channelViolated[n](each start=false,each fixed=true); output Modelica.Units.SI.Time channelFirstViolation[n](each start=0,each fixed=true); Modelica.Blocks.Interfaces.RealOutput value; Modelica.Blocks.Interfaces.BooleanOutput available</p><p><b>Parameters</b> parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime; parameter Modelica.Units.SI.Time windowStart=0; parameter Modelica.Units.SI.Time windowStop=5; parameter Boolean applicable=true; parameter Boolean useValidInput=false; parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01; parameter Modelica.Units.SI.Time sampleStart=0; parameter Integer n(min=1)=3; parameter Real lower[n]=fill(0,n); parameter Real upper[n]=fill(1,n); parameter Real tolerance[n]=fill(0,n); parameter String channelUnit[n]=fill(\"1\",n); parameter Boolean useChannelValid=false</p><p><b>Behavior</b> Evaluate independent finite numeric channel bounds</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> A channel is evaluated in its declared unit. This block does not convert units.</p><p><b>Observables</b> complete, everViolated, result, perChannelVerdict, channelViolated, value, available</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.BoundsAndValidWitness\">EvaluationLibrary.Examples.BoundsAndValidWitness</a></p></html>"));
end VectorBounds;
