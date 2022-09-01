within MoSDH.Components.Distribution;
model DistrictHeatingPipes "Two burried district heating pipes (experimental)"
	MoSDH.Utilities.Interfaces.SupplyPort fromSupply(medium=medium) "From district heating flow" annotation(Placement(
		transformation(
			origin={-60,-60},
			extent={{-10,-10},{10,10}}),
		iconTransformation(extent={{186.7,40},{206.7,60}})));
	MoSDH.Utilities.Interfaces.SupplyPort toSupply(medium=medium) "To district heating flow" annotation(Placement(
		transformation(extent={{50,-70},{70,-50}}),
		iconTransformation(
			origin={-200,50},
			extent={{-10,-10},{10,10}},
			rotation=180)));
	MoSDH.Utilities.Interfaces.ReturnPort fromReturn(medium=medium) "From district heating return" annotation(Placement(
		transformation(extent={{50,-50},{70,-30}}),
		iconTransformation(extent={{-210,-60},{-190,-40}})));
	MoSDH.Utilities.Interfaces.ReturnPort toReturn(medium=medium) "To district heating return" annotation(Placement(
		transformation(
			origin={-60,-40},
			extent={{-10,-10},{10,10}}),
		iconTransformation(
			origin={196.7,-50},
			extent={{-10,-10},{10,10}},
			rotation=180)));
	replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby Modelica.Thermal.FluidHeatFlow.Media.Medium annotation(choicesAllMatching=true);
	replaceable parameter Parameters.Soils.Soil groundData constrainedby MoSDH.Parameters.Soils.SoilPartial annotation(choicesAllMatching=true);
	replaceable parameter Parameters.DistrictHeatingPipes.DN250_400 pipeData constrainedby MoSDH.Parameters.DistrictHeatingPipes.SinglePipePartial annotation(choicesAllMatching=true);
	parameter Modelica.Units.SI.Length length=600 "Length of district heating grid section";
	parameter Modelica.Units.SI.Length depth(
		min=0.55*(distance + pipeData.dCasing*1.2),
		max=3)=1.2 "burry depth of pipes";
	parameter Modelica.Units.SI.Length heightDifference=0 "Height difference 'h_supply_out - h_supply_in'";
	parameter Modelica.Units.SI.Length distance(
		min=pipeData.dCasing,
		max=2)=1 "Axial distance between pipes";
	parameter Integer nElements(
		min=2,
		max=20)=10;
	parameter Modelica.Units.SI.Temperature TinitialGround=283.14999999999998 "Initial ground temperature";
	parameter Modelica.Units.SI.Temperature TinitialSupply=TinitialGround "Supply initial fluid temperature";
	parameter Modelica.Units.SI.Temperature TinitialReturn=TinitialGround "Return initial fluid temperature";
	parameter Boolean useTaverage=false "=true, if average surface temperature is used";
	parameter Modelica.Units.SI.Temperature Taverage=283.15 "Average surface temperature" annotation(Dialog(enable=useTaverage));
	protected
		inner parameter Real BHElength=length;
		inner parameter Integer nSeries=1 "Not used";
		inner parameter Integer nBHEs=1 "Not used";
		inner parameter Integer iGroutChange=1 "Not used";
		parameter Modelica.Units.SI.ThermalConductivity lamdaEquivalent=pipeData.lamdaCasing
		*pipeData.lamdaInsulation*pipeData.lamdaPipe*log(pipeData.dCasing/(
		pipeData.dPipe - 2*pipeData.tPipe))/(pipeData.lamdaInsulation*pipeData.lamdaPipe
		*log(pipeData.dCasing/(pipeData.dCasing - 2*pipeData.tCasing)) + pipeData.lamdaCasing
		*pipeData.lamdaPipe*log((pipeData.dCasing - 2*pipeData.tCasing)/pipeData.dPipe)
		 + pipeData.lamdaCasing*pipeData.lamdaInsulation*log(pipeData.dPipe/(
		pipeData.dPipe - 2*pipeData.tPipe)));
	public
		Modelica.Units.SI.Temperature Tsupply=sum(pipeRegion.BHEsegments[iSeg].supplyPipe.T for iSeg in 1:nElements)/nElements "Average supply temperature";
		Modelica.Units.SI.Temperature Treturn=sum(pipeRegion.BHEsegments[iSeg].returnPipe.T for iSeg in 1:nElements)/nElements "Average return temperature";
		Modelica.Units.SI.Temperature TsupplyIn=fromSupply.h/medium.cp "Incoming supply temperature (fromSupply)";
		Modelica.Units.SI.Temperature TsupplyOut=toSupply.h/medium.cp "Outgoing supply temperature (toSupply)";
		Modelica.Units.SI.Temperature TreturnIn=fromReturn.h/medium.cp "Incoming return temperature (fromReturn)";
		Modelica.Units.SI.Temperature TreturnOut=toReturn.h/medium.cp "Outgoing return temperature (toReturn)";
		Modelica.Units.SI.VolumeFlowRate volFlowSupply "Supply line flow rate";
		Modelica.Units.SI.VolumeFlowRate volFlowReturn "Supply line flow rate";
		Modelica.Units.SI.Pressure dpSupplyLine=fromSupply.p - toSupply.p "Supply pipe pressure drop";
		Modelica.Units.SI.Pressure dpReturnLine=fromReturn.p - toReturn.p "Return pipe pressure drop";
		Modelica.Units.SI.Power PthermalLoss "Thermal loss to the ground";
		Modelica.Units.SI.Energy QthermalLoss(
			start=0,
			fixed=true) "Thermal energy lost to the ground";
		Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1 annotation(Placement(transformation(
			origin={0,40},
			extent={{10,-10},{-10,10}},
			rotation=90)));
		Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResistor1[nElements](each R=Modelica.Math.acosh(2*depth/(distance+pipeData.dCasing*1.5))/(2*Modelica.Constants.pi*groundData.lamda*length/nElements)) annotation(Placement(transformation(
			origin={0,-15},
			extent={{10,-10},{-10,10}},
			rotation=90)));
		Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector1(m=nElements) annotation(Placement(transformation(
			origin={0,10},
			extent={{-10,-10},{10,10}},
			rotation=180)));
		MoSDH.Utilities.Interfaces.Weather weatherPort "Weather data connector" annotation(Placement(
			transformation(extent={{-10,85},{10,105}}),
			iconTransformation(extent={{-10,-106.7},{10,-86.7}})));
		Modelica.Blocks.Continuous.FirstOrder Tambient_movingAverage(
			T(displayUnit="d")=1728000,
			initType=Modelica.Blocks.Types.Init.SteadyState,
			y_start=283.15,
			y(quantity="CelsiusTemperature")) annotation(Placement(transformation(
			origin={0,70},
			extent={{10,10},{-10,-10}},
			rotation=90)));
		BaseClasses.DHpiping pipeRegion(
			nSegments=nElements,
			segmentLengths=fill(length/nElements,nElements),
			BHEdata(
				dBorehole=distance+pipeData.dCasing*1.2,
				spacing=distance,
				nShanks=1,
				dPipe1=pipeData.dCasing,
				tPipe1=(pipeData.dCasing-pipeData.dPipe)/2+pipeData.tPipe,
				lamda1=lamdaEquivalent,
				dPipe2=pipeData.dCasing,
				tPipe2=(pipeData.dCasing-pipeData.dPipe)/2+pipeData.tPipe,
				lamda2=lamdaEquivalent),
			groutData(
				lamda=groundData.lamda,
				cp=groundData.cp,
				rho=groundData.rho),
			medium=medium,
			TinitialGrout(each fixed=true)=fill(TinitialGround,nElements),
			TinitialSupply(each fixed=true)=fill(TinitialSupply,nElements),
			TinitialReturn(each fixed=true)=fill(TinitialReturn,nElements),
			heightDifference=heightDifference) annotation(Placement(transformation(
			origin={0,-50},
			extent={{-10,-20},{10,20}},
			rotation=90)));
	equation
		 der(QthermalLoss)=PthermalLoss;
		 PthermalLoss=-sum(pipeRegion.BHEsegments.supplyPipe.Q_flow)-sum(pipeRegion.BHEsegments.returnPipe.Q_flow);
		 volFlowSupply=fromSupply.m_flow/medium.rho;
		 volFlowReturn=fromReturn.m_flow/medium.rho;
		
		   for iElement in 1:nElements loop
		    if iElement<nElements then
		        end if;
		 end for;
		
		connect(thermalResistor1[:].port_a,thermalCollector1.port_a[:]) annotation(Line(
		 points={{0,-5},{0,0},{0,-5},{0,0}},
		 color={191,0,0},
		 thickness=0.0625));
		
		
		connect(Tambient_movingAverage.y,prescribedTemperature1.T) annotation(Line(
		 points={{0,59},{0,54},{0,57},{0,52}},
		 color={0,0,127},
		 thickness=0.0625));
		
		 if useTaverage then
		 Tambient_movingAverage.u=Taverage;
		 else
		 Tambient_movingAverage.u=weatherPort.Tambient;
		 end if;
		connect(thermalCollector1.port_b,prescribedTemperature1.port) annotation(Line(
		 points={{0,20},{0,25},{0,30}},
		 color={191,0,0},
		 thickness=0.0625));
		connect(pipeRegion.boreholeWallPort[:],thermalResistor1[:].port_b) annotation(Line(
		 points={{0,-40.33},{0,-40.33},{0,-30},{0,-25}},
		 color={191,0,0},
		 thickness=0.0625));
		connect(pipeRegion.supplyPort2,toSupply) annotation(Line(
		 points={{19.67,-55},{19.67,-55},{55,-55},{55,-60},{60,-60}},
		 color={255,0,0}));
		connect(pipeRegion.returnPort2,fromReturn) annotation(Line(
		 points={{19.67,-45},{19.67,-45},{55,-45},{55,-40},{60,-40}},
		 color={0,0,255}));
		connect(pipeRegion.supplyPort,fromSupply) annotation(Line(
		 points={{-20,-55},{-25,-55},{-55,-55},{-55,-60},{-60,-60}},
		 color={255,0,0}));
		connect(pipeRegion.returnPort,toReturn) annotation(Line(
		 points={{-20,-45},{-25,-45},{-55,-45},{-55,-40},{-60,-40}},
		 color={0,0,255}));
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
					fillColor={255,215,0},
					fillPattern=FillPattern.Solid,
					extent={{-186.4,66.7},{183.6,33.3}}),
				Rectangle(
					fillPattern=FillPattern.Solid,
					extent={{-170,73.3},{170,26.7}}),
				Rectangle(
					lineColor={127,127,127},
					fillColor={127,127,127},
					fillPattern=FillPattern.Solid,
					extent={{-203.3,-42},{196.7,-55.4}}),
				Rectangle(
					lineColor={255,255,0},
					fillColor={255,215,0},
					fillPattern=FillPattern.Solid,
					extent={{-186.7,-34},{183.3,-67.40000000000001}}),
				Rectangle(
					fillPattern=FillPattern.Solid,
					extent={{-171,-28.4},{169,-75}})}),
		experiment(
			StopTime=1,
			StartTime=0,
			Tolerance=1e-06,
			Interval=0.001),
 Documentation(info = "<html><head></head><body>Model of two pre-insulated burried pipes. For a detailed description see <a href=\"modelica://MoSDH.UsersGuide.References\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">[Formhals2022]</a>&nbsp;<div><br><div><br></div></div><table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>Concept of the DistrictHeatingPipes model (left) and the DistrictHeatingTwinPipes model (right)</caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/DHpipes.png\" width=\"700\">
    </td>
  </tr>
</tbody></table></body></html>"));
end DistrictHeatingPipes;
