within MoSDH.Examples;

model ExampleSolarHeating "Solar supported heating system example"
  import modes = MoSDH.Utilities.Types.OperationModes;
  extends Modelica.Icons.Example;
  Components.Storage.StratifiedTank.TTES buffer(storageVolume = solarThermalField.nParallel * solarThermalField.nSeries * solarThermalField.apertureArea * 0.2, storageHeight = 10, Tinitial = {303.15, 303.15, 303.15, 303.15, 303.15, 338.15, 338.15, 338.15, 338.15, 338.15}, setAbsolutePressure = false) annotation(
    Placement(transformation(extent = {{-10, 0}, {20, 60}})));
  Components.Weather.WeatherData weather annotation(
    Placement(transformation(extent = {{-15, -55}, {25, -15}})));
  Components.Loads.HeatDemand load(medium = buffer.medium, loadData = Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatDemand/Darmstadt_TRY2015_5GWh.txt"), powerUnitData = 1000, TreturnGrid = TreturnRef) annotation(
    Placement(transformation(extent = {{85, 10}, {125, 50}})));
  Components.Sources.Solar.SolarThermalField solarThermalField(specificYield(displayUnit = "kWh"), collectorRowDistance = 5, azimut = 0, beta = 0.6108652381980153, nParallel = 25, nSeries = 3, redeclare replaceable model CollectorModel = MoSDH.Components.Sources.Solar.BaseClasses.SolarThermalModule, apertureArea = 13.61, height = 2.28, V_flowMax = 0.01, tau = 3600, eta0 = 0.773, a1 = 2.27, a2 = 0.018, on = activateSolar, Tref(displayUnit = "K") = max(TsupplyRef, buffer.Tlayers[1] + 5)) annotation(
    Placement(transformation(extent = {{-90, 10}, {-50, 50}})));
  Components.Sources.Fossil.GasBoiler boiler(Pthermal_max = 8500000, mode = Utilities.Types.ControlTypes.RefFlowRefTemp, on = true, Tref = GB_Tref, volFlowRef = GB_volFlowRef) annotation(
    Placement(transformation(extent = {{25, 10}, {65, 50}})));
  Components.Distribution.HeatExchanger hx(nSegments = 5, redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Gylcol20_20degC mediumSource, setAbsoluteSourcePressure = true, setAbsoluteLoadPressure = true, heatExchangeSurface = solarThermalField.nParallel * solarThermalField.nSeries * solarThermalField.apertureArea * 0.15, controlType = Utilities.Types.ControlTypesHX.CoupleLoad, flowRatioConstant = solarThermalField.medium.cp / buffer.medium.cp) annotation(
    Placement(transformation(extent = {{-45, 20}, {-25, 40}})));
  Components.Distribution.threeWayValveMix valve(tau = 600) annotation(
    Placement(transformation(extent = {{70, 30}, {80, 40}})));
  Components.Distribution.threeWayValveMix valve1(tau = 600) annotation(
    Placement(transformation(extent = {{70, 30}, {80, 20}})));
  parameter Modelica.Units.SI.Temperature TsupplyRef = 333.15;
  parameter Modelica.Units.SI.Temperature TreturnRef = 303.15;
  modes boilerMode "Gas boiler operation mode";
  Boolean activateSolar "Enable solar collector field";
  Modelica.Units.SI.VolumeFlowRate GB_volFlowRef "Volume flow rate from boiler to load";
  Modelica.Units.SI.Temperature GB_Tref "Volume flow rate from boiler to load";
initial algorithm
// determine the initial control state
  activateSolar := true;
  if min(buffer.Tlayers[buffer.nLayers - 1:buffer.nLayers]) > TsupplyRef + 1 then
    boilerMode := modes.Idle;
  elseif min(buffer.Tlayers[buffer.nLayers - 1:buffer.nLayers]) > TsupplyRef - 8 then
    boilerMode := modes.PartLoad;
  else
    boilerMode := modes.FullLoad;
  end if;
  if buffer.Tlayers[10] > 378.15 or buffer.Tlayers[1] > 378.15 - 5 then
    activateSolar := false;
  else
    activateSolar := true;
  end if;
algorithm
//Control strategy
//Switch state according to buffer state of charge
  when min(buffer.Tlayers[buffer.nLayers - 1:buffer.nLayers]) > TsupplyRef + 1 then
    boilerMode := modes.Idle;
  elsewhen min(buffer.Tlayers[buffer.nLayers - 1:buffer.nLayers]) < TsupplyRef - 3 then
    boilerMode := modes.PartLoad;
  elsewhen min(buffer.Tlayers[buffer.nLayers - 1:buffer.nLayers]) < TsupplyRef - 16 then
    boilerMode := modes.FullLoad;
  elsewhen min(buffer.Tlayers[buffer.nLayers - 1:buffer.nLayers]) > TsupplyRef - 8 then
    boilerMode := modes.PartLoad;
  end when;
// switch solar field on/off depending on the buffer storage state of charge
  when buffer.Tlayers[10] > 368.15 or buffer.Tlayers[1] > 363.15 - 5 then
    activateSolar := false;
  elsewhen buffer.Tlayers[10] < 363.15 and buffer.Tlayers[1] < 363.15 - 10 then
    activateSolar := true;
  end when;
equation
// definition of component control for each  state
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
  connect(weather.weatherPort, buffer.weatherPort) annotation(
    Line(points = {{5, -15}, {5, -10}, {5, 0.3}, {5, 0.3}}, color = {0, 176, 80}));
  connect(solarThermalField.supplyPort, hx.supplyPortSource) annotation(
    Line(points = {{-50.3, 35}, {-46, 35}}, color = {255, 0, 0}, thickness = 1));
  connect(solarThermalField.returnPort, hx.returnPortSource) annotation(
    Line(points = {{-50.3, 25}, {-46, 25}}, color = {0, 0, 255}, thickness = 1));
  connect(solarThermalField.weatherPort, weather.weatherPort) annotation(
    Line(points = {{-70, 10.3}, {-70, -10}, {4, -10}, {4, -15}}, color = {0, 176, 80}));
  connect(load.weatherPort, weather.weatherPort) annotation(
    Line(points = {{105, 10.3}, {105, 5.3}, {105, -10}, {5, -10}, {5, -15}}, color = {0, 176, 80}));
  connect(buffer.sourceIn, hx.supplyPortLoad) annotation(
    Line(points = {{-10, 55}, {-15, 55}, {-20.3, 55}, {-20.3, 35}, {-25.3, 35}}, color = {255, 0, 0}, thickness = 1));
  connect(buffer.sourceOut, hx.returnPortLoad) annotation(
    Line(points = {{-10, 5}, {-15, 5}, {-20.3, 5}, {-20.3, 25}, {-25.3, 25}}, color = {0, 0, 255}, thickness = 1));
  connect(buffer.loadOut, valve.flowPort_c) annotation(
    Line(points = {{19.7, 55}, {24.7, 55}, {75, 55}, {75, 45}, {75, 40}}, color = {255, 0, 0}, thickness = 1));
  connect(buffer.loadIn, valve1.flowPort_c) annotation(
    Line(points = {{19.7, 5}, {24.7, 5}, {75, 5}, {75, 15}, {75, 20}}, color = {0, 0, 255}, thickness = 1));
  connect(boiler.returnPort, valve1.flowPort_b) annotation(
    Line(points = {{64.7, 25}, {69.7, 25}, {65, 25}, {70, 25}}, color = {0, 0, 255}, thickness = 1));
  connect(boiler.supplyPort, valve.flowPort_b) annotation(
    Line(points = {{64.7, 35}, {69.7, 35}, {65, 35}, {70, 35}}, color = {255, 0, 0}, thickness = 1));
  connect(load.supplyPort, valve.flowPort_a) annotation(
    Line(points = {{85, 35}, {80, 35}, {84.7, 35}, {79.7, 35}}, color = {255, 0, 0}, thickness = 1));
  connect(load.returnPort, valve1.flowPort_a) annotation(
    Line(points = {{85, 25}, {80, 25}, {84.7, 25}, {79.7, 25}}, color = {0, 0, 255}, thickness = 1));
  annotation(
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "cvode"),
    Diagram(coordinateSystem(extent = {{-150, -100}, {150, 100}})),
    Documentation(info = "<html><head></head><body><h3>Example model for a solar heating system:</h3><div><ul><li>A <a href=\"modelica://MoSDH.Components.Sources.Solar.SolarThermalField\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">solar thermal field</a>&nbsp;supplies heat to the&nbsp;<a href=\"modelica://MoSDH.Components.Storage.StratifiedTank.TTES\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">buffer storage</a> via a <a href=\"modelica://MoSDH.Components.Distribution.HeatExchanger\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">heat exchanger</a>.&nbsp;</li><li>The <a href=\"modelica://MoSDH.Components.Loads.HeatDemand\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">heat load</a>&nbsp;is suuplied from the buffer storage and a <a href=\"modelica://MoSDH.Components.Sources.Fossil,BasBoiler\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">gas boiler</a> is used if the buffer is used as additional heat source. &nbsp;</li><li>The <a href=\"modelica://MoSDH.Components.Weather.WeatherData\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">weather</a> component is required to giva the ambient temperature for calculation of the buffer's thermal losses and the day of the year for the heat load table.</li><li>The system control strategy is defined on the top level of the model.</li><li>Parameters <b>TsupplyRef</b> and <b>TreturnRef</b> are used to define the operating temperatures of the system.</li><li>The solar field is operated in mode <b>RefTemp</b> for which the supply temperature setpoint <b>solarThermalField.Tref</b> is set to <b>TsupplyRef</b>.</li><li>Variable <b>activateSolar</b> is used to switch off the solar collectors (<b>solarthermalField</b>.<b>on</b> = false) if the buffer top temperature exceeds 95 °C or the buffer bottom temperature exceeds 85°C.</li><li>The gas boiler is operated in mode <b>RefTempFefFlow</b>, for which teh supply temperture is deined by the control variable <b>boiler.Tref</b> and the volume flow rate by the variable <b>boiler.volFlowRef</b>.&nbsp;</li><li>The variable <b>boilerMode</b> of type <a href=\"modelica://MoSDH.Utilities.Types.OperationModes\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">OperationModes</a> is used &nbsp;to define the behavior of the gas boiler. Three modes are implemented:</li><ul><li>Idle: If the buffer has the required temperature, the boiler is turned off (<b>volFlowRef</b>=0)</li><li>PartLoad: If the buffer temperature falls below the required temperature, the gas boiler is used to shift the temperature of the stored heat by mixing.</li><li>FullLoad: If the buffer temperature falls below the deinfed maximum, all of the heat demand is covered by the boiler.&nbsp;</li></ul></ul></div>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>Buffer layer temperatures</caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/ExampleSolarHeatingA.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>
</body></html>"),
    experiment(StopTime = 31536000, StartTime = 0, Tolerance = 1e-06, Interval = 3600));
end ExampleSolarHeating;
