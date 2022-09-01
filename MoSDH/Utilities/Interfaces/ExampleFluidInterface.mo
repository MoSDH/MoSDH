within MoSDH.Utilities.Interfaces;
model ExampleFluidInterface "Example model for the Modelica.Fluid interface"
 extends Modelica.Icons.Example;
 FluidInterface fluidInterface(redeclare package medium2 =
        Modelica.Media.Water.ConstantPropertyLiquidWater)                                                    annotation(Placement(transformation(
  origin={-5,-5},
  extent={{-10,-10},{10,10}})));
 Modelica.Fluid.Sources.FixedBoundary boundary(
  nPorts=1,
  redeclare package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater,
  p=100000,
  T=303.15) annotation(Placement(transformation(
  origin={-60,-5},
  extent={{-10,-10},{10,10}})));
 Modelica.Thermal.FluidHeatFlow.Sources.VolumeFlow volumeFlow(
  medium=fluidInterface.medium1,
  m=0,
  T0(displayUnit="K")=293.15,
  T0fixed=false,
  useVolumeFlowInput=true,
  constantVolumeFlow=1) annotation(Placement(transformation(
  origin={25,-5},
  extent={{-10,-10},{10,10}})));
 Modelica.Thermal.FluidHeatFlow.Sources.Ambient ambient(
  medium=fluidInterface.medium1,
  constantAmbientPressure=100000,
  constantAmbientTemperature=293.15) annotation(Placement(transformation(
  origin={65,-5},
  extent={{-10,-10},{10,10}})));
 Modelica.Blocks.Sources.Sine sine(
  amplitude=0.001,
  f=0.1,
  phase=1.5707963267949) annotation(Placement(transformation(
  origin={-6,32},
  extent={{-10,-10},{10,10}})));
 Modelica.Fluid.Sensors.TemperatureTwoPort temperature(redeclare package Medium
      =
        Modelica.Media.Water.ConstantPropertyLiquidWater)                                                                           annotation(Placement(transformation(
  origin={-30,-5},
  extent={{-10,-10},{10,10}})));
 Modelica.Thermal.FluidHeatFlow.Sensors.TemperatureSensor temperatureSensor1(
  medium=fluidInterface.medium1) annotation(Placement(transformation(extent={{45,15},{65,35}})));
equation
  connect(fluidInterface.fluidHeatFlowPort,volumeFlow.flowPort_a) annotation(Line(
   points={{4.2,-5},{4.2,-5},{10,-5},{15,-5}},
   color={255,0,0}));
  connect(sine.y,volumeFlow.volumeFlow) annotation(Line(
   points={{5,32},{10,32},{25,32},{25,10},{25,5}},
   color={0,0,127}));
  connect(fluidInterface.fluidPort,temperature.port_b) annotation(Line(
   points={{-15,-5},{-20,-5},{-15,-5},{-20,-5}},
   color={0,127,255}));
  connect(temperature.port_a,boundary.ports[1]) annotation(Line(
   points={{-40,-5},{-45,-5},{-50,-5}},
   color={0,127,255}));
  connect(volumeFlow.flowPort_b,ambient.flowPort) annotation(Line(
   points={{35,-5},{40,-5},{50,-5},{55,-5}},
   color={255,0,0},
   thickness=0.0625));
  connect(temperatureSensor1.flowPort,volumeFlow.flowPort_b) annotation(Line(
   points={{45,25},{40,25},{40,-5},{35,-5}},
   color={255,0,0},
   thickness=0.0625));
 annotation(experiment(
  StopTime=20,
  StartTime=0,
  Tolerance=1e-06,
  Interval=0.1));
end ExampleFluidInterface;