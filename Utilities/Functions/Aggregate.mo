within EvaluationLibrary.Utilities.Functions;
function Aggregate "Combine required verdict codes using an explicit priority"
  extends Modelica.Icons.Function;
input Integer codes[:];
  input Boolean required[size(codes,1)];
  output EvaluationLibrary.Utilities.Types.Verdict verdict;
protected
  Integer applicableCount;
  Boolean invalid;
  Boolean violated;
  Boolean undecided;
algorithm
  applicableCount:=0; invalid:=false; violated:=false; undecided:=false;
  for i in 1:size(codes,1) loop
    if required[i] and codes[i]<>5 then
      applicableCount:=applicableCount+1;
      invalid:=invalid or EvaluationLibrary.Utilities.Functions.VerdictFromCode(codes[i])==EvaluationLibrary.Utilities.Types.Verdict.INVALID;
      violated:=violated or codes[i]==3;
      undecided:=undecided or codes[i]==1;
    end if;
  end for;
  verdict:=if applicableCount==0 then EvaluationLibrary.Utilities.Types.Verdict.NOT_APPLICABLE elseif invalid then EvaluationLibrary.Utilities.Types.Verdict.INVALID
    elseif violated then EvaluationLibrary.Utilities.Types.Verdict.VIOLATED elseif undecided then EvaluationLibrary.Utilities.Types.Verdict.UNDECIDED else EvaluationLibrary.Utilities.Types.Verdict.SATISFIED;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Line(points={{-42.16,23.16},{-14.96,23.16},{-2.72,4.12}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-42.16,4.12},{-2.72,4.12}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Line(points={{-42.16,-14.92},{-14.96,-14.92},{-2.72,4.12}}, color={128,128,128}, thickness=0.8, pattern=LinePattern.Solid),
        Rectangle(extent={{-3.4,-12.2},{25.84,21.12}}, lineColor={64,64,64}, fillColor={255,255,255}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{0.68,17.72},{21.76,-8.12}}, textString="&", textColor={0,0,127}, fontSize=0),
        Line(points={{25.84,4.12},{44.2,4.12}}, color={0,0,127}, thickness=0.9, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Text(extent={{-65,-55},{65,-78}}, textString="aggregate", textColor={108,88,49}, fontSize=0),
        Text(extent={{-150,155},{150,125}}, textString="%name", textColor={0,0,255}, fontSize=0)
      }),
    Documentation(info="<html><p><b>Purpose</b> Combine required verdict codes using an explicit priority.</p><p><b>Interfaces</b> input Integer codes[:]; input Boolean required[size(codes,1)]; output EvaluationLibrary.Utilities.Types.Verdict verdict</p><p><b>Parameters</b> No tuning parameters; use the declared input contract.</p><p><b>Behavior</b> Combine required verdict codes using an explicit priority</p><p><b>Initialization</b> Evaluated from the current inputs and parameter bindings.</p><p><b>Activation and recovery</b> Not applicable.</p><p><b>Limitations</b> Outputs retain the units declared at the interface. Numerical values depend on the supplied input and parameter range.</p><p><b>Observables</b> Public outputs and the stated input conditions.</p></html>"));
end Aggregate;
