within MoSDH.Components.Distribution;
model Pump "Pump model"
	parameter Modelica.Thermal.FluidHeatFlow.Media.Medium medium=Modelica.Thermal.FluidHeatFlow.Media.Water() "Medium in the component" annotation(
		choicesAllMatching=true,
		Dialog(
			group="General",
			tab="Design"));
	parameter Modelica.Units.SI.VolumeFlowRate volFlowNom=0.01 "Nominal pumpp volume flow" annotation(Dialog(
		group="Efficiency",
		tab="Design"));
	parameter Boolean useConstantEfficiency=true "=true, if pump efficiency is independent from flow rate" annotation(Dialog(
		group="Efficiency",
		tab="Design"));
	parameter Real constantEfficiency(
		min=0.1,
		max=1)=0.6 "Pump effciency" annotation(Dialog(
		group="Efficiency",
		tab="Design"));
	parameter Real pumpEfficiency[:,:]={{0.1, 0.6}, {0.5, 0.6}, {1, 0.6}} "Normalized pump efficiency data" annotation(Dialog(
		group="Efficiency",
		tab="Design"));
	Modelica.Units.SI.VolumeFlowRate volFlowRef=0 "Reference volume flow rate" annotation(Dialog(
		group="General",
		tab="Control"));
	Modelica.Units.SI.VolumeFlowRate volFlow=flowPort_a.m_flow / medium.rho "Volume flow rate control";
	Modelica.Units.SI.Pressure dp=flowPort_a.p - flowPort_b.p "Pressure drop";
	Modelica.Blocks.Tables.CombiTable1Dv pumpEfficiencyTable(
		tableOnFile=false,
		table=pumpEfficiency,
		verboseRead=false,
		extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint) "Pump efficency table";
	Modelica.Units.SI.Power PelectricPump(displayUnit="kW") "Electric pump power";
	Modelica.Units.SI.Energy EelectricPump(
		start=0,
		fixed=true) "Electric pump energy";
	MoSDH.Utilities.Interfaces.FluidPort flowPort_a(medium=medium) "Uncolored port for fluid" annotation(Placement(
		transformation(extent={{-110,40},{-90,60}}),
		iconTransformation(extent={{-60,-10},{-40,10}})));
	MoSDH.Utilities.Interfaces.FluidPort flowPort_b(medium=medium) "Uncolored port for fluid" annotation(Placement(
		transformation(
			origin={100,50},
			extent={{-10,-10},{10,10}},
			rotation=180),
		iconTransformation(
			origin={46.7,0},
			extent={{-10,-10},{10,10}},
			rotation=180)));
	Modelica.Units.SI.Temperature Tstream=if volFlow >= 0 then flowPort_a.h / medium.cp else flowPort_b.h / medium.cp "Pump stream tempearture";
	equation
		//pump
		  flowPort_a.m_flow = volFlowRef * medium.rho ;
		// mass balance
		  flowPort_a.m_flow + flowPort_b.m_flow = 0;
		// energy balance
		//flowPort_a.H_flow + flowPort_b.H_flow = 0;
		  
		    flowPort_a.H_flow = semiLinear(flowPort_a.m_flow, flowPort_a.h, flowPort_b.h);
		    flowPort_b.H_flow = semiLinear(flowPort_b.m_flow, flowPort_b.h, flowPort_a.h);
		 
		//efficiency
		  pumpEfficiencyTable.u[1] = abs(volFlow) / volFlowNom;
		  if useConstantEfficiency then
		    PelectricPump = -dp * volFlow / constantEfficiency;
		  else
		    PelectricPump = -dp * volFlow / min(max(0.01, pumpEfficiencyTable.y[1]), 1);
		  end if;
		  der(EelectricPump) = PelectricPump;
	annotation(
		defaultComponentName="pump",
		Icon(
			coordinateSystem(extent={{-50,-50},{50,50}}),
			graphics={
							Bitmap(
								imageSource="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",
								extent={{-50,-49.8},{50,49.8}})}),
		Documentation(info="<html><head></head><body><h4>Pump model for a fixed volume flow rate</h4><div><ul><li>According to the setting of &nbsp;<b>useConstantEfficiency</b>, the electricity consumption is either caclulated by parameter <b>constantEfficiency</b> or by table data as function of the relative volume flow rate volFlow/<b>volFlowNom</b>.</li></ul></div></body></html>"),
		experiment(
			StopTime=31536000,
			StartTime=0,
			Tolerance=0.0001,
			Interval=60));
end Pump;
