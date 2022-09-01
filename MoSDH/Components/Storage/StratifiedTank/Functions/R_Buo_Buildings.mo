within MoSDH.Components.Storage.StratifiedTank.Functions;
function R_Buo_Buildings "Function that returns the additional conductance (reciprocal resistance) for temperature inversion in a thermal storage based on Buildings"
 input Modelica.Units.SI.Temperature T_up "Upper Temperature";
 input Modelica.Units.SI.Temperature T_down "Lower temperature";
 input Modelica.Thermal.FluidHeatFlow.Media.Medium medium "Storage medium";
 input Integer n(min=2) "Number of volume elements";
 input Modelica.Units.SI.Time tau "Time constant";
 input Modelica.Units.SI.Volume volume "Storage volume";
 output Modelica.Units.SI.ThermalConductance G "Additional thermal resistance to model buoyancy";
protected
  Real k(unit="W/K");
  constant Modelica.Units.SI.Temperature TempDummy=1;
algorithm
  k := volume*medium.rho*medium.cp*(T_down-T_up)/(n*tau*TempDummy);
  //G := if T_up < T_down then volume*medium.rho*medium.cp*(T_down-T_up)/(n*tau) else 0;
  G :=if T_up < T_down then k else 0;
 annotation(Icon(graphics={
 Text(
  textString="Buoyancy",
  extent={{-100,50},{90,-6.7}})}));
end R_Buo_Buildings;