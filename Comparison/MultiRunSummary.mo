within EvaluationLibrary.Comparison;
block MultiRunSummary "Summarize explicitly connected complete and comparable runs"
parameter Integer n(min=1)=3;
  parameter String comparisonId="comparison";
  parameter String comparisonIds[n]=fill(comparisonId,n);
  parameter String unit="1";
  parameter String units[n]=fill(unit,n);
  parameter Modelica.Units.SI.Time windowStart=0;
  parameter Modelica.Units.SI.Time windowStop=5;
  parameter Modelica.Units.SI.Time runStart[n]=fill(windowStart,n);
  parameter Modelica.Units.SI.Time runStop[n]=fill(windowStop,n);
  EvaluationLibrary.Utilities.Interfaces.MetricInput u[n] annotation(Placement(transformation(origin={-100,0},extent={{-10,-10},{10,10}}),iconTransformation(origin={-100,0},extent={{-10,-10},{10,10}})));
  output Integer nInputs;
  output Integer nValid;
  output Boolean available;
  output Real minimum;
  output Real maximum;
  output Real mean;
protected
  Boolean accepted[n];
initial equation
  assert(n>=1 and comparisonId<>"" and windowStop>windowStart,"Invalid comparison metadata.");
equation
  for i in 1:n loop
    accepted[i]=comparisonIds[i]==comparisonId and units[i]==unit and abs(runStart[i]-windowStart)<=1e-9
      and abs(runStop[i]-windowStop)<=1e-9 and u[i].complete and u[i].dataStatus==2 and u[i].valueAvailable
      and abs(u[i].value)<Modelica.Constants.inf;
  end for;
  nInputs=n;
  nValid=sum({if accepted[i] then 1 else 0 for i in 1:n});
  available=nValid>0;
  minimum=if available then min({if accepted[i] then u[i].value else Modelica.Constants.inf for i in 1:n}) else 0;
  maximum=if available then max({if accepted[i] then u[i].value else -Modelica.Constants.inf for i in 1:n}) else 0;
  mean=if available then sum({if accepted[i] then u[i].value else 0 for i in 1:n})/nValid else 0;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(extent={{-90,-85},{90,85}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-62,55},{-62,-37},{65,-37}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Solid),
        Rectangle(extent={{-49,-37},{-30,0}}, lineColor={128,128,128}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{-14,-37},{5,35}}, lineColor={128,128,128}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Rectangle(extent={{21,-37},{40,14}}, lineColor={128,128,128}, fillColor={235,235,235}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Line(points={{-58,17},{62,17}}, color={128,128,128}, thickness=0.5, pattern=LinePattern.Dash),
        Line(points={{61,-1},{61,35}}, color={64,64,64}, thickness=0.65, pattern=LinePattern.Solid, arrow={Arrow.Filled,Arrow.Filled}),
        Text(extent={{-65,-50},{65,-75}}, textString="min µ max", textColor={64,64,64}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Summarize explicitly connected complete and comparable runs.</p><p><b>Interfaces</b> EvaluationLibrary.Utilities.Interfaces.MetricInput u[n]; output Integer nInputs; output Integer nValid; output Boolean available; output Real minimum; output Real maximum; output Real mean</p><p><b>Parameters</b> parameter Integer n(min=1)=3; parameter String comparisonId=\"comparison\"; parameter String comparisonIds[n]=fill(comparisonId,n); parameter String unit=\"1\"; parameter String units[n]=fill(unit,n); parameter Modelica.Units.SI.Time windowStart=0; parameter Modelica.Units.SI.Time windowStop=5; parameter Modelica.Units.SI.Time runStart[n]=fill(windowStart,n); parameter Modelica.Units.SI.Time runStop[n]=fill(windowStop,n)</p><p><b>Behavior</b> Summarize explicitly connected complete and comparable runs</p><p><b>Initialization</b> The declared start values and initialization equations apply.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Each run is provided explicitly. A summary performs no simulation or parameter sweep.</p><p><b>Observables</b> nInputs, nValid, available, minimum, maximum, mean</p><p><b>Evidence kind</b> Interpret the result with the declared window and sampling rule. Incomplete or invalid evidence must not be interpreted as satisfied.</p><p><b>Example</b> <a href=\"modelica://EvaluationLibrary.Examples.PairedPerformance\">EvaluationLibrary.Examples.PairedPerformance</a></p></html>"));
end MultiRunSummary;
