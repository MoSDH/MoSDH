within MoSDH.Components.Sources.Fossil;
model ExampleThermalPlant "Thermal power plant example model"
	import MoSDH.Examples.*;
	extends Modelica.Icons.Example;
	ThermalPowerPlant thermalPowerPlant(
		storageVolume=500,
		CHP_Pthermal_max=1000000,
		GB_Pthermal_max=10000000,
		mode=MoSDH.Utilities.Types.ControlTypes.RefFlowRefTemp,
		enabledUnits=thermalPowerPlant.CHP_units,
		volFlowRef(displayUnit="mÂ³/s")=load.volFlow) annotation(Placement(transformation(extent={{-70,30},{-30,70}})));
	Weather.WeatherData weatherData1 annotation(Placement(transformation(extent={{-20,-30},{20,10}})));
	Loads.HeatDemand load annotation(Placement(transformation(extent={{15,30},{55,70}})));
	Distribution.HydraulicShunt hydraulicShunt1(setAbsolutePressure=true) annotation(Placement(transformation(extent={{-15,40},{5,60}})));
	equation
		connect(weatherData1.weatherPort,thermalPowerPlant.weather) annotation(Line(
		 points={{0,10},{0,15},{0,25.3},{-50,25.3},{-50,30.3}},
		 color={0,176,80}));
		connect(weatherData1.weatherPort,load.weatherPort) annotation(Line(
		 points={{0,10},{0,15},{0,25.3},{35,25.3},{35,30.33}},
		 color={0,176,80}));
		connect(thermalPowerPlant.supplyPort,hydraulicShunt1.sourceSupply) annotation(Line(
		 points={{-30.3,55},{-25.3,55},{-20,55},{-15,55}},
		 color={255,0,0},
		 thickness=1));
		connect(thermalPowerPlant.returnPort,hydraulicShunt1.sourceReturn) annotation(Line(
		 points={{-30.3,45},{-25.3,45},{-20,45},{-15,45}},
		 color={0,0,255},
		 thickness=1));
		connect(hydraulicShunt1.loadSupply,load.supplyPort) annotation(Line(
		 points={{5,55},{10,55},{15,55}},
		 color={255,0,0},
		 thickness=1));
		connect(hydraulicShunt1.loadReturn,load.returnPort) annotation(Line(
		 points={{4.67,45},{4.67,45},{10,45},{15,45}},
		 color={0,0,255},
		 thickness=1));
	annotation(
		__OpenModelica_simulationFlags(
			lv="LOG_STATS",
			outputFormat="mat",
			s="dassl"),
		__OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
		Documentation(info= "<html><head></head><body><h3><font face=\"MS Shell Dlg 2\">Example model for the <a href=\"modelica://MoSDH.Components.Sources.Fossil.ThermalPowerPlant\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">ThermalPowerPlant</a> model:</font></h3><h4><ul><li><font face=\"MS Shell Dlg 2\" style=\"font-weight: normal;\">A <a href=\"modelica://MoSDH.Components.Loads.HeatDemand\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">Heat Demand</a> is supplied by a thermal power plant, consisting of a <a href=\"modelica://MoSDH.Components.Sources.Fossil.CHP\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">CHP</a>, a <a href=\"modelica://MoSDH.Components.Storage.StratifiedTank.TTES\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">buffer storage</a> and a <a href=\"modelica://MoSDH.Components.Sources.Fossil.GasBoiler\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">gas boiler</a>.</font></li><li><font face=\"MS Shell Dlg 2\"><span style=\"font-weight: normal;\">Since both components define a volume flow rate, a <a href=\"modelica://MoSDH.Components.Distribution.HydraulicShunt\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">hydraulic shunt</a> is used for decoupling, to avoid an overdetermined hydraulic circuit.</span></font></li><li><font face=\"MS Shell Dlg 2\" style=\"font-weight: normal;\">The plant is controlled in mode&nbsp;</font><font face=\"MS Shell Dlg 2\">RefFlowRefTemp<span style=\"font-weight: normal;\">, for which the supply point setpoint </span>Tref<span style=\"font-weight: normal;\"> and the volume flow rate </span>volFlowRef<span style=\"font-weight: normal;\"> have to be defined in the control tab.</span></font></li><li><font face=\"MS Shell Dlg 2\" style=\"font-weight: normal;\">The thermal power plant meets the demand, by setting the volume flow rate&nbsp;</font><font face=\"MS Shell Dlg 2\">volFlowRef</font><font face=\"MS Shell Dlg 2\" style=\"font-weight: normal;\">&nbsp;equal to the flow rate of the load component.</font></li><li><span style=\"font-weight: normal;\">A&nbsp;</span><a href=\"modelica:///MoSDH.Components.Weather.WeatherData\" style=\"font-size: 12px; font-weight: normal; font-family: 'MS Shell Dlg 2';\">WeatherData</a><span style=\"font-weight: normal;\">&nbsp;component is required for input of ambient temperature (buffer storage losses) and the time of the year (read load data).</span></li></ul></h4>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>Thermal power/demand of the components.</caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/ThermalPowerPlantExample.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>

</body></html>"),
		experiment(
			StopTime = 3.1536e+07,
			StartTime=0,
			Tolerance=1e-06,
			Interval=3600));
end ExampleThermalPlant;
