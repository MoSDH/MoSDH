within MoSDH.Components.Sources.Electric;
model HeatPump "Compression heat pump"
	MoSDH.Utilities.Interfaces.SupplyPort supplyPortLoad(medium=mediumLoad) "Load side supply port" annotation(Placement(
		transformation(extent={{145,55},{165,75}}),
		iconTransformation(extent={{186.7,40},{206.7,60}})));
	MoSDH.Utilities.Interfaces.ReturnPort returnPortLoad(medium=mediumLoad) "Load side return port" annotation(Placement(
		transformation(extent={{145,-15},{165,5}}),
		iconTransformation(extent={{186.7,-60},{206.7,-40}})));
	MoSDH.Utilities.Interfaces.ReturnPort returnPortSource(medium=mediumSource) "Source side return port" annotation(Placement(
		transformation(extent={{-125,-15},{-105,5}}),
		iconTransformation(extent={{-210,-60},{-190,-40}})));
	MoSDH.Utilities.Interfaces.SupplyPort supplyPortSource(medium=mediumSource) "Source side supply port" annotation(Placement(
		transformation(extent={{-125,55},{-105,75}}),
		iconTransformation(extent={{-210,40},{-190,60}})));
	Modelica.Thermal.FluidHeatFlow.Components.Pipe sourcePipe(
		medium=mediumSource,
		m=V_flowNominalSource * mediumSource.rho * tau,
		T0=TinitialSource,
		T0fixed=true,
		V_flowLaminar=V_flowLaminarSource,
		dpLaminar=dpLaminarSource,
		V_flowNominal=V_flowNominalSource,
		dpNominal=dpNominalSource,
		useHeatPort=true,
		h_g=0) annotation(Placement(transformation(
		origin={-45,30},
		extent={{10,-10},{-10,10}},
		rotation=90)));
	Distribution.Pump sourcePump(
		medium=mediumSource,
		volFlowRef=volFlowSourceSet) annotation(Placement(transformation(extent={{-70,55},{-50,75}})));
	Modelica.Thermal.FluidHeatFlow.Components.Pipe loadPipe(
		medium=mediumLoad,
		m=V_flowNominalLoad * mediumLoad.rho * tau,
		T0=TinitialLoad,
		T0fixed=true,
		V_flowLaminar=V_flowLaminarLoad,
		dpLaminar=dpLaminarLoad,
		V_flowNominal=V_flowNominalLoad,
		dpNominal=dpNominalLoad,
		useHeatPort=true,
		h_g=0) annotation(Placement(transformation(
		origin={15,30},
		extent={{-10,10},{10,-10}},
		rotation=90)));
	Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaTsupply[2] annotation(Placement(transformation(
		origin={-10,0},
		extent={{-10,10},{10,-10}},
		rotation=90)));
	Distribution.Pump loadPump(
		medium=mediumLoad,
		volFlowRef=volFlowLoadSet) annotation(Placement(transformation(extent={{50,55},{70,75}})));
	Modelica.Thermal.FluidHeatFlow.Sources.AbsolutePressure absolutePressureSource(
		medium=mediumSource,
		p=pSource) if setAbsoluteSourcePressure annotation(Placement(transformation(extent={{-60,-15},{-80,5}})));
	Modelica.Thermal.FluidHeatFlow.Sources.AbsolutePressure absolutePressureLoad(
		medium=mediumLoad,
		p=pLoad) if setAbsoluteLoadPressure annotation(Placement(transformation(extent={{35,10},{55,30}})));
	Distribution.ReturnFlowMixing rfm(
		V_flowNom=V_flowNominalSource,
		tau=tau,
		TinitialSupply=TinitialSource,
		TinitialReturn=TinitialSource,
		medium=mediumSource,
		Tref=if enableReturnFlowMixing then TmaxSource else 1000) annotation(Placement(transformation(extent={{-105,25},{-85,45}})));
	Modelica.Blocks.Tables.CombiTable2Ds COPdata(
		tableOnFile=true,
		tableName=COPtableName,
		fileName=HPdataFile,
		verboseRead=false);
	Modelica.Blocks.Tables.CombiTable2Ds PowerData(
		tableOnFile=true,
		tableName=PowerTableName,
		fileName=HPdataFile,
		verboseRead=false);
	Boolean compressorON "Compressor is turned on";
	Modelica.Units.SI.Temperature TsupplyLoad(displayUnit="degC") "Load side supply temperature";
	Modelica.Units.SI.Temperature TreturnLoad(displayUnit="degC") "Load side return temperature";
	Modelica.Units.SI.VolumeFlowRate volFlowLoad "Load side volume flow";
	Modelica.Units.SI.Power PthermalLoad(displayUnit="kW") "Load side thermal power";
	Modelica.Units.SI.Energy QthermalLoad(
		start=0,
		fixed=true) "Load side thermal energy budget";
	Modelica.Units.SI.Temperature TsupplySource(displayUnit="degC") "Source side supply temperature";
	Modelica.Units.SI.Temperature TreturnSource(displayUnit="degC") "Source side return temperature";
	Modelica.Units.SI.VolumeFlowRate volFlowSource "Source side volume flow";
	Modelica.Units.SI.Power PthermalSource(displayUnit="kW") "Source side thermal power";
	Modelica.Units.SI.Energy QthermalSource(
		start=0,
		fixed=true) "Source side thermal energy budget";
	Modelica.Units.SI.Pressure dpSource "Source side pressure drop (flow->return)";
	Modelica.Units.SI.Pressure dpLoad "Load side pressure drop (return->flow)";
	Modelica.Units.SI.Temperature TsupplyEvaporator "Evaporator supply temperature after mixing";
	Real COP "Coefficient of performance";
	Real SPF "Seasonal performance factor";
	Modelica.Units.SI.Power Pelectric "Electric compressor power";
	Modelica.Units.SI.Energy Eelectric(
		start=0,
		fixed=true) "Compressor energy demand";
	parameter Modelica.Units.SI.Time tau=120 "Time constant for dynamic behaviour" annotation(Dialog(
		group="Dynamics",
		tab="Design"));
	replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water mediumSource constrainedby Modelica.Thermal.FluidHeatFlow.Media.Medium "Source side heat carrier fluid" annotation(
		choicesAllMatching=true,
		Dialog(
			group="General",
			tab="Design"));
	parameter Modelica.Units.SI.VolumeFlowRate V_flowLaminarSource=V_flowNominalSource * 0.01 "Laminar volume flow" annotation(Dialog(
		group="Source side",
		tab="Design"));
	parameter Modelica.Units.SI.Pressure dpLaminarSource=dpNominalSource * 0.001 "Laminar pressure drop" annotation(Dialog(
		group="Source side",
		tab="Design"));
	parameter Modelica.Units.SI.VolumeFlowRate V_flowNominalSource=0.01 "Nominal volume flow" annotation(Dialog(
		group="Source side",
		tab="Design"));
	parameter Modelica.Units.SI.Pressure dpNominalSource=1000 "Nominal pressure drop" annotation(Dialog(
		group="Source side",
		tab="Design"));
	parameter Boolean setAbsoluteSourcePressure=false "Define absolute pressure at source flow port" annotation(Dialog(
		group="Source side",
		tab="Design"));
	parameter Modelica.Units.SI.AbsolutePressure pSource=100000 "Absolute pressure at source flow port" annotation(Dialog(
		group="Source side",
		tab="Design",
		enable=setAbsoluteSourcePressure));
	replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water mediumLoad constrainedby Modelica.Thermal.FluidHeatFlow.Media.Medium "Load side heat carrier fluid" annotation(
		choicesAllMatching=true,
		Dialog(
			group="General",
			tab="Design"));
	parameter Modelica.Units.SI.VolumeFlowRate V_flowLaminarLoad=V_flowNominalLoad * 0.01 "Laminar volume flow" annotation(Dialog(
		group="Load side",
		tab="Design"));
	parameter Modelica.Units.SI.Pressure dpLaminarLoad=dpNominalLoad * 0.001 "Laminar pressure drop" annotation(Dialog(
		group="Load side",
		tab="Design"));
	parameter Modelica.Units.SI.VolumeFlowRate V_flowNominalLoad=0.01 "Nominal volume flow" annotation(Dialog(
		group="Load side",
		tab="Design"));
	parameter Modelica.Units.SI.Pressure dpNominalLoad=1000 "Nominal pressure drop" annotation(Dialog(
		group="Load side",
		tab="Design"));
	parameter Boolean setAbsoluteLoadPressure=true "Define absolute pressure at load flow port" annotation(Dialog(
		group="Load side",
		tab="Design"));
	parameter Modelica.Units.SI.AbsolutePressure pLoad=100000 "Absolute pressure at load flow port" annotation(Dialog(
		group="Load side",
		tab="Design",
		enable=setAbsoluteLoadPressure));
	parameter Modelica.Units.SI.Temperature TinitialSource(displayUnit="degC")=(TmaxSource + TminSource) / 2 "Load side return temperature" annotation(Dialog(
		group="Operational range",
		tab="Performance"));
	parameter Modelica.Units.SI.Temperature TinitialLoad(displayUnit="degC")=(TmaxLoad + TminLoad) / 2 "Load side return temperature" annotation(Dialog(
		group="Operational range",
		tab="Performance"));
	parameter Modelica.Units.SI.Temperature TmaxSource(displayUnit="degC")=323.15 "Maximum source supply temperature" annotation(Dialog(
		group="Operational range",
		tab="Performance"));
	parameter Modelica.Units.SI.Temperature TminSource(displayUnit="degC")=273.15 "Minimum source supply temperature" annotation(Dialog(
		group="Operational range",
		tab="Performance"));
	parameter Modelica.Units.SI.Temperature TmaxLoad(displayUnit="degC")=353.15 "Maximum load supply temperature" annotation(Dialog(
		group="Operational range",
		tab="Performance"));
	parameter Modelica.Units.SI.Temperature TminLoad(displayUnit="degC")=333.15 "Minimum load supply temperature" annotation(Dialog(
		group="Operational range",
		tab="Performance"));
	parameter Modelica.Units.SI.Temperature MiminumShift(displayUnit="K",min=5,max=TmaxLoad-TminSource)=20 "Minimum shift from source to load" annotation(Dialog(
		group="Operational range",
		tab="Performance"));
	parameter Boolean enableReturnFlowMixing=true "=true, to lower source supply temperature by mixing with source return flow" annotation(Dialog(
		group="Operational range",
		tab="Performance"));
	parameter String HPdataFile=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatPump/Viessmann_Vitocal_350AHT147.txt") "HP data file" annotation(Dialog(
		group="Efficiency",
		tab="Performance",
		loadSelector(
			filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
			caption="Open file in which table is present")));
	parameter String COPtableName="COP" "COP table name" annotation(Dialog(
		group="Efficiency",
		tab="Performance",
		loadSelector(
			filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
			caption="Open file in which table is present")));
	parameter String PowerTableName="Pthermal" "IAM table name" annotation(Dialog(
		group="Efficiency",
		tab="Performance",
		loadSelector(
			filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
			caption="Open file in which table is present")));
	parameter Boolean constrainPower=false "=true, if HP cpacity is constrained by the PowerTable." annotation(Dialog(
		group="Efficiency",
		tab="Performance",
		loadSelector(
			filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
			caption="Open file in which table is present")));
	parameter Real powerScaling=1 "Maximum power is scaling factor" annotation(Dialog(
		group="Efficiency",
		tab="Performance",
		enable=constrainPower,
		loadSelector(
			filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
			caption="Open file in which table is present")));
	MoSDH.Utilities.Types.ControlTypesHeatPump mode=MoSDH.Utilities.Types.ControlTypesHeatPump.SourceFlowRate "Definition of controlled inputs" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	Boolean on=true "=true, if component is enabled" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	Modelica.Units.SI.Power Pref=10000000 "Reference thermal power" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	Modelica.Units.SI.Temperature Tref=343.15 "Reference supply temperature" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	Modelica.Units.SI.VolumeFlowRate volFlowRef=0.01 "Reference volume flow rate" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	Modelica.Units.SI.TemperatureDifference DeltaTref=5 "Reference temperature differnece" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	protected
		Modelica.Units.SI.TemperatureDifference deltaTload;
		Modelica.Units.SI.Temperature TsupplyLoadTarget;
		Modelica.Units.SI.Power Pcondenser;
		Modelica.Units.SI.VolumeFlowRate volFlowSourceSet;
		Modelica.Units.SI.VolumeFlowRate volFlowLoadSet;
	initial algorithm
		compressorON := false;
	algorithm
		when time >= 2 and TsupplySource > TminSource + 1 and on then
		  compressorON := true;
		elsewhen TsupplySource < TminSource or not on then
		  compressorON := false;
		end when;
	equation
//Outputs
  TsupplySource = supplyPortSource.h / mediumSource.cp;
		  TreturnSource = returnPortSource.h / mediumSource.cp;
		  TsupplyLoad = supplyPortLoad.h / mediumLoad.cp;
		  TreturnLoad = returnPortLoad.h / mediumLoad.cp;
		  volFlowLoad = returnPortLoad.m_flow / mediumLoad.rho;
		  PthermalLoad = -(supplyPortLoad.H_flow + returnPortLoad.H_flow);
		  der(QthermalLoad) = PthermalLoad;
		  dpLoad = loadPipe.dp;
		  volFlowSource = supplyPortSource.m_flow / mediumSource.rho;
		  PthermalSource = supplyPortSource.H_flow + returnPortSource.H_flow;
		  der(QthermalSource) = PthermalSource;
		  dpSource = sourcePipe.dp;
//Control
  TsupplyEvaporator = sourcePipe.flowPort_a.h / mediumSource.cp;
		  TsupplyLoadTarget = max(TminLoad, min(TmaxLoad, max(Tref, TsupplyEvaporator + MiminumShift)));
		  COPdata.u1 = max(TminSource - 273.15, min(TmaxSource - 273.15, TsupplyEvaporator - 273.15));
		  COPdata.u2 = TsupplyLoadTarget - 273.15;
		  COP = max(1.1, COPdata.y);
		  SPF = QthermalLoad / max(1, Eelectric);
		  PowerData.u1 = max(TminSource - 273.15, min(TmaxSource - 273.15, TsupplyEvaporator - 273.15));
		  PowerData.u2 = TsupplyLoadTarget - 273.15;
		  heaTsupply[1].Q_flow = -Pcondenser * (1 - 1 / COP);
		  heaTsupply[2].Q_flow = Pcondenser;
		  Pelectric = Pcondenser / COP;
		  der(Eelectric) = Pelectric;
		  deltaTload = max(1, TsupplyLoadTarget - TreturnLoad);
//control modes (Pref<0 -> maximum power)
  if not on then
    Pcondenser = 0;
    volFlowSourceSet = 0;
  elseif mode == MoSDH.Utilities.Types.ControlTypesHeatPump.SourceFlowRate then
    Pcondenser = if not compressorON then 0 elseif Pref < (-0.5) then PowerData.y * 1000 * powerScaling
     elseif not constrainPower then Pref else max(0, min(Pref, PowerData.y * 1000 * powerScaling));
    volFlowSourceSet = volFlowRef;
  elseif mode == MoSDH.Utilities.Types.ControlTypesHeatPump.DeltaTsource then
    Pcondenser = if not compressorON then 0 elseif Pref < (-0.5) then PowerData.y * 1000 * powerScaling
     elseif not constrainPower then Pref else max(0, min(Pref, PowerData.y * 1000 * powerScaling));
    volFlowSourceSet = if not compressorON then V_flowNominalSource else Pcondenser * (1 - 1 / COP) / (max(1, DeltaTref) * mediumSource.cp * mediumSource.rho);
  else
    Pcondenser = if not compressorON then 0 elseif Pref < (-0.5) then PowerData.y * 1000 * powerScaling / (1 - 1 / COP)
     elseif not constrainPower then Pref / (1 - 1 / COP) else min(Pref / (1 - 1 / COP), PowerData.y * 1000 * powerScaling / (1 - 1 / COP));
    volFlowSourceSet = if not compressorON then V_flowNominalSource else Pref / (max(1, DeltaTref) * mediumSource.cp * mediumSource.rho);
  end if;
		  volFlowLoadSet = if compressorON then Pcondenser / (deltaTload * mediumLoad.cp * mediumLoad.rho) else 0;
//source side connections
  connect(sourcePipe.flowPort_a, sourcePump.flowPort_b) annotation(
    Line(points = {{-45, 40}, {-45, 45}, {-45, 65}, {-50.66, 65}, {-50.66, 65}}, color = {255, 0, 0}, thickness = 1));
		  connect(absolutePressureSource.flowPort, sourcePipe.flowPort_b) annotation (
		    Line(points = {{-60, -5}, {-55, -5}, {-45, -5}, {-45, 15}, {-45, 20}}, color = {255, 0, 0}, thickness = 1));
		  connect(rfm.supplyPortLoad, sourcePump.flowPort_a) annotation (
		    Line(points = {{-85.33, 40}, {-85.33, 40}, {-75, 40}, {-75, 65}, {-70, 65}}, color = {255, 0, 0}, thickness = 1));
		  connect(rfm.supplyPortSource, supplyPortSource) annotation (
		    Line(points = {{-105, 40}, {-110, 40}, {-110, 65}, {-115, 65}}, color = {255, 0, 0}, thickness = 1));
		  connect(rfm.returnPortSource, returnPortSource) annotation (
		    Line(points = {{-105, 30}, {-110, 30}, {-110, -5}, {-115, -5}}, color = {0, 0, 255}, thickness = 1));
		  connect(rfm.returnPortLoad, sourcePipe.flowPort_b) annotation (
		    Line(points = {{-85.33, 30}, {-80.3, 30}, {-80.3, 15}, {-45, 15}, {-45, 20}}, color = {0, 0, 255}, thickness = 1));
//load side connections
  connect(loadPipe.flowPort_b, loadPump.flowPort_a) annotation(
    Line(points = {{15, 40}, {15, 45}, {15, 65}, {45, 65}, {50, 65}}, color = {255, 0, 0}, thickness = 1));
		  connect(loadPump.flowPort_b, supplyPortLoad) annotation (
		    Line(points = {{69.34, 65}, {69.34, 65}, {150, 65}, {155, 65}}, color = {255, 0, 0}, thickness = 1));
		  connect(absolutePressureLoad.flowPort, loadPipe.flowPort_a) annotation (
		    Line(points = {{35, 20}, {30, 20}, {30, 15}, {15, 15}, {15, 20}}, color = {255, 0, 0}, thickness = 1));
		  connect(loadPipe.flowPort_a, returnPortLoad) annotation (
		    Line(points = {{15, 20}, {15, 15}, {15, -5}, {150, -5}, {155, -5}}, color = {255, 0, 0}, thickness = 1));
// transfer heat between source and load
  connect(heaTsupply[1].port, sourcePipe.heatPort) annotation(
    Line(points = {{-10, 10}, {-10, 15}, {-10, 30}, {-30, 30}, {-35, 30}}, color = {191, 0, 0}, thickness = 1));
		  connect(heaTsupply[2].port, loadPipe.heatPort) annotation (
		    Line(points = {{-10, 10}, {-10, 15}, {-10, 30}, {0, 30}, {5, 30}}, color = {191, 0, 0}, thickness = 1));
	annotation(
		defaultComponentName="hp",
		Icon(
			coordinateSystem(extent={{-200,-200},{200,200}}),
			graphics={
							Bitmap(
								imageSource="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
xw0ac8QR/w+Ac0TPdH8K5gAAAABJRU5ErkJggg==",
								extent={{-199.8,-200},{199.8,200}})}),
		Documentation(info= "<html><head></head><body><h4><font face=\"MS Shell Dlg 2\">Heat pump component (Sources.electric.HeatPump)</font></h4><h4><div style=\"font-weight: normal;\"></div><div style=\"font-weight: normal;\"><ul><li><font face=\"MS Shell Dlg 2\">Electric driven heat pump model based on COP and heat power maps.</font></li><li><font face=\"MS Shell Dlg 2\">Tables for the COP and maximum heating power have to be defined by tables (<b>HPDataFile</b>).</font></li><li><font face=\"MS Shell Dlg 2\">The heating power can be kept unrestrained if&nbsp;<b>constrainPower</b>&nbsp;is set to false or multiplied by the factor&nbsp;<b>powerScaling</b>&nbsp;to allow for parameter studies without a change of the input data.</font></li><li><font face=\"MS Shell Dlg 2\">If&nbsp;<b>returnFlowMixing</b>&nbsp;is set to true and the source temperature exceeds the maximum (<b>TmaxSource</b>), the source supply is mixed with return flow.</font></li><li>The heat pump can be enabled/disabled by the control variable&nbsp;<b>on</b>.</li><li>The&nbsp;heat pump can operate in three modes (<b>mode</b>) between which it can change dynamically:</li><ul><li><b>SourceFlowRate:&nbsp;</b>Define supply temperature&nbsp;<b>Tref</b>&nbsp;and power&nbsp;<b>Pref</b>&nbsp;on load side as well as volume flow rate&nbsp;<b>volfFlow</b>&nbsp;on source side.</li><li><b>DeltaTsource</b>:&nbsp;Define supply temperature&nbsp;<b>Tref</b>&nbsp;and power&nbsp;<b>Pref</b>&nbsp;on load side as well as temperature difference&nbsp;<b>DeltaTref</b>&nbsp;on source side.</li><li><b>SourcePower</b>: Define supply temperature&nbsp;<b>Tref</b>&nbsp;on load side as well as power&nbsp;<b>Pref</b>&nbsp;and volume flow rate&nbsp;<b>volFlow</b>&nbsp;on source side.&nbsp;</li></ul></ul></div></h4></body></html>"),
		experiment(
			StopTime=1,
			StartTime=0,
			Tolerance=1e-06,
			Interval=0.002));
end HeatPump;
