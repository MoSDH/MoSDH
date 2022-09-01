within MoSDH.Components.Utilities.FluidHeatFlow.Functions;
function Reynolds "Reynolds number"
 extends Modelica.Icons.Function;
  input Modelica.Units.SI.Velocity velocity "volume flow velocity";
  input Modelica.Units.SI.Length diameter "diameter of pipe or annular gap";
  input Modelica.Units.SI.KinematicViscosity nue
    "dynamic viscosity of refrigerant";
 output Real Re "Reynolds number";
algorithm
  // enter your algorithm here
  Re:= velocity*diameter/nue;
end Reynolds;