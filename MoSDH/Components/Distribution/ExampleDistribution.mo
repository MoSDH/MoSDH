within MoSDH.Components.Distribution;
model ExampleDistribution "Distribution example"
	extends Modelica.Icons.Example;
	Weather.WeatherData weatherData(
		latitude=-0.5916666164260777,
		weatherData="C:\\Users\\Julian\\Documents\\Modelica\\MoSDH\\Data\\Weather\\EnergyPlus\\AUS_NSW.Sydney.947670_IWEC.txt") annotation(Placement(transformation(
		origin={1,-51},
		extent={{-21,-21},{21,21}})));
	Loads.HeatDemand load(
		loadData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatDemand/Darmstadt_TRY2015_5GWh.txt"),
		powerUnitData(displayUnit="kW")=1000) annotation(Placement(transformation(extent={{-55,-15},{-95,25}})));
	HeatExchanger HX1(
		Tinitial=323.15,
		setAbsoluteSourcePressure=true,
		pSource=100000,
		setAbsoluteLoadPressure=true,
		pLoad=100000,
		heatExchangeSurface=1200,
		heatTransferCoeffieicent=1500,
		controlType=MoSDH.Utilities.Types.ControlTypesHX.Passive) annotation(Placement(transformation(extent={{-30,-5},{-50,15}})));
	DistrictHeatingPipes pipe1(
		redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN200_355 pipeData,
		volFlowSupply(displayUnit="mÂ³/h")) annotation(Placement(transformation(
		origin={-30,60},
		extent={{-20,10},{20,-10}},
		rotation=180)));
	Loads.HeatDemand load2(
		loadData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatDemand/Darmstadt_TRY2015_5GWh.txt"),
		powerUnitData(displayUnit="kW")=1000) annotation(Placement(transformation(extent={{70,-15},{30,25}})));
	HeatExchanger HX2(
		Tinitial=323.15,
		setAbsoluteSourcePressure=false,
		pSource=100000,
		pLoad=100000,
		heatExchangeSurface=1200,
		heatTransferCoeffieicent=1500,
		controlType=MoSDH.Utilities.Types.ControlTypesHX.CoupleSource) annotation(Placement(transformation(extent={{65,50},{85,70}})));
	DistrictHeatingTwinPipes pipe2(
		redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN100_twinPipe twinPipeData,
		redeclare replaceable parameter Parameters.Grouts.PUfoam insulationData) annotation(Placement(transformation(
		origin={25,60},
		extent={{-20,10},{20,-10}},
		rotation=180)));
	Sources.Fossil.GasBoiler gasBoiler1(
		Pthermal_max=100000000,
		mode=MoSDH.Utilities.Types.ControlTypes.RefFlowRefTemp,
		volFlowRef(displayUnit="mÂ³/s")=HX1.volFlowLoad+HX2.volFlowLoad) annotation(Placement(transformation(
		origin={-75,60},
		extent={{-20,-20},{20,20}})));
	equation
		connect(HX1.returnPortLoad,load.returnPort) annotation(Line(
		 points={{-49.7,0},{-54.7,0},{-50,0},{-55,0}},
		 color={0,0,255},
		 thickness=1));
		connect(HX1.supplyPortLoad,load.supplyPort) annotation(Line(
		 points={{-49.7,10},{-54.7,10},{-50,10},{-55,10}},
		 color={255,0,0},
		 thickness=1));
		connect(HX2.supplyPortLoad,load2.supplyPort) annotation(Line(
		 points={{84.7,65},{89.7,65},{89.7,10},{75,10},{70,10}},
		 color={255,0,0},
		 thickness=1));
		connect(HX2.returnPortLoad,load2.returnPort) annotation (
		 Line(
		  points={{84.66667175292969,55},{95,55},{95,0},{75,0},{70,0}},
		  color={0,0,255},
		  thickness=1));
		connect(gasBoiler1.supplyPort,pipe1.fromSupply) annotation(Line(
		 points={{-55.3,65},{-50.3,65},{-54.7,65},{-49.7,65}},
		 color={255,0,0},
		 thickness=1));
		connect(pipe1.toSupply,HX1.supplyPortSource) annotation (
		 Line(
		  points={{-10,65},{-5,65},{-5,10},{-25,10},{-30,10}},
		  color={255,0,0},
		  thickness=1));
		connect(gasBoiler1.returnPort,pipe1.toReturn) annotation(Line(
		 points={{-55.3,55},{-50.3,55},{-54.7,55},{-49.7,55}},
		 color={0,0,255},
		 thickness=1));
		connect(pipe1.fromReturn,HX1.returnPortSource) annotation (
		 Line(
		  points={{-10,55},{0,55},{0,0},{-25,0},{-30,0}},
		  color={0,0,255},
		  thickness=1));
		connect(pipe2.fromSupply,pipe1.toSupply) annotation(Line(
		 points={{5.3,65},{0.3,65},{-5,65},{-10,65}},
		 color={255,0,0},
		 thickness=1));
		connect(pipe2.toReturn,pipe1.fromReturn) annotation(Line(
		 points={{5.3,55},{0.3,55},{-5,55},{-10,55}},
		 color={0,0,255},
		 thickness=1));
		connect(HX2.supplyPortSource,pipe2.toSupply) annotation(Line(
		 points={{65,65},{60,65},{50,65},{45,65}},
		 color={255,0,0},
		 thickness=1));
		connect(HX2.returnPortSource,pipe2.fromReturn) annotation(Line(
		 points={{65,55},{60,55},{50,55},{45,55}},
		 color={0,0,255},
		 thickness=1));
		connect(weatherData.weatherPort,load.weatherPort) annotation(Line(
		 points={{1,-30},{1,-25},{1,-19.7},{-75,-19.7},{-75,-14.7}},
		 color={0,176,80}));
		connect(weatherData.weatherPort,load2.weatherPort) annotation(Line(
		 points={{1,-30},{1,-25},{1,-19.7},{50,-19.7},{50,-14.7}},
		 color={0,176,80}));
		connect(weatherData.weatherPort,pipe2.weatherPort) annotation (
		 Line(
		  points={{1,-30},{1,-25},{1,-20},{25,-20},{25,50.33333206176758}},
		  color={0,176,80}));
		connect(pipe1.weatherPort,weatherData.weatherPort) annotation (
		 Line(
		  points={{-30,50.3},{-30,45.3},{-30,-20},{1,-20},{1,-30}},
		  color={0,176,80}));
	annotation(
		Documentation(info= "<html><head></head><body><h4>Distribution example model</h4><p></p><ul><li>Two load omponents are connected to a grid via heat exchangers.</li><li>The heat exchangers use control mode <b>passive</b> (no internal pumps).</li><li>The gas boiler is operated in model R<b>efFlowRefTemp</b> and feeds the combined volume flow of the load components into the grid.</li></ul><p></p>

</body></html>"),
		experiment(
			StopTime=31536000,
			StartTime=0,
			Tolerance=0.0001,
			Interval=3600));
end ExampleDistribution;
