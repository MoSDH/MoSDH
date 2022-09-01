within MoSDH.Examples;
model ExampleSolarPTES "PTES SDH system 20220731.isx"
	import opMode = MoSDH.Utilities.Types.OperationModes;
	import seasons = MoSDH.Utilities.Types.Seasons;
	extends Modelica.Icons.Example;
	MoSDH.Components.Storage.PitStorage.PTES pit(
		
		Tinitial=fill(303.15, pit.nLayers),
		buoyancyMode=MoSDH.Components.Storage.StratifiedTank.BaseClasses.BuoyancyModels.buildings,
		embankmentHeight=1,
		embankmentWidth=1.5,
		heightMidPort=7,
		lamdaInsulationBottom=90,
		lamdaInsulationWall=90,
		lidOverlap=1, redeclare MoSDH.Parameters.Locations.SingleLayerLocation location,
		nLayers=15,
		nLidLayers=3,
		slope=0.5,
		storageHeight=10,
		storageVolume=75000,
		tInsulationBottom=1,
		tInsulationWall=1,
		tau=7200) annotation(Placement(transformation(extent={{-40,10},{-120,40}})));
	MoSDH.Components.Weather.WeatherData weather(
		verboseRead=false,
		initialMonth=5,
		summerStartMonth=4) annotation(Placement(transformation(extent={{85,-55},{125,-15}})));
	MoSDH.Components.Loads.HeatDemand load(
		tau=600,
		TreturnGrid=system.DH_TreturnRef) annotation(Placement(transformation(extent={{240,5},{280,45}})));
	MoSDH.Components.Sources.Solar.SolarThermalField solarField(
		collectorRowDistance=4,
		beta=0.6108652381980153,
		nParallel=25000 / (solarField.nSeries * solarField.apertureArea),
		V_collector=0.004,
		tau=120,
		on=solarMode == opMode.FullLoad,
		Tref=system.DH_TsupplyRef + 5) annotation(Placement(transformation(extent={{35,5},{75,45}})));
	MoSDH.Components.Distribution.HeatExchanger hx(
		nSegments=5,
		tau=600,
		redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Gylcol20_20degC mediumSource,
		V_flowNominalSource(displayUnit="m³/s")=solarField.nParallel * solarField.V_flowMax,
		setAbsoluteSourcePressure=true,
		V_flowNominalLoad(displayUnit="m³/s")=solarField.nParallel * solarField.V_flowMax,
		setAbsoluteLoadPressure=false,
		heatExchangeSurface=solarField.apertureArea * solarField.nSeries * solarField.nParallel * 0.2,
		heatTransferCoeffieicent=1500,
		controlType=MoSDH.Utilities.Types.ControlTypesHX.CoupleLoad,
		flowRatioConstant=hx.mediumLoad.cp * hx.mediumLoad.rho / (hx.mediumSource.cp * hx.mediumSource.rho)) annotation(Placement(transformation(extent={{80,15},{100,35}})));
	MoSDH.Components.Sources.Fossil.GasBoiler gb(
		tau=600,
		Pthermal_max=10000000,
		mode=MoSDH.Utilities.Types.ControlTypes.RefFlowRefTemp,
		Tref=gbTref,
		volFlowRef=gbVolFlowRef) annotation(Placement(transformation(extent={{110,5},{150,45}})));
	MoSDH.Components.Control.System system(
		lowerSetpointTambient=263.15,
		lowerSetpointTsupply=353.15,
		upperSetpointTsupply=343.15,
		DH_Treturn=303.15) annotation(Placement(transformation(extent={{35,-55},{75,-15}})));
	MoSDH.Components.Sources.Electric.HeatPump hp(
		tau=3600,
		setAbsoluteLoadPressure=false,
		TmaxLoad=363.15,
		constrainPower=true,
		powerScaling=2500000 / 300000,
		mode=MoSDH.Utilities.Types.ControlTypesHeatPump.DeltaTsource,
		on=hpMode == opMode.On,
		Pref=max(0.5,min(1,(pit.Tlayers[1]-TdischMin)/3))*2500000,
		Tref=system.DH_TsupplyRef+3,
		volFlowRef=2000000 / (10 * hp.mediumSource.cp * hp.mediumSource.rho),
		DeltaTref=10) annotation(Placement(transformation(extent={{-20,5},{20,45}})));
	Modelica.Units.SI.VolumeFlowRate gbVolFlowRef;
	Modelica.Units.SI.Temperature gbTref;
	opMode hpMode;
	opMode gbMode;
	opMode solarMode;
	MoSDH.Components.Distribution.DistrictHeatingPipes districtHeatingPipes(
		
		TinitialReturn(displayUnit = "K") =303.15,
		TinitialSupply(displayUnit = "K") =353.15, redeclare MoSDH.Parameters.Soils.Soil groundData,
		length=400,
		nElements=5,
		redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN250_450 pipeData) annotation(Placement(transformation(extent={{195,15},{235,35}})));
	MoSDH.Components.Distribution.ReturnFlowMixing rfm(Tref=system.DH_TsupplyRef) annotation(Placement(transformation(extent={{170,15},{190,35}})));
	MoSDH.Components.Distribution.threeWayValveMix vRet2(tau=1200) annotation(Placement(transformation(extent={{100,-5},{110,5}})));
	MoSDH.Components.Distribution.threeWayValveMix vSup1(tau=1200) annotation(Placement(transformation(extent={{100,55},{110,45}})));
	MoSDH.Components.Distribution.threeWayValveMix vRet1(tau=1200) annotation(Placement(transformation(extent={{-35,25},{-25,15}})));
	MoSDH.Components.Distribution.threeWayValveMix vSup2(tau=1200) annotation(Placement(transformation(extent={{155,25},{165,35}})));
	MoSDH.Components.Distribution.threeWayValveMix vRet3(tau=1200) annotation(Placement(transformation(extent={{155,25},{165,15}})));
	MoSDH.Components.Distribution.threeWayValveMix vRet(tau=1200) annotation(Placement(transformation(extent={{25,-5},{35,5}})));
	MoSDH.Components.Distribution.threeWayValveMix vSup(tau=1200) annotation(Placement(transformation(extent={{25,55},{35,45}})));
	parameter Modelica.Units.SI.Temperature TdischMin=293.15;
	initial algorithm
		if min(pit.Tlayers[pit.nLayers-3:pit.nLayers]) > system.DH_TsupplyRef or pit.Tlayers[1]<TdischMin-2 or weather.season==MoSDH.Utilities.Types.Seasons.Summer then
			hpMode := opMode.Off;
		else
			hpMode := opMode.On;
		end if;
		
		if pit.Tlayers[pit.nLayers] > system.DH_TsupplyRef then
			gbMode := opMode.Idle;
		elseif pit.Tlayers[pit.nLayers] > system.DH_TsupplyRef-5 then
		  	gbMode := opMode.PartLoadMixing;
		else
		  	gbMode := opMode.FullLoad;
		end if;
		
		if pit.Tlayers[pit.nLayers] < 363.15 then
		  solarMode := opMode.FullLoad;
		else
		  solarMode := opMode.Idle;
		end if;
	algorithm
		when min(pit.Tlayers[pit.nLayers-3:pit.nLayers]) > system.DH_TsupplyRef or pit.Tlayers[1]<TdischMin-2 or weather.season==MoSDH.Utilities.Types.Seasons.Summer then
			hpMode := opMode.Off;
		elsewhen min(pit.Tlayers[pit.nLayers-3:pit.nLayers]) < system.DH_TsupplyRef-5 and pit.Tlayers[1]>TdischMin+3 and weather.season==MoSDH.Utilities.Types.Seasons.Winter then
			hpMode := opMode.On;
		end when;
		
		when pit.Tlayers[pit.nLayers] < system.DH_TsupplyRef-3 then
		  	gbMode := opMode.PartLoadMixing;
		elsewhen pit.Tlayers[pit.nLayers] < system.DH_TsupplyRef-10 then
		  	gbMode := opMode.FullLoad;
		elsewhen pit.Tlayers[pit.nLayers] > system.DH_TsupplyRef-5 then
		  	gbMode := opMode.PartLoadMixing;
		elsewhen pit.Tlayers[pit.nLayers] > system.DH_TsupplyRef then
			gbMode := opMode.Idle;
		end when;
			
		  
		when pit.Tlayers[1] < 343.15 then
		  solarMode := opMode.FullLoad;
		elsewhen pit.Tlayers[1] > 353.15 then
		  solarMode := opMode.Idle;
		end when;
	equation
		if gbMode == opMode.Idle then
		  gbVolFlowRef = 0;
		  gbTref = system.DH_TsupplyRef;
		elseif gbMode == opMode.PartLoadMixing and hpMode==opMode.Off then
		  gbVolFlowRef = max(0, rfm.volFlowSource - hx.volFlowLoad - hp.volFlowLoad) * (system.DH_TsupplyRef - pit.Tlayers[pit.nLayers]) / (368.15 - pit.Tlayers[pit.nLayers]);
		  gbTref = 368.15;
		elseif gbMode == opMode.PartLoadMixing and hpMode==opMode.On then
			gbVolFlowRef = max(0, rfm.volFlowSource - hx.volFlowLoad - hp.volFlowLoad);
		  	gbTref = system.DH_TsupplyRef;
		else
		  gbVolFlowRef = max(0, rfm.volFlowSource - hx.volFlowLoad - hp.volFlowLoad);
		  gbTref = system.DH_TsupplyRef;
		end if;
		connect(solarField.returnPort,hx.returnPortSource) annotation(Line(
			points={{74.67,20},{74.67,20},{75,20},{80,20}},
			color={0,0,255},
			thickness=1));
		connect(solarField.supplyPort,hx.supplyPortSource) annotation(Line(
			points={{74.67,30},{74.67,30},{75,30},{80,30}},
			color={255,0,0},
			thickness=1));
		connect(hp.returnPortLoad,vRet.flowPort_c) annotation(Line(
			points={{19.7,20},{24.7,20},{30,20},{30,10},{30,5}},
			color={0,0,255},
			thickness=1));
		connect(hp.supplyPortLoad,vSup.flowPort_c) annotation(Line(
			points={{19.7,30},{24.7,30},{30,30},{30,40},{30,45}},
			color={255,0,0},
			thickness=1));
		connect(weather.weatherPort,system.weatherPort) annotation(Line(
			points={{105,-15},{105,-10},{55,-10},{55,-15}},
			color={0,176,80}));
		connect(weather.weatherPort,solarField.weatherPort) annotation(
			Line(
				points={{105,-15},{105,-10},{55,-10},{55,5.333335876464844}},
				color={0,176,80}));
		connect(weather.weatherPort,load.weatherPort) annotation(
			Line(
				points={{105,-15},{105,-10},{260,-10},{260,5.333335876464844}},
				color={0,176,80}));
		connect(districtHeatingPipes.weatherPort,weather.weatherPort) annotation(Line(
			points={{215,15.3},{215,10.3},{215,-10},{105,-10},{105,-15}},
			color={0,176,80}));
		connect(pit.weatherPort,weather.weatherPort) annotation(Line(
			points={{-80,10.3},{-80,5.3},{-80,-10},{105,-10},{105,-15}},
			color={0,176,80}));
		connect(hx.returnPortLoad,vRet2.flowPort_c) annotation(Line(
			points={{99.67,20},{99.67,20},{105,20},{105,10},{105,5}},
			color={0,0,255},
			thickness=1));
		connect(vSup.flowPort_a,vSup1.flowPort_b) annotation(Line(
			points={{34.7,50},{39.7,50},{95,50},{100,50}},
			color={255,0,0},
			thickness=1));
		connect(hx.supplyPortLoad,vSup1.flowPort_c) annotation(Line(
			points={{99.67,30},{99.67,30},{105,30},{105,40},{105,45}},
			color={255,0,0},
			thickness=1));
		connect(vRet.flowPort_a,vRet2.flowPort_b) annotation(Line(
			points={{34.7,0},{39.7,0},{95,0},{100,0}},
			color={0,0,255},
			thickness=1));
		connect(districtHeatingPipes.fromSupply,load.supplyPort) annotation(Line(
			points={{234.7,30},{239.7,30},{235,30},{240,30}},
			color={255,0,0},
			thickness=1));
		connect(districtHeatingPipes.toSupply,rfm.supplyPortLoad) annotation(Line(
			points={{195,30},{190,30},{189.67,30},{189.67,30}},
			color={255,0,0},
			thickness=1));
		connect(districtHeatingPipes.fromReturn,rfm.returnPortLoad) annotation(Line(
			points={{195,20},{190,20},{189.67,20},{189.67,20}},
			color={0,0,255},
			thickness=1));
		connect(load.returnPort,districtHeatingPipes.toReturn) annotation(Line(
			points={{240,20},{235,20},{239.7,20},{234.7,20}},
			color={0,0,255},
			thickness=1));
		connect(vSup1.flowPort_a,vSup2.flowPort_c) annotation(Line(
			points={{109.67,50},{109.67,50},{160,50},{160,40},{160,35}},
			color={255,0,0},
			thickness=1));
		connect(vRet2.flowPort_a,vRet3.flowPort_c) annotation(Line(
			points={{109.67,0},{109.67,0},{160,0},{160,10},{160,15}},
			color={0,0,255},
			thickness=1));
		connect(gb.returnPort,vRet3.flowPort_b) annotation(Line(
			points={{149.7,20},{154.7,20},{150,20},{155,20}},
			color={0,0,255},
			thickness=1));
		connect(gb.supplyPort,vSup2.flowPort_b) annotation(Line(
			points={{149.7,30},{154.7,30},{150,30},{155,30}},
			color={255,0,0},
			thickness=1));
		connect(rfm.supplyPortSource,vSup2.flowPort_a) annotation(Line(
			points={{170,30},{165,30},{164.67,30},{164.67,30}},
			color={255,0,0},
			thickness=1));
		connect(rfm.returnPortSource,vRet3.flowPort_a) annotation(Line(
			points={{170,20},{165,20},{164.67,20},{164.67,20}},
			color={0,0,255},
			thickness=1));
		connect(pit.midPort,hp.supplyPortSource) annotation(Line(
			points={{-40,25},{-35,25},{-25,25},{-25,30},{-20,30}},
			color={177,0,177},
			thickness=1));
		connect(hp.returnPortSource,vRet1.flowPort_a) annotation(Line(
			points={{-20,20},{-25,20},{-20.3,20},{-25.3,20}},
			color={0,0,255},
			thickness=1));
		connect(pit.bottomPort,vRet1.flowPort_b) annotation(Line(
			points={{-40,20},{-35,20},{-40,20},{-35,20}},
			color={0,0,255},
			thickness=1));
		connect(vRet1.flowPort_c,vRet.flowPort_b) annotation(Line(
			points={{-30,15},{-30,10},{-30,0},{20,0},{25,0}},
			color={0,0,255},
			thickness=1));
		connect(pit.topPort,vSup.flowPort_b) annotation(
			Line(
				points={{-40,30},{-35,30},{-30,30},{-30,50},{25,50}},
				color={255,0,0},
				thickness=1));
	annotation(
		__OpenModelica_simulationFlags(
			lv="LOG_STATS", s = "cvode"),
		__OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
		uses(
			MoSDH(version="1.0"),
			Modelica(version="4.0.0")),
		Diagram(coordinateSystem(extent={{-125,-125},{275,125}})),
		Documentation(info="<html><head></head><body><h2>Example Geothermal Heating System</h2><h4>Solar district heating system with pit storage.</h4><div><ul><li>The solar thermal field is operated in mode <b>RefTemp</b> for which the reference supply temperture has to be defined by the control variable <b>Tref</b>.&nbsp;</li><li>The share of the load side flow rate of the solar heat exchanger which exceeds the flow rate of the load component is fed into the pit storage.</li><li>The pit storage is discharged to the load component:</li><ul><li>Directly, if the top layer temperature is at the reference supply temperature level (pitMode:=FullLoad)</li><li>Mixed with hot fluid from the gas boiler, if the pit top temperature falls 6K below the reference supply temperature and the heating season is winter (pitMode:=PartLoadMixing).</li><li>Discharged with a heat pump, if the pit top temperature falls 14K below the reference supply temperature and the season is winter (pitMode:=HeatPumpDischarge)</li><li>Not discharged (pitMode:=Idle), if&nbsp;</li><ul><li>the solar production is above the current demand of the load</li><li>pit top temperature falls 6K below reference supply temperature during summer&nbsp;</li><li>pit top temperature falls belo 50 Â°C during winter.</li></ul></ul><li>The heat pump source side is supplied by the pit top diffusor and returns the cooled down fluid to the mid diffusor.</li><li>The HP&nbsp;is operated in mode <b>SourceFlowRate</b>&nbsp;for which the following signals have to be defined in the component:</li><ul><li>source side volume flow rate&nbsp;<b>volFlow</b></li><li>load side supply temperature&nbsp;<b>Tref</b>&nbsp;</li><li>load side thermal power&nbsp;<b>Pref</b>.</li></ul><li>The volume flow required by the heat load which can not be supplied by the solar thermal field and the pit storage is supplied by the gas boiler.</li><li>The gas boiler is controlled with mode RefFlowRefTemp for which the following signals have to be defined in the control component:</li><ul><li>Turn boiler on/off: <b>on</b></li><li>Supply temperture <b>Tref</b></li><li>Volume flow rate <b>volFlow</b></li></ul><li>The gas boiler is controlled differently according to the current pitMode:</li><ul><li>Idle: Turned off</li><li>PartLoadMixing: The gas boiler supplies water at 90 Â°C and the volume flow rate is controlled so the mixed fluid of the pit and the boiler has the reference supply temperature. The mixed fluid operates in parallel to the solar collectors.</li><li>The gas boiler operates at the reference supply temperature and in parallel to the solar collectors and the heat pump.</li></ul></ul></div>

</body></html>"),
		experiment(
			StopTime= 3.1536e+07,
			StartTime=0,
			Tolerance= 1e-04,
			Interval= 7200));
end ExampleSolarPTES;
