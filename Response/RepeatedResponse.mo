within EvaluationLibrary.Response;
block RepeatedResponse "Pair repeated qualified events using a finite FIFO and explicit deadline"
parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime;
  parameter Modelica.Units.SI.Time windowStart=0;
  parameter Modelica.Units.SI.Time windowStop=5;
  parameter Boolean applicable=true;
  parameter Boolean useValidInput=false;

  parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01;
  parameter Modelica.Units.SI.Time sampleStart=0;
  Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput annotation(Placement(transformation(origin={70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={70,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle annotation(Placement(transformation(origin={-100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,70},extent={{-10,-10},{10,10}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataStatus;
  output EvaluationLibrary.Utilities.Types.Verdict verdict;
  output Boolean complete;
  output Boolean everViolated;
  output Modelica.Units.SI.Time firstViolationTime;
  EvaluationLibrary.Utilities.Interfaces.MetricOutput result annotation(Placement(transformation(origin={100,70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,70},extent={{-10,-10},{10,10}})));

  parameter Modelica.Units.SI.Time deadline(min=0)=0.2;
  parameter Boolean qualifyDeadline=false "Classify the result as a deadline requirement";
  parameter Integer capacity(min=1)=64;
  parameter Integer maxRecords(min=1)=128;
    Modelica.Blocks.Interfaces.BooleanInput request annotation(Placement(transformation(origin={-70,100},extent={{-10,-10},{10,10}}),iconTransformation(origin={-70,100},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput response annotation(Placement(transformation(origin={-100,23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput matched(start=0,fixed=true) annotation(Placement(transformation(origin={100,50},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,50},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput timedOut(start=0,fixed=true) annotation(Placement(transformation(origin={100,30},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,30},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput censored(start=0,fixed=true) annotation(Placement(transformation(origin={100,10},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,10},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.IntegerOutput unmatchedResponse(start=0,fixed=true) annotation(Placement(transformation(origin={100,-10},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-10},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput overflow(start=false,fixed=true) annotation(Placement(transformation(origin={100,-30},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-30},extent={{-10,-10},{10,10}})));
  discrete Modelica.Units.SI.Time delays[maxRecords](each start=0,each fixed=true);
  output Integer queueLength(start=0,fixed=true);

  Modelica.Blocks.Interfaces.RealOutput value annotation(Placement(transformation(origin={100,-50},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-50},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanOutput available annotation(Placement(transformation(origin={100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={100,-70},extent={{-10,-10},{10,10}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput trusted annotation(Placement(transformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-23.33333},extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput externalWindow annotation(Placement(transformation(origin={-100,-70},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,-70},extent={{-10,-10},{10,10}})));
  EvaluationLibrary.Utilities.Internal.WindowEvidence gate(windowMode=windowMode,windowStart=windowStart,windowStop=windowStop,
    sampled=false,samplePeriod=samplePeriod,sampleStart=sampleStart,applicable=applicable);
  Boolean dataOK;
  Boolean violationNow;

  discrete Modelica.Units.SI.Time timestamps[capacity](each start=0,each fixed=true);
  discrete Modelica.Units.SI.Time delaySum(start=0,fixed=true);
  discrete Modelica.Units.SI.Time firstMissed(start=0,fixed=true);
  Boolean expired;

initial equation
  assert(deadline>=0 and capacity>=1 and maxRecords>=1,"Invalid queue dimensions or deadline.");
equation
  connect(valid,trusted);
  connect(window,externalWindow);
  if not useValidInput then trusted=true; end if;
  if windowMode<>EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle then externalWindow=false; end if;
  dataOK=trusted;
  gate.rawWindow=externalWindow;
  gate.dataOK=dataOK;
  gate.overflow=overflow;
  violationNow=(if false then gate.sampleInWindow else gate.inWindow) and dataOK and (false);
  dataStatus=if qualifyDeadline and gate.status==EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE and (censored>0 or matched+timedOut==0) then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE else gate.status;
  verdict=EvaluationLibrary.Utilities.Functions.ToVerdict(dataStatus,everViolated,qualifyDeadline);
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

  expired=pre(queueLength)>0 and time>=pre(timestamps[1])+deadline;
  value=if matched>0 then delaySum/matched else 0;
  available=matched>0;
  everViolated=timedOut>0;
  firstViolationTime=firstMissed;

algorithm

  when {initial(),request,response,expired,gate.complete} then
    if initial() then queueLength:=0; end if;
    if gate.inWindow then
      while queueLength>0 and timestamps[1]+deadline<time-1e-10 loop
        if timedOut==0 then firstMissed:=timestamps[1]+deadline; end if;
        timedOut:=timedOut+1;
        for j in 1:queueLength-1 loop timestamps[j]:=timestamps[j+1]; end for;
        queueLength:=queueLength-1;
      end while;
      if dataOK and request and (initial() or not pre(request)) then
        if queueLength>=capacity then overflow:=true;
        else queueLength:=queueLength+1; timestamps[queueLength]:=time; end if;
      end if;
      if dataOK and response and (initial() or not pre(response)) then
        if queueLength<=0 then unmatchedResponse:=unmatchedResponse+1;
        elseif matched>=maxRecords then
          overflow:=true;
          for j in 1:queueLength-1 loop timestamps[j]:=timestamps[j+1]; end for;
          queueLength:=queueLength-1;
        else
          matched:=matched+1;
          delays[matched]:=time-timestamps[1];
          delaySum:=delaySum+delays[matched];
          for j in 1:queueLength-1 loop timestamps[j]:=timestamps[j+1]; end for;
          queueLength:=queueLength-1;
        end if;
      end if;
      while queueLength>0 and timestamps[1]+deadline<=time+1e-10 loop
        if timedOut==0 then firstMissed:=timestamps[1]+deadline; end if;
        timedOut:=timedOut+1;
        for j in 1:queueLength-1 loop timestamps[j]:=timestamps[j+1]; end for;
        queueLength:=queueLength-1;
      end while;
    elseif gate.complete then
      for j in 1:queueLength loop
        if timestamps[j]+deadline<gate.actualStop and timestamps[j]+deadline<=time then
          if timedOut==0 then firstMissed:=timestamps[j]+deadline; end if;
          timedOut:=timedOut+1;
        else censored:=censored+1; end if;
      end for;
      queueLength:=0;
    end if;
  end when;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-67,4},{-44,4}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{42,4},{66,4}}, color={0,0,127}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Rectangle(extent={{-41,-16},{-18,24}}, lineColor={0,0,127}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-13,-16},{10,24}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{15,-16},{38,24}}, lineColor={128,128,128}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-38,43},{35,43}}, color={128,128,128}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Line(points={{-42,-36},{42,-36}}, color={128,128,128}, thickness=0.6, pattern=LinePattern.Solid),
        Text(extent={{-42,-26},{42,-48}}, textString="1  2  3", textColor={128,128,128}, fontSize=0),
        Text(extent={{-65,-50},{65,-75}}, textString="FIFO", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Pair repeated qualified events using a finite FIFO and explicit deadline.</p><p><b>Interfaces</b> Modelica.Blocks.Interfaces.BooleanInput valid if useValidInput; Modelica.Blocks.Interfaces.BooleanInput window if windowMode==EvaluationLibrary.Utilities.Types.WindowMode.ExternalSingle; output EvaluationLibrary.Utilities.Types.DataStatus dataStatus; output EvaluationLibrary.Utilities.Types.Verdict verdict; output Boolean complete; output Boolean everViolated; output Modelica.Units.SI.Time firstViolationTime; EvaluationLibrary.Utilities.Interfaces.MetricOutput result; Modelica.Blocks.Interfaces.BooleanInput request; Modelica.Blocks.Interfaces.BooleanInput response; Modelica.Blocks.Interfaces.IntegerOutput matched(start=0,fixed=true); Modelica.Blocks.Interfaces.IntegerOutput timedOut(start=0,fixed=true); Modelica.Blocks.Interfaces.IntegerOutput censored(start=0,fixed=true); Modelica.Blocks.Interfaces.IntegerOutput unmatchedResponse(start=0,fixed=true); Modelica.Blocks.Interfaces.BooleanOutput overflow(start=false,fixed=true); output Integer queueLength(start=0,fixed=true); Modelica.Blocks.Interfaces.RealOutput value; Modelica.Blocks.Interfaces.BooleanOutput available</p><p><b>Parameters</b> parameter EvaluationLibrary.Utilities.Types.WindowMode windowMode=EvaluationLibrary.Utilities.Types.WindowMode.FixedTime; parameter Modelica.Units.SI.Time windowStart=0; parameter Modelica.Units.SI.Time windowStop=5; parameter Boolean applicable=true; parameter Boolean useValidInput=false; parameter Modelica.Units.SI.Time samplePeriod(min=0)=0.01; parameter Modelica.Units.SI.Time sampleStart=0; parameter Modelica.Units.SI.Time deadline(min=0)=0.2; parameter Boolean qualifyDeadline=false \"Classify the result as a deadline requirement\"; parameter Integer capacity(min=1)=64; parameter Integer maxRecords(min=1)=128</p><p><b>Behavior</b> Pair repeated qualified events using a finite FIFO and explicit deadline</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Outputs retain the units declared at the interface. Numerical values depend on the supplied input and parameter range.</p><p><b>Observables</b> complete, everViolated, result, matched, timedOut, censored, unmatchedResponse, overflow, queueLength, value</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.FirstOrderResponse\">EvaluationLibrary.Examples.FirstOrderResponse</a></p></html>"));
end RepeatedResponse;
