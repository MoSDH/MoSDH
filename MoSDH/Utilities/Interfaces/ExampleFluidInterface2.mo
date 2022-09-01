within MoSDH.Utilities.Interfaces;
model ExampleFluidInterface2 "Example model for the Modelica.Fluid interface with a storage component"
extends Modelica.Icons.Example;
 MoSDH.Components.Storage.BoreholeStorage.BTES Storage(
  nBHEs=25,
  BHElength=50,
  redeclare replaceable parameter Parameters.Locations.SingleLayerLocation location,
  redeclare replaceable parameter Parameters.BoreholeHeatExchangers.DoubleU_DN32 BHEdata,
  nBHEsInSeries=5,
  redeclare replaceable model BHEmodel =
        MoSDH.Components.Sources.Geothermal.BaseClasses.DoubleU_BHE,
  volFlowRef(displayUnit="mÂ³/s")=if mod(time,8760*3600)<8760*3600*0.5 then 0.001*Storage.nBHEs/Storage.nBHEsInSeries else -0.001*Storage.nBHEs/Storage.nBHEsInSeries) annotation(Placement(visible = true, transformation(origin = {2, -14}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.Fluid.Sources.FixedBoundary supplySource(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,                                                                       T = 343.15, nPorts = 1) annotation (
    Placement(visible = true, transformation(origin = {-64, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 MoSDH.Utilities.Interfaces.FluidInterface returnInterface(redeclare package
      medium2 =
        Modelica.Media.Water.ConstantPropertyLiquidWater)                                                                                annotation (
    Placement(visible = true, transformation(origin = {11, 34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Modelica.Fluid.Sources.FixedBoundary returnSource(redeclare package Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater,                                                                       T = 283.15, nPorts = 1) annotation (
    Placement(visible = true, transformation(origin = {60, 70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
 Modelica.Fluid.Sensors.TemperatureTwoPort returnSensor(redeclare package
      Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)                                                                            annotation (
    Placement(visible = true, transformation(origin = {30, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Fluid.Sensors.TemperatureTwoPort supplySensor(redeclare package
      Medium =
        Modelica.Media.Water.ConstantPropertyLiquidWater)                                                                            annotation (
    Placement(visible = true, transformation(origin = {-32, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 MoSDH.Utilities.Interfaces.FluidInterface supplyInterface(redeclare package
      medium2 =
        Modelica.Media.Water.ConstantPropertyLiquidWater)                                                                                annotation (
    Placement(visible = true, transformation(origin = {-9, 34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
 connect(returnSource.ports[1], returnSensor.port_b) annotation (
    Line(points = {{50, 70}, {40, 70}}, color = {0, 127, 255}));
 connect(supplySensor.port_b, supplyInterface.fluidPort) annotation (
    Line(points={{-22,70},{-9,70},{-9,44}},        color = {0, 127, 255}));
 connect(returnSensor.port_a, returnInterface.fluidPort) annotation (
    Line(points={{20,70},{11,70},{11,44}},        color = {0, 127, 255}));
 connect(supplySource.ports[1], supplySensor.port_a) annotation (
    Line(points = {{-54, 70}, {-42, 70}}, color = {0, 127, 255}));
 connect(Storage.supplyPort, supplyInterface.fluidHeatFlowPort) annotation (
    Line(points={{-8,6},{-8,16},{-8,24.8},{-9,24.8}},
                                      thickness=1, color = {255, 0, 0}));
 connect(Storage.returnPort, returnInterface.fluidHeatFlowPort) annotation (
    Line(points={{12,6},{12,16},{12,24.8},{11,24.8}},
                                       thickness=1,color = {0, 0, 255}));
  annotation (
  __OpenModelica_simulationFlags(
   lv="LOG_STATS",
   s="cvode"),
  __OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian,nonewInst -d=nonewInst",
  Documentation(info= "<html><head></head><body><p>Example model for the interface to Modelica.Fluid components. The operation scneario is equvalent to MoSDH.Components.Storage.BoreholeStorage.ExampleBTES.</p><ul>
</ul>

</body></html>"),
  experiment(
   StopTime=315360000,
   StartTime=0,
   Tolerance=0.0001,
   Interval=7200));
end ExampleFluidInterface2;