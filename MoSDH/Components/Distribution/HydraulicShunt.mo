within MoSDH.Components.Distribution;
model HydraulicShunt "Shunt model for hydraulic decoupling of load and demand"
	MoSDH.Utilities.Interfaces.SupplyPort sourceSupply(medium=medium) "Supply from source" annotation(Placement(
		transformation(extent={{-110,40},{-90,60}}),
		iconTransformation(extent={{-110,40},{-90,60}})));
	MoSDH.Utilities.Interfaces.SupplyPort loadSupply(medium=medium) "Supply to load" annotation(Placement(
		transformation(
			origin={100,50},
			extent={{-10,-10},{10,10}},
			rotation=180),
		iconTransformation(
			origin={100,50},
			extent={{-10,-10},{10,10}},
			rotation=180)));
	MoSDH.Utilities.Interfaces.ReturnPort sourceReturn(medium=medium) "Return to source" annotation(Placement(
		transformation(extent={{-110,-60},{-90,-40}}),
		iconTransformation(extent={{-110,-60},{-90,-40}})));
	MoSDH.Utilities.Interfaces.ReturnPort loadReturn(medium=medium) "Return from load" annotation(Placement(
		transformation(
			origin={96.7,-50},
			extent={{-10,-10},{10,10}},
			rotation=180),
		iconTransformation(
			origin={96.7,-50},
			extent={{-10,-10},{10,10}},
			rotation=180)));
	Modelica.Units.SI.Temperature TsupplyLoad=loadSupply.h/medium.cp "Load side supply temperature";
	Modelica.Units.SI.Temperature TreturnLoad=loadReturn.h/medium.cp "Load side return temperature";
	Modelica.Units.SI.Temperature TsupplySource=sourceSupply.h/medium.cp "Source side supply temperature";
	Modelica.Units.SI.Temperature TreturnSource=sourceReturn.h/medium.cp "Source side return temperature";
	replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby Modelica.Thermal.FluidHeatFlow.Media.Medium "Medium" annotation(choicesAllMatching=true);
	parameter Boolean setAbsolutePressure=true "Absolute pressure supply";
	parameter Modelica.Units.SI.Pressure absolutePressure=100000 "Absolute pressure at the storage top" annotation(Dialog(enable=setAbsolutePressure));
	parameter Modelica.Units.SI.VolumeFlowRate V_flowNom=0.01 "Nominal volume flow rate";
	parameter Modelica.Units.SI.Time tau=300 "Time constant for dynamic behaviour";
	threeWayValveMix supplyValve(
		medium=medium,
		controlMode=MoSDH.Utilities.Types.ValveOpeningModes.free,
		V_flowNom=V_flowNom,
		tau=tau,
		Tinitial=293.15) annotation(Placement(transformation(extent={{-10,55},{-20,45}})));
	threeWayValveMix returnValve(
		medium=medium,
		controlMode=MoSDH.Utilities.Types.ValveOpeningModes.free,
		V_flowNom=V_flowNom,
		tau=tau,
		Tinitial=293.15) annotation(Placement(transformation(extent={{-10,-55},{-20,-45}})));
	Modelica.Units.SI.VolumeFlowRate volFlowShortCircuit=volFlowLoad-volFlowSource "Short circuit volume flow (supply->return)";
	Modelica.Units.SI.VolumeFlowRate volFlowLoad=-loadSupply.m_flow/medium.rho "Load side volume flow rate";
	Modelica.Units.SI.VolumeFlowRate volFlowSource=sourceSupply.m_flow/medium.rho "Source side volume flow rate";
	Modelica.Thermal.FluidHeatFlow.Sources.AbsolutePressure absolutePressure1(
		medium=medium,
		p=absolutePressure) if setAbsolutePressure annotation(Placement(transformation(
		origin={-30,70},
		extent={{-10,-10},{10,10}},
		rotation=90)));
	equation
		connect(sourceSupply,absolutePressure1.flowPort) annotation(Line(
		 points={{-100,50},{-95,50},{-30,50},{-30,55},{-30,60}},
		 color={255,0,0},
		 thickness=1));
		connect(sourceSupply,supplyValve.flowPort_a) annotation(Line(
			points={{-100,50},{-95,50},{-24.7,50},{-19.7,50}},
			color={255,0,0},thickness=1));
		connect(loadSupply,supplyValve.flowPort_b) annotation(Line(
			points={{100,50},{95,50},{-5,50},{-10,50}},
			color={255,0,0},thickness=1));
		connect(supplyValve.flowPort_c,returnValve.flowPort_c) annotation(Line(thickness=1,points={{-15,45},{-15,40},{-15,-40},{-15,-45}}));
		connect(loadReturn,returnValve.flowPort_b) annotation(Line(
			points={{96.7,-50},{91.7,-50},{-5,-50},{-10,-50}},
			color={0,0,255},thickness=1));
		connect(sourceReturn,returnValve.flowPort_a) annotation(Line(
			points={{-100,-50},{-95,-50},{-24.7,-50},{-19.7,-50}},thickness=1,
			color={0,0,255}));
	annotation(
		defaultComponentName="shunt",
		Icon(graphics={
						Bitmap(
							imageSource="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
AAAASUVORK5CYII=",
							extent={{-100,-99.7},{100,99.7}})}),
		experiment(
			StopTime=1,
			StartTime=0,
			Tolerance=1e-06,
			Interval=0.001));
end HydraulicShunt;