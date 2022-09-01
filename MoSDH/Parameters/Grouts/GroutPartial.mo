within MoSDH.Parameters.Grouts;
partial record GroutPartial "grout"
 extends Modelica.Icons.Record;
 parameter Real lamda(quantity="ThermalConductivity") "thermal conductivity of grout" annotation(Dialog(
  group="grout",
  tab="BTES"));
 parameter Real cp(
  quantity="SpecificHeatCapacity",
  displayUnit="kJ/(kgÂ·K)") "thermal capacity of grout" annotation(Dialog(
  group="grout",
  tab="BTES"));
 parameter Real rho(quantity="Density") "density of grout" annotation(Dialog(
  group="grout",
  tab="BTES"));
end GroutPartial;