within MoSDH.Examples;
model ExampleGeoSolar "Example model with BHE and solar thermal fields"
	import MoSDH.Utilities.Types.Seasons;
	extends Modelica.Icons.Example;
		import Modes = MoSDH.Utilities.Types.OperationModes;
		Components.Sources.Solar.SolarThermalField solarThermalField(
			specificYield(displayUnit="J"),
			collectorRowDistance=5,
			azimut=0,
			beta=0.61086523819802,
			nParallel=200,
			nSeries=3,
			apertureArea=13.61,
			height=2.28,
			V_flowMax=0.01,
			tau=600,
			eta0=0.773,
			a1=2.27,
			a2=0.018,
			on=SolarMode == Modes.FullLoad,
			Tref=max(TsupplyRef + 3, tank.Tlayers[1] + 15)) annotation(Placement(transformation(extent={{-135,20},{-95,60}})));
		Components.Distribution.HeatExchanger heatExchanger(
			nSegments=5,
			tau=600,
			redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Gylcol20_20degC mediumSource,
			setAbsoluteSourcePressure=true,
			mediumLoad=tank.medium,
			setAbsoluteLoadPressure=false,
			heatExchangeSurface=solarThermalField.nParallel * solarThermalField.nSeries * solarThermalField.apertureArea * 0.15,
			heatTransferCoeffieicent=1000,
			controlType=Utilities.Types.ControlTypesHX.CoupleLoad,
			flowRatioConstant=heatExchanger.mediumLoad.cp / heatExchanger.mediumSource.cp) annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
		Components.Distribution.threeWayValveMix valve1(
			medium=tank.medium,
			controlMode=MoSDH.Utilities.Types.ValveOpeningModes.free,
			tau=600) annotation(Placement(transformation(
			origin={5,0},
			extent={{5,-5},{-5,5}},
			rotation=-90)));
		Components.Distribution.threeWayValveMix valve2(
			medium=tank.medium,
			controlMode=MoSDH.Utilities.Types.ValveOpeningModes.free,
			tau=600) annotation(Placement(transformation(
			origin={15,-5},
			extent={{-5,-5},{5,5}},
			rotation=-90)));
		Components.Storage.StratifiedTank.TTES tank(
			storageVolume=solarThermalField.nParallel * solarThermalField.nSeries * solarThermalField.apertureArea * 0.2,
			storageHeight=10,
			Tinitial(each displayUnit="degC")={303.15, 303.15, 303.15, 303.15, 303.15, 338.15, 338.15, 338.15, 338.15, 338.15}) annotation(Placement(transformation(extent={{-40,10},{-10,70}})));
		Components.Weather.WeatherData weather(
			weatherData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/Weather/DWD/TRY2017_Darmstadt.txt"),
			initialMonth=4) annotation(Placement(transformation(extent={{-100,-50},{-60,-10}})));
		Components.Loads.HeatDemand load(
			tau=600,
			medium=tank.medium,
			loadData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatDemand/Darmstadt_TRY2015_5GWh.txt"),
			powerUnitData=1000,
			TreturnGrid=TreturnRef) annotation(Placement(transformation(extent={{75,20},{115,60}})));
		Components.Sources.Fossil.GasBoiler boiler(
			tau=600,
			Pthermal_max=10000000,
			mode=MoSDH.Utilities.Types.ControlTypes.RefFlowRefTemp,
			on=true,
			Tref=TsupplyRef + 5,
			volFlowRef=max(0, load.volFlow - Buffer_volFlowRef)) annotation(Placement(transformation(extent={{15,20},{55,60}})));
		Components.Storage.BoreholeStorage.BTES boreholes(
			
			BHElength=150,
			BHEspacing= 4, BHEstart = 2, dZminMax(displayUnit = ""), nAdditionalElementsR = 6,nBHEs=100,
			nBHEsInSeries=2, relativeModelDepth = 1.3,
			volFlowRef=if BTESmode == Modes.Charge then BHE_volFlowRefSummer * boreholes.nBHEs / boreholes.nBHEsInSeries elseif BTESmode == Modes.Discharge then -BHE_volFlowRefWinter * boreholes.nBHEs / boreholes.nBHEsInSeries else 0) annotation(Placement(transformation(
			origin={40,-30},
			extent={{20,-20},{-20,20}})));
		Components.Sources.Electric.HeatPump heatPump(
			tau=600,
			mediumSource=boreholes.medium,
			setAbsoluteSourcePressure=false,
			redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water mediumLoad,
			setAbsoluteLoadPressure=false,
			TminSource=268.15,
			TmaxLoad=363.15,
			TminLoad=303.15,
			MiminumShift=20,
			HPdataFile=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatPump/Viessmann_Vitocal_350AHT147.txt"),
			mode=MoSDH.Utilities.Types.ControlTypesHeatPump.SourceFlowRate,
			on=HPmode == Modes.FullLoad,
			Pref=PthermalMax * min(1, max(0.2, (min(boreholes.TboreholeWall) - TboreholeMin)/temperatureDummy)),
			Tref=TsupplyRef + 2,
			volFlowRef=-boreholes.volFlow) annotation(Placement(transformation(
			origin={-25,-30},
			extent={{20,-20},{-20,20}})));
		Components.Distribution.threeWayValveMix valve(tau=600) annotation(Placement(transformation(extent={{60,40},{70,50}})));
		Components.Distribution.threeWayValveMix valve3(tau=600) annotation(Placement(transformation(extent={{60,40},{70,30}})));
		parameter Modelica.Units.SI.Power PthermalMax=boreholes.nBHEs*4000 "Maximum thermal power of heat pump";
		parameter Modelica.Units.SI.Temperature TsupplyRef=323.15 "Reference grid supply temperature";
		parameter Modelica.Units.SI.Temperature TreturnRef=298.15 "Reference grid return temperature";
		parameter Modelica.Units.SI.Temperature TboreholeMin=283.15 "Minimum allowed entrance temperature of boreholes";
		parameter Modelica.Units.SI.VolumeFlowRate BHE_volFlowRefSummer(displayUnit="l/s")=0.00025 "Reference volume flow rate through indiviual boreholes in summer";
		parameter Modelica.Units.SI.VolumeFlowRate BHE_volFlowRefWinter=0.0005 "Reference volume flow rate through indiviual boreholes";
		parameter Integer summerStartMonth(
			min=1,
			max=12)=4 "First month of summer";
		parameter Integer winterStartMonth(
			min=1,
			max=12)=9 "First month of winter";
		Modes HPmode "Heat pump operation mode";
		Modes RenewableHeatingMode "Supply from buffer storage";
		Modes SolarMode "Solar thermal operation mode";
		Modes BTESmode "BTES operation mode";
		Seasons season "Winter/Summer";
		Modelica.Units.SI.VolumeFlowRate Buffer_volFlowRef "Volume flow from buffer to load";
		Modelica.Units.SI.VolumeFlowRate Buffer_volFlowMax "Maximum volume flow from buffer to load";
		Modelica.Units.SI.Temperature Tmean=(boreholes.Tsupply + boreholes.Treturn)/2 "Mean BHE temperature";
		Real storageUtilization=boreholes.QthermalDischarged/max(1,boreholes.QthermalCharged)*100 "Storage utilization [%]";
	protected
		constant Modelica.Units.SI.Temperature temperatureDummy=1 "Dummy variable for unit consistency";
		constant Modelica.Units.SI.Time timeDummy=1 "Dummy variable for unit consistency";
	initial algorithm
		// determine the initial control states
		// Season
		  if weather.monthOfTheYear >= summerStartMonth and weather.monthOfTheYear < winterStartMonth then
		    season := Seasons.Summer;
		  else
		    season := Seasons.Winter;
		  end if;
		//initial solar mode
		  SolarMode := Modes.FullLoad;
		//Initial BTES & heat pump operation modes
		  if season == Seasons.Winter and min(tank.Tlayers[8:10]) < TsupplyRef and min(boreholes.TboreholeWall) > TboreholeMin + 0.5 then
		    HPmode := Modes.FullLoad;
		    BTESmode := Modes.Discharge;
		  elseif season == Seasons.Summer and min(tank.Tlayers[3:10]) > TsupplyRef then
		    HPmode := Modes.Idle;
		    BTESmode := Modes.Charge;
		  else
		    HPmode := Modes.Idle;
		    BTESmode := Modes.Idle;
		  end if;
		// Initial Geothermal heating mode
		  if min(tank.Tlayers[5:10]) > TsupplyRef - 2 then
		    RenewableHeatingMode := Modes.FullLoad;
		  elseif min(tank.Tlayers[8:10]) > TsupplyRef - 2 then
		    RenewableHeatingMode := Modes.PartLoad;
		  else
		    RenewableHeatingMode := Modes.Idle;
		  end if;
		//Wechsel zwiwschen States beim Eintritt von 'events'
	equation
		//Change of season
	algorithm
		  when weather.monthOfTheYear >= summerStartMonth then
		    season := Seasons.Summer;
		  elsewhen weather.monthOfTheYear >= winterStartMonth then
		    season := Seasons.Winter;
		  end when;
		//Control strategy
		// switch solar field on/off depending on the buffer storage state of charge
		  when tank.Tlayers[1] > TsupplyRef or tank.Tlayers[10] > 378.15 then
		    SolarMode := Modes.Idle;
		  elsewhen tank.Tlayers[1] < TsupplyRef - 10 and tank.Tlayers[10] < 373.15 then
		    SolarMode := Modes.FullLoad;
		  end when;
		// Renewable heating mode transitions (geothermal & solar)
		  when RenewableHeatingMode == Modes.FullLoad and min(tank.Tlayers[7:10]) < TsupplyRef - 2 then
		    RenewableHeatingMode := Modes.PartLoad;
		  elsewhen RenewableHeatingMode == Modes.PartLoad and tank.Tlayers[10] < TsupplyRef - 2 then
		    RenewableHeatingMode := Modes.Idle;
		  elsewhen RenewableHeatingMode == Modes.Idle and min(tank.Tlayers[8:10]) > TsupplyRef - 2 then
		    RenewableHeatingMode := Modes.PartLoad;
		  elsewhen RenewableHeatingMode == Modes.PartLoad and min(tank.Tlayers[5:10]) > TsupplyRef - 2 then
		    RenewableHeatingMode := Modes.FullLoad;
		  end when;
		//BTES & heat pump operation modes
		  when season == Seasons.Winter and min(tank.Tlayers[8:10]) < TsupplyRef and min(boreholes.TboreholeWall) > TboreholeMin + 0.5 then
		    HPmode := Modes.FullLoad;
		    BTESmode := Modes.Discharge;
		  elsewhen season == Seasons.Winter and (min(boreholes.TboreholeWall) < TboreholeMin or min(tank.Tlayers[3:10]) > TsupplyRef + 1) then
		    HPmode := Modes.Idle;
		    BTESmode := Modes.Idle;
		  elsewhen season == Seasons.Summer and min(tank.Tlayers[6:10]) > TsupplyRef then
		    HPmode := Modes.Idle;
		    BTESmode := Modes.Charge;
		  elsewhen season == Seasons.Summer and min(tank.Tlayers[9:10]) < TsupplyRef - 3 then
		    HPmode := Modes.Idle;
		    BTESmode := Modes.Idle;
		  end when;
	equation
		// Renewable heating volume flow rate (geothermal & solar)
		// reference volume flow is defined by maximum allowed or current demand
		  Buffer_volFlowRef = max(0, min(Buffer_volFlowMax, load.volFlow));
		
		// maximum allowed flow rate is defined in relation to the time it takes to empty the tank (2h/4h)
		  if RenewableHeatingMode == Modes.FullLoad then
		    Buffer_volFlowMax = tank.storageVolume / (7200*timeDummy);
		  elseif RenewableHeatingMode == Modes.PartLoad then
		    Buffer_volFlowMax = tank.storageVolume / (14400*timeDummy);
		  else
		    Buffer_volFlowMax = 0;
		  end if;
		
		
		connect(weather.weatherPort,tank.weatherPort) annotation(Line(
		 points={{-80,-10},{-80,-5},{-80,10},{-25,10},{-25,10.33}},
		 color={0,176,80}));
		connect(weather.weatherPort,load.weatherPort) annotation (
		 Line(
		  points={{-80,-10},{-80,-5},{-80,10},{95,10},{95,20.33}},
		  color={0,176,80}));
		connect(solarThermalField.returnPort,heatExchanger.returnPortSource) annotation(Line(
		 points={{-95.33,35},{-95.33,35},{-95,35},{-90,35}},
		 color={0,0,255},
		 thickness=1));
		connect(solarThermalField.supplyPort,heatExchanger.supplyPortSource) annotation(Line(
		 points={{-95.33,45},{-95.33,45},{-95,45},{-90,45}},
		 color={255,0,0},
		 thickness=1));
		connect(weather.weatherPort,solarThermalField.weatherPort) annotation(Line(
		 points={{-80,-10},{-80,-5},{-80,10},{-115,10},{-115,20.33}},
		 color={0,176,80}));
		connect(boreholes.returnPort,valve2.flowPort_c) annotation(Line(
		 points={{30,-10},{30,-5},{25,-5},{20,-5}},
		 color={0,0,255},
		 thickness=1));
		connect(heatPump.returnPortSource,valve2.flowPort_a) annotation(Line(
		 points={{-5,-35},{0,-35},{15,-35},{15,-9.67},{15,-9.67}},
		 color={0,0,255},
		 thickness=1));
		connect(heatPump.supplyPortSource,valve1.flowPort_b) annotation(Line(
		 points={{-5,-25},{0,-25},{5,-25},{5,-10},{5,-5}},
		 color={255,0,0},
		 thickness=1));
		connect(tank.loadOut,valve1.flowPort_a) annotation(Line(
		 points={{-10.33,65},{-10.33,65},{5,65},{5,4.67},{5,4.67}},
		 color={255,0,0},
		 thickness=1));
		connect(boreholes.supplyPort,valve1.flowPort_c) annotation(Line(
		 points={{50,-10},{50,-5},{50,0},{15,0},{10,0}},
		 color={255,0,0},
		 thickness=1));
		connect(tank.loadIn,valve2.flowPort_b) annotation(Line(
		 points={{-10.33,15},{-10.33,15},{15,15},{15,5},{15,0}},
		 color={0,0,255},
		 thickness=1));
		connect(tank.sourceIn,heatExchanger.supplyPortLoad) annotation(Line(
		 points={{-40,65},{-45,65},{-65.3,65},{-65.3,45},{-70.33,45}},
		 color={255,0,0},
		 thickness=1));
		connect(heatPump.supplyPortLoad,tank.sourceIn) annotation(Line(
		 points={{-44.67,-25},{-49.7,-25},{-49.7,65},{-45,65},{-40,65}},
		 color={255,0,0},
		 thickness=1));
		connect(heatPump.returnPortLoad,tank.sourceOut) annotation(Line(
		 points={{-44.67,-35},{-55,-35},{-55,15},{-45,15},{-40,15}},
		 color={0,0,255},
		 thickness=1));
		connect(tank.sourceOut,heatExchanger.returnPortLoad) annotation(Line(
		 points={{-40,15},{-45,15},{-65.3,15},{-65.3,35},{-70.33,35}},
		 color={0,0,255},
		 thickness=1));
		connect(tank.loadOut,valve.flowPort_c) annotation(Line(
		 points={{-10.33,65},{-10.33,65},{65,65},{65,55},{65,50}},
		 color={255,0,0},thickness=1));
		connect(tank.loadIn,valve3.flowPort_c) annotation(Line(
		 points={{-10.33,15},{-10.33,15},{65,15},{65,25},{65,30}},
		 color={0,0,255},thickness=1));
		connect(boiler.supplyPort,valve.flowPort_b) annotation(Line(
		 points={{54.67,45},{54.67,45},{55,45},{60,45}},
		 color={255,0,0},thickness=1));
		connect(boiler.returnPort,valve3.flowPort_b) annotation(Line(
		 points={{54.67,35},{54.67,35},{55,35},{60,35}},
		 color={0,0,255},thickness=1));
		connect(load.supplyPort,valve.flowPort_a) annotation(Line(
		 points={{75,45},{70,45},{69.67,45},{69.67,45}},
		 color={255,0,0},thickness=1));
		connect(load.returnPort,valve3.flowPort_a) annotation(Line(
		 points={{75,35},{70,35},{69.67,35},{69.67,35}},
		 color={0,0,255},thickness=1));
	annotation(
		__OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian -d=nonewInst -d=nonewInst",
		__OpenModelica_simulationFlags(
			lv="LOG_STATS",
			s= "cvode"),
		Diagram(coordinateSystem(extent={{-150,-100},{150,100}})),
		Documentation(info= "<html><head></head><body><h3 style=\"font-family: 'MS Shell Dlg 2';\">Example model for a geo-solar heating system:</h3><h2><ul><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">A&nbsp;<a href=\"modelica:///MoSDH.Components.Sources.Solar.SolarThermalField\">solar thermal collector field</a>&nbsp;supplies heat to the&nbsp;<a href=\"modelica:///MoSDH.Components.Storage.StratifiedTank.TTES\">buffer storage</a>&nbsp;via a&nbsp;<a href=\"modelica:///MoSDH.Components.Distribution.HeatExchanger\">heat exchanger</a>.&nbsp;</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">The&nbsp;<a href=\"modelica:///MoSDH.Components.Storage.BoreholeStorage.BTES\">borehole heat exchanger array</a>&nbsp;supplies heat to the&nbsp;<a href=\"modelica:///MoSDH.Components.Storage.StratifiedTank.TTES\">buffer storage</a>&nbsp;via a&nbsp;<a href=\"modelica:///MoSDH.Components.Sources.Electric.HeatPump\">heat pump</a>.&nbsp;</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">The BHE array is regenerated (charged) during summer with excess heat from the buffer storage.</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">The&nbsp;<a href=\"modelica:///MoSDH.Components.Loads.HeatDemand\">heat load</a>&nbsp;is suuplied from the buffer storage and a&nbsp;<a href=\"modelica:///MoSDH.Components.Sources.Fossil,BasBoiler\">gas boiler</a>&nbsp;is used if the buffer is used as additional heat source.&nbsp;</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">The system control strategy is defined on the top level of the model.</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">Parameters&nbsp;<b>TsupplyRef</b>&nbsp;and&nbsp;<b>TreturnRef</b>&nbsp;are used to define the operating temperatures of the system.</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">The gas boiler is operated in mode&nbsp;<b>RefTempFefFlow</b>, for which teh supply temperture is deined by the control variable&nbsp;<b>boiler.Tref</b>&nbsp;and the volume flow rate by the variable&nbsp;<b>boiler.volFlowRef</b>.&nbsp;</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\">The variable&nbsp;<b>boilerMode</b>&nbsp;of type&nbsp;<a href=\"modelica:///MoSDH.Utilities.Types.OperationModes\">OperationModes</a>&nbsp;is used &nbsp;to define the behavior of the gas boiler. Three modes are implemented:</li><ul style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px; font-weight: normal;\"><li>Idle: If the buffer has the required temperature, the boiler is turned off (<b>volFlowRef</b>=0)</li><li>PartLoad: If the buffer temperature falls below the required temperature, the gas boiler is used to shift the temperature of the stored heat by mixing.</li><li>FullLoad: If the buffer temperature falls below the deinfed maximum, all of the heat demand is covered by the boiler.</li></ul><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><span style=\"font-weight: normal;\">The heat pump is operated in&nbsp;</span>mode<span style=\"font-weight: normal;\">&nbsp;SourceFlowRate, fow which the source side volume flow rate (</span>hp.volFlowRef<span style=\"font-weight: normal;\">), the load side supply temperature (</span>hp.Tref<span style=\"font-weight: normal;\">) and the load thermal power (</span>hp.Tref<span style=\"font-weight: normal;\">) have to be defined.</span></li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><span style=\"font-weight: normal;\">The variable heatPumpMode is used to turn the heat pump off, if the buffer storage is filled or the borehole wall temperature falls below parameter&nbsp;</span>TboreholeMin.</li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><span style=\"font-weight: normal;\">The heating power of the heat pump is defined in relation to the total borehole length by parameter&nbsp;</span>BHE_PthermalSpec<span style=\"font-weight: normal;\">&nbsp;and modulated to a minimum of 25 % if the borehole temperatures gets close to&nbsp;</span>TboreholeMin<span style=\"font-weight: normal;\">.</span></li><li style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><span style=\"font-weight: normal;\">The borehole field volume flow rate&nbsp;</span>boreholes.volFlowRef<span style=\"font-weight: normal;\">&nbsp;is set equal to the source side volume flow rate of the heat pump&nbsp;</span>hp.volFlowSource&nbsp;<span style=\"font-weight: normal;\">(negative -&gt; see pump on the icon of the borehole field).</span></li></ul></h2>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>Borehole inlet and outlet temperatures</caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/ExampleGeoSolarA.png\" width=\"700\">
    </td>
  </tr>
  
</tbody></table>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 2: </strong>Energy supplies and demand of the components.</caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/ExampleGeoSolarB.png\" width=\"700\">
    </td>
  </tr>
  
</tbody></table>
</body></html>"),
		experiment(
			StopTime = 157680000,
			StartTime=0,
			Tolerance=0.0001,
			Interval= 36000));
end ExampleGeoSolar;
