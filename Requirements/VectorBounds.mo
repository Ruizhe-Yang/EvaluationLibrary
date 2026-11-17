within EvaluationLibrary.Requirements;
block VectorBounds "Check independent numerical bounds for multiple channels"
  parameter String metricId=getInstanceName() "Identifier carried by the result";
  parameter String requirementId="" "Optional requirement identifier";
  parameter String requirementVersion="" "Optional requirement version";
  parameter String unitName="1" "Unit label for the reported value";
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime "Fixed interval or first contiguous external window";
  parameter Modelica.Units.SI.Time windowStart=0 "Inclusive start of the observation window";
  parameter Modelica.Units.SI.Time windowStop=5 "Exclusive end of the observation window";
  parameter Boolean applicable=true "True if this assessment is applicable";
  parameter Boolean useValidInput=false "Enable the optional input validity connector";

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01 "Uniform sampling interval for sampled evaluation";
  parameter Modelica.Units.SI.Time sampleStart=0 "Time origin of the uniform sample grid";
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput "True if the observed inputs are valid" annotation(Placement(transformation(origin={0,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={0,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle "External observation gate; only the first contiguous interval is accepted" annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus "Observation coverage and data validity";
  output EvaluationLibrary.Utilities.Types.Verdict verdict "Requirement outcome, separate from data qualification";
  output Boolean complete "Observation has ended; completeness is reported by dataStatus";
  output Boolean everViolated(start=false,fixed=true) "True after a valid violation has been observed";
  output Modelica.Units.SI.Time firstViolationTime(start=0,fixed=true) "Time of the first valid violation";
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result "Value, qualification and requirement outcome" annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));

  parameter Integer n(min=1)=3 "Number of channels, records or configured items; at least one";
  parameter Real lower[n]=fill(0,n) "Inclusive lower acceptance bound";
  parameter Real upper[n]=fill(1,n) "Inclusive upper acceptance bound";
  parameter Real tolerance[n]=fill(0,n) "Non-negative allowance added to the acceptance bound";
  parameter String channelUnit[n]=fill("1",n) "Engineering unit of each simultaneous channel";
  parameter Boolean useChannelValid=false "Expose per-channel validity flags";
    Modelica.Blocks.Interfaces.RealInput u[n] "Observed real signal in the declared engineering unit" annotation(Placement(transformation(origin={-100,42},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,42},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput channelValid[n] if useChannelValid "Validity of each observed channel" annotation(Placement(transformation(origin={-100,14},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,14},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput perChannelVerdict[n] "Requirement verdict code for each channel" annotation(Placement(transformation(origin={100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,23.33333},extent={{-10,-10},{10,10}})));
  output Boolean channelViolated[n](each start=false,each fixed=true) "Latched violation flag for each channel";
  output Modelica.Units.SI.Time channelFirstViolation[n](each start=0,each fixed=true) "First valid violation time for each channel";
  Modelica.Blocks.Interfaces.RealOutput value "Numerical result; meaningful only when available" annotation(Placement(transformation(origin={100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available "True if the numerical result is available" annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted "Effective input validity" annotation(Placement(transformation(origin={-100,-14},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-14},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow "External window" annotation(Placement(transformation(origin={-100,-42},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-42},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=false,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable) "Observation window and data qualification";
  Boolean dataOK "True if input validity and numerical checks pass";
  Boolean violationNow "Valid requirement violation at the current instant";
  Modelica.Blocks.Interfaces.BooleanInput validity[n] "Validity" annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  Boolean qualifiedChannel[n] "Channel validity and finite-value check";
  Boolean violation[n] "Violation";
  Boolean invalid[n] "Invalid";
  discrete Boolean invalidSeen[n](each start=false,each fixed=true) "Latched indication of invalid input";
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
  result.metricId=metricId;
  result.requirementId=requirementId;
  result.requirementVersion=requirementVersion;
  result.unit=unitName;
  result.windowStart=gate.actualStart;
  result.windowStop=gate.actualStop;
  result.observedDuration=gate.observedDuration;
  result.samplePeriod=if gate.sampled then samplePeriod else 0;
  result.evidenceKind=Integer(EvaluationLibrary.Utilities.Types.EvidenceKind.Continuous);
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
        Rectangle(extent={{-60,25},{60,49}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45, radius=0),
        Rectangle(extent={{-42,-8},{49,16}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45, radius=0),
        Rectangle(extent={{-55,-41},{32,-17}}, lineColor={128,128,128}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.45, radius=0),
        Ellipse(extent={{-15.7,33.3},{-8.3,40.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{20.3,0.3},{27.7,7.7}}, lineColor={0,0,127}, fillColor={0,0,127}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Ellipse(extent={{42.3,-32.7},{49.7,-25.3}}, lineColor={191,0,0}, fillColor={191,0,0}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.55),
        Line(points={{67,49},{74,49},{74,-41},{67,-41}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid),
        Text(extent={{-65,-50},{65,-75}}, textString="Li <= ui <= Ui", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p>Checks each channel against its inclusive interval <code>[lower[i]-tolerance[i], upper[i]+tolerance[i]]</code>. The block retains per-channel violation flags, first violation times and verdict codes. <code>value</code> counts the channels with a recorded valid violation.</p><p>Use <code>useChannelValid</code> for individual validity signals and <code>useValidInput</code> for shared validity. Invalid data in one channel invalidates the combined evidence while the other channel verdicts remain separately available. Limits and <code>channelUnit</code> refer to the original channel units.</p></html>"));
end VectorBounds;
