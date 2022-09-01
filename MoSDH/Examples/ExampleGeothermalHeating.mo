within MoSDH.Examples;
model ExampleGeothermalHeating "Geothermal supported heating system example"
	import modes = MoSDH.Utilities.Types.OperationModes;
	extends Modelica.Icons.Example;
	MoSDH.Components.Storage.StratifiedTank.TTES buffer(
		storageVolume=0.01 * boreholes.nBHEs * boreholes.BHElength,
		storageHeight=10,
		buoyancyMode=Components.Storage.StratifiedTank.BaseClasses.BuoyancyModels.buildings,
		nLayers=10,
		Tinitial=linspace(TreturnRef, TsupplyRef, buffer.nLayers)) annotation(Placement(transformation(extent={{-15,5},{15,65}})));
	MoSDH.Components.Weather.WeatherData weather(weatherData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/Weather/DWD/TRY2017_Darmstadt.txt")) annotation(Placement(transformation(extent={{-20,-60},{20,-20}})));
	MoSDH.Components.Loads.HeatDemand load(
		Qthermal(displayUnit="J"),
		tau=3600,
		medium=buffer.medium,
		loadData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatDemand/Darmstadt_TRY2015_5GWh.txt"),
		powerUnitData(displayUnit="W")=1000,
		TreturnGrid=TreturnRef) annotation(Placement(transformation(extent={{85,15},{125,55}})));
	MoSDH.Components.Sources.Fossil.GasBoiler boiler(
		tau=3600,
		Pthermal_max=2000000,
		mode=MoSDH.Utilities.Types.ControlTypes.RefFlowRefTemp,
		on=true,
		Tref(displayUnit="degC")=GB_Tref,
		volFlowRef=GB_volFlowRef) annotation(Placement(transformation(extent={{25,15},{65,55}})));
	MoSDH.Components.Storage.BoreholeStorage.BTES boreholes(
		nBHEs=200,
		BHElength=100,
		nBHEsInSeries=2,
		redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Gylcol20_20degC medium,
		BHEstart=2,
		BHEspacing=8,
		dZminMax(displayUnit=""),
		relativeModelDepth=1.3,
		nAdditionalElementsR=5,
		volFlowRef=-heatPump.volFlowSource) annotation(Placement(transformation(
		origin={-120,-25},
		extent={{-20,-20},{20,20}})));
	MoSDH.Components.Sources.Electric.HeatPump heatPump(
		tau=3600,
		redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Gylcol20_20degC mediumSource,
		setAbsoluteSourcePressure=true,
		redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water mediumLoad,
		setAbsoluteLoadPressure=false,
		TminLoad=323.15,
		MiminumShift=20,
		mode=MoSDH.Utilities.Types.ControlTypesHeatPump.SourceFlowRate,
		on=heatPumpMode == modes.FullLoad,
		Pref=HP_PthermalRef,
		Tref=TsupplyRef + 3,
		volFlowRef=boreholes.nBHEs * BHE_volFlowSpec / boreholes.nBHEsInSeries,
		DeltaTref=5) annotation(Placement(transformation(
		origin={-60,35},
		extent={{-20,-20},{20,20}})));
	MoSDH.Components.Distribution.HydraulicShunt hydraulicShunt(
		redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Gylcol20_20degC medium,
		setAbsolutePressure=false,
		tau=3600) annotation(Placement(transformation(
		origin={-95,35},
		extent={{-10,-10},{10,10}})));
	parameter Modelica.Units.SI.Power BHE_PthermalSpec=30;
	parameter Modelica.Units.SI.Temperature TsupplyRef=323.15;
	parameter Modelica.Units.SI.Temperature TreturnRef=298.15;
	parameter Modelica.Units.SI.Temperature TboreholeMin=273.15 "Minimum allowed entrance temperature of boreholes";
	parameter Modelica.Units.SI.VolumeFlowRate BHE_volFlowSpec=0.0005 "Specific flow rate through BHEs";
	modes heatPumpMode "Heat pump operation mode";
	modes boilerMode "Supply from buffer mode";
	Modelica.Units.SI.Power HP_PthermalRef(displayUnit="MW") "Reference thermal power of heat pump";
	Modelica.Units.SI.VolumeFlowRate GB_volFlowRef "Boiler flow rate";
	Modelica.Units.SI.Temperature GB_Tref "Boiler supply temperature";
	MoSDH.Components.Distribution.threeWayValveMix valve(tau=3600) annotation(Placement(transformation(extent={{70,35},{80,45}})));
	MoSDH.Components.Distribution.threeWayValveMix valve1(tau=3600) annotation(Placement(transformation(extent={{70,35},{80,25}})));
	MoSDH.Components.Distribution.threeWayValveMix valve5(tau=3600) annotation(Placement(transformation(extent={{-30,55},{-20,65}})));
	MoSDH.Components.Distribution.threeWayValveMix valve6(tau=3600) annotation(Placement(transformation(extent={{-30,15},{-20,5}})));
	MoSDH.Components.Distribution.threeWayValveMix valve2(tau=3600) annotation(Placement(transformation(extent={{20,15},{30,5}})));
	MoSDH.Components.Distribution.threeWayValveMix valve3(tau=3600) annotation(Placement(transformation(extent={{20,55},{30,65}})));
	MoSDH.Components.Distribution.Pump pump(volFlowRef=min(heatPump.volFlowLoad,load.volFlow-boiler.volFlow)) annotation(Placement(transformation(
		origin={0,70},
		extent={{-5,-5},{5,5}})));
	MoSDH.Components.Distribution.Pump pump1(volFlowRef=min(heatPump.volFlowLoad,load.volFlow-boiler.volFlow)) annotation(Placement(transformation(
		origin={0,-5},
		extent={{5,-5},{-5,5}})));
	initial algorithm
		// determine the initial heat pump operation mode
		  if max(buffer.Tlayers) < TsupplyRef and time>3600 then
		    heatPumpMode := modes.FullLoad;
		  else
		    heatPumpMode := modes.Idle;
		  end if;
		// determine the initial gas boiler operation mode
		  if min(buffer.Tlayers[buffer.nLayers - 1:buffer.nLayers]) > TsupplyRef + 1 then
		    boilerMode := modes.Idle;
		  elseif min(buffer.Tlayers[buffer.nLayers - 1:buffer.nLayers]) > TsupplyRef - 8 then
		    heatPumpMode := modes.PartLoad;
		  else
		    heatPumpMode := modes.FullLoad;
		  end if;
	algorithm
		//Switch heat pump on/off
		  when min(buffer.Tlayers) > TsupplyRef - 5 or min(boreholes.TboreholeWall) < TboreholeMin then
		    heatPumpMode := modes.Idle;
		  elsewhen max(buffer.Tlayers) < TsupplyRef and time>3600 and min(boreholes.TboreholeWall) > TboreholeMin + 2 then
		    heatPumpMode := modes.FullLoad;
		  end when;
		//siwtch between boiler full load, part load and idle model
		  when min(buffer.Tlayers[buffer.nLayers - 1:buffer.nLayers]) > TsupplyRef + 1 then
		    boilerMode := modes.Idle;
		  elsewhen min(buffer.Tlayers[buffer.nLayers - 1:buffer.nLayers]) < TsupplyRef - 3 then
		    boilerMode := modes.PartLoad;
		  elsewhen min(buffer.Tlayers[buffer.nLayers - 1:buffer.nLayers]) < TsupplyRef - 16 then
		    boilerMode := modes.FullLoad;
		  elsewhen min(buffer.Tlayers[buffer.nLayers - 1:buffer.nLayers]) > TsupplyRef - 8 then
		    boilerMode := modes.PartLoad;
		  end when;
	equation
		// Component behaviour
		HP_PthermalRef = boreholes.nBHEs * boreholes.BHElength * BHE_PthermalSpec * min(1, max(0.25, (min(boreholes.TboreholeWall) - TboreholeMin) / 2));
		if boilerMode == modes.FullLoad then
		  GB_volFlowRef = load.volFlow;
		  GB_Tref = TsupplyRef;
		elseif boilerMode == modes.PartLoad then
		  GB_volFlowRef = load.volFlow * (TsupplyRef - buffer.Tlayers[10]) / (363.15 - TsupplyRef);
		  GB_Tref = 363.15;
		else
		  GB_volFlowRef = 0;
		  GB_Tref = 363.15;
		end if;
		connect(hydraulicShunt.loadSupply,heatPump.supplyPortSource) annotation(Line(
			points={{-85,40},{-80,40},{-85,40},{-80,40}},
			color={255,0,0},
			thickness=1));
		connect(heatPump.returnPortSource,hydraulicShunt.loadReturn) annotation(Line(
			points={{-80,30},{-85,30},{-80.3,30},{-85.3,30}},
			color={0,0,255},
			thickness=1));
		connect(hydraulicShunt.sourceReturn,boreholes.returnPort) annotation(Line(
			points={{-105,30},{-110,30},{-110,0},{-110,-5}},
			color={0,0,255},
			thickness=1));
		connect(hydraulicShunt.sourceSupply,boreholes.supplyPort) annotation(Line(
			points={{-105,40},{-110,40},{-130,40},{-130,0},{-130,-5}},
			color={255,0,0},
			thickness=1));
		connect(boiler.supplyPort,valve.flowPort_b) annotation(Line(
			points={{64.7,40},{64.7,40},{65,40},{70,40}},
			color={255,0,0},
			thickness=1));
		connect(boiler.returnPort,valve1.flowPort_b) annotation(Line(
			points={{64.7,30},{64.7,30},{65,30},{70,30}},
			color={0,0,255},
			thickness=1));
		connect(load.supplyPort,valve.flowPort_a) annotation(Line(
			points={{85,40},{80,40},{79.7,40},{79.7,40}},
			color={255,0,0},
			thickness=1));
		connect(load.returnPort,valve1.flowPort_a) annotation(Line(
			points={{85,30},{80,30},{79.7,30},{79.7,30}},
			color={0,0,255},
			thickness=1));
		connect(load.weatherPort,weather.weatherPort) annotation(Line(
			points={{105,15.3},{105,10.3},{105,-15},{0,-15},{0,-20}},
			color={0,176,80}));
		connect(weather.weatherPort,buffer.weatherPort) annotation(Line(
			points={{0,-20},{0,-15},{0,0.3},{0,5.3}},
			color={0,176,80}));
		connect(pump1.flowPort_b,valve6.flowPort_c) annotation(Line(
			points={{-4,-5},{-9,-5},{-25,-5},{-25,0},{-25,5}},
			color={0,0,255},
			thickness=1));
		connect(pump.flowPort_a,valve5.flowPort_c) annotation(Line(
			points={{-5,70},{-10,70},{-25,70},{-25,65}},
			color={255,0,0},
			thickness=1));
		connect(pump.flowPort_b,valve3.flowPort_c) annotation(Line(
			points={{5,70},{10,70},{25,70},{25,65}},
			color={255,0,0},
			thickness=1));
		connect(buffer.sourceIn,valve5.flowPort_a) annotation(Line(
			points={{-15,60},{-20,60},{-15,60},{-20,60}},
			color={255,0,0},
			thickness=1));
		connect(buffer.sourceOut,valve6.flowPort_a) annotation(Line(
			points={{-15,10},{-20,10},{-15,10},{-20,10}},
			color={0,0,255},
			thickness=1));
		connect(buffer.loadOut,valve3.flowPort_b) annotation(Line(
			points={{14,60},{19,60},{15,60},{20,60}},
			color={255,0,0},
			thickness=1));
		connect(buffer.loadIn,valve2.flowPort_b) annotation(Line(
			points={{14,10},{19,10},{15,10},{20,10}},
			color={0,0,255},
			thickness=1));
		connect(valve2.flowPort_a,valve1.flowPort_c) annotation(Line(
			points={{29,10},{34,10},{75,10},{75,20},{75,25}},
			color={0,0,255},
			thickness=1));
		connect(valve3.flowPort_a,valve.flowPort_c) annotation(Line(
			points={{29,60},{34,60},{75,60},{75,50},{75,45}},
			color={255,0,0},
			thickness=1));
		connect(pump1.flowPort_a,valve2.flowPort_c) annotation(Line(
			points={{5,-5},{10,-5},{25,-5},{25,0},{25,5}},
			color={0,0,255},
			thickness=1));
		connect(valve6.flowPort_b,heatPump.returnPortLoad) annotation(Line(
			points={{-30,10},{-35,10},{-35,10},{-35,30},{-40,30}},
			color={0,0,255},
			thickness=1));
		connect(valve5.flowPort_b,heatPump.supplyPortLoad) annotation(Line(
			points={{-30,60},{-35,60},{-35,60},{-35,40},{-40,40}},
			color={255,0,0},
			thickness=1));
	annotation(
		__OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian -d=nonewInst -d=nonewInst",
		__OpenModelica_simulationFlags(
			lv="LOG_STATS",
			s="cvode"),
		__esi_viewinfo={
					ModelInfo(
						defaultViewSettings=ViewSettings(showGrid=2))},
		Diagram(coordinateSystem(extent={{-150,-100},{150,100}})),
		Documentation(info= "<html><head></head><body><h3 style=\"font-family: 'MS Shell Dlg 2';\">Example model for a geothermal heating system:</h3><h2><ul><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">A&nbsp;<a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.BTES\">borehole heat exchanger array</a>&nbsp;supplies heat to the&nbsp;<a href=\"modelica://MoSDH.Components.Storage.StratifiedTank.TTES\">buffer storage</a>&nbsp;via a&nbsp;<a href=\"modelica://MoSDH.Components.Sources.Electric.HeatPump\">heat pump</a>.&nbsp;</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">A <a href=\"modelica://MoSDH.Components.Distribution.HydraulicShunt\">shunt</a> is used for hydraulic decoupling of the BHEs and the heat pumps, since both have a circulation pump integrated into the same hydraulic circuit.</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">The&nbsp;<a href=\"modelica://MoSDH.Components.Loads.HeatDemand\">heat load</a>&nbsp;is suplied from the buffer storage and a&nbsp;<a href=\"modelica://MoSDH.Components.Sources.Fossil,BasBoiler\">gas boiler</a>&nbsp;is used as additional heat source.&nbsp;</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">The&nbsp;<a href=\"modelica://MoSDH.Components.Weather.WeatherData\">weather</a>&nbsp;component is required to giv the ambient temperature for calculation of the buffer's thermal losses and the day of the year for the heat load table.</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">Pumps are used to bypass the buffer, if heat can be supplied directly from the heat pump to the load.</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">The system control strategy is defined on the top level of the model.</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">Parameters&nbsp;<b>TsupplyRef</b>&nbsp;and&nbsp;<b>TreturnRef</b>&nbsp;are used to define the operating temperatures of the system.</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">The gas boiler is operated in mode&nbsp;<b>RefTempFefFlow</b>, for which the supply temperture is deined by the control variable&nbsp;<b>boiler.Tref</b>&nbsp;and the volume flow rate by the variable&nbsp;<b>boiler.volFlowRef</b>.&nbsp;</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">The variable&nbsp;<b>boilerMode</b>&nbsp;of type&nbsp;<a href=\"modelica://MoSDH.Utilities.Types.OperationModes\">OperationModes</a>&nbsp;is used &nbsp;to define the behavior of the gas boiler. Three modes are implemented:</li><ul style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><li><span style=\"font-weight: normal;\">Idle: If the buffer has the required temperature, the boiler is turned off (</span>boiler.<b>volFlowRef</b><span style=\"font-weight: normal;\">=0)</span></li><li style=\"font-weight: normal;\">PartLoad: If the buffer temperature falls below the required temperature, the gas boiler is used to shift the temperature of the stored heat by mixing.</li><li style=\"font-weight: normal;\">FullLoad: If the buffer temperature falls below the deinfed maximum, all of the heat demand is covered by the boiler.</li></ul><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><span style=\"font-weight: normal;\">The heat pump is operated in </span>mode<span style=\"font-weight: normal;\"> SourceFlowRate, fow which the source side volume flow rate (</span>heatPump.volFlowRef<span style=\"font-weight: normal;\">), the load side supply temperature (</span>heatPump.Tref<span style=\"font-weight: normal;\">) and the load thermal power (</span>heatPump.Tref<span style=\"font-weight: normal;\">) have to be defined.</span></li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><span style=\"font-weight: normal;\">The variable heatPumpMode is used to turn the heat pump off, if the buffer storage is filled or the borehole wall temperature falls below parameter </span>TboreholeMin.</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><span style=\"font-weight: normal;\">The heating power of the heat pump is defined in relation to the total borehole length by parameter </span>BHE_PthermalSpec<span style=\"font-weight: normal;\">&nbsp;and modulated to a minimum of 25 % if the borehole temperatures gets close to </span>TboreholeMin<span style=\"font-weight: normal;\">.</span></li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><span style=\"font-weight: normal;\">The borehole field volume flow rate </span>boreholes.volFlowRef<span style=\"font-weight: normal;\"> is set equal to the source side volume flow rate of the heat pump </span>hp.volFlowSource <span style=\"font-weight: normal;\">(negative -&gt; see pump on the icon of the borehole field).</span></li></ul>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>Thermal powers</caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/ExampleGeothermalHeating.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 2: </strong>BHE inlet and outlet temperatures </caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/ExampleGeothermalHeatingB.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>
</h2>

</body></html>"),
		experiment(
			StopTime=31536000,
			StartTime=0,
			Tolerance=0.0001,
			Interval=7200));
end ExampleGeothermalHeating;
