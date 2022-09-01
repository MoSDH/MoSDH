within MoSDH.Components.Sources.Electric;
model ExampleElectricHeatSource "Electric heat source example model"
 extends Modelica.Icons.Example;
 ElectricHeatingRod EHunit(redeclare parameter Modelica.Thermal.FluidHeatFlow.Media.Water_10degC medium) annotation(Placement(transformation(extent={{-20,-20},{20,20}})));
 Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot1(medium=EHunit.medium) annotation(Placement(transformation(extent={{40,0},{50,10}})));
 Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold1(medium=EHunit.medium) annotation(Placement(transformation(extent={{40,-10},{50,0}})));
equation
  connect(fluidSourceHot1.fluidPort,EHunit.supplyPort) annotation(Line(
   points={{40,5},{35,5},{24.7,5},{19.7,5}},
   color={255,0,0},
   thickness=1));
  connect(fluidSourceCold1.fluidPort,EHunit.returnPort) annotation(Line(
   points={{40,-5},{35,-5},{24.7,-5},{19.7,-5}},
   color={0,0,255},
   thickness=1));
 annotation (
  __OpenModelica_simulationFlags(
   lv="LOG_STATS",
   outputFormat="mat",
   s="dassl"),
  __OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  Documentation(info= "<html><head></head><body><h3><font face=\"MS Shell Dlg 2\">Example model for the electric heating rod:</font></h3><h4><font face=\"MS Shell Dlg 2\">Electric heating rod component (Sources.Electric.ElectricHeatingRod):</font></h4><div><ul><li><font face=\"MS Shell Dlg 2\"><span style=\"font-size: 12px;\">Electric heating rod</span>&nbsp;supplies heat up to the power&nbsp;<b>PelMax*efficiency</b>.</font></li><li>The actual supply temperature is at least&nbsp;<b>deltaTmin</b>&nbsp;higher than the return temperature.</li><li>The electricity consumption is calculated by the parameter <b>efficiency</b>.</li><li>The electric heating rod can be enabled/disabled by the control variable&nbsp;<b>on</b>.</li><li>The&nbsp;electric heating rod&nbsp;can operate in three modes (<b>mode</b>) between which he can change dynamically:</li><ul><li><b>RefPowerRefTemp</b>: Define reference thermal power&nbsp;<b>Pref</b>&nbsp;and supply temperature&nbsp;<b>Tref.</b></li><li><b>RefFlowRefTemp</b>: Define reference volume flow&nbsp;<b>volFlow</b>&nbsp;and reference supply temperature&nbsp;<b>Tref</b>.</li><li><b>RefFlowRefPower</b>: Define reference volume flow rate&nbsp;<b>volFlow</b>&nbsp;and reference power&nbsp;<b>Pref</b>.</li></ul></ul></div>

</body></html>"),
  experiment(
   StopTime=31536000,
   StartTime=0,
   Tolerance=1e-06,
   Interval=60));
end ExampleElectricHeatSource;