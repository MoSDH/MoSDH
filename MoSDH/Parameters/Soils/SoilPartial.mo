within MoSDH.Parameters.Soils;
partial record SoilPartial "soil properties"
 extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Density rho(min=1) "Density";
  parameter Modelica.Units.SI.SpecificHeatCapacity cp(min=1)
    "Specific heat capacity at constant pressure";
  parameter Modelica.Units.SI.ThermalConductivity lamda(min=0.01)
    "Thermal conductivity";
 annotation(Documentation(info="<html>
Record containing (constant) soil properties.
</html>"));
end SoilPartial;