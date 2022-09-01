within MoSDH.Utilities.Interfaces;
connector WarmPort "Port used for warm fluid"
 extends Modelica.Thermal.FluidHeatFlow.Interfaces.FlowPort;
 annotation (
  Icon(graphics={
  Ellipse(
   lineColor={177,0,177},
   fillColor={177,0,177},
   fillPattern=FillPattern.Solid,
   lineThickness=1,
   extent={{-98,98},{98,-98}})}),
  Diagram(graphics={
   Ellipse(
    lineColor={177,0,177},
    fillColor={177,0,177},
    fillPattern=FillPattern.Solid,
    extent={{-48,48},{48,-48}}),
   Text(
    textString="%name",
    lineColor={0,0,255},
    extent={{-100,110},{100,50}})}),
  Documentation(info="<html>
Same as SupplyPort, but icon allows to differentiate direction of flow.
</html>"));
end WarmPort;