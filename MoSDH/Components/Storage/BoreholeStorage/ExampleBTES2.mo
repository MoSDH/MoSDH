within MoSDH.Components.Storage.BoreholeStorage;
model ExampleBTES2 "BTES example with constant charging temperature and dischargin power"
 extends Modelica.Icons.Example;
 MoSDH.Components.Storage.BoreholeStorage.BTES Storage(volFlowRef=volFlow) annotation(Placement(visible = true, transformation(origin = {2, -2}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot1(
  medium=Storage.medium,
  Tsource=Tsupply) annotation(Placement(visible = true, transformation(origin = {-8, 48}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
 MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold1(
  medium=Storage.medium,
  Tsource=Treturn) annotation(Placement(visible = true, transformation(origin = {12, 48}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
 Modelica.Units.SI.Temperature Tsupply;
 Modelica.Units.SI.Temperature Treturn;
 Modelica.Units.SI.VolumeFlowRate volFlow;
 Modelica.Units.SI.Power PthExtraction=PextractionSpec*Storage.nBHEs*Storage.BHElength;
 parameter Modelica.Units.SI.Temperature Tcharge=343.15 "Charging temperature";
 parameter Modelica.Units.SI.Temperature TdischargeMin=273.15 "Minimum discharge temperature";
 parameter Real PextractionSpec(unit="W/m")=40;
 parameter Modelica.Units.SI.VolumeFlowRate volFlowSpec=0.001 "Volume flow rate through single BHE";
equation
 connect(fluidSourceHot1.fluidPort, Storage.supplyPort) annotation(
    Line(points = {{-8, 43}, {-8, 38}, {-8, 23}, {-8, 18}}, color = {255, 0, 0}, thickness = 1));
 connect(fluidSourceCold1.fluidPort, Storage.returnPort) annotation(
    Line(points = {{12, 43}, {12, 38}, {12, 23}, {12, 18}}, color = {0, 0, 255}, thickness = 1));
  if mod(time, 8760 * 3600) < 8760 * 3600 * 0.5 then
    volFlow = volFlowSpec * Storage.nBHEs / Storage.nBHEsInSeries;
    Tsupply = Tcharge;
    Treturn = Storage.Treturn;
  else
    volFlow = -volFlowSpec * Storage.nBHEs / Storage.nBHEsInSeries;
    Tsupply = Storage.Tsupply;
    Treturn = max(TdischargeMin, Tsupply + PthExtraction / (Storage.medium.rho * Storage.medium.cp * volFlow));
  end if;
 annotation (
  __OpenModelica_simulationFlags(
   lv="LOG_STATS",
   s= "dassl"),
  __OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian,nonewInst -d=nonewInst",
  Documentation(info= "<html><head></head><body><p><a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.BTES\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">Borehole storage</a> example model with constant charging temperature and discharging power:</p>
<ul>
<li>Simulation of 10 years</li>
<li>Constant charging for 6 months with Tcharge and volFlowSpec (model parameters)</li>
<li>Constant discharging for 6 months with PextractionSpec and volFlowSpec (model parameters)</li><li>Discharging temperature is limited to TdischargeMin (parameter)</li>
</ul>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>BHE inlet and outlet temperatures</caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/BTESExample2.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>

</body></html>"),
  experiment(
   StopTime = 3.1536e+08,
   StartTime=0,
   Tolerance=0.0001,
   Interval=7200));
end ExampleBTES2;
