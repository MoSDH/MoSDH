within MoSDH.Components.Storage.StratifiedTank.Functions;
function R_Buo_BuildingSystems "Function that returns the additional conductance (reciprocal resistance) for temperature inversion in a thermal storage based on BuildingSystems"
 input Modelica.Units.SI.Temperature T_up "Upper Temperature";
 input Modelica.Units.SI.Temperature T_down "Lower temperature";
 input Integer n(
  min=4,
  max=40) "Number of volume elements (must be between 4 and 40)";
 output Modelica.Units.SI.ThermalConductance G "Additional thermal resistance to model buoyancy";
protected
  parameter Real expn=1.5 "Karman constant to model buoyancy";
  parameter Modelica.Units.SI.ThermalConductance Gbs=if n<10 then 0.8*n+16 else 26-0.2571*n;
algorithm
  G := if T_up < T_down then Gbs*n^expn else 0;
 annotation(Icon(graphics={
 Text(
  textString="Buoyancy",
  extent={{-100,50},{90,-6.7}})}));
end R_Buo_BuildingSystems;