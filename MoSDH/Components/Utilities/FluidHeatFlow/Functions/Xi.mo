within MoSDH.Components.Utilities.FluidHeatFlow.Functions;
function Xi "auxillary variable"
 extends Modelica.Icons.Function;
 input Real Re "Reynolds number";
 output Real Xi "auxillary variable Xi";
algorithm
  // enter your algorithm here
  Xi:=(1.8*log10(Re)-1.5)^(-2);
end Xi;