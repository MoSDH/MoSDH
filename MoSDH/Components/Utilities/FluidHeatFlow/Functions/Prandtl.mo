within MoSDH.Components.Utilities.FluidHeatFlow.Functions;
function Prandtl "Prandtl number"
 extends Modelica.Icons.Function;
  input Modelica.Units.SI.DynamicViscosity dynamicViscosity
    "dynamic viscosity of fluid";
  input Modelica.Units.SI.SpecificHeatCapacity cRefrigerant
    "heat capacity of refrigerant";
  input Modelica.Units.SI.ThermalConductivity lambdaRefrigerant
    "thermal conductivity of refrigerant";
 output Real Pr "Prandtl Number";
algorithm
  // enter your algorithm here
  Pr:= dynamicViscosity*cRefrigerant/lambdaRefrigerant;
end Prandtl;