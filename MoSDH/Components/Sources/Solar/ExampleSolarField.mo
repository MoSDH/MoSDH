within MoSDH.Components.Sources.Solar;
model ExampleSolarField "Solar thermal collector field example"
	extends Modelica.Icons.Example;
	Weather.WeatherData weatherData annotation(Placement(transformation(extent={{-20,-45},{20,-5}})));
	SolarThermalField solarThermalField(
		
		a1=2.27,
		a2=0.018,
		apertureArea=13.61,
		azimut=0,
		beta=0.6108652381980153,collectorRowDistance=4,
		eta0=0.773,
		height=2.28,
		nParallel=10,
		nSeries=10) annotation(Placement(transformation(extent={{-20,5},{20,45}})));
	Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot(medium=solarThermalField.medium) annotation(Placement(transformation(extent={{45,25},{55,35}})));
	Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold(medium=solarThermalField.medium) annotation(Placement(transformation(extent={{45,15},{55,25}})));	equation
		connect(weatherData.weatherPort,solarThermalField.weatherPort) annotation(Line(
		 points={{0,-5},{0,0},{0,0.3},{0,5.3}},
		 color={0,176,80}));
		connect(solarThermalField.supplyPort,fluidSourceHot.fluidPort) annotation(Line(
		 points={{19.7,30},{24.7,30},{40,30},{45,30}},
		 color={255,0,0},
		 thickness=1));
		connect(solarThermalField.returnPort,fluidSourceCold.fluidPort) annotation(Line(
		 points={{19.7,20},{24.7,20},{40,20},{45,20}},
		 color={0,0,255},
		 thickness=1));
	annotation(
		__OpenModelica_simulationFlags(
			lv="LOG_STATS",
			s="dassl"),
		__OpenModelica_commandLineOptions= "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=initialization ",
		Documentation(info= "<html><head></head><body><h2>Example SolarThermalField</h2><p>Example model for the solar thermal field component:</p><h4><span style=\"font-weight: normal;\">The <a href=\"modelica://MoSDH.Components.Sources.Solar.SolarThermalField\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">solar thermal field</a></span>&nbsp;<span style=\"font-weight: normal;\">is turned&nbsp;</span>on<span style=\"font-weight: normal;\">&nbsp;and controlled in model&nbsp;</span><b>RefTemp</b><span style=\"font-weight: normal;\">, for which the supply temperature setpoint is defined by </span>Tref<span style=\"font-weight: normal;\">. The return temperature is defined by the <a href=\"modelica://MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceCold\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">cold fluid source</a>&nbsp;with variable </span>Tsource<span style=\"font-weight: normal;\">.<span></span></span></h4><div><span style=\"font-weight: normal;\">A <a href=\"modelica:///MoSDH.Components.Weather.WeatherData\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">WeatherData</a> component is required for input of ambient temperatur, direct and diffuse irradiation.</span></div><div><p></p>

</div></body></html>"),
		experiment(
			StopTime= 3.1536e+07,
			StartTime=0,
			Tolerance=1e-06,
			Interval= 3600));
end ExampleSolarField;
