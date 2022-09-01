within MoSDH.Components.Utilities.FluidHeatFlow.Functions;
function vFluid "fluid velocity"
 extends Modelica.Icons.Function;
  input Modelica.Units.SI.VolumeFlowRate volFlow "volume flow";
  input Modelica.Units.SI.Length dInner "inner diameter";
  input Modelica.Units.SI.Length dOuter "outer diameter";
  output Modelica.Units.SI.Velocity velocity "volume flow velocity";
algorithm
  // enter your algorithm here
  velocity:=volFlow/(Modelica.Constants.pi*(dOuter^2-dInner^2)/4);
end vFluid;