within MoSDH.Components.Loads;
model ExampleHeatDemand "Load example"
 import MoSDH.Components.Sources.Solar.*;
 import MoSDH.Components.Sources.*;
 MoSDH.Components.Weather.WeatherData weatherData(
  latitude=-0.5916666164260777,
  weatherData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/Weather/DWD/Darmstadt_TRY2015.txt")) annotation(Placement(visible = true, transformation(origin = {2, -25.7}, extent = {{-21, -21}, {19, 16.7}}, rotation = 0)));
 extends Modelica.Icons.Example;
 MoSDH.Components.Loads.HeatDemand load(loadData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatDemand/Darmstadt_TRY2015_5GWh.txt")) annotation(Placement(visible = true, transformation(extent = {{-19, 1}, {21, 41}}, rotation = 0)));
 MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot1(
  medium=load.medium,
  Tsource=333.15) annotation(Placement(visible = true, transformation(extent = {{-34, 21}, {-44, 31}}, rotation = 0)));
 MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold1(medium=load.medium) annotation(Placement(visible = true, transformation(extent = {{-34, 11}, {-44, 21}}, rotation = 0)));
equation
 connect(weatherData.weatherPort, load.weatherPort) annotation(
    Line(points = {{1, -9}, {1, -4}, {1, -3.7}, {1, 1.3}}, color = {0, 176, 80}, thickness = 0.875));
 connect(fluidSourceCold1.fluidPort, load.returnPort) annotation(
    Line(points = {{-34, 16}, {-29, 16}, {-24, 16}, {-19, 16}}, color = {0, 0, 255}, thickness = 1));
 connect(fluidSourceHot1.fluidPort, load.supplyPort) annotation(
    Line(points = {{-34, 26}, {-29, 26}, {-24, 26}, {-19, 26}}, color = {255, 0, 0}, thickness = 1));
 annotation (
  __OpenModelica_simulationFlags(
   lv="LOG_STATS",
   outputFormat="mat",
   s="dassl"),
  __OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  Documentation(info= "<html><head></head><body><p><h4><a href=\"modelica://MoSDH.Components.Loads.HeatDemand\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">Heat demand</a> component (Loads.HeatDemand)</h4><div><ul><li>A heat load curve is read from file (<b>loadData</b>)</li><li>The volume flow of the component is controlled to meet the heat load and the return temperature which is defined dynamically by <b>TreturnGrid.</b></li><li><b>The heat load is only extracted&nbsp;</b></li><li>If isTRYdata is set to true, the load curve is repeated annualy.</li><li><b>timeUnitData</b> and <b>powerUnitdata</b> have to be set according to the units in the file.</li></ul></div></p>

</body></html>"),
  experiment(
   StopTime=31536000,
   StartTime=0,
   Tolerance=0.0001,
   Interval=3600));
end ExampleHeatDemand;
