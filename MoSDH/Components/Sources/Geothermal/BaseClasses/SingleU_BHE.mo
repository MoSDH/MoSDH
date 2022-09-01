within MoSDH.Components.Sources.Geothermal.BaseClasses;
model SingleU_BHE "SingleU borehole heat exchanger"
 extends partialBHE;
 MoSDH.Components.Sources.Geothermal.BaseClasses.SingleUsegment BHEsegments[nSegments](
  each BHEdata=BHEdata,
  groutData(
   lamda={ if iSeg>= iGroutChange then groutData.lamda else groutDataUpper.lamda for iSeg in 1:nSegments},
   cp={ if iSeg>= iGroutChange then groutData.cp else groutDataUpper.cp for iSeg in 1:nSegments},
   rho={ if iSeg>= iGroutChange then groutData.rho else groutDataUpper.rho for iSeg in 1:nSegments}),
  each medium=medium,
  each nParallel=nParallel,
  TinitialGrout=TinitialGrout,
  TinitialSupply=TinitialSupply,
  TinitialReturn=TinitialReturn,
  returnPipe(
   dpLaminar=cat(1,{74240*BHElength*medium.nu^2*medium.rho/((BHEdata.dPipe1 - 2*BHEdata.tPipe1)^3)},fill(0,nSegments-1)),
   dpNominal=cat(1,{7.86324*1e+06*BHElength*medium.nu^2*medium.rho/((BHEdata.dPipe1 - 2*BHEdata.tPipe1)^3)},fill(0,nSegments-1))),
  supplyPipe(
   dpLaminar=cat(1,{74240*BHElength*medium.nu^2*medium.rho/((BHEdata.dPipe1 - 2*BHEdata.tPipe1)^3)},fill(0,nSegments-1)),
   dpNominal=cat(1,{7.86324*1e+06*BHElength*medium.nu^2*medium.rho/((BHEdata.dPipe1 - 2*BHEdata.tPipe1)^3)},fill(0,nSegments-1))),
  segmentLength=segmentLengths) annotation(Placement(transformation(extent={{-50,10},{-30,30}})));
 MoSDH.Components.Utilities.FluidHeatFlow.HeatTransmissionResistance heatTransmission(
  medium=medium,
  Lchar(displayUnit="m")=BHElength,
  diameter(displayUnit="m")=BHEdata.dPipe1-BHEdata.tPipe1) annotation(Placement(transformation(extent={{-85,5},{-65,25}})));
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
  connect(BHEsegments[nSegments].bottomSupplyPort,BHEsegments[nSegments].bottomReturnPort) annotation(Line(
   points={{-45,10.3},{-45,5.3},{-35,5.3},{-35,10.3}},
   color={177,0,177},
   thickness=1));
  connect(BHEsegments.boreholeWallPort,boreholeWallPort) annotation(Line(
   points={{-30.3,20},{-25.3,20},{0,20},{5,20}},
   color={191,0,0},
   thickness=0.0625));
  for iSegment in 1:nSegments loop
   connect(heatTransmission.R,BHEsegments[iSegment].Radvective[1]) annotation(Line(
   points={{-65.3,20},{-60.3,20},{-55,20},{-50,20}},
   color={0,0,127},
   thickness=0.0625));
  end for;
 annotation (
  Icon(
   coordinateSystem(extent={{-100,-200},{100,200}}),
   graphics={
    Rectangle(
     pattern=LinePattern.None,
     fillColor={102,102,102},
     fillPattern=FillPattern.Solid,
     extent={{33.3,200},{66.7,-173.3}}),
    Rectangle(
     pattern=LinePattern.None,
     fillColor={0,0,255},
     fillPattern=FillPattern.Solid,
     extent={{60,200},{40,-166.7}}),
    Rectangle(
     pattern=LinePattern.None,
     fillColor={102,102,102},
     fillPattern=FillPattern.Solid,
     extent={{-66.40000000000001,200},{-33.3,-173.3}}),
    Rectangle(
     pattern=LinePattern.None,
     fillColor={255,0,0},
     fillPattern=FillPattern.Solid,
     extent={{-60,203.3},{-40,-166.7}}),
    Rectangle(
     pattern=LinePattern.None,
     fillColor={102,102,102},
     fillPattern=FillPattern.Solid,
     extent={{-33.3,-173.3},{33.3,-140}}),
    Rectangle(
     pattern=LinePattern.None,
     lineColor={255,255,0},
     fillColor={192,87,255},
     fillPattern=FillPattern.Solid,
     extent={{-40,-166.7},{40,-146.7}})}),
  experiment(
   StopTime=1,
   StartTime=0,
   Tolerance=1e-06,
   Interval=0.001));
end SingleU_BHE;