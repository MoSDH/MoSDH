within MoSDH.Components.Distribution;
model ExampleHeatExchanger "Heat exchanger example"
 extends Modelica.Icons.Example;
 HeatExchanger hx(
  redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water_10degC mediumSource,
  setAbsoluteLoadPressure=false,
  heatExchangeSurface=500,
  heatTransferCoeffieicent=1000,
  controlType=MoSDH.Utilities.Types.ControlTypesHX.CoupleLoad,
  flowRatioConstant=hx.mediumSource.cp/hx.mediumLoad.cp) annotation(Placement(transformation(extent={{-75,40},{-55,60}})));
 Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot1(medium=hx.mediumLoad) annotation(Placement(transformation(extent={{-25,55},{-15,65}})));
 Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold1(medium=hx.mediumLoad) annotation(Placement(transformation(extent={{-25,35},{-15,45}})));
 Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot2(
  medium=hx.mediumSource,
  Tsource=333.15) annotation(Placement(transformation(extent={{-120,60},{-130,70}})));
 Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold2(medium=hx.mediumSource) annotation(Placement(transformation(extent={{-120,40},{-130,50}})));
 Pump pump1(
  medium=hx.mediumSource,
  volFlowRef=0.01) annotation(Placement(transformation(extent={{-95,60},{-85,70}})));
equation
  connect(fluidSourceCold2.fluidPort,hx.returnPortSource) annotation(Line(
   points={{-120,45},{-115,45},{-80,45},{-75,45}},
   color={0,0,255},
   thickness=1));
  connect(hx.supplyPortLoad,fluidSourceHot1.fluidPort) annotation(Line(
   points={{-55.3,55},{-50.3,55},{-30,55},{-30,60},{-25,60}},
   color={255,0,0},
   thickness=1));
  connect(fluidSourceCold1.fluidPort,hx.returnPortLoad) annotation(Line(
   points={{-25,40},{-30,40},{-50.3,40},{-50.3,45},{-55.3,45}},
   color={0,0,255},
   thickness=1));
  connect(fluidSourceHot2.fluidPort,pump1.flowPort_a) annotation(Line(
   points={{-120,65},{-115,65},{-100,65},{-95,65}},
   color={255,0,0},
   thickness=1));
  connect(hx.supplyPortSource,pump1.flowPort_b) annotation(Line(
   points={{-75,55},{-80,55},{-80.3,55},{-80.3,65},{-85.3,65}},
   color={255,0,0},
   thickness=1));
 annotation (
  __OpenModelica_simulationFlags(
   lv="LOG_STATS",
   outputFormat="mat",
   s="dassl"),
  __OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  Documentation(info= "<html><head></head><body><p><ul><li>The flow rate at source side is defined by the external pump.</li><li>The load side flow rate is defined to have the same heat capacity flow as the source flow.</li></ul></p><p><br></p>

</body></html>"),
  experiment(
   StopTime=31536000,
   StartTime=0,
   Tolerance=0.0001,
   Interval=3600));
end ExampleHeatExchanger;