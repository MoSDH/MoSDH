within MoSDH.Components.Utilities.BaseClasses;
partial model PartialThermalSource "Partial model for thermal source"
	MoSDH.Utilities.Interfaces.SupplyPort supplyPort(medium=medium) "Supply port" annotation(Placement(
		transformation(extent={{90,10},{110,30}}),
		iconTransformation(extent={{186.7,40},{206.7,60}})));
	MoSDH.Utilities.Interfaces.ReturnPort returnPort(medium=medium) "Return port" annotation(Placement(
		transformation(extent={{110,-30},{90,-10}}),
		iconTransformation(extent={{206.7,-60},{186.7,-40}})));
	Modelica.Units.SI.Temperature Tsupply(displayUnit="degC") "Supply temperature";
	Modelica.Units.SI.Temperature Treturn(displayUnit="degC") "Return temperature";
	Modelica.Units.SI.VolumeFlowRate volFlow "Volume flow rate";
	Modelica.Units.SI.Power Pthermal(displayUnit="kW") "Thermal power";
	Modelica.Units.SI.Energy Qthermal(
		start=0,
		fixed=true) "Thermal energy production";
	Modelica.Units.SI.Pressure dp "Pressure drop";
	Modelica.Units.SI.Power PelectricPump(displayUnit="kW")=pump.PelectricPump "Electric pump power";
	Modelica.Units.SI.Energy EelectricPump=pump.EelectricPump "Electric pump energy";
	MoSDH.Components.Distribution.Pump pump(medium=medium) annotation(Placement(transformation(extent={{50,10},{70,30}})));
	Modelica.Thermal.FluidHeatFlow.Components.Pipe pipe(
		medium=medium,
		m=pipe.V_flowNominal*medium.rho*tau,
		T0=283.15,
		T0fixed=true,
		tapT=0.5,
		V_flowLaminar=pipe.V_flowNominal*0.01,
		dpLaminar=pipe.dpNominal*0.001,
		V_flowNominal=V_flowNom,
		dpNominal=1000,
		useHeatPort=true,
		h_g=0) annotation(Placement(transformation(
		origin={30,0},
		extent={{-10,10},{10,-10}},
		rotation=90)));
	parameter Modelica.Units.SI.Time tau=300 "Time constant for dynamic behaviour" annotation(Dialog(
		group="Properties",
		tab="Design"));
	parameter Modelica.Units.SI.VolumeFlowRate V_flowNom=0.01 "Nominal volume flow rate" annotation(Dialog(
		group="Properties",
		tab="Design"));
	replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby Modelica.Thermal.FluidHeatFlow.Media.Medium "Grid heat carrier fluid" annotation(
		choicesAllMatching=true,
		Dialog(
			group="Properties",
			tab="Design"));
	equation
		Tsupply = supplyPort.h / medium.cp;
		Treturn = returnPort.h / medium.cp;
		volFlow=returnPort.m_flow/medium.rho;
		Pthermal=pipe.Q_flow;
		der(Qthermal)=Pthermal;
		dp=pump.dp;
		connect(supplyPort,pump.flowPort_b) annotation(Line(
		 points={{100,20},{95,20},{74.3,20},{69.3,20}},
		 color={255,0,0},
		 thickness=1));
		connect(pump.flowPort_a,pipe.flowPort_b) annotation(Line(
		 points={{50,20},{45,20},{30,20},{30,15},{30,10}},
		 color={255,0,0},
		 thickness=1));
		connect(pipe.flowPort_a,returnPort) annotation(Line(
		 points={{30,-10},{30,-15},{30,-20},{95,-20},{100,-20}},
		 color={0,0,255},
		 thickness=1));
	annotation(Icon(coordinateSystem(extent={{-200,-200},{200,200}})));
end PartialThermalSource;