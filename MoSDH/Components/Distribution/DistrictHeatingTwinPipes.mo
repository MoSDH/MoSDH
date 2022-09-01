within MoSDH.Components.Distribution;
model DistrictHeatingTwinPipes "Burried district heating twin pipes (experimental)"
	MoSDH.Utilities.Interfaces.SupplyPort fromSupply(medium=medium) "From district heating supply" annotation(Placement(
		transformation(extent={{-70,-85},{-50,-65}}),
		iconTransformation(extent={{186.7,40},{206.7,60}})));
	MoSDH.Utilities.Interfaces.SupplyPort toSupply(medium=medium) "To district heating supply" annotation(Placement(
		transformation(extent={{50,-85},{70,-65}}),
		iconTransformation(
			origin={-200,50},
			extent={{-10,-10},{10,10}},
			rotation=180)));
	MoSDH.Utilities.Interfaces.ReturnPort fromReturn(medium=medium) "From district heating return" annotation(Placement(
		transformation(extent={{50,-65},{70,-45}}),
		iconTransformation(extent={{-210,-60},{-190,-40}})));
	MoSDH.Utilities.Interfaces.ReturnPort toReturn(medium=medium) "To district heating return" annotation(Placement(
		transformation(extent={{-70,-65},{-50,-45}}),
		iconTransformation(
			origin={196.7,-50},
			extent={{-10,-10},{10,10}},
			rotation=180)));
	replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby Modelica.Thermal.FluidHeatFlow.Media.Medium annotation(choicesAllMatching=true);
	replaceable parameter MoSDH.Parameters.Soils.Soil groundData constrainedby MoSDH.Parameters.Soils.SoilPartial annotation(choicesAllMatching=true);
	replaceable parameter Parameters.DistrictHeatingPipes.DN100_twinPipe twinPipeData constrainedby MoSDH.Parameters.DistrictHeatingPipes.partialTwinPipeData annotation(choicesAllMatching=true);
	replaceable parameter Parameters.Grouts.PUfoam insulationData constrainedby MoSDH.Parameters.Grouts.GroutPartial annotation(choicesAllMatching=true);
	parameter Modelica.Units.SI.Length length=600 "Length of district heating grid section";
	parameter Modelica.Units.SI.Length depth(
		min=0.8,
		max=2)=1.2 "burry depth of pipes";
	parameter Modelica.Units.SI.Length heightDifference=0 "Height difference 'h_supply_out - h_supply_in'";
	parameter Integer nElements(
		min=2,
		max=20)=5;
	parameter Modelica.Units.SI.Temperature TinitialGround=283.14999999999998 "Initial ground temperature";
	parameter Modelica.Units.SI.Temperature TinitialSupply=TinitialGround "Supply initial fluid temperature";
	parameter Modelica.Units.SI.Temperature TinitialReturn=TinitialGround "Return initial fluid temperature";
	MoSDH.Components.Utilities.Ground.CylinderElement_FiniteDifferences groundElements[nElements](
		each groundData(
			each rho=groundData.rho,
			each cp=groundData.cp,
			each lamda=groundData.lamda),
		each numberOfBHEsInRing(each fixed=true)=1,
		each nRings(each fixed=true)=3,
		each rEquivalent(each fixed=true)=twinPipeData.dCasing/2+0.6,
		each rBorehole(each fixed=true)=twinPipeData.dCasing/2,
		each elementHeight(each fixed=true)=length/nElements,
		each Tinitial(each fixed=true)=TinitialGround) annotation(Placement(transformation(
		origin={0,-35},
		extent={{-10,-10},{10,10}},
		rotation=90)));
	Sources.Geothermal.BaseClasses.SingleUsegment pipeElements[nElements](
		each BHEdata(
			each dBorehole=twinPipeData.dCasing,
			each spacing=twinPipeData.spacing,
			each nShanks=1,
			each dPipe1=twinPipeData.dPipe,
			each tPipe1=twinPipeData.tPipe,
			each lamda1=twinPipeData.lamda,
			each dPipe2=twinPipeData.dPipe,
			each tPipe2=twinPipeData.tPipe,
			each lamda2=twinPipeData.lamda),
		each groutData=insulationData,
		each medium=medium,
		each TinitialGrout(each fixed=true)=TinitialGround,
		each TinitialSupply(each fixed=true)=TinitialSupply,
		each TinitialReturn(each fixed=true)=TinitialReturn,
		returnPipe(each h_g=-heightDifference/nElements),
		supplyPipe(each h_g=heightDifference/nElements),
		each segmentLength(each fixed=true)=length/nElements) annotation(Placement(transformation(
		origin={0,-65},
		extent={{-10,-10},{10,10}},
		rotation=90)));
	Utilities.FluidHeatFlow.HeatTransmissionResistance heatTransmission(
		Lchar=length,
		diameter=twinPipeData.dPipe-2*twinPipeData.tPipe) annotation(Placement(transformation(extent={{-35,-100},{-15,-80}})));
	protected
		inner parameter Real BHElength=length;
		inner parameter Integer nSeries=1;
		inner parameter Integer nBHEs=1;
	public
		Modelica.Units.SI.Temperature TsupplyIn=if fromSupply.m_flow > 0 then
					                 fromSupply.h/medium.cp else pipeElements[1].topSupplyPort.h/medium.cp "Incoming supply temperature";
		Modelica.Units.SI.Temperature TsupplyOut=if toSupply.m_flow > 0 then toSupply.h
				              /medium.cp else pipeElements[nElements].topReturnPort.h/medium.cp "Outgoing supply temperature";
		Modelica.Units.SI.Temperature TreturnIn=if toReturn.m_flow > 0 then toReturn.h
				              /medium.cp else pipeElements[1].bottomReturnPort.h/medium.cp "Incoming return temperature";
		Modelica.Units.SI.Temperature TreturnOut=if fromReturn.m_flow > 0 then
		fromReturn.h/medium.cp else pipeElements[nElements].bottomSupplyPort.h/
		medium.cp "Outgoing return temperature";
		Modelica.Units.SI.Power PthermalLoss "Thermal loss to the ground";
		Modelica.Units.SI.Energy QthermalLoss(
			start=0,
			fixed=true) "Thermal energy lost to the ground";
		Modelica.Units.SI.VolumeFlowRate volFlowSupply "Supply line flow rate";
		Modelica.Units.SI.VolumeFlowRate volFlowReturn "Supply line flow rate";
		Modelica.Units.SI.Pressure dpSupply "Supply pipe pressure drop";
		Modelica.Units.SI.Pressure dpReturn "Return pipe pressure drop";
		Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1 annotation(Placement(transformation(
			origin={0,40},
			extent={{10,-10},{-10,10}},
			rotation=90)));
		Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResistor1[nElements](each R=Modelica.Math.acosh(depth/(twinPipeData.dCasing/2+0.6))/(2*Modelica.Constants.pi*groundData.lamda*length/nElements)) annotation(Placement(transformation(
			origin={0,-10},
			extent={{10,-10},{-10,10}},
			rotation=90)));
		Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector1(m=nElements) annotation(Placement(transformation(
			origin={0,15},
			extent={{-10,-10},{10,10}},
			rotation=180)));
		MoSDH.Utilities.Interfaces.Weather weatherPort "Weather data connector" annotation(Placement(
			transformation(extent={{-10,90},{10,110}}),
			iconTransformation(extent={{-10,-106.7},{10,-86.7}})));
		Modelica.Blocks.Continuous.FirstOrder Tambient_movingAverage(
			T(displayUnit="d")=1728000,
			initType=Modelica.Blocks.Types.Init.SteadyState,
			y_start=293.15,
			y(quantity="CelsiusTemperature")) annotation(Placement(transformation(
			origin={0,70},
			extent={{10,10},{-10,-10}},
			rotation=90)));
	equation
		der(QthermalLoss)=PthermalLoss;
		PthermalLoss=sum(pipeElements.boreholeWallPort.Q_flow);
		heatTransmission.volFlow=volFlowSupply;
		volFlowSupply=fromSupply.m_flow/medium.rho;
		volFlowReturn=fromReturn.m_flow/medium.rho;
		dpSupply=fromSupply.p-toSupply.p;
		dpReturn=fromReturn.p-toReturn.p;
		connect(pipeElements[1:nElements-1].bottomSupplyPort,pipeElements[2:nElements].topSupplyPort) annotation(Line(points=0));
		connect(pipeElements[1:nElements-1].bottomReturnPort,pipeElements[2:nElements].topReturnPort) annotation(Line(points=0));
		connect(pipeElements[:].boreholeWallPort,groundElements[:].boreholeWallPort) annotation(Line(
		 points={{0,-55.3},{0,-50.3},{-15,-50.3},{-15,-35},{-10,-35}},
		 color={191,0,0},
		 thickness=0.0625));
		
		for iElement in 1:nElements loop
		 connect(heatTransmission.R,pipeElements[iElement].Radvective[1]) annotation(Line(
		 points={{-15.3,-85},{-10.3,-85},{0,-85},{0,-80},{0,-75}},
		 color={0,0,127},
		 thickness=0.0625));
		end for;
		Tambient_movingAverage.u=weatherPort.Tambient;
		connect(Tambient_movingAverage.y,prescribedTemperature1.T) annotation(Line(
		 points={{0,59},{0,54},{0,57},{0,52}},
		 color={0,0,127},
		 thickness=0.0625));
		connect(thermalCollector1.port_b,prescribedTemperature1.port) annotation(Line(
		 points={{0,25},{0,30},{0,25},{0,30}},
		 color={191,0,0},
		 thickness=0.0625));
		connect(thermalResistor1.port_a,thermalCollector1.port_a) annotation(Line(
		 points={{0,0},{0,5},{0,0},{0,5}},
		 color={191,0,0},
		 thickness=0.0625));
		
		connect(groundElements.local2globalPort,thermalResistor1.port_b) annotation(Line(
		 points={{0,-25},{0,-20},{0,-25},{0,-20}},
		 color={191,0,0},
		 thickness=0.0625));
		connect(pipeElements[1].topSupplyPort,fromSupply) annotation(Line(
		 points={{-10,-70},{-15,-70},{-55,-70},{-55,-75},{-60,-75}},
		 color={255,0,0},
		 thickness=1));
		connect(pipeElements[1].topReturnPort,toReturn) annotation(Line(
		 points={{-10,-60},{-15,-60},{-55,-60},{-55,-55},{-60,-55}},
		 color={0,0,255},
		 thickness=1));
		connect(toSupply,pipeElements[nElements].bottomSupplyPort) annotation(Line(
		 points={{60,-75},{55,-75},{14.7,-75},{14.7,-70},{9.699999999999999,-70}},
		 color={255,0,0},
		 thickness=1));
		connect(fromReturn,pipeElements[nElements].bottomReturnPort) annotation(Line(
		 points={{60,-55},{55,-55},{14.7,-55},{14.7,-60},{9.699999999999999,-60}},
		 color={0,0,255},
		 thickness=1));
	annotation(
		defaultComponentName="DHline",
		Icon(
			coordinateSystem(extent={{-200,-100},{200,100}}),
			graphics={
				Rectangle(
					lineColor={127,127,127},
					fillColor={127,127,127},
					fillPattern=FillPattern.Solid,
					extent={{-203,56.7},{197,43.3}}),
				Rectangle(
					lineColor={255,255,0},
					fillColor={255,255,0},
					fillPattern=FillPattern.Solid,
					extent={{-186.4,66.7},{183.3,-53.3}}),
				Rectangle(
					fillPattern=FillPattern.Solid,
					extent={{-176.3,73.3},{173.3,-33.3}}),
				Rectangle(
					lineColor={127,127,127},
					fillColor={127,127,127},
					fillPattern=FillPattern.Solid,
					extent={{-203.3,-45},{196.7,-58.4}}),
				Rectangle(
					lineColor={255,255,0},
					fillColor={255,255,0},
					fillPattern=FillPattern.Solid,
					extent={{-186.7,-35},{183.3,-68.40000000000001}}),
				Rectangle(
					fillPattern=FillPattern.Solid,
					extent={{-176.6,-28.4},{173.4,-75}})}),
		experiment(
			StopTime=1,
			StartTime=0,
			Tolerance=1e-06,
			Interval=0.001));
end DistrictHeatingTwinPipes;