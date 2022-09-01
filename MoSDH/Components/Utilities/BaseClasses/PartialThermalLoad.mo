within MoSDH.Components.Utilities.BaseClasses;
partial model PartialThermalLoad "Partial model for thermal load"
	MoSDH.Utilities.Interfaces.ReturnPort returnPort(medium=medium) "Return port" annotation(Placement(
		transformation(extent={{-125,10},{-105,30}}),
		iconTransformation(extent={{-210,-60},{-190,-40}})));
	MoSDH.Utilities.Interfaces.SupplyPort supplyPort(medium=medium) "Supply port" annotation(Placement(
		transformation(extent={{-125,80},{-105,100}}),
		iconTransformation(extent={{-210,40},{-190,60}})));
	Modelica.Units.SI.Temperature Tsupply(displayUnit="degC") "Supply temperature";
	Modelica.Units.SI.Temperature Treturn(displayUnit="degC") "Return temperature";
	Modelica.Units.SI.VolumeFlowRate volFlow "Volume flow rate";
	Modelica.Units.SI.Power Pthermal(displayUnit="kW") "Thermal power";
	Modelica.Units.SI.Energy Qthermal(
		start=0,
		fixed=true) "Thermal energy demand";
	Modelica.Units.SI.Pressure dp "Pressure drop";
	Modelica.Units.SI.Power PelectricPump(displayUnit="kW")=pump.PelectricPump "Electric pump power";
	Modelica.Units.SI.Energy EelectricPump=pump.EelectricPump "Electric pump energy";
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
		origin={-95,45},
		extent={{-10,-10},{10,10}},
		rotation=90)));
	MoSDH.Components.Distribution.Pump pump(medium=medium) annotation(Placement(transformation(
		origin={-95,75},
		extent={{-10,-10},{10,10}},
		rotation=-90)));
	parameter Modelica.Units.SI.Time tau=300 "Time constant for dynamic behaviour" annotation(Dialog(
		group="Properties",
		tab="Design"));
	parameter Modelica.Units.SI.VolumeFlowRate V_flowNom=0.01 "Nominal volume flow" annotation(Dialog(
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
		volFlow=supplyPort.m_flow/medium.rho;
		Pthermal=-pipe.Q_flow;
		der(Qthermal)=Pthermal;
		dp=pump.dp;
		connect(supplyPort,pump.flowPort_a) annotation(Line(
		 points={{-115,90},{-110,90},{-95,90},{-95,85}},
		 color={255,0,0},
		 thickness=1));
		connect(returnPort,pipe.flowPort_a) annotation(Line(
		 points={{-115,20},{-110,20},{-95,20},{-95,30},{-95,35}},
		 color={0,0,255},
		 thickness=1));
		connect(pump.flowPort_b,pipe.flowPort_b) annotation(Line(
		 points={{-95,65.66},{-95,65.66},{-95,60},{-95,55}},
		 thickness=0.0625));
	annotation(Icon(coordinateSystem(extent={{-200,-200},{200,200}})));
end PartialThermalLoad;