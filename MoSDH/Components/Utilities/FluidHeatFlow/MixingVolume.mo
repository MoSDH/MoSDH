within MoSDH.Components.Utilities.FluidHeatFlow;
model MixingVolume "Mixing volume for decoupling of hydraulic branches"
	MoSDH.Utilities.Interfaces.FluidPort fluidPort_a[nPortsA](each medium=medium) "A-ports (top)" annotation(Placement(
		transformation(
			origin={0,50},
			extent={{-10,-10},{10,10}},
			rotation=180),
		iconTransformation(
			origin={0,50},
			extent={{-10,-10},{10,10}},
			rotation=180)));
	MoSDH.Utilities.Interfaces.FluidPort fluidPort_b[nPortsB](each medium=medium) "B-ports (bottom)" annotation(Placement(
		transformation(
			origin={-50,100},
			extent={{-10,-10},{10,10}},
			rotation=270),
		iconTransformation(
			origin={0,-46.7},
			extent={{-10,-10},{10,10}},
			rotation=270)));
	Modelica.Units.SI.Temperature T(
		start=Tinitial,
		fixed=true) "Temperature of medium";
	Modelica.Units.SI.VolumeFlowRate volFlowA[nPortsA]=fluidPort_a.m_flow/medium.rho "Volume flows at port a";
	Modelica.Units.SI.VolumeFlowRate volFlowB[nPortsB]=fluidPort_b.m_flow/medium.rho "Volume flows at port b";
	Modelica.Units.SI.Pressure p=fluidPort_a[1].p "Mixing volume pressure";
	parameter Integer nPortsA(min=1)=1 "Number of a-ports (top)";
	parameter Integer nPortsB(min=1)=1 "Number of b-ports (bottom)";
	replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby Modelica.Thermal.FluidHeatFlow.Media.Medium "Grid heat carrier fluid" annotation(
		choicesAllMatching=true,
		Dialog(
			group="Properties",
			tab="Design"));
	parameter Modelica.Units.SI.Temperature Tinitial(displayUnit="degC")=293.15 "Initial temperature of medium" annotation(Dialog(enable=m>Modelica.Constants.small));
	parameter Modelica.Units.SI.VolumeFlowRate V_flowNom=0.01 "Nominal volume flow rate";
	parameter Modelica.Units.SI.Time tau=120 "Time constant for first order filter";
	protected
		parameter Modelica.Units.SI.Mass m(min=1)=V_flowNom*medium.rho*tau "Mass of medium";
	equation
		//Mass balance
		 sum(fluidPort_a.m_flow)=-sum(fluidPort_b.m_flow);
		
		 //Energy balance
		 sum(fluidPort_a.H_flow)+sum(fluidPort_b.H_flow)=m*medium.cp*der(T);
		
		 //ports
		 for iPort in 1:nPortsA loop
		  fluidPort_a[iPort].H_flow = semiLinear(fluidPort_a[iPort].m_flow,fluidPort_a[iPort].h,T*medium.cp);
		 end for;
		 for iPort in 1:nPortsB loop
		  fluidPort_b[iPort].H_flow = semiLinear(fluidPort_b[iPort].m_flow,fluidPort_b[iPort].h,T*medium.cp);
		 end for;
		
		 fluidPort_a[1].p=fluidPort_b[1].p;
		 if nPortsA>1 then
		  for iPort in 2:nPortsA loop
		   fluidPort_a[1].p=fluidPort_a[iPort].p;
		  end for;
		 end if;
		 if nPortsB>1 then
		  for iPort in 2:nPortsB loop
		   fluidPort_b[1].p=fluidPort_b[iPort].p;
		  end for;
		 end if;
	annotation(
		Icon(
			coordinateSystem(extent={{-50,-50},{50,50}}),
			graphics={
			Ellipse(
				pattern=LinePattern.None,
				fillPattern=FillPattern.Solid,
				extent={{-46.6,46.6},{46.8,-46.7}})}),
		experiment(
			StopTime=1,
			StartTime=0,
			Tolerance=1e-06,
			Interval=0.001));
end MixingVolume;