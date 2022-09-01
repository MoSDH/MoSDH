within MoSDH.Components.Sources.Solar;
model ExamplePVT "PVT collector example model"
	extends Modelica.Icons.Example;
	Weather.WeatherData weatherData(weatherData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/Weather/DWD/Darmstadt_TRY2015.txt")) annotation(Placement(transformation(extent={{-20,-40},{20,0}})));
	SolarThermalField solarThermalField(
		specificYield(displayUnit="kWh"),
		specificElectricYield(displayUnit="kWh"),
		collectorRowDistance=2.38,
		azimut=0,
		beta=0.5235987755982988,
		nParallel=1,
		nSeries=1,
		redeclare replaceable model CollectorModel = MoSDH.Components.Sources.Solar.BaseClasses.PVTmodule,
		apertureArea=1.955,
		height=0.952,
		dAbsorberPipe=0.012,
		nAbsorberPipes=23,
		V_flowMax=0.00022,
		eta0=0.468,
		a1=22.99,
		a2=0,
		tableOnFile=true,
		IAMtable=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/Solar/SOLINK5_IAM.txt"),
		Upvt=177.33,
		cWind=7.57,
		etaElectric=0.195,
		etaElectricThermalCoefficient=0.0039,
		etaElectricWindCoefficient=0.067,
		aEl=0.00008287,
		bEl=-0.049,
		cEl=-1.3,
		Tref=293.15) annotation(Placement(transformation(extent={{-20,5},{20,45}})));
	Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot(medium=solarThermalField.medium) annotation(Placement(transformation(extent={{55,25},{65,35}})));
	Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold(
		medium=solarThermalField.medium,
		Tsource=283.15) annotation(Placement(transformation(extent={{55,15},{65,25}})));
	Modelica.Thermal.FluidHeatFlow.Components.Pipe pipe1(
		medium=solarThermalField.medium,
		m=10,
		T0=293.15,
		T0fixed=true,
		V_flowLaminar=0.1,
		dpLaminar=0.09999999999999999,
		V_flowNominal=1,
		dpNominal=1,
		useHeatPort=false,
		h_g=0) annotation(Placement(transformation(extent={{25,20},{45,40}})));
	equation
		connect(weatherData.weatherPort,solarThermalField.weatherPort) annotation(Line(
		 points={{0,0},{0,5},{0,0.3},{0,5.3}},
		 color={0,176,80}));
		connect(solarThermalField.returnPort,fluidSourceCold.fluidPort) annotation(Line(
		 points={{19.7,20},{24.7,20},{50,20},{55,20}},
		 color={0,0,255},
		 thickness=1));
		connect(solarThermalField.supplyPort,pipe1.flowPort_a) annotation(Line(
		 points={{19.7,30},{24.7,30},{20,30},{25,30}},
		 color={255,0,0}));
		connect(fluidSourceHot.fluidPort,pipe1.flowPort_b) annotation(Line(
		 points={{55,30},{50,30},{45,30}},
		 color={255,0,0}));
	annotation(
		__OpenModelica_simulationFlags(
			lv="LOG_STATS",
			outputFormat="mat",
			s="dassl"),
		__OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
		Documentation(info= "<html><head></head><body><h2>Example SolarThermalField</h2><p>Example model for the solar thermal field component:</p><h4><p style=\"font-weight: normal;\">Example model for the solar thermal field component in PVT mode:</p></h4><h4><span style=\"font-weight: normal;\">The&nbsp;<a href=\"modelica://MoSDH.Components.Sources.Solar.SolarThermalField\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">solarThermalField</a></span>&nbsp;<span style=\"font-weight: normal;\">is turned&nbsp;</span>on<span style=\"font-weight: normal;\">&nbsp;and controlled in model&nbsp;</span><b>RefTemp</b><span style=\"font-weight: normal;\">, for which the supply temperature setpoint is defined by&nbsp;</span>Tref<span style=\"font-weight: normal;\">. The return temperature is defined by the&nbsp;<a href=\"modelica://MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceCold\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">cold fluid source</a>&nbsp;with variable&nbsp;</span>Tsource<span style=\"font-weight: normal;\">.</span></h4><h4><div style=\"font-weight: normal;\">A&nbsp;<a href=\"modelica:///MoSDH.Components.Weather.WeatherData\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">WeatherData</a>&nbsp;component is required for input of ambient temperatur, direct and diffuse irradiation.</div></h4><div><p></p>

</div></body></html>"),
		experiment(
			StopTime=31536000,
			StartTime=0,
			Tolerance=1e-06,
			Interval=600));
end ExamplePVT;
