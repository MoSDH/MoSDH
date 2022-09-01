within MoSDH.Components.Storage.StratifiedTank;
model TTES "Stratified buffer storage model"
	MoSDH.Utilities.Interfaces.SupplyPort loadOut(medium=medium) "Load side flow" annotation(Placement(
		transformation(extent={{30,10},{50,30}}),
		iconTransformation(extent={{136.7,240},{156.7,260}})));
	MoSDH.Utilities.Interfaces.SupplyPort sourceIn(medium=medium) "Source side flow" annotation(Placement(
		transformation(extent={{-50,10},{-30,30}}),
		iconTransformation(extent={{-160,240},{-140,260}})));
	MoSDH.Utilities.Interfaces.ReturnPort loadIn(medium=medium) "Load side return" annotation(Placement(
		transformation(extent={{30,-30},{50,-10}}),
		iconTransformation(
			origin={146.7,-250},
			extent={{-10,-10},{10,10}},
			rotation=180)));
	MoSDH.Utilities.Interfaces.ReturnPort sourceOut(medium=medium) "Source side return" annotation(Placement(
		transformation(extent={{-50,-30},{-30,-10}}),
		iconTransformation(extent={{-160,-260},{-140,-240}})));
	MoSDH.Utilities.Interfaces.Weather weatherPort "Weather data connector" annotation(Placement(
		transformation(extent={{-10,-90},{10,-70}}),
		iconTransformation(extent={{-10,-306.7},{10,-286.7}})));
	Modelica.Units.SI.Power PthermalLoad(displayUnit="kW") "Load side thermal power";
	Modelica.Units.SI.Energy QthermalLoad(
		start=0,
		fixed=true) "Load side thermal energy extraction";
	Modelica.Units.SI.VolumeFlowRate volFlowLoad "Load side volume flow rate";
	Modelica.Units.SI.Power PthermalSource(displayUnit="kW") "Source side thermal power";
	Modelica.Units.SI.Energy QthermalSource(
		start=0,
		fixed=true) "Source side thermal energy injection";
	Modelica.Units.SI.VolumeFlowRate volFlowSource "Source side volume flow rate";
	parameter Modelica.Units.SI.Volume storageVolume(min=0.1)=100 "Volume of the storage" annotation(Dialog(
		group="Dimensions",
		tab="Storage"));
	parameter Modelica.Units.SI.Length storageHeight(min=0.5)=10 "Height of the storage" annotation(Dialog(
		group="Dimensions",
		tab="Storage"));
	replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby Modelica.Thermal.FluidHeatFlow.Media.Medium "Storage medium" annotation(
		choicesAllMatching=true,
		Dialog(
			group="Storage volume",
			tab="Storage"));
	parameter Modelica.Units.SI.CubicExpansionCoefficient beta=350 * 10 ^ (-6) "Thermal expansion coefficient of medium to model buoyancy" annotation(Dialog(
		group="Storage volume",
		tab="Storage"));
	parameter BaseClasses.BuoyancyModels buoyancyMode=BaseClasses.BuoyancyModels.aixLib "Mode of buoyancy calculation" annotation(Dialog(
		group="Storage volume",
		tab="Storage"));
	parameter Modelica.Units.SI.Time tau=1 "Time constant for buoyancy calculation after Modelica buildings library" annotation(Dialog(
		group="Medium",
		tab="Storage",
		enable=Integer(buoyancyMode)==2));
	parameter Integer nLayers(
		min=3,
		max=100)=10 "Total number of volume elements" annotation(Dialog(
		group="Storage volume",
		tab="Storage"));
	parameter Modelica.Units.SI.Temperature Tinitial[nLayers]=linspace(303.15, 363.15, nLayers) "Inital Temperature of the volume elements" annotation(Dialog(
		group="Initial and boundary conditions",
		tab="Modeling"));
	Modelica.Units.SI.Temperature Tlayers[nLayers] "Temperature of each volume element of the storage";
	parameter Modelica.Units.SI.Length tInsulationLid=0.1 "Lid insulation thickness" annotation(Dialog(
		group="Insulation",
		tab="Storage"));
	parameter Modelica.Units.SI.Length tInsulationWall=0.1 "Pit wall insulation thickness" annotation(Dialog(
		group="Insulation",
		tab="Storage"));
	parameter Modelica.Units.SI.Length tInsulationBottom=0.1 "Pit bottom insulation thickness" annotation(Dialog(
		group="Insulation",
		tab="Storage"));
	parameter Modelica.Units.SI.ThermalConductivity lamdaInsulationLid=0.03 "Thermal conductivity of the lid" annotation(Dialog(
		group="Insulation",
		tab="Storage"));
	parameter Modelica.Units.SI.ThermalConductivity lamdaInsulationWall=0.03 "Thermal conductivity of the pit wall insulation" annotation(Dialog(
		group="Insulation",
		tab="Storage"));
	parameter Modelica.Units.SI.ThermalConductivity lamdaInsulationBottom=0.03 "Thermal conductivity of the bottom insulation" annotation(Dialog(
		group="Insulation",
		tab="Storage"));
	parameter Boolean setAbsolutePressure=true "Absolute pressure at the storage top" annotation(Dialog(
		group="Initial and boundary conditions",
		tab="Modeling"));
	parameter Modelica.Units.SI.Pressure absolutePressure=100000 "Absolute pressure at the storage top" annotation(Dialog(
		group="Initial and boundary conditions",
		tab="Modeling",
		enable=setAbsolutePressure));
	Modelica.Units.SI.Temperature Tmax "Maximum temperature of the volume elements";
	Modelica.Units.SI.Temperature Tmin "Minimum temperature of the volume elements";
	Modelica.Units.SI.Temperature Taverage "Average temperature of the volume elements";
	Modelica.Units.SI.Power PthermalLoss "Heat flow rate from storage to surroundings";
	Modelica.Units.SI.Energy QthermalLoss(
		start=0,
		fixed=true) "Heat flow rate from storage to surroundings";
	replaceable parameter Parameters.Locations.SingleLayerLocation location constrainedby MoSDH.Parameters.Locations.LocationPartial "Local geology" annotation(
		choicesAllMatching=true,
		Dialog(
			group="Initial and boundary conditions",
			tab="Modeling"));
	parameter Boolean usePortTemperature=true "=true, if weather port temperature is used for loss calculation." annotation(Dialog(
		group="Initial and boundary conditions",
		tab="Modeling"));
	Modelica.Units.SI.Temperature Tambient(displayUnit="degC")=293.15 annotation(Dialog(
		group="Initial and boundary conditions",
		tab="Modeling",
		enable=not usePortTemperature));
	Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector1(m=nLayers + 1) annotation(Placement(transformation(
		origin={60,0},
		extent={{-10,-10},{10,10}},
		rotation=90)));
	Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature BC_Twall "To prescribe ground temperature" annotation(Placement(transformation(
		origin={85,0},
		extent={{10,-10},{-10,10}})));
	BaseClasses.StratifiedStorageVolume stratifiedVolumeElements(
		medium=medium,
		beta=beta,
		buoyancyMode=buoyancyMode,
		tau=tau,
		elementHeights=fill(storageHeight / nLayers, nLayers),
		elementVolumes=fill(storageVolume / nLayers, nLayers),
		nLayers=nLayers,
		Tinitial=Tinitial,
		tInsulationWall=tInsulationWall,
		tInsulationLid=tInsulationLid,
		tInsulationBottom=tInsulationBottom,
		lamdaInsulationWall=lamdaInsulationWall,
		lamdaInsulationBottom=lamdaInsulationBottom,
		lamdaInsulationLid=lamdaInsulationLid,
		setAbsolutePressure=setAbsolutePressure,
		absolutePressure=absolutePressure) annotation(Placement(transformation(extent={{-10,-15},{10,25}})));
	Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResistor1(R=1 / (location.strat1.lamda * 4 * sqrt(storageVolume / (Modelica.Constants.pi * storageHeight)))) "Thermal resistance of a disc on a half-infinite medium" annotation(Placement(transformation(
		origin={0,-35},
		extent={{-10,-10},{10,10}},
		rotation=-90)));
	Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TgroundAverage(T=location.Taverage) annotation(Placement(transformation(
		origin={0,-60},
		extent={{-10,-10},{10,10}},
		rotation=90)));
	equation
//------------------------------- ELEMENT CONNECTIONS --------------------------------
// envelope
// mass balance
		  PthermalLoad = -(loadOut.H_flow + loadIn.H_flow);
		  PthermalSource = sourceOut.H_flow + sourceIn.H_flow;
		  volFlowSource = sourceIn.m_flow / medium.rho;
		  volFlowLoad = loadIn.m_flow / medium.rho;
		  der(QthermalLoad) = PthermalLoad;
		  der(QthermalSource) = PthermalSource;
		  BC_Twall.T = if usePortTemperature then weatherPort.Tambient else Tambient;
		  Tlayers = stratifiedVolumeElements.Tlayers;
		  Tmax = stratifiedVolumeElements.Tmax;
		  Tmin = stratifiedVolumeElements.Tmin;
		  Taverage = stratifiedVolumeElements.Taverage;
		  PthermalLoss = stratifiedVolumeElements.PlossBottom + stratifiedVolumeElements.PlossTop + stratifiedVolumeElements.PlossShell + stratifiedVolumeElements.PlossBottom;
		  der(QthermalLoss) = PthermalLoss;
		  connect(BC_Twall.port, thermalCollector1.port_b) annotation (
		    Line(points = {{75, 0}, {70, 0}, {75, 0}, {70, 0}}, color = {191, 0, 0}, thickness = 0.0625));
		  connect(sourceIn, stratifiedVolumeElements.sourcePorts[nLayers]) annotation (
		    Line(points = {{-40, 20}, {-35, 20}, {-15, 20}, {-15, 5}, {-10, 5}}, color = {255, 0, 0}, thickness = 1));
		  connect(sourceOut, stratifiedVolumeElements.sourcePorts[1]) annotation (
		    Line(points = {{-40, -20}, {-35, -20}, {-15, -20}, {-15, 4.1}, {-10, 4.1}}, color = {0, 0, 255}, thickness = 1));
		  connect(loadOut, stratifiedVolumeElements.loadPorts[nLayers]) annotation (
		    Line(points = {{40, 20}, {35, 20}, {14.7, 20}, {14.7, 5}, {9.67, 5}}, color = {255, 0, 0}, thickness = 1));
		  connect(loadIn, stratifiedVolumeElements.loadPorts[1]) annotation (
		    Line(points = {{40, -20}, {35, -20}, {14.7, -20}, {14.7, 4.1}, {9.67, 4.1}}, color = {0, 0, 255}, thickness = 1));
		  connect(stratifiedVolumeElements.wallHeatPort[:], thermalCollector1.port_a[1:nLayers]) annotation (
		    Line(points = {{9.67, -5}, {9.67, -5}, {45, -5}, {45, 0}, {50, 0}}, color = {191, 0, 0}, thickness = 0.0625));
		  connect(thermalResistor1.port_a, stratifiedVolumeElements.bottomHeatPort) annotation (
		    Line(points = {{0, -25}, {0, -20}, {0, -14.67}, {0, -14.67}}, color = {191, 0, 0}, thickness = 0.0625));
		  connect(TgroundAverage.port, thermalResistor1.port_b) annotation (
		    Line(points = {{0, -50}, {0, -45}, {0, -50}, {0, -45}}, color = {191, 0, 0}, thickness = 0.0625));
		  connect(stratifiedVolumeElements.lidHeatPort, thermalCollector1.port_a[nLayers + 1]) annotation (
		    Line(points = {{-5, 25}, {-5, 30}, {20, 30}, {20, 0}, {45, 0}, {50, 0}}, color = {191, 0, 0}, thickness = 0.0625));
	annotation(
		defaultComponentName="buffer",
		Icon(
			coordinateSystem(extent={{-150,-300},{150,300}}),
			graphics={
							Bitmap(
								imageSource="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
c57K+eoP6vz1azmf2QwqcgOSDznaDupcMvwb2wH+29t/zruJ7DnJgZ9d4N2JAeBR5fyS80zON3+Y
80/OQ9t//njOS3WKEpHbmm984xu/UOunn9xkmjM32/nSdrLItfAuIwaO82adJ75U540sD38y55Oc
V+oUIyJytmwnlJ/fTi6/tPn1miLNVGk+Qjprs7m0zSwK3Dw5rnN8P1HH+9ESSc4DOR9s/92GTxG5
+uQyt2eeeeYXn3zyyU9sJ6bMpOSmPrnvST7gL+u7uX3985vuRAdcnhyHOR5zXD6W43STO35+Msdv
jmOXrYrIjUymZrd3Uh/b/PImn6/zW9u/uRdKbmn/le3frBlrVmBerhZ5uo6fx3M8bX5786lNjrOP
2XMhIrKQO3fu/Nz2ruyjWVOuE2kalt/c/M72ri1rzvno65x0czvlTBfbs8J1NpY9/q5e1/k8krzO
83r/TF7/OQ62//7xHBc5PupQERGRQ0hOzrmUL1PK24k7e1fSuPzOJrdhzrJQ3iV+pU7yuaFRTvru
RMt5yOsor6ejGYl6jT2+yXJHbpr1O/V6PFryqNfpR93bQkREjhqY2AaKj2WQ2P49mn2pgSM7/Xeb
mcitn3dnYqIbnDhM4282Zh5y2ej42+bvnL93lgqPXgObX87rYmsofmm8VuqlIyIiclgZA9WwDWiZ
Rv/EsA1muU/LGOB2G50j2/9/tOS044vb1x29wz7O9jXZTzMG11lnvbtuvq+rd5KfzhIcZ/uafBzB
T3/veh5++rxsdhuDT+V53H1et///aLliV/1JROTC88/+2f8HAymvdpvOuJsAAAAASUVORK5CYII=",
								extent={{-157.3,-319},{156.1,314.3}})}),
		Documentation(info= "<html><head></head><body><h4>Model of a stratified water tank</h4><p></p><ul><li>Model of a tank thermal energy storage (TTES) divided into <b>nLayers</b> with two ports at the top and two at the bottom.&nbsp;</li><li>For a detailed model description see <a href=\"modelica://MoSDH.UsersGuide.References\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">[Formhals2022]</a>&nbsp;</li><li>The storage is open at the top and consequently balance of mass is not automatically guaranteed. By default ports on source and load side are not coupled (<b>coupleSourceFlows</b> and <b>coupleLoadFlows</b>). The bufer model can be used to define the absolute pressure level of the connected hydraulic network (<b>setAbsolutePressure</b> &amp; <b>absolutePressure</b>).</li><li>Layers are connected by a fluid port for the exchange of the storage media and thermal ports for heat conduction. Furthermore, they exchange heat with the surrounding through the TTES hull. The insulation can be set individually for the wall (<b>tInsulationWall</b>&nbsp; &amp; <b>lamdaInsulationWall</b>), top&nbsp;(<b>tInsulationLid</b>&nbsp;&nbsp;&amp;&nbsp;<b>lamdaInsulationLid</b>)&nbsp;and bottom&nbsp;(<b>tInsulationBottom</b>&nbsp;&nbsp;&amp;&nbsp;<b>lamdaInsulationBottom</b>). Heat exchange trhough wall and top is calculated using either the ambient temperature of the ambient port (<b>usePortTemperature</b>=true) or a defined temperature <b>Tambient</b>. The bottom is represented by a steady state reistance to an hald infinite medium of temperature <b>location.Taverage</b>.&nbsp;</li></ul><p></p><ul>
</ul>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>Model structure</caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/TTES.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>
<p></p><ul><li>In the case of thermal inversion, additional heat is transfered from the bottom element to the top element according to the chosen <b>buoyancyMode</b>.&nbsp;</li></ul><p></p>

</body></html>"),
		experiment(
			StopTime=1,
			StartTime=0,
			Tolerance=1e-06,
			Interval=0.001));
end TTES;
