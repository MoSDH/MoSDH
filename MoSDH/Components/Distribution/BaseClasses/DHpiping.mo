within MoSDH.Components.Distribution.BaseClasses;
model DHpiping "Model of two pipes in a circulare region"
	MoSDH.Utilities.Interfaces.SupplyPort supplyPort2(medium=medium) "Port used for hot fluid" annotation(Placement(
		transformation(extent={{-60,-30},{-40,-10}}),
		iconTransformation(extent={{-60,-206.7},{-40,-186.7}})));
	MoSDH.Utilities.Interfaces.ReturnPort returnPort2(medium=medium) "Port used for cool fluid" annotation(Placement(
		transformation(extent={{-40,-30},{-20,-10}}),
		iconTransformation(extent={{40,-206.7},{60,-186.7}})));
	extends MoSDH.Components.Sources.Geothermal.BaseClasses.partialBHE;
	parameter Modelica.Units.SI.Length heightDifference=0 "Height difference 'h_supply_out - h_supply_in'";
	MoSDH.Components.Sources.Geothermal.BaseClasses.SingleUsegment BHEsegments[nSegments](
		each BHEdata=BHEdata,
		each medium=medium,
		each nParallel=nParallel,
		TinitialGrout=TinitialGrout,
		TinitialSupply=TinitialSupply,
		TinitialReturn=TinitialReturn,
		returnPipe(
			dpLaminar=cat(1,{nSegments*74240*segmentLengths[1]*medium.nu^2*medium.rho/((BHEdata.dPipe1 - 2*BHEdata.tPipe1)^3)},fill(0,nSegments-1)),
			dpNominal=cat(1,{nSegments*7.86324*1e+06*segmentLengths[1]*medium.nu^2*medium.rho/((BHEdata.dPipe1- 2*BHEdata.tPipe1)^3)},fill(0,nSegments-1)),
			each h_g=-heightDifference/nSegments),
		supplyPipe(
			dpLaminar=cat(1,{nSegments*74240*segmentLengths[1]*medium.nu^2*medium.rho/((BHEdata.dPipe1 - 2*BHEdata.tPipe1)^3)},fill(0,nSegments-1)),
			dpNominal=cat(1,{nSegments*7.86324*1e+06*segmentLengths[1]*medium.nu^2*medium.rho/((BHEdata.dPipe1- 2*BHEdata.tPipe1)^3)},fill(0,nSegments-1)),
			each h_g=heightDifference/nSegments),
		segmentLength=segmentLengths) annotation(Placement(transformation(extent={{-50,10},{-30,30}})));
	MoSDH.Components.Utilities.FluidHeatFlow.HeatTransmissionResistance heatTransmission(
		medium=medium,
		Lchar=sum(segmentLengths),
		diameter=BHEdata.dPipe1-BHEdata.tPipe1) annotation(Placement(transformation(extent={{-85,5},{-65,25}})));
	equation
		heatTransmission.volFlow=supplyPort.m_flow/(medium.rho*nParallel);
		connect(BHEsegments[1].topSupplyPort,supplyPort) annotation(Line(
		 points={{-45,30},{-45,35},{-45,90},{-55,90},{-60,90}},
		 color={255,0,0},
		 thickness=1));
		connect(BHEsegments[1].topReturnPort,returnPort) annotation(Line(
		 points={{-35,30},{-35,35},{-35,90},{-15,90},{-10,90}},
		 color={0,0,255},
		 thickness=1));
		connect(BHEsegments[1:nSegments-1].bottomSupplyPort,BHEsegments[2:nSegments].topSupplyPort) annotation(Line(points=0));
		connect(BHEsegments[1:nSegments-1].bottomReturnPort,BHEsegments[2:nSegments].topReturnPort) annotation(Line(points=0));
		connect(BHEsegments.boreholeWallPort,boreholeWallPort) annotation(Line(
		 points={{-30.33,20},{-30.33,20},{0,20},{5,20}},
		 color={191,0,0},
		 thickness=0.0625));
		for iSegment in 1:nSegments loop
		
		connect(heatTransmission.R,BHEsegments[iSegment].Radvective[1]) annotation(Line(
		 points={{-65.33,20},{-65.33,20},{-55,20},{-50,20}},
		 color={0,0,127},
		 thickness=0.0625));
		end for;
		connect(supplyPort2,BHEsegments[nSegments].bottomSupplyPort) annotation(Line(
		 points={{-50,-20},{-45,-20},{-45,10.33},{-45,10.33}},
		 color={255,0,0}));
		connect(returnPort2,BHEsegments[nSegments].bottomReturnPort) annotation(Line(
		 points={{-30,-20},{-35,-20},{-35,10.33},{-35,10.33}},
		 color={0,0,255}));
	annotation(
		Icon(
			coordinateSystem(extent={{-100,-200},{100,200}}),
			graphics={
				Rectangle(
					pattern=LinePattern.None,
					fillPattern=FillPattern.Solid,
					extent={{-71.3,197.6},{-29.7,-200.3}}),
				Rectangle(
					pattern=LinePattern.None,
					fillColor={255,215,0},
					fillPattern=FillPattern.Solid,
					extent={{-66.40000000000001,200},{-33.3,-200}}),
				Rectangle(
					pattern=LinePattern.None,
					fillColor={255,0,0},
					fillPattern=FillPattern.Solid,
					extent={{-60,202.3},{-40,-201}}),
				Rectangle(
					pattern=LinePattern.None,
					fillPattern=FillPattern.Solid,
					extent={{28.4,197.9},{70,-200}}),
				Rectangle(
					pattern=LinePattern.None,
					fillColor={255,215,0},
					fillPattern=FillPattern.Solid,
					extent={{33.3,200.3},{66.40000000000001,-199.7}}),
				Rectangle(
					pattern=LinePattern.None,
					fillColor={0,0,255},
					fillPattern=FillPattern.Solid,
					extent={{39.7,202.6},{59.7,-200.7}})}),
		experiment(
			StopTime=1,
			StartTime=0,
			Tolerance=1e-06,
			Interval=0.001));
end DHpiping;