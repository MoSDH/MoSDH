within MoSDH.Components.Utilities.FluidHeatFlow.Functions;
function Gamma "auxillary variable gamma"
 extends Modelica.Icons.Function;
 input Real Re "Reynolds number";
 output Real Gamma "auxillary variable gamma";
algorithm
  // enter your algorithm here
  Gamma:=(Re-2300)/(10^4-2300);
end Gamma;