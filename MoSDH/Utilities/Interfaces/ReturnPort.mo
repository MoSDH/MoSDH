within MoSDH.Utilities.Interfaces;
connector ReturnPort "Port used for cool fluid"
 extends Modelica.Thermal.FluidHeatFlow.Interfaces.FlowPort;
 annotation (
  Icon(graphics={
  Ellipse(
   lineColor={0,0,255},
   fillColor={0,0,255},
   fillPattern=FillPattern.Solid,
   lineThickness=0.1,
   extent={{-98,98},{98,-98}})}),
  Diagram(graphics={
   Ellipse(
    lineColor={0,0,255},
    fillColor={0,0,255},
    fillPattern=FillPattern.Solid,
    extent={{-48,48},{48,-48}}),
   Text(
    textString="%name",
    lineColor={0,0,255},
    extent={{-100,110},{100,50}})}),
  Documentation(info="<html>
Same as SupplyPort, but icon allows to differentiate direction of flow.
</html>"));
end ReturnPort;
