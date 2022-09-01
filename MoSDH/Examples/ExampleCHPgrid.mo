within MoSDH.Examples;
model ExampleCHPgrid "Thermal power plant example model"
	extends Modelica.Icons.Example;
	Components.Distribution.ReturnFlowMixing rfm(Tref(displayUnit="K")=system.DH_TsupplyRef-10) annotation(Placement(transformation(extent={{120,5},{140,25}})));
	Components.Control.System system(
		lowerSetpointTambient=268.15,
		lowerSetpointTsupply=383.15,
		upperSetpointTambient=288.15,
		upperSetpointTsupply=358.15,
		DH_Treturn=338.15) annotation(Placement(transformation(extent={{70,-120},{110,-80}})));
	Components.Sources.Fossil.ThermalPowerPlant thermalPowerPlant(
		storageVolume=500,
		nBufferLayers=10,
		CHP_Pthermal_max=2000000,
		GB_Pthermal_max=20000000,
		chp(Qthermal(displayUnit="GWh")),
		gasBoiler(Qthermal(displayUnit="GWh")),
		mode=MoSDH.Utilities.Types.ControlTypes.RefFlowRefTemp,
		enabledUnits=3,
		Tref(displayUnit="K")=system.DH_TsupplyRef,
		volFlowRef(displayUnit="mÂ³/s")=shunt.volFlowLoad) annotation(Placement(transformation(extent={{-115,-10},{-75,30}})));
	Components.Weather.WeatherData weatherData1 annotation(Placement(transformation(extent={{20,-120},{60,-80}})));
	Components.Loads.HeatDemand load_E(
		loadData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatDemand/Darmstadt_TRY2015_5GWh.txt"),
		powerUnitData(displayUnit="kW")=1000,
		TreturnGrid(displayUnit="K")=system.DH_TreturnRef) annotation(Placement(transformation(extent={{195,-5},{235,35}})));
	Components.Loads.HeatDemand load_SE(
		loadData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatDemand/Darmstadt_TRY2015_5GWh.txt"),
		powerUnitData(displayUnit="kW")=1000,
		TreturnGrid(displayUnit="K")=system.DH_TreturnRef) annotation(Placement(transformation(
		origin={145,-50},
		extent={{-20,-20},{20,20}})));
	Components.Loads.HeatDemand load_SW(
		loadData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatDemand/Darmstadt_TRY2015_5GWh.txt"),
		powerUnitData(displayUnit="kW")=1000,
		TreturnGrid(displayUnit="K")=system.DH_TreturnRef) annotation(Placement(transformation(
		origin={-70,-50},
		extent={{20,-20},{-20,20}})));
	Components.Loads.HeatDemand load_NE(
		loadData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatDemand/Darmstadt_TRY2015_25GWh.txt"),
		powerUnitData(displayUnit="W")=1,
		TreturnGrid(displayUnit="K")=system.DH_TreturnRef) annotation(Placement(transformation(
		origin={145,70},
		extent={{-20,-20},{20,20}})));
	Components.Loads.HeatDemand load_NW(
		loadData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatDemand/Darmstadt_TRY2015_5GWh.txt"),
		powerUnitData(displayUnit="kW")=1000,
		TreturnGrid(displayUnit="K")=system.DH_TreturnRef) annotation(Placement(transformation(
		origin={-65,70},
		extent={{20,-20},{-20,20}})));
	Components.Distribution.HydraulicShunt shunt(setAbsolutePressure=true) annotation(Placement(transformation(extent={{-60,0},{-40,20}})));
	Components.Distribution.DistrictHeatingPipes ring_SW(
		redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN250_400 pipeData,
		length=1000,
		depth(displayUnit="m")=0.6+ring_SW.pipeData.dCasing/2,
		distance(displayUnit="m")=0.3+ring_SW.pipeData.dCasing,
		nElements=5,
		TinitialSupply(displayUnit="Â°C")=363.15,
		TinitialReturn(displayUnit="Â°C")=333.15) annotation(Placement(transformation(
		origin={-8.699999999999999,-12},
		extent={{-20,-10},{20,10}},
		rotation=-225)));
	Components.Distribution.DistrictHeatingPipes ring_S(
		redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN250_400 pipeData,
		length=1000,
		depth(displayUnit="m")=0.6+ring_S.pipeData.dCasing/2,
		distance(displayUnit="m")=0.3+ring_S.pipeData.dCasing,
		nElements=5,
		TinitialSupply(displayUnit="Â°C")=363.15,
		TinitialReturn(displayUnit="Â°C")=333.15) annotation(Placement(transformation(
		origin={40,-30},
		extent={{-20,-10},{20,10}},
		rotation=-180)));
	Components.Distribution.DistrictHeatingPipes ring_NW(
		redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN250_400 pipeData,
		length=1000,
		depth(displayUnit="m")=0.6+ring_NW.pipeData.dCasing/2,
		distance(displayUnit="m")=0.3+ring_NW.pipeData.dCasing,
		nElements=5,
		TinitialSupply(displayUnit="Â°C")=363.15,
		TinitialReturn(displayUnit="Â°C")=333.15) annotation(Placement(transformation(
		origin={-8,33},
		extent={{-20,10},{20,-10}},
		rotation=-135)));
	Components.Distribution.DistrictHeatingPipes ring_N(
		redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN250_400 pipeData,
		length=1000,
		depth(displayUnit="m")=0.6+ring_N.pipeData.dCasing/2,
		distance(displayUnit="m")=0.3+ring_N.pipeData.dCasing,
		nElements=5,
		TinitialSupply(displayUnit="Â°C")=363.15,
		TinitialReturn(displayUnit="Â°C")=333.15) annotation(Placement(transformation(
		origin={40,55},
		extent={{-20,-10},{20,10}})));
	Components.Distribution.DistrictHeatingPipes ring_NE(
		redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN250_400 pipeData,
		length=1000,
		depth(displayUnit="m")=0.6+ring_NE.pipeData.dCasing/2,
		distance(displayUnit="m")=0.3+ring_NE.pipeData.dCasing,
		nElements=5,
		TinitialSupply(displayUnit="Â°C")=363.15,
		TinitialReturn(displayUnit="Â°C")=333.15) annotation(Placement(transformation(
		origin={87,33},
		extent={{20,-10},{-20,10}},
		rotation=-45)));
	Components.Distribution.DistrictHeatingPipes ring_SE(
		redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN250_400 pipeData,
		length=1000,
		depth(displayUnit="m")=0.6+ring_SE.pipeData.dCasing/2,
		distance(displayUnit="m")=0.3+ring_SE.pipeData.dCasing,
		nElements=5,
		TinitialSupply(displayUnit="Â°C")=363.15,
		TinitialReturn(displayUnit="Â°C")=333.15) annotation(Placement(transformation(
		origin={87,-11},
		extent={{-20,-10},{20,10}},
		rotation=-135)));
	Components.Distribution.DistrictHeatingPipes pipe_E(
		redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN150_250 pipeData,
		length=500,
		depth(displayUnit="m")=0.6+pipe_E.pipeData.dCasing/2,
		distance(displayUnit="m")=0.3+pipe_E.pipeData.dCasing,
		nElements=5,
		TinitialSupply(displayUnit="Â°C")=353.15,
		TinitialReturn(displayUnit="Â°C")=333.15) annotation(Placement(transformation(extent={{190,5},{150,25}})));
	Components.Distribution.DistrictHeatingPipes pipe_NW(
		redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN150_250 pipeData,
		length=500,
		depth(displayUnit="m")=0.6+pipe_NW.pipeData.dCasing/2,
		distance(displayUnit="m")=0.3+pipe_NW.pipeData.dCasing,
		nElements=5,
		TinitialSupply(displayUnit="Â°C")=353.15,
		TinitialReturn(displayUnit="Â°C")=333.15) annotation(Placement(transformation(extent={{-40,60},{0,80}})));
	Components.Distribution.DistrictHeatingPipes pipe_NE(
		redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN150_250 pipeData,
		length=500,
		depth(displayUnit="m")=0.6+pipe_NE.pipeData.dCasing/2,
		distance(displayUnit="m")=0.3+pipe_NE.pipeData.dCasing,
		nElements=5,
		TinitialSupply(displayUnit="Â°C")=353.15,
		TinitialReturn(displayUnit="Â°C")=333.15) annotation(Placement(transformation(extent={{80,60},{120,80}})));
	Components.Distribution.DistrictHeatingPipes pipe_SW(
		redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN150_250 pipeData,
		length=500,
		depth(displayUnit="m")=0.6+pipe_SW.pipeData.dCasing/2,
		distance(displayUnit="m")=0.3+pipe_SW.pipeData.dCasing,
		nElements=5,
		TinitialSupply(displayUnit="Â°C")=353.15,
		TinitialReturn(displayUnit="Â°C")=333.15) annotation(Placement(transformation(extent={{-40,-60},{0,-40}})));
	Components.Distribution.DistrictHeatingPipes pipe_SE(
		redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN150_250 pipeData,
		length=500,
		depth(displayUnit="m")=0.6+pipe_SE.pipeData.dCasing/2,
		distance(displayUnit="m")=0.3+pipe_SE.pipeData.dCasing,
		nElements=5,
		TinitialSupply(displayUnit="Â°C")=353.15,
		TinitialReturn(displayUnit="Â°C")=333.15) annotation(Placement(transformation(extent={{75,-60},{115,-40}})));
	equation
		connect(weatherData1.weatherPort,system.weatherPort) annotation (
		 Line(
		  points={{40,-80},{40,-75},{90,-75},{90,-80}},
		  color={0,176,80}));
		connect(thermalPowerPlant.returnPort,shunt.sourceReturn) annotation(Line(
			points={{-75.3,5},{-70.3,5},{-65,5},{-60,5}},
			color={0,0,255},
			thickness=1));
		connect(thermalPowerPlant.supplyPort,shunt.sourceSupply) annotation(Line(
			points={{-75.3,15},{-70.3,15},{-65,15},{-60,15}},
			color={255,0,0},
			thickness=1));
		connect(pipe_E.fromSupply,rfm.supplyPortLoad) annotation(Line(
		 points={{150.33,20},{150.33,20},{139.67,20},{139.67,20}},
		 color={255,0,0},
		 thickness=1));
		connect(pipe_E.toReturn,rfm.returnPortLoad) annotation(Line(
		 points={{150.33,10},{150.33,10},{139.67,10},{139.67,10}},
		 color={0,0,255},
		 thickness=1));
		connect(pipe_E.toSupply,load_E.supplyPort) annotation(Line(
		 points={{190,20},{195,20},{190,20},{195,20}},
		 color={255,0,0},
		 thickness=1));
		connect(pipe_E.fromReturn,load_E.returnPort) annotation(Line(
		 points={{190,10},{195,10},{190,10},{195,10}},
		 color={0,0,255},
		 thickness=1));
		connect(thermalPowerPlant.weather,weatherData1.weatherPort) annotation(Line(
			points={{-95,-9.699999999999999},{-95,-14.7},{-95,-75},{40,-75},{40,-80}},
			color={0,176,80}));
		connect(load_SW.weatherPort,weatherData1.weatherPort) annotation (
		 Line(
		  points={{-70,-69.67},{-70,-69.67},{-70,-75},{40,-75},{40,-80}},
		  color={0,176,80}));
		connect(load_SE.weatherPort,weatherData1.weatherPort) annotation (
		 Line(
		  points={{145,-69.67},{145,-69.67},{145,-75},{40,-75},{40,-80}},
		  color={0,176,80}));
		connect(load_E.weatherPort,weatherData1.weatherPort) annotation (
		 Line(
		  points={{215,-4.67},{215,-4.67},{215,-75},{40,-75},{40,-80}},
		  color={0,176,80}));
		connect(pipe_E.weatherPort,weatherData1.weatherPort) annotation (
		 Line(
		  points={{170,5.33},{170,5.33},{170,-75},{40,-75},{40,-80}},
		  color={0,176,80}));
		connect(weatherData1.weatherPort,load_NE.weatherPort) annotation (
		 Line(
		  points={{40,-80},{40,55},{100,55},{100,45},{145,45},{145,50.33}},
		  color={0,176,80}));
		connect(weatherData1.weatherPort,load_NW.weatherPort) annotation (
		 Line(
		  points={{40,-80},{40,55},{-20,55},{-20,45},{-65,45},{-65,50.33}},
		  color={0,176,80}));
		connect(weatherData1.weatherPort,ring_NW.weatherPort) annotation (
		 Line(
		  points={{40,-80},{40,10},{-1.16228,10},{-1.16228,26.1623}},
		  color={0,176,80}));
		connect(shunt.loadReturn,ring_NW.toReturn) annotation (
		 Line(
		  points={{-40.33,5},{-18.3732,15.5557}},
		  color={0,0,255},
		  thickness=1));
		connect(shunt.loadSupply,ring_NW.fromSupply) annotation (
		 Line(
		  points={{-40,15},{-25.4443,22.6267}},
		  color={255,0,0},
		  thickness=1));
		connect(ring_NW.toSupply,ring_N.toSupply) annotation (
		 Line(
		  points={{2.6066,50.6777},{20,60}},
		  color={255,0,0},
		  thickness=1));
		connect(ring_NW.fromReturn,ring_N.fromReturn) annotation (
		 Line(
		  points={{9.67767,43.6066},{20,50}},
		  color={0,0,255},
		  thickness=1));
		connect(weatherData1.weatherPort,ring_N.weatherPort) annotation(Line(
		 points={{40,-80},{40,-75},{40,45.33},{40,45.33}},
		 color={0,176,80}));
		connect(weatherData1.weatherPort,ring_NE.weatherPort) annotation (
		 Line(
		  points={{40,-80},{40,10},{80.1623,10},{80.1623,26.1623}},
		  color={0,176,80}));
		connect(ring_NE.toSupply,rfm.supplyPortSource) annotation (
		 Line(
		  points={{104.678,22.3934},{120,20}},
		  color={255,0,0},
		  thickness=1));
		connect(ring_NE.fromSupply,ring_N.fromSupply) annotation (
		 Line(
		  points={{76.6267,50.4443},{59.67,60}},
		  color={255,0,0},
		  thickness=1));
		connect(ring_NE.toReturn,ring_N.toReturn) annotation (
		 Line(
		  points={{69.5557,43.3733},{59.67,50}},
		  color={0,0,255},
		  thickness=1));
		connect(weatherData1.weatherPort,ring_SE.weatherPort) annotation (
		 Line(
		  points={{40,-80},{40,10},{80.1623,10},{80.1623,-4.16228}},
		  color={0,176,80}));
		connect(rfm.returnPortSource,ring_SE.fromReturn) annotation (
		 Line(
		  points={{120,10},{97.6066,6.67767}},
		  color={0,0,255},
		  thickness=1));
		connect(ring_SE.toSupply,ring_NE.toSupply) annotation (
		 Line(
		  points={{104.678,-0.393398},{104.678,4},{104,4},{104,10.0601},{104.667,
		        10.0601},{104.667,22.3333}},
		  color={255,0,0},
		  thickness=1));
		connect(ring_SE.fromReturn,ring_NE.fromReturn) annotation (
		 Line(
		  points={{97.6066,6.67767},{97.6066,10},{98,10},{98,11.989},{97.6667,11.989},
		        {97.6667,15.3333}},
		  color={0,0,255},
		  thickness=1));
		connect(ring_S.fromReturn,ring_SE.toReturn) annotation (
		 Line(
		  points={{60,-25},{69.5557,-21.3733}},
		  color={0,0,255},
		  thickness=1));
		connect(ring_S.toSupply,ring_SE.fromSupply) annotation (
		 Line(
		  points={{60,-35},{76.6267,-28.4443}},
		  color={255,0,0},
		  thickness=1));
		connect(weatherData1.weatherPort,ring_S.weatherPort) annotation(Line(
		 points={{40,-80},{40,-75},{40,-20.33},{40,-20.33}},
		 color={0,176,80}));
		connect(weatherData1.weatherPort,ring_SW.weatherPort) annotation (
		 Line(
		  points={{40,-80},{40,10},{-1.86228,10},{-1.86228,-5.16228}},
		  color={0,176,80}));
		connect(ring_SW.fromReturn,ring_S.toReturn) annotation (
		 Line(
		  points={{8.97767,-22.6066},{20.33,-25}},
		  color={0,0,255},
		  thickness=1));
		connect(ring_S.fromSupply,ring_SW.toSupply) annotation (
		 Line(
		  points={{20.33,-35},{1.9066,-29.6777}},
		  color={255,0,0},
		  thickness=1));
		connect(ring_NW.fromSupply,ring_SW.fromSupply) annotation (
		 Line(
		  points={{-25.4443,22.6267},{-26.1443,-1.62674}},
		  color={255,0,0},
		  thickness=1));
		connect(ring_SW.toReturn,ring_NW.toReturn) annotation (
		 Line(
		  points={{-19.0733,5.44432},{-18.3732,15.5557}},
		  color={0,0,255},
		  thickness=1));
		connect(ring_N.fromReturn,pipe_NW.toReturn) annotation (
		 Line(
		  points={{20,50},{-0.33,65}},
		  color={0,0,255},
		  thickness=1));
		connect(weatherData1.weatherPort,pipe_NW.weatherPort) annotation (
		 Line(
		  points={{40,-80},{40,55},{-20,55},{-20,60.33}},
		  color={0,176,80}));
		connect(pipe_NW.fromSupply,ring_N.toSupply) annotation (
		 Line(
		  points={{-0.33,75},{20,60}},
		  color={255,0,0},
		  thickness=1));
		connect(load_NW.returnPort,pipe_NW.fromReturn) annotation(Line(
		 points={{-45,65},{-40,65},{-45,65},{-40,65}},
		 color={0,0,255},
		 thickness=1));
		connect(load_NW.supplyPort,pipe_NW.toSupply) annotation(Line(
		 points={{-45,75},{-40,75},{-45,75},{-40,75}},
		 color={255,0,0},
		 thickness=1));
		connect(ring_N.toReturn,pipe_NE.fromReturn) annotation (
		 Line(
		  points={{59.67,50},{80,65}},
		  color={0,0,255},
		  thickness=1));
		connect(ring_N.fromSupply,pipe_NE.toSupply) annotation (
		 Line(
		  points={{59.67,60},{80,75}},
		  color={255,0,0},
		  thickness=1));
		connect(weatherData1.weatherPort,pipe_NE.weatherPort) annotation (
		 Line(
		  points={{40,-80},{40,55},{100,55},{100,60.33}},
		  color={0,176,80}));
		connect(pipe_NE.toReturn,load_NE.returnPort) annotation(Line(
		 points={{119.67,65},{119.67,65},{120,65},{125,65}},
		 color={0,0,255},
		 thickness=1));
		connect(pipe_NE.fromSupply,load_NE.supplyPort) annotation(Line(
		 points={{119.67,75},{119.67,75},{120,75},{125,75}},
		 color={255,0,0},
		 thickness=1));
		connect(pipe_SE.fromReturn,ring_S.fromReturn) annotation (
		 Line(
		  points={{75,-55},{60,-25}},
		  color={0,0,255},
		  thickness=1));
		connect(pipe_SE.toSupply,ring_SE.fromSupply) annotation(Line(
		 points={{75,-45},{76.6267,-28.4443}},
		 color={255,0,0},
		 thickness=1));
		connect(weatherData1.weatherPort,pipe_SE.weatherPort) annotation (
		 Line(
		  points={{40,-80},{40,-75},{95,-75},{95,-59.67}},
		  color={0,176,80}));
		connect(load_SE.returnPort,pipe_SE.toReturn) annotation(Line(
		 points={{125,-55},{120,-55},{114.67,-55},{114.67,-55}},
		 color={0,0,255},
		 thickness=1));
		connect(load_SE.supplyPort,pipe_SE.fromSupply) annotation(Line(
		 points={{125,-45},{120,-45},{114.67,-45},{114.67,-45}},
		 color={255,0,0},
		 thickness=1));
		connect(pipe_SW.toReturn,ring_S.toReturn) annotation (
		 Line(
		  points={{-0.33,-55},{20.33,-25}},
		  color={0,0,255},
		  thickness=1));
		connect(pipe_SW.fromSupply,ring_SW.toSupply) annotation(Line(
		 points={{-0.33,-45},{1.9066,-29.6777}},
		 color={255,0,0},
		 thickness=1));
		connect(weatherData1.weatherPort,pipe_SW.weatherPort) annotation (
		 Line(
		  points={{40,-80},{40,-75},{-20,-75},{-20,-59.67}},
		  color={0,176,80}));
		connect(pipe_SW.fromReturn,load_SW.returnPort) annotation(Line(
		 points={{-40,-55},{-45,-55},{-50,-55}},
		 color={0,0,255},
		 thickness=1));
		connect(pipe_SW.toSupply,load_SW.supplyPort) annotation(Line(
		 points={{-40,-45},{-45,-45},{-50,-45}},
		 color={255,0,0},
		 thickness=1));
	annotation(
		__OpenModelica_simulationFlags(
			lv="LOG_STATS",
			s="cvode"),
		__OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
		Diagram(coordinateSystem(extent={{-125,-125},{225,125}})),
		Documentation(info= "<html><head></head><body><p>Example model with a ring DH grid:</p><p></p><ul><li>5 heat load components are supplied by a DHG grid with a ring layout.</li><li>A central thermal power plant with 3 CHP units of 2 MWth each, a 200 mÂ² buffer storage and a gas boiler supplies thermal energy to the grid on the temperature level defined by the system control component.</li><ul><li><b>Tref</b>: Reference supply temperature set according to <b>system.DH_TsupplyRef</b>.</li><li><b>volFlowRef</b>: Volume flow rate is equal to the source side volume flow rate of the connected hydraulic shunt (= <b>shunt.volFlowLoad</b>).</li></ul><li>The system component define the reference supply temperature in relation to the ambient temperature by a heating curve.</li><li>The eastern load componen (E) has a supply temperature 10K below the reference supply temperature.</li><li>The north-east (NE) load component has a annual heat demand of 25 GWh and the remaining components 5 GWh each.&nbsp;</li><li>The NE heat load is higher than the combined load of the other components during winter, but lower during summer.</li></ul><div>

<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>Thermal power of the componentsl</caption>
  <tbody><tr>
    <td>
   <img src=\"modelica://MoSDH/Utilities/Images/ExampleCHPgrid.png\" width=\"500\"></td></tr></tbody></table></div><div>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 2: </strong>Grid volume flow rates</caption>
  <tbody><tr>
    <td>
   <img src=\"modelica://MoSDH/Utilities/Images/ExampleCHPgridB.png\" width=\"500\"></td></tr></tbody></table><div><br></div><p></p>

</div></body></html>"),
		experiment(
			StopTime= 3.1536e+07,
			StartTime=0,
			Tolerance=1e-06,
			Interval= 7200));
end ExampleCHPgrid;
