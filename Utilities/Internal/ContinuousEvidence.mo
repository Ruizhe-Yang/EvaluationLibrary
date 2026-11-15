within EvaluationLibrary.Utilities.Internal;
block ContinuousEvidence "Continuous observation coverage and latched invalidity"
  parameter Modelica.Units.SI.Time windowStart = 0 "Inclusive window start, s";
  parameter Modelica.Units.SI.Time windowEnd = 5 "Exclusive window end, s";
  parameter Boolean applicable = true "Whether the analysis applies";

  input Boolean dataOK "Already checked input validity and numerical domain";

  Modelica.Blocks.Interfaces.BooleanOutput inWindow "Current point lies in applicable window" annotation(Placement(transformation(extent={{94,18},{106,30}}), iconTransformation(extent={{94,18},{106,30}})));
  output EvaluationLibrary.Utilities.Types.DataStatus dataState "Collection and data validity state";
  Modelica.Blocks.Interfaces.RealOutput observedDuration(unit="s",start=0,fixed=true) "Accumulated valid duration" annotation(Placement(transformation(extent={{94,-30},{106,-18}}), iconTransformation(extent={{94,-30},{106,-18}})));
  output Modelica.Units.SI.Time totalObservedDuration "Observed window duration, including invalid intervals";
protected

  parameter Modelica.Units.SI.Time simulationStart(fixed=false) "Observed simulation initialization time";
  Boolean invalidSeen "Invalid seen";
  Boolean sufficient "Sufficient";

initial equation
  simulationStart = time;
  assert(windowEnd > windowStart, "Window must have positive duration.");

equation
  when {initial(),inWindow and not dataOK} then
    invalidSeen = inWindow and not dataOK;
  end when;
  totalObservedDuration = if applicable then max(0,min(time,windowEnd)-max(simulationStart,windowStart)) else 0;
  der(observedDuration) = if inWindow and dataOK then 1 else 0;
  sufficient = observedDuration > 0;

  inWindow = applicable and time >= windowStart and time < windowEnd;
  dataState = if not applicable then EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE
    elseif invalidSeen then EvaluationLibrary.Utilities.Types.DataStatus.INVALID
    elseif time < windowEnd then EvaluationLibrary.Utilities.Types.DataStatus.PENDING
    elseif simulationStart > windowStart or not sufficient then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE
    else EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-57,43},{57,43}}, color={128,128,128}, thickness=0.7, pattern=LinePattern.Solid),
        Ellipse(extent={{-61,39},{-53,47}}, lineColor={64,64,64}, fillColor={64,64,64}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Ellipse(extent={{53,39},{61,47}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.8),
        Line(points={{-57,31},{-57,72}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Line(points={{57,31},{57,72}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Line(points={{-57,19},{57,19}}, color={128,128,128}, thickness=4, pattern=LinePattern.Solid),
        Line(points={{-57,-4},{-8,-4}}, color={0,0,127}, thickness=4, pattern=LinePattern.Solid),
        Line(points={{7,-4},{38,-4}}, color={0,0,127}, thickness=4, pattern=LinePattern.Solid),
        Text(extent={{-33,-28},{33,-58}}, textString="dt", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>Continuous observation coverage and latched invalidity. Inputs retain the physical units or logical meaning stated by their declarations. Domain assertions and explicit availability flags are part of the contract.</p></html>"));
end ContinuousEvidence;
