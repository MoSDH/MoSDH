within MoSDH.Components.Storage.StratifiedTank;
package Functions "Functions"
	extends Modelica.Icons.FunctionsPackage;
	function R_Buo_AixLib "Function that returns the additional conductance (reciprocal resistance) for temperature inversion in a thermal storage based on AixLib"
		input Modelica.Units.SI.Temperature T_up "Upper Temperature";
		input Modelica.Units.SI.Temperature T_down "Lower temperature";
		input Modelica.Thermal.FluidHeatFlow.Media.Medium medium "Storage medium";
		input Modelica.Units.SI.Length depth "Depth from the surface";
		input Modelica.Units.SI.Length height "Height of the volume element";
		input Modelica.Units.SI.Area baseArea "Base area of the volume element";
		input Modelica.Units.SI.CubicExpansionCoefficient beta "Thermal expansion coefficient to model buoyancy";
		output Modelica.Units.SI.ThermalConductance G "Additional thermal conductance to model buoyancy";
		protected
			parameter Real k(unit="m.K.s/J")=0.41 "Karman constant to model buoyancy";
			Modelica.Units.SI.ThermalConductivity lambda_buo "Additional thermal conductivity";
		algorithm
			lambda_buo := (2/3)*medium.rho*medium.cp*k*depth^2*sqrt(abs(-Modelica.Constants.g_n*beta*((T_up - T_down)/(depth))));
			G := if T_up < T_down then (baseArea*lambda_buo)/height else 0;
		annotation(Icon(graphics={
		Text(
			textString="Buoyancy",
			extent={{-100,50},{90,-6.7}})}));
	end R_Buo_AixLib;
	annotation(dateModified="2020-09-01 12:42:27Z");
end Functions;