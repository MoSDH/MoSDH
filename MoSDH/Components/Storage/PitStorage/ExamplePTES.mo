within MoSDH.Components.Storage.PitStorage;

model ExamplePTES "Pit storage example model"
  extends Modelica.Icons.Example;
  Weather.WeatherData weatherData1(weatherData = Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/Weather/DWD/TRY2017_Darmstadt.txt")) annotation(
    Placement(transformation(extent = {{-20, -60}, {20, -20}})));
  PTES pit(Tinitial = fill(283.15, pit.nLayers), lidOverlap = 1.5, nLayers = 10, nLidLayers = 3, slope = 0.443139, storageHeight = 16, storageVolume = 75000, tInsulationLid = fill(0.08, pit.nLidLayers)) annotation(
    Placement(transformation(extent = {{-40, -5}, {40, 25}})));
  Distribution.Pump pump1(volFlowRef(displayUnit = "mÂ³/s") = flowRate) annotation(
    Placement(transformation(extent = {{-100, 10}, {-90, 20}})));
  Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot1(Tsource = 363.15) annotation(
    Placement(transformation(extent = {{-115, 10}, {-125, 20}})));
  Distribution.Pump pump3(volFlowRef(displayUnit = "mÂ³/s") = -flowRate) annotation(
    Placement(transformation(extent = {{-70, 0}, {-60, 10}})));
  Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold(Tsource = 303.15) annotation(
    Placement(transformation(extent = {{-115, 0}, {-125, 10}})));
  Modelica.Units.SI.VolumeFlowRate flowRate = if mod(time, 8760 * 3600) < 31536000 / 2 then pit.storageVolume / (8760 * 3600 * 0.5) else -pit.storageVolume / (8760 * 3600 * 0.5);
equation
  connect(weatherData1.weatherPort, pit.weatherPort) annotation(
    Line(points = {{0, -20}, {0, -15}, {0, -9.699999999999999}, {0, -4.7}}, color = {0, 176, 80}));
  connect(pit.bottomPort, pump3.flowPort_b) annotation(
    Line(points = {{-40, 5}, {-45, 5}, {-55.3, 5}, {-60.3, 5}}, color = {0, 0, 255}, thickness = 1));
  connect(pit.topPort, pump1.flowPort_b) annotation(
    Line(points = {{-40, 15}, {-45, 15}, {-85.3, 15}, {-90.3, 15}}, color = {255, 0, 0}, thickness = 1));
  connect(fluidSourceHot1.fluidPort, pump1.flowPort_a) annotation(
    Line(points = {{-115, 15}, {-110, 15}, {-105, 15}, {-100, 15}}, color = {255, 0, 0}, thickness = 1));
  connect(fluidSourceCold.fluidPort, pump3.flowPort_a) annotation(
    Line(points = {{-115, 5}, {-110, 5}, {-75, 5}, {-70, 5}}, color = {0, 0, 255}, thickness = 1));
  annotation(
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "cvode", maxStepSize = "7200"),
    Documentation(info = "<html><head></head><body><p>Example model for the <a href=\"modelica://MoSDH.Components.Storage.PitStorage.PTES\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">PTES</a>:</p><p></p><ul><li>Generic load scenario over 10 years.</li><li>Constant charging with 4 l/s and 90 °C for 182.5 days.</li><li>Constant discharging with 4 l/s and 30 °C for 182.5 days.</li></ul><p></p><ul>
</ul>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>PTES layer temperatures</caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/PTESexample.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 2: </strong>Thermal loss components</caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/PTESexampleB.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>

</body></html>"),
    experiment(StopTime = 3.1536e+08, StartTime = 0, Tolerance = 0.0001, Interval = 86400));
end ExamplePTES;
