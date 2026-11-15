within EvaluationLibrary.Utilities.Functions;
function StatusFromCode "Decode the fixed data status ordinal"
  extends Modelica.Icons.Function;
input Integer code "Code";
  output EvaluationLibrary.Utilities.Types.DataStatus status "Status";
algorithm
  status:=if code==1 then EvaluationLibrary.Utilities.Types.DataStatus.PENDING elseif code==2 then EvaluationLibrary.Utilities.Types.DataStatus.COMPLETE elseif code==3 then EvaluationLibrary.Utilities.Types.DataStatus.INCOMPLETE
    elseif code==5 then EvaluationLibrary.Utilities.Types.DataStatus.NOT_APPLICABLE else EvaluationLibrary.Utilities.Types.DataStatus.INVALID;
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(extent={{-100,-100},{100,100}}, lineColor={108,88,49}, fillColor={255,215,136}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5),
        Text(extent={{-18,79},{18,47}}, textString="f", textColor={108,88,49}, fontSize=0),
        Text(extent={{-57.017,18.934},{-25.53,-20.212}}, textString="#", textColor={108,88,49}, fontSize=0),
        Line(points={{-17.871,-0.639},{10.212,-0.639}}, color={64,64,64}, thickness=0.8, pattern=LinePattern.Solid, arrow={Arrow.None,Arrow.Filled}),
        Rectangle(extent={{22.977,-14.255},{50.209,12.977}}, lineColor={64,64,64}, fillColor={245,245,245}, fillPattern=FillPattern.Solid, pattern=LinePattern.Solid, lineThickness=0.5, radius=0),
        Text(extent={{25.53,10.424},{47.656,-11.702}}, textString="Q", textColor={64,64,64}, fontSize=0)
      }),
    Documentation(info="<html><p>Status from code. Inputs retain the physical units or logical meaning stated by their declarations. Domain assertions and explicit availability flags are part of the contract.</p></html>"));
end StatusFromCode;
