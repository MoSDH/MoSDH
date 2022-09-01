within MoSDH.Components.Sources.Fossil;
model ExampleGasBoiler "Bas boiler unit example model"
 import MoSDH.Components.Sources.Solar.*;
 extends Modelica.Icons.Example;
 GasBoiler GBunit(mode=MoSDH.Utilities.Types.ControlTypes.RefPowerRefTemp) annotation(Placement(transformation(extent={{-20,-20},{20,20}})));
 Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot1(medium=GBunit.medium) annotation(Placement(transformation(extent={{50,0},{60,10}})));
 Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold1(
  medium=GBunit.medium,
  Tsource=303.15) annotation(Placement(transformation(extent={{50,-10},{60,0}})));
equation
  connect(GBunit.supplyPort,fluidSourceHot1.fluidPort) annotation(Line(
   points={{19.7,5},{24.7,5},{45,5},{50,5}},
   color={255,0,0},
   thickness=1));
  connect(GBunit.returnPort,fluidSourceCold1.fluidPort) annotation(Line(
   points={{19.7,-5},{24.7,-5},{45,-5},{50,-5}},
   color={0,0,255},
   thickness=1));
 annotation (
  __OpenModelica_simulationFlags(
   lv="LOG_STATS",
   outputFormat="mat",
   s="dassl"),
  __OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",

  Documentation(info= "<html><head></head><body><h3><a href=\"modelica://MoSDH.Components.Sources.Fossil.GasBoiler\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">GasBoiler</a> component example model:</h3><div><ul><li><font face=\"MS Shell Dlg 2\">Gas boiler supplies heat up to the power <b>Pthermal_max</b>.</font></li><li>The actual supply temperature is at least <b>deltaTmin</b> higher than the return temperature.</li><li>The fuel consumption is calculated in relation to the relative power Pthermal/Pthermal_max by the table data <b>fuelEfficiency</b>.</li><li>The gas boiler can be enabled/disabled by the control variable&nbsp;<b>on</b>.</li><li>The gas boilercan operate in three models (<b>mode</b>) between which he can change dynamically:</li><ul><li><b>RefPowerRefTemp</b>: Define reference thermal power&nbsp;<b>Pref</b>&nbsp;and supply temperature&nbsp;<b>Tref.</b></li><li><b>RefFlowRefTemp</b>: Define reference volume flow&nbsp;<b>volFlow</b>&nbsp;and reference supply temperature&nbsp;<b>Tref</b>.</li><li><b>RefFlowRefPower</b>: Define reference volume flow rate&nbsp;<b>volFlow</b>and reference power&nbsp;<b>Pref</b>.</li></ul></ul></div>

</body></html>"),
  experiment(
   StopTime= 3.1536e+07,
   StartTime=0,
   Tolerance=1e-06,
   Interval= 3600));
end ExampleGasBoiler;
