within MoSDH.Components.Storage.StratifiedTank.Functions;
function Buoyancy "Function that returns an increased thermal conductivity for temperature inversion in a thermal storage"
 input Real T_up(quantity="Basics.Temp") "Upper Temperature";
 input Real T_down(quantity="Basics.Temp") "Lower temperature";
 input Modelica.Thermal.FluidHeatFlow.Media.Medium medium "Storage medium";
 input Real depth(quantity="Basics.Length") "Depth from the surface";
 output Real lambda_buo(quantity="Thermofluidics.ThermConductivity") "(Increased) thermal conductivity to model buoyancy";
  input Modelica.Units.SI.CubicExpansionCoefficient beta
    "Thermal expansion coefficient to model buoyancy";
protected
  parameter Real k=0.41 "Karman constant to model buoyancy";
algorithm
  lambda_buo :=if T_up < T_down then medium.lambda + (2/3)*medium.rho*medium.cp
    *k*depth^2*sqrt(abs(-Modelica.Constants.g_n*beta*((T_up - T_down)/(depth))))
     else medium.lambda;
 annotation(Icon(graphics={
 Text(
  textString="Buoyancy",
  extent={{-100,50},{90,-6.7}})}));
end Buoyancy;