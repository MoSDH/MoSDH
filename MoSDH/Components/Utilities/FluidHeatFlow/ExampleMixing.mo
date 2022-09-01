within MoSDH.Components.Utilities.FluidHeatFlow;
model ExampleMixing "Mixing volume example"
 extends Modelica.Icons.Example;
 MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot1(Tsource=333.15) annotation(Placement(transformation(extent={{75,80},{85,90}})));
 MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot2(Tsource=333.15) annotation(Placement(transformation(extent={{75,60},{85,70}})));
 MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot3(Tsource=333.15) annotation(Placement(transformation(extent={{75,40},{85,50}})));
 MoSDH.Components.Distribution.Pump pump(volFlowRef=0.01) annotation(Placement(transformation(extent={{70,60},{60,70}})));
 MoSDH.Components.Distribution.Pump pump1(volFlowRef=0.01) annotation(Placement(transformation(extent={{70,80},{60,90}})));
 MoSDH.Components.Distribution.Pump pump2(volFlowRef=0.01) annotation(Placement(transformation(extent={{60,40},{50,50}})));
 Modelica.Thermal.FluidHeatFlow.Components.Pipe pipe1(
  medium=Modelica.Thermal.FluidHeatFlow.Media.Air_30degC(),
  m=2,
  T0=293.15,
  T0fixed=true,
  V_flowLaminar=0.1,
  dpLaminar=0.09999999999999999,
  V_flowNominal=1,
  dpNominal=1,
  h_g=0) annotation(Placement(transformation(extent={{25,75},{45,95}})));
 Modelica.Thermal.FluidHeatFlow.Components.Pipe pipe2(
  medium=Modelica.Thermal.FluidHeatFlow.Media.Air_30degC(),
  m=2,
  T0=293.15,
  T0fixed=true,
  V_flowLaminar=0.1,
  dpLaminar=0.09999999999999999,
  V_flowNominal=1,
  dpNominal=1,
  h_g=0) annotation(Placement(transformation(extent={{25,55},{45,75}})));
 Modelica.Thermal.FluidHeatFlow.Components.Pipe pipe3(
  medium=Modelica.Thermal.FluidHeatFlow.Media.Air_30degC(),
  m=2,
  T0=293.15,
  T0fixed=true,
  V_flowLaminar=0.1,
  dpLaminar=0.09999999999999999,
  V_flowNominal=1,
  dpNominal=1,
  h_g=0) annotation(Placement(transformation(extent={{25,35},{45,55}})));
 MoSDH.Components.Utilities.FluidHeatFlow.MixingVolume mixingVolume1(
  nPortsA=3,
  V_flowNom=0.1) annotation(Placement(transformation(
  origin={-15,65},
  extent={{-5,-5},{5,5}},
  rotation=-90)));
 MoSDH.Components.Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold1 annotation(Placement(transformation(extent={{-35,60},{-45,70}})));
equation
  connect(fluidSourceHot1.fluidPort,pump1.flowPort_a) annotation(Line(
   points={{75,85},{70,85},{75,85},{70,85}},
   color={255,0,0}));
  connect(fluidSourceHot2.fluidPort,pump.flowPort_a) annotation(Line(
   points={{75,65},{70,65},{75,65},{70,65}},
   color={255,0,0}));
  connect(fluidSourceHot3.fluidPort,pump2.flowPort_a) annotation(Line(
   points={{75,45},{70,45},{65,45},{60,45}},
   color={255,0,0}));
  connect(pump1.flowPort_b,pipe1.flowPort_b) annotation(Line(points={{60.3,85},{55.3,85},{50,85},{45,85}}));
  connect(pump.flowPort_b,pipe2.flowPort_b) annotation(Line(points={{60.3,65},{55.3,65},{50,65},{45,65}}));
  connect(pump2.flowPort_b,pipe3.flowPort_b) annotation(Line(points={{50.3,45},{45.3,45},{50,45},{45,45}}));
  connect(mixingVolume1.fluidPort_a[1],pipe1.flowPort_a) annotation(Line(points={{-10,65},{-5,65},{20,65},{20,85},{25,85}}));
  connect(mixingVolume1.fluidPort_a[2],pipe2.flowPort_a) annotation(Line(points={{-10,65},{-5,65},{20,65},{25,65}}));
  connect(mixingVolume1.fluidPort_a[3],pipe3.flowPort_a) annotation(Line(points={{-10,65},{-5,65},{20,65},{20,45},{25,45}}));
  connect(fluidSourceCold1.fluidPort,mixingVolume1.fluidPort_b[1]) annotation(Line(
   points={{-35,65},{-30,65},{-24.7,65},{-19.7,65}},
   color={0,0,255}));
 annotation(experiment(
  StopTime=1,
  StartTime=0,
  Tolerance=1e-06,
  Interval=0.001));
end ExampleMixing;