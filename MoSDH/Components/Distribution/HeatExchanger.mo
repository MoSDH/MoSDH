within MoSDH.Components.Distribution;
model HeatExchanger "Heat exchanger model"
	MoSDH.Utilities.Interfaces.SupplyPort supplyPortLoad(medium=mediumLoad) "Load side flow port (hot)" annotation(Placement(
		transformation(extent={{90,55},{110,75}}),
		iconTransformation(extent={{86.7,40},{106.7,60}})));
	MoSDH.Utilities.Interfaces.ReturnPort returnPortLoad(medium=mediumLoad) "Load side return port (cool)" annotation(Placement(
		transformation(extent={{90,-15},{110,5}}),
		iconTransformation(extent={{86.7,-60},{106.7,-40}})));
	MoSDH.Utilities.Interfaces.ReturnPort returnPortSource(medium=mediumSource) "Source side return port (cool)" annotation(Placement(
		transformation(extent={{-125,-15},{-105,5}}),
		iconTransformation(extent={{-110,-60},{-90,-40}})));
	MoSDH.Utilities.Interfaces.SupplyPort supplyPortSource(medium=mediumSource) "Source side flow port (hot)" annotation(Placement(
		transformation(extent={{-125,55},{-105,75}}),
		iconTransformation(extent={{-110,40},{-90,60}})));
	Modelica.Thermal.FluidHeatFlow.Components.Pipe sourcePipe[nSegments](
		each medium=mediumSource,
		each m=V_flowNominalLoad*mediumLoad.rho*tau,
		each T0=Tinitial+5,
		each T0fixed=true,
		each tapT=0.5,
		each V_flowLaminar=V_flowLaminarSource,
		dpLaminar=cat(1,{dpLaminarSource},fill(0,nSegments-1)),
		each V_flowNominal=V_flowNominalSource,
		dpNominal=cat(1,{dpNominalSource},fill(0,nSegments-1)),
		each useHeatPort=true,
		each h_g=0) annotation(Placement(transformation(
		origin={-45,30},
		extent={{10,-10},{-10,10}},
		rotation=90)));
	Pump sourcePump(
		medium=mediumSource,
		volFlowRef=volFlowSet) if useSourcePump annotation(Placement(transformation(extent={{-85,55},{-65,75}})));
	Modelica.Thermal.FluidHeatFlow.Components.Pipe loadPipe[nSegments](
		each medium=mediumLoad,
		each m=V_flowNominalLoad*mediumLoad.rho*tau,
		each T0=Tinitial-5,
		each T0fixed=true,
		each tapT=0.5,
		each V_flowLaminar=V_flowLaminarLoad,
		dpLaminar=cat(1,{dpLaminarLoad},fill(0,nSegments-1)),
		each V_flowNominal=V_flowNominalLoad,
		dpNominal=cat(1,{dpNominalLoad},fill(0,nSegments-1)),
		each useHeatPort=true,
		each h_g=0) annotation(Placement(transformation(
		origin={15,30},
		extent={{-10,10},{10,-10}},
		rotation=90)));
	Pump loadPump(
		medium=mediumLoad,
		volFlowRef=volFlowSet) if useLoadPump annotation(Placement(transformation(extent={{50,55},{70,75}})));
	Modelica.Thermal.FluidHeatFlow.Sources.AbsolutePressure absolutePressureSource(
		medium=mediumSource,
		p=pSource) if setAbsoluteSourcePressure annotation(Placement(transformation(extent={{-100,30},{-120,50}})));
	Modelica.Thermal.FluidHeatFlow.Sources.AbsolutePressure absolutePressureLoad(
		medium=mediumLoad,
		p=pLoad) if setAbsoluteLoadPressure annotation(Placement(transformation(extent={{35,10},{55,30}})));
	Modelica.Thermal.HeatTransfer.Components.ThermalConductor contactSurface[nSegments](each G=heatExchangeSurface*heatTransferCoeffieicent/nSegments) annotation(Placement(transformation(extent={{-25,20},{-5,40}})));
	Modelica.Units.SI.Temperature TsupplyLoad(displayUnit="degC") "Load side supply temperature";
	Modelica.Units.SI.Temperature TreturnLoad(displayUnit="degC") "Load side return temperature";
	Modelica.Units.SI.VolumeFlowRate volFlowLoad "Load side volume flow";
	Modelica.Units.SI.Power PthermalLoad(displayUnit="kW") "Load side thermal power";
	Modelica.Units.SI.Energy QthermalLoad(
		start=0,
		fixed=true) "Load side thermal energy budget";
	Modelica.Units.SI.Pressure dpLoad "Load side pressure drop (return->flow)";
	Modelica.Units.SI.Temperature TsupplySource(displayUnit="degC") "Source side supply temperature";
	Modelica.Units.SI.Temperature TreturnSource(displayUnit="degC") "Source side return temperature";
	Modelica.Units.SI.VolumeFlowRate volFlowSource "Source side volume flow";
	Modelica.Units.SI.Power PthermalSource(displayUnit="kW") "Source side thermal power";
	Modelica.Units.SI.Energy QthermalSource(
		start=0,
		fixed=true) "Source side thermal energy budget";
	Modelica.Units.SI.Pressure dpSource "Source side pressure drop (flow->return)";
	parameter Integer nSegments(min=2)=10 "Number of heat transfer segments" annotation(Dialog(
		group="General",
		tab="Design"));
	parameter Modelica.Units.SI.Temperature Tinitial(displayUnit="degC")=293.15 "Load side return temperature" annotation(Dialog(
		group="General",
		tab="Design"));
	parameter Modelica.Units.SI.Time tau=300 "Time constant for dynamic behaviour" annotation(Dialog(
		group="Dynamics",
		tab="Design"));
	replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water mediumSource constrainedby Modelica.Thermal.FluidHeatFlow.Media.Medium "Source side heat carrier fluid" annotation(
		choicesAllMatching=true,
		Dialog(
			group="General",
			tab="Design"));
	parameter Modelica.Units.SI.VolumeFlowRate V_flowLaminarSource=V_flowNominalSource*0.01 "Laminar volume flow" annotation(Dialog(
		group="Source side",
		tab="Design"));
	parameter Modelica.Units.SI.Pressure dpLaminarSource=dpNominalSource*0.001 "Laminar pressure drop" annotation(Dialog(
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
	parameter Modelica.Units.SI.VolumeFlowRate V_flowLaminarLoad=V_flowNominalLoad*0.01 "Laminar volume flow" annotation(Dialog(
		group="Load side",
		tab="Design"));
	parameter Modelica.Units.SI.Pressure dpLaminarLoad=dpNominalLoad*0.001 "Laminar pressure drop" annotation(Dialog(
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
	parameter Modelica.Units.SI.Area heatExchangeSurface=50 "Heat exchanger surface" annotation(Dialog(
		group="General",
		tab="Design"));
	parameter Modelica.Units.SI.CoefficientOfHeatTransfer heatTransferCoeffieicent=1000 "Heat transfer coefficient" annotation(Dialog(
		group="General",
		tab="Design"));
	parameter MoSDH.Utilities.Types.ControlTypesHX controlType=MoSDH.Utilities.Types.ControlTypesHX.Passive annotation(Dialog(
		group="Bus system",
		tab="Control"));
	parameter Real flowRatioConstant=1 "Flow ratio to uncontrolled side (>0 for counter current)" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	Modelica.Units.SI.VolumeFlowRate volFlowRef=0.01 "Reference volume flow" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	protected
		parameter Boolean useSourcePump=Integer(controlType)==2 or Integer(controlType)==3 "Source side pump is modeled";
		parameter Boolean useLoadPump=Integer(controlType)==4 or Integer(controlType)==5 "Load side pump is modeled";
		Modelica.Units.SI.VolumeFlowRate volFlowSet "Actual volume flow";
	equation
		//Outputs
		  TsupplySource = supplyPortSource.h / mediumSource.cp;
		    TreturnSource=returnPortSource.h/mediumSource.cp;
		    TsupplyLoad=supplyPortLoad.h/mediumLoad.cp;
		    TreturnLoad=returnPortLoad.h/mediumLoad.cp;
		
		    volFlowLoad=returnPortLoad.m_flow/mediumLoad.rho;
		    PthermalLoad=-(supplyPortLoad.H_flow+returnPortLoad.H_flow);
		    der(QthermalLoad)=PthermalLoad;
		    dpLoad= sum(loadPipe[iSegment].dp for iSegment in 1:nSegments);
		
		    volFlowSource=supplyPortSource.m_flow/mediumSource.rho;
		    PthermalSource=(supplyPortSource.H_flow+returnPortSource.H_flow);
		    der(QthermalSource)=PthermalSource;
		    dpSource= sum(sourcePipe[iSegment].dp for iSegment in 1:nSegments);
		//control
		//set pump control signal
		  if Integer(controlType) == 2 then
		    volFlowSet = flowRatioConstant * returnPortLoad.m_flow / mediumLoad.rho;
		  elseif Integer(controlType) == 3 or Integer(controlType) == 5 then
		    volFlowSet = volFlowRef;
		  elseif Integer(controlType) == 4 then
		    volFlowSet = -flowRatioConstant * returnPortSource.m_flow / mediumSource.rho;
		  else
		    volFlowSet = 0;
		  end if;
		//source side connections
		// source pump used?
		  if useSourcePump then
		    connect(sourcePipe[1].flowPort_a, sourcePump.flowPort_b) annotation (
		      Line(points = {{-45, 40}, {-45, 45}, {-45, 65}, {-65.66, 65}, {-65.66, 65}}, color = {255, 0, 0}, thickness = 0.0625));
		    connect(sourcePump.flowPort_a, supplyPortSource) annotation (
		      Line(points = {{-85, 65}, {-90, 65}, {-110, 65}, {-115, 65}}, color = {255, 0, 0}, thickness = 0.0625));
		  else
		    connect(supplyPortSource, sourcePipe[1].flowPort_a) annotation (
		      Line(points = 0));
		  end if;
		//load side connections
		// load pump used?
		  if useLoadPump then
		    connect(loadPipe[1].flowPort_b, loadPump.flowPort_a) annotation (
		      Line(points = {{15, 40}, {15, 45}, {15, 65}, {45, 65}, {50, 65}}, color = {255, 0, 0}, thickness = 0.0625));
		    connect(loadPump.flowPort_b, supplyPortLoad) annotation (
		      Line(points = {{69.34, 65}, {69.34, 65}, {95, 65}, {100, 65}}, color = {255, 0, 0}, thickness = 0.0625));
		  else
		    connect(supplyPortLoad, loadPipe[1].flowPort_b) annotation (
		      Line(points = 0));
		  end if;
		    connect(absolutePressureLoad.flowPort,loadPipe[nSegments].flowPort_a) annotation(Line(
		   points={{35,20},{30,20},{30,15},{15,15},{15,20}},
		   color={255,0,0},
		   thickness=0.0625));
		// transfer heat between source and load
		// flow sensors
		  connect(sourcePipe[1:nSegments - 1].flowPort_b, sourcePipe[2:nSegments].flowPort_a) annotation (
		    Line(points = 0));
		   connect(loadPipe[1:nSegments-1].flowPort_a,loadPipe[2:nSegments].flowPort_b) annotation(Line(points=0));
		   connect(absolutePressureSource.flowPort,sourcePipe[1].flowPort_a) annotation(Line(
		   points={{-100,40},{-95,40},{-95,45},{-45,45},{-45,40}},
		   color={255,0,0},
		   thickness=0.0625));
		  connect(returnPortSource,sourcePipe[nSegments].flowPort_b) annotation(Line(
		   points={{-115,-5},{-110,-5},{-45,-5},{-45,15},{-45,20}},
		   color={255,0,0},
		   thickness=0.0625));
		  connect(returnPortLoad,loadPipe[nSegments].flowPort_a) annotation(Line(
		   points={{100,-5},{95,-5},{15,-5},{15,15},{15,20}},
		   color={255,0,0},
		   thickness=0.0625));
		//transfer
		  connect(sourcePipe.heatPort, contactSurface.port_a) annotation (
		    Line(points = {{-35, 30}, {-30, 30}, {-25, 30}}, color = {191, 0, 0}, thickness = 0.0625));
		   connect(contactSurface.port_b,loadPipe.heatPort) annotation(Line(
		   points={{-5,30},{0,30},{5,30}},
		   color={191,0,0},
		   thickness=0.0625));
	annotation(
		defaultComponentName="hx",
		Icon(graphics={
						Bitmap(
							imageSource="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
uuj/A/OyARwR9qL6AAAAAElFTkSuQmCC",
							extent={{-100,-99.7},{100,99.7}})}),
		Documentation(info="<html><head></head><body><h4>Discretized heat exchanger model:</h4><div><ul><li>The heat exchanger surface is divided into segments (nSegments).</li><li>The hx can be controlled in 5 different modes:</li><ul><li>Passive: no pumps</li><li>CoupleSource: volFlowSource = <b>flowRatioConstant</b> * volFlowLoad</li><li>SourcePump: Define source side flow rate by <b>volFlowRef</b></li><li>CoupleLoad:&nbsp;volFlowLoad = <b>flowRatioConstant</b> * volFlowSource</li><li>LoadPump:&nbsp;Define load side flow rate by&nbsp;<b>volFlowRef</b></li></ul></ul></div></body></html>"),
		experiment(
			StopTime=1,
			StartTime=0,
			Tolerance=1e-06,
			Interval=0.001));
end HeatExchanger;