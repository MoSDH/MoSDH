within MoSDH.Components.Sources.Geothermal.BaseClasses;
model Coax_BHE "Coaxial borehole heat exchanger"
 extends partialBHE;
 MoSDH.Components.Sources.Geothermal.BaseClasses.CoaxSegment BHEsegments[nSegments](
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
  outerPipe(
   dpLaminar=cat(1,{74240*BHElength*medium.nu^2*medium.rho/((2*(BHEdata.dPipe2 -2*BHEdata.tPipe2 - BHEdata.dPipe1))^3)},fill(0,nSegments-1)),
   dpNominal=cat(1,{7.86324*1e+06*BHElength*medium.nu^2*medium.rho/((2*(BHEdata.dPipe2- 2*BHEdata.tPipe2 - BHEdata.dPipe1))^3)},fill(0,nSegments-1))),
  innerPipe(
   dpLaminar=cat(1,{74240*BHElength*medium.nu^2*medium.rho/((BHEdata.dPipe1 - 2*BHEdata.tPipe1)^3)},fill(0,nSegments-1)),
   dpNominal=cat(1,{7.86324*1e+06*BHElength*medium.nu^2*medium.rho/((BHEdata.dPipe1 - 2*BHEdata.tPipe1)^3)},fill(0,nSegments-1))),
  segmentLength=segmentLengths) annotation(Placement(transformation(extent={{-50,10},{-30,30}})));
 MoSDH.Components.Utilities.FluidHeatFlow.HeatTransmissionResistance alphaGapOuter(
  medium=medium,
  isAnnularGap=true,
  Lchar(displayUnit="m")=BHElength,
  diameter(displayUnit="m")=BHEdata.dPipe2-BHEdata.tPipe2,
  dInnerGap(displayUnit="m")=BHEdata.dPipe1) annotation(Placement(transformation(extent={{-85,25},{-65,45}})));
 MoSDH.Components.Utilities.FluidHeatFlow.HeatTransmissionResistance alphaGapInner(
  medium=medium,
  isAnnularGap=true,
  innerGapSurface=true,
  Lchar(displayUnit="m")=BHElength,
  diameter(displayUnit="m")=BHEdata.dPipe2-BHEdata.tPipe2,
  dInnerGap(displayUnit="m")=BHEdata.dPipe1) annotation(Placement(transformation(extent={{-85,5},{-65,25}})));
 Utilities.FluidHeatFlow.HeatTransmissionResistance alphaInnerPipe(
  medium=medium,
  isAnnularGap=false,
  Lchar(displayUnit="m")=BHElength,
  diameter(displayUnit="m")=BHEdata.dPipe1,
  dInnerGap(displayUnit="m")=BHEdata.dPipe1) annotation(Placement(transformation(extent={{-85,45},{-65,65}})));
equation
  alphaGapOuter.volFlow=supplyPort.m_flow/(medium.rho*nParallel);
  alphaGapInner.volFlow=supplyPort.m_flow/(medium.rho*nParallel);
  alphaInnerPipe.volFlow=supplyPort.m_flow/(medium.rho*nParallel);
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
   connect(alphaInnerPipe.R,BHEsegments[iSegment].Radvective[1]) annotation(Line(
    points={{-65.3,60},{-60.3,60},{-55,60},{-55,20},{-50,20}},
    color={0,0,127},
    thickness=0.0625));
   connect(alphaGapInner.R,BHEsegments[iSegment].Radvective[2]) annotation(Line(
    points={{-65.3,20},{-60.3,20},{-55,20},{-50,20}},
    color={0,0,127},
    thickness=0.0625));
   connect(alphaGapOuter.R,BHEsegments[iSegment].Radvective[3]) annotation(Line(
    points={{-65.3,40},{-60.3,40},{-55,40},{-55,20},{-50,20}},
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
     extent={{33.3,200},{66.7,100}}),
    Rectangle(
     pattern=LinePattern.None,
     fillColor={0,0,255},
     fillPattern=FillPattern.Solid,
     extent={{60,200},{40,103.3}}),
    Rectangle(
     pattern=LinePattern.None,
     fillColor={102,102,102},
     fillPattern=FillPattern.Solid,
     extent={{70,100},{-66.7,-170}}),
    Rectangle(
     pattern=LinePattern.None,
     fillColor={0,0,255},
     fillPattern=FillPattern.Solid,
     extent={{60,90},{-56.7,-156.7}}),
    Rectangle(
     pattern=LinePattern.None,
     fillColor={102,102,102},
     fillPattern=FillPattern.Solid,
     extent={{-26.7,146.7},{30,-133.3}}),
    Rectangle(
     pattern=LinePattern.None,
     fillColor={255,0,0},
     fillPattern=FillPattern.Solid,
     extent={{-16.7,136.7},{20,-133.3}}),
    Rectangle(
     pattern=LinePattern.None,
     fillColor={102,102,102},
     fillPattern=FillPattern.Solid,
     extent={{-66.40000000000001,200},{-33,110}}),
    Rectangle(
     pattern=LinePattern.None,
     fillColor={102,102,102},
     fillPattern=FillPattern.Solid,
     extent={{-66.7,110},{-16.7,140}}),
    Rectangle(
     pattern=LinePattern.None,
     fillColor={255,0,0},
     fillPattern=FillPattern.Solid,
     extent={{-16.7,136.7},{-60,116.7}}),
    Rectangle(
     pattern=LinePattern.None,
     fillColor={255,0,0},
     fillPattern=FillPattern.Solid,
     extent={{-60,203.3},{-40,116.7}})}),
  experiment(
   StopTime=1,
   StartTime=0,
   Tolerance=1e-06,
   Interval=0.001));
end Coax_BHE;