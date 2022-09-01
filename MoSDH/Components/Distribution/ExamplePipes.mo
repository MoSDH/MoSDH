within MoSDH.Components.Distribution;
model ExamplePipes "DH pipe example model"
 extends Modelica.Icons.Example;
 MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot1(redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium) annotation(Placement(visible = true, transformation(extent = {{51, 54}, {61, 64}}, rotation = 0)));
 MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold1(
  redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium,
  Tsource=353.15) annotation(Placement(visible = true, transformation(extent = {{51, 44}, {61, 54}}, rotation = 0)));
 MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot2(
  redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium,
  Tsource=393.15) annotation(Placement(visible = true, transformation(extent = {{-64, 54}, {-74, 64}}, rotation = 0)));
 MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold2(redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium) annotation(Placement(visible = true, transformation(extent = {{-64, 44}, {-74, 54}}, rotation = 0)));
 MoSDH.Components.Distribution.Pump pump1(
  medium=Modelica.Thermal.FluidHeatFlow.Media.Water(),
  volFlowNom(displayUnit="mÂ³/h")=0.05,
  volFlowRef=0.05) annotation(Placement(visible = true, transformation(extent = {{-39, 54}, {-29, 64}}, rotation = 0)));
 MoSDH.Components.Distribution.DistrictHeatingPipes districtHeatingPipes1(
  redeclare replaceable parameter Parameters.Soils.Soil groundData(lamda=1),
  redeclare replaceable parameter Parameters.DistrictHeatingPipes.DN200_355 pipeData,
  length=100,
  depth=1.2,
  distance=0.615,
  nElements=5,
  useTaverage=true) annotation(Placement(visible = true, transformation(extent = {{-19, 44}, {21, 64}}, rotation = 0)));
 MoSDH.Components.Weather.WeatherData weatherData1 annotation(Placement(visible = true, transformation(extent = {{-19, -16}, {21, 24}}, rotation = 0)));
 MoSDH.Components.Distribution.Pump pump2(
  medium=Modelica.Thermal.FluidHeatFlow.Media.Water(),
  volFlowRef=0.05) annotation(Placement(visible = true, transformation(extent = {{41, 44}, {31, 54}}, rotation = 0)));
 Modelica.Units.SI.HeatFlowRate specificHeatLosses=districtHeatingPipes1.PthermalLoss
        /(2*districtHeatingPipes1.length) "Specific heat losses [W/m]";
equation
 connect(fluidSourceHot2.fluidPort, pump1.flowPort_a) annotation (
    Line(points = {{-64, 59}, {-59, 59}, {-44, 59}, {-39, 59}}, color = {255, 0, 0}, thickness = 1));
 connect(districtHeatingPipes1.fromSupply, fluidSourceHot1.fluidPort) annotation (
    Line(points = {{20.67, 59}, {25.67, 59}, {45.97, 59}, {50.97, 59}}, color = {255, 0, 0}, thickness = 1));
 connect(fluidSourceCold2.fluidPort, districtHeatingPipes1.fromReturn) annotation (
    Line(points = {{-64, 49}, {-59, 49}, {-24, 49}, {-19, 49}}, color = {0, 0, 255}, thickness = 1));
 connect(districtHeatingPipes1.toSupply, pump1.flowPort_b) annotation (
    Line(points = {{-19, 59}, {-24, 59}, {-24.3, 59}, {-29.3, 59}}, color = {255, 0, 0}, thickness = 1));
 connect(weatherData1.weatherPort, districtHeatingPipes1.weatherPort) annotation (
    Line(points = {{1, 24}, {1, 29}, {1, 39.3}, {1, 44.3}}, color = {0, 176, 80}));
 connect(fluidSourceCold1.fluidPort, pump2.flowPort_a) annotation (
    Line(points = {{51, 49}, {46, 49}, {41, 49}}, color = {0, 0, 255}, thickness = 1));
 connect(districtHeatingPipes1.toReturn, pump2.flowPort_b) annotation (
    Line(points = {{20.67, 49}, {25.67, 49}, {26.27, 49}, {31.27, 49}}, color = {0, 0, 255}, thickness = 1));
 annotation (
  __OpenModelica_simulationFlags(
   lv="LOG_STATS",
   outputFormat="mat",
   s="dassl"),
  __OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  Documentation(info= "<html>


</html>"),
  experiment(
   StopTime=31536000,
   StartTime=0,
   Tolerance=0.0001,
   Interval=3600));
end ExamplePipes;