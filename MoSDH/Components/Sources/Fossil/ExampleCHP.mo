within MoSDH.Components.Sources.Fossil;
model ExampleCHP "Combined Heat and power unit example model"
 extends Modelica.Icons.Example;
 CHP chpUnit(
  Pthermal_max(displayUnit="kW"),
  deltaTmin(displayUnit="K"),
  enabledUnits=if time < 1800 * 8760 then 2 else 3) annotation(Placement(transformation(extent={{-20,-20},{20,20}})));
 Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot1(medium=chpUnit.medium) annotation(Placement(transformation(extent={{40,0},{50,10}})));
 Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold1(
  medium=chpUnit.medium,
  Tsource=303.15) annotation(Placement(transformation(extent={{40,-10},{50,0}})));
equation
  connect(fluidSourceHot1.fluidPort,chpUnit.supplyPort) annotation(Line(
   points={{40,5},{35,5},{24.7,5},{19.7,5}},
   color={255,0,0},
   thickness=1));
  connect(fluidSourceCold1.fluidPort,chpUnit.returnPort) annotation(Line(
   points={{40,-5},{35,-5},{24.7,-5},{19.7,-5}},
   color={0,0,255},
   thickness=1));
 annotation (
  __OpenModelica_simulationFlags(
   lv="LOG_STATS",
   outputFormat="mat",
   s="dassl"),
  __OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  Documentation(info= "<html><head></head><body><h4><a href=\"modelica://MoSDH.Components.Sources.Fossil.CHP\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">CHP</a> component example model: </h4><div><ul><li>CHP component consisting of 3 unit (<b>nUnits</b>) of identical thermal power 1,000 kW (<b>Pthermal_Max</b>).</li><li>The number of active units can be changed dynamically by the control variable&nbsp;<b>activeUnits&nbsp;</b>and is switched from 2 to 3 after half a year&nbsp;in the example.</li><li>The units can be modulated from 100% down to a minimum degree of modulation <b>MinimumModulation</b>.</li><li>Electricity production is calculated according to <b>power2HeatRatio</b> and fuel consumption according to <b>fuelEfficiency.</b></li><li>The chp module can be enabled/disabled by thecontrol &nbsp;variable&nbsp;<b>on</b>.</li><li>The units are controlled by setting the reference power (<b>Pref</b>) and reference supply temperature (<b>Tref</b>) for each unit.</li></ul>

</div></body></html>"),
  experiment(
   StopTime = 3.1536e+07,
   StartTime=0,
   Tolerance=1e-06,
   Interval= 3600));
end ExampleCHP;
