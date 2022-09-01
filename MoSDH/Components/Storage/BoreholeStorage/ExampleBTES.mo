within MoSDH.Components.Storage.BoreholeStorage;

model ExampleBTES "BTES example with constant inlet temperatures"
  extends Modelica.Icons.Example;
  MoSDH.Components.Storage.BoreholeStorage.BTES Storage(nBHEs = 25, BHElength = 50, redeclare replaceable parameter Parameters.Locations.SingleLayerLocation location, redeclare replaceable parameter Parameters.BoreholeHeatExchangers.DoubleU_DN32 BHEdata, nBHEsInSeries = 5, redeclare replaceable model BHEmodel = MoSDH.Components.Sources.Geothermal.BaseClasses.DoubleU_BHE, volFlowRef(displayUnit = "mÂ³/s") = if mod(time, 8760 * 3600) < 8760 * 3600 * 0.5 then 0.001 * Storage.nBHEs / Storage.nBHEsInSeries else -0.001 * Storage.nBHEs / Storage.nBHEsInSeries) annotation(
    Placement(visible = true, transformation(origin = {0, -6}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot1(medium = Storage.medium, Tsource = 343.15) annotation(
    Placement(visible = true, transformation(origin = {-10, 44}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold1(medium = Storage.medium, Tsource = 283.15) annotation(
    Placement(visible = true, transformation(origin = {10, 44}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
equation
  connect(fluidSourceHot1.fluidPort, Storage.supplyPort) annotation(
    Line(points = {{-10, 39}, {-10, 34}, {-10, 19}, {-10, 14}}, color = {255, 0, 0}, thickness = 1));
  connect(fluidSourceCold1.fluidPort, Storage.returnPort) annotation(
    Line(points = {{10, 39}, {10, 34}, {10, 19}, {10, 14}}, color = {0, 0, 255}, thickness = 1));
  annotation(
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "cvode"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian,nonewInst -d=nonewInst",
    Documentation(info = "<html><head></head><body><p><a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.BTES\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">Borehole storage</a> example model with constant charging and discharging temperatures.
</p>
<ul>
<li>Simulation of 10 years</li>
<li>Constant charging for 6 months with 80 °C and 2 l/s per BHE</li>
<li>Constant discharging for 6 months with 20 °C and 2 l/s per BHE</li>
<li>Parallel connection of double-U BHEs</li>
<li>Constant thermal properties of the underground</li>
<li>Variation of the number, length, arrangement and radial distance of BHEs </li>
</ul>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>BHE inlet and outlet temperatures</caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/BTESExample1.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>
</body></html>"),
    experiment(StopTime = 315360000, StartTime = 0, Tolerance = 0.0001, Interval = 7200));
end ExampleBTES;
