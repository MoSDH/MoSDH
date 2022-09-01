within MoSDH.Components.Utilities.FluidHeatFlow;
model fluidSourceCold "Cold fluid source"
 MoSDH.Utilities.Interfaces.ReturnPort fluidPort(medium=medium) "Port used for hot fluid" annotation(Placement(
  transformation(extent={{-110,40},{-90,60}}),
  iconTransformation(extent={{-60,-10},{-40,10}})));
 Modelica.Thermal.FluidHeatFlow.Sources.Ambient ambient(
  medium=medium,
  usePressureInput=true,
  constantAmbientPressure=100000,
  useTemperatureInput=true,
  constantAmbientTemperature=293.15) annotation(Placement(transformation(extent={{-70,40},{-50,60}})));
 replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby
    Modelica.Thermal.FluidHeatFlow.Media.Medium                                                                                    "Grid heat carrier fluid" annotation(Dialog(
  group="Properties",
  tab="Design"),
 choicesAllMatching=true);
 Modelica.Blocks.Interfaces.RealInput Tsource(
  final quantity="ThermodynamicTemperature",
  final unit="K",
  min=0.0,
  start=288.15,
  nominal=300,
  displayUnit="degC")=293.15 "Fluid source temperature" annotation(Dialog(
  group="Properties",
  tab="Design"));
 Modelica.Blocks.Interfaces.RealInput pSource(
  final quantity="Pressure",
  final unit="Pa",
  displayUnit="bar")=100000 "Fluid source pressure" annotation(Dialog(
  group="Properties",
  tab="Design"));
equation
  connect(ambient.ambientPressure,pSource);
  connect(ambient.ambientTemperature,Tsource);
  connect(fluidPort,ambient.flowPort) annotation(Line(
   points={{-100,50},{-95,50},{-75,50},{-70,50}},
   color={0,0,255},
   thickness=1));
 annotation (
  Icon(
   coordinateSystem(extent={{-50,-50},{50,50}}),
   graphics={
   Ellipse(
    pattern=LinePattern.None,
    fillColor={0,0,255},
    fillPattern=FillPattern.Solid,
    extent={{-46.6,46.6},{46.8,-46.7}})}),
  experiment(
   StopTime=1,
   StartTime=0,
   Tolerance=1e-06,
   Interval=0.001),
 Documentation(info = "<html><head></head><body>Fluid volume of infinite volume of temperature Tsource and with pressure pSource. Both are defined as variables and can be defined dynamic. Use component for system inputs/outputs.</body></html>"));
end fluidSourceCold;
