within MoSDH.Components.Distribution;
model threeWayValve "3 way valve"
 MoSDH.Utilities.Interfaces.FluidPort flowPort_a(medium=medium) "Residual port volFlow=f(1-y) " annotation(Placement(
  transformation(extent={{30,40},{50,60}}),
  iconTransformation(
   origin={46.7,0},
   extent={{-10,-10},{10,10}},
   rotation=180)));
 MoSDH.Utilities.Interfaces.FluidPort flowPort_b(medium=medium) "Controlled port volFlow=f(y)" annotation(Placement(
  transformation(extent={{-110,40},{-90,60}}),
  iconTransformation(extent={{-60,-10},{-40,10}})));
 MoSDH.Utilities.Interfaces.FluidPort flowPort_c(medium=medium) "Open port" annotation(Placement(
  transformation(extent={{-40,85},{-20,105}}),
  iconTransformation(extent={{-10,40},{10,60}})));
 replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby
    Modelica.Thermal.FluidHeatFlow.Media.Medium                                                                                    "Heat carrier fluid" annotation(choicesAllMatching=true);
 Modelica.Units.SI.VolumeFlowRate volFlowB=flowPort_b.m_flow/medium.rho "Volume flow rate at port b";
 Modelica.Units.SI.VolumeFlowRate volFlowA=flowPort_a.m_flow/medium.rho "Volume flow rate at port a";
 Modelica.Units.SI.VolumeFlowRate volFlowC=flowPort_c.m_flow/medium.rho "Volume flow rate at port c";
 Modelica.Thermal.FluidHeatFlow.Components.Valve valveA(
  medium=medium,
  m=m/3,
  T0=T0,
  T0fixed=T0fixed,
  LinearCharacteristic=LinearCharacteristic,
  y1=1,
  Kv1=1,
  kv0=kv0,
  dp0=dp0,
  rho0=medium.rho,
  frictionLoss=frictionLoss) annotation(Placement(transformation(
  origin={15,50},
  extent={{-10,10},{10,-10}},
  rotation=-180)));
 Modelica.Thermal.FluidHeatFlow.Components.Valve valveB(
  medium=medium,
  m=m/3,
  T0=T0,
  T0fixed=T0fixed,
  LinearCharacteristic=LinearCharacteristic,
  y1=1,
  Kv1=1,
  kv0=kv0,
  dp0=dp0,
  rho0=medium.rho,
  frictionLoss=frictionLoss) annotation(Placement(transformation(extent={{-85,40},{-65,60}})));
 Modelica.Thermal.FluidHeatFlow.Components.Valve valveC(
  medium=medium,
  m=m/3,
  T0=T0,
  T0fixed=T0fixed,
  LinearCharacteristic=LinearCharacteristic,
  y1=1,
  Kv1=1,
  kv0=kv0,
  dp0=dp0,
  rho0=medium.rho,
  frictionLoss=frictionLoss) annotation(Placement(transformation(
  origin={-30,70},
  extent={{-10,10},{10,-10}},
  rotation=-90)));
 parameter Boolean LinearCharacteristic=true "Type of characteristic" annotation (
  choices(
   choice=true "Linear",
   choice=false "Exponential"),
  Dialog(group="Standard characteristic"));
 parameter Real kv0(
  min=Modelica.Constants.small,
  max=1-Modelica.Constants.small)=1e-12 "Leakage flow / max.flow @ y = 0" annotation(Dialog(group="Standard characteristic"));
 parameter Modelica.Units.SI.Pressure dp0=1e-05 "Standard pressure drop" annotation(Dialog(group="Standard characteristic"));
 parameter Real frictionLoss(
  min=0,
  max=1)=0 "Part of friction losses fed to medium";
 parameter Modelica.Units.SI.Mass m=100 "Mass of medium";
 parameter Modelica.Units.SI.Temperature T0(displayUnit="degC")=293.15 "Initial temperature of medium" annotation(Dialog(enable=m>Modelica.Constants.small));
 parameter Boolean T0fixed=true "Initial temperature guess value or fixed" annotation (
  choices(checkBox=true),
  Dialog(enable=m>Modelica.Constants.small));
 MoSDH.Utilities.Types.ValveOperationModes controlMode=MoSDH.Utilities.Types.ValveOperationModes.ctrlAfreeC "Define controlled ports" annotation(Dialog(
  group="Setpoint",
  tab="Control"));
 Real controlSignalRef=1 "Define controlled ports" annotation(Dialog(
  group="Setpoint",
  tab="Control",
  enable=Integer(mode)<>3));
equation
  if controlMode==MoSDH.Utilities.Types.ValveOperationModes.ctrlAfreeC then
   valveA.y=max(0,min(1,controlSignalRef));
   valveB.y=max(0,min(1,1-controlSignalRef));
   valveC.y=1;
  elseif controlMode==MoSDH.Utilities.Types.ValveOperationModes.ctrlCfreeA then
   valveA.y=1;
   valveB.y=max(0,min(1,1-controlSignalRef));
   valveC.y=max(0,min(1,controlSignalRef));
  else
   valveA.y=1;
   valveB.y=1;
   valveC.y=1;
  end if;

  connect(flowPort_b,valveB.flowPort_a) annotation(Line(
   points={{-100,50},{-95,50},{-90,50},{-85,50}},
   thickness=1));
  connect(flowPort_a,valveA.flowPort_a) annotation(Line(
   points={{40,50},{35,50},{30,50},{25,50}},
   thickness=1));
  connect(valveA.flowPort_b,valveC.flowPort_b) annotation(Line(
   points={{5,50},{0,50},{-30,50},{-30,55},{-30,60}},
   color={255,0,0},
   thickness=0.0625));
  connect(valveB.flowPort_b,valveC.flowPort_b) annotation(Line(
   points={{-65,50},{-60,50},{-30,50},{-30,55},{-30,60}},
   color={255,0,0},
   thickness=0.0625));
  connect(flowPort_c,valveC.flowPort_a) annotation (
   Line(
    points={{-30,95},{-30,90},{-30,85},{-30,80}},
    thickness=1),
   AutoRoute=false);
 annotation (
  defaultComponentName="valve",
  Icon(
   coordinateSystem(extent={{-50,-50},{50,50}}),
   graphics={
    Line(
     points={{-50,0},{46.7,0}},
     thickness=1),
    Line(
     points={{0,0},{0,50}},
     thickness=1),
    Polygon(
     points={{0.7,0},{-46,33.3},{-46,-33.3}},
     fillColor={255,255,255},
     fillPattern=FillPattern.Solid,
     lineThickness=1),
    Polygon(
     points={{1.3,-0.2},{48,33.1},{48,-33.5}},
     fillColor={255,255,255},
     fillPattern=FillPattern.Solid,
     lineThickness=1),
    Polygon(
     points={{-31.1,0},{15.6,33.3},{15.6,-33.3}},
     fillColor={255,255,255},
     fillPattern=FillPattern.Solid,
     lineThickness=1,
     origin={-0.6,31.3},
     rotation=90)}),
  experiment(
   StopTime=1,
   StartTime=0,
   Tolerance=1e-06,
   Interval=0.001));
end threeWayValve;