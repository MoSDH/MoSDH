within MoSDH.Components.Sources.WasteHeat;
model ExampleWasteHeatSource "Waste heat source example model"
 extends Modelica.Icons.Example;
 WasteHeatSource wasteHeat(deltaTmin(displayUnit="K")) annotation(Placement(transformation(extent={{-20,-20},{20,20}})));
 Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot1(medium=wasteHeat.medium) annotation(Placement(transformation(extent={{30,0},{40,10}})));
 Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold1(
  medium=wasteHeat.medium,
  Tsource=303.15) annotation(Placement(transformation(extent={{30,-10},{40,0}})));
equation
  connect(fluidSourceCold1.fluidPort,wasteHeat.returnPort) annotation(Line(
   points={{30,-5},{25,-5},{24.7,-5},{19.7,-5}},
   color={0,0,255},
   thickness=1));
  connect(fluidSourceHot1.fluidPort,wasteHeat.supplyPort) annotation(Line(
   points={{30,5},{25,5},{24.7,5},{19.7,5}},
   color={255,0,0},
   thickness=1));
 annotation (
  __OpenModelica_simulationFlags(
   lv="LOG_STATS",
   outputFormat="mat",
   s="dassl"),
  __OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  Documentation(info= "<html><head></head><body><h3><font face=\"MS Shell Dlg 2\">Example model for the waste heat unit:</font></h3><h4><font face=\"MS Shell Dlg 2\">Waste heat component (Sources.WasteHeat.WasteHeatSource):</font></h4><div><ul><li><font face=\"MS Shell Dlg 2\">Waste heat unit supplies heat up to the power&nbsp;<b>Pthermal_max</b>.</font></li><li>The actual supply temperature is at least&nbsp;<b>deltaTmin</b>higher than the return temperature.</li><li>The resource input Pfuell is calculated by&nbsp;<b>efficiency</b>.</li><li>The waste heat unit can be enabled/disabled by the control variable&nbsp;<b>on</b>.</li><li>The waste heat unit can operate in three modes (<b>mode</b>) between which it can change dynamically:</li><ul><li><b>RefPowerRefTemp</b>: Define reference thermal power&nbsp;<b>Pref</b>&nbsp;and supply temperature&nbsp;<b>Tref.</b></li><li><b>RefFlowRefTemp</b>: Define reference volume flow&nbsp;<b>volFlow</b>&nbsp;and reference supply temperature&nbsp;<b>Tref</b>.</li><li><b>RefFlowRefPower</b>: Define reference volume flow rate&nbsp;<b>volFlow</b>&nbsp;and reference power&nbsp;<b>Pref</b>.</li></ul></ul></div>

</body></html>"),
  experiment(
   StopTime=31536000,
   StartTime=0,
   Tolerance=1e-06,
   Interval=60));
end ExampleWasteHeatSource;