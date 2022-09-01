within MoSDH.Components.Distribution;
model ExampleShunt "Example model for hydraulic shunt"
 extends Modelica.Icons.Example;
 Loads.HeatDemand load(loadData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatDemand/Darmstadt_TRY2015_25GWh.txt")) annotation(Placement(transformation(extent={{20,-20},{60,20}})));
 HydraulicShunt hydraulicShunt1 annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
 Sources.Fossil.GasBoiler gasBoiler1(
  Pthermal_max=10000000,
  deltaTmin(displayUnit="K"),
  mode=MoSDH.Utilities.Types.ControlTypes.RefFlowRefTemp,
  volFlowRef(displayUnit="mÂ³/s")=load.volFlow) annotation(Placement(transformation(extent={{-65,-20},{-25,20}})));
 Weather.WeatherData weatherData1 annotation(Placement(transformation(extent={{20,-80},{60,-40}})));
equation
  connect(hydraulicShunt1.loadSupply,load.supplyPort) annotation(Line(
   points={{10,5},{15,5},{20,5}},
   color={255,0,0},
   thickness=1));
  connect(hydraulicShunt1.loadReturn,load.returnPort) annotation(Line(
   points={{9.699999999999999,-5},{14.7,-5},{15,-5},{20,-5}},
   color={0,0,255},
   thickness=1));
  connect(gasBoiler1.supplyPort,hydraulicShunt1.sourceSupply) annotation(Line(
   points={{-25.3,5},{-20.3,5},{-15,5},{-10,5}},
   color={255,0,0},
   thickness=1));
  connect(gasBoiler1.returnPort,hydraulicShunt1.sourceReturn) annotation(Line(
   points={{-25.3,-5},{-20.3,-5},{-15,-5},{-10,-5}},
   color={0,0,255},
   thickness=1));
  connect(weatherData1.weatherPort,load.weatherPort) annotation(Line(
   points={{40,-40},{40,-35},{40,-24.7},{40,-19.7}},
   color={0,176,80}));
 annotation (
  Documentation(info="<html><head></head><body><p><ul><li>If source and load components are connected directly without a storage inbetween, the hydraulic circuit is overdetermined, since both components define the volume flow rate.</li><li>A shunt can be used to decouple the flow of source and load side.</li><li>In this example a gas boiler supplies the thermal load.</li><li>The gas boiler is controlled by a reference flow temperature of 60 Â°C and a volume flow rate, which is set equal to the load volume flow rate.</li></ul></p>

</body></html>"),
  experiment(
   StopTime=31536000,
   StartTime=0,
   Tolerance=1e-06,
   Interval=900));
end ExampleShunt;