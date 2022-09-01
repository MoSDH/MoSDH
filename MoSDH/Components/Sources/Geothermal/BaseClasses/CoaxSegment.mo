within MoSDH.Components.Sources.Geothermal.BaseClasses;
model CoaxSegment "Coaxial borehole heat exchanger"
 extends BHEsegment_partial;
 Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C_grout(
  C=nParallel*groutData.cp*(BHEdata.dBorehole^2-BHEdata.dPipe2^2)/4*segmentLength*groutData.rho*Modelica.Constants.pi,
  T(
   start=TinitialGrout,
   fixed=true)) "Grout thermal capacity" annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
  MoSDH.Components.Utilities.FluidHeatFlow.Pipe outerPipe(
    medium=medium,
    m=nParallel*(((BHEdata.dPipe2/2 - BHEdata.tPipe2)^2 - (BHEdata.dPipe1/2)^2)
        *Modelica.Constants.pi*segmentLength*medium.rho),
    T0=TinitialReturn,
    T0fixed=true,
    tapT=0.5,
    V_flowLaminar=nParallel*580*(2*(BHEdata.dPipe2 - 2*BHEdata.tPipe2 - BHEdata.dPipe1))
        *Modelica.Constants.pi*medium.nu,
    dpLaminar=74240*segmentLength*medium.nu^2*medium.rho/((2*(BHEdata.dPipe2 -
        2*BHEdata.tPipe2 - BHEdata.dPipe1))^3),
    V_flowNominal=nParallel*6250*(2*(BHEdata.dPipe2 - 2*BHEdata.tPipe2 -
        BHEdata.dPipe1))*Modelica.Constants.pi*medium.nu,
    dpNominal=7.86324*1e+06*segmentLength*medium.nu^2*medium.rho/((2*(BHEdata.dPipe2
         - 2*BHEdata.tPipe2 - BHEdata.dPipe1))^3),
    useHeatPort=true,
    h_g(displayUnit="m") = -segmentLength) "annular gap of coaxial pipe"
    annotation (Placement(transformation(
        origin={80,55},
        extent={{-10,-10},{10,10}},
        rotation=-90)));
  MoSDH.Components.Utilities.FluidHeatFlow.Pipe innerPipe(
    medium=medium,
    m=nParallel*((BHEdata.dPipe1/2 - BHEdata.tPipe1)^2*Modelica.Constants.pi*
        segmentLength*medium.rho),
    T0=TinitialSupply,
    T0fixed=true,
    tapT=0.5,
    V_flowLaminar=nParallel*580*(BHEdata.dPipe1 - 2*BHEdata.tPipe1)*Modelica.Constants.pi
        *medium.nu,
    dpLaminar=74240*segmentLength*medium.nu^2*medium.rho/((BHEdata.dPipe1 - 2*
        BHEdata.tPipe1)^3),
    V_flowNominal=nParallel*6250*(BHEdata.dPipe1 - 2*BHEdata.tPipe1)*Modelica.Constants.pi
        *medium.nu,
    dpNominal=7.86324*1e+06*segmentLength*medium.nu^2*medium.rho/((BHEdata.dPipe1
         - 2*BHEdata.tPipe1)^3),
    useHeatPort=true,
    h_g(displayUnit="m") = segmentLength) "inner pipe of coaxial pipe"
    annotation (Placement(transformation(
        origin={-120,55},
        extent={{-10,-10},{10,10}},
        rotation=90)));
 Modelica.Thermal.HeatTransfer.Components.ThermalResistor R_pipeToPipe(R=log(0.5*BHEdata.dPipe1/(0.5*BHEdata.dPipe1-BHEdata.tPipe1))/(2*Modelica.Constants.pi*BHEdata.lamda1*segmentLength*nParallel)) "thermal resistance due to conduction in inner pipe" annotation(Placement(transformation(extent={{-50,65},{-30,85}})));
 Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector1(m=2) annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
 Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor Rconv_inner "convective thermal resistance " annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
 Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor Rconv_annularInner "convective thermal resistance" annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
 Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor Rconv_annularOuter "convective thermal resistance" annotation(Placement(transformation(extent={{-10,-10},{10,10}})));
 Modelica.Thermal.HeatTransfer.Components.ThermalResistor R_groutToWall(R=(1-x_grout_center)*log(BHEdata.dBorehole/BHEdata.dPipe2)/(2*Modelica.Constants.pi*groutData.lamda*segmentLength*nParallel)) "conductive thermal resistance from grout centre of mass to borehole wall" annotation(Placement(transformation(
  origin={40,-5},
  extent={{-10,-10},{10,10}},
  rotation=-90)));
 Modelica.Thermal.HeatTransfer.Components.ThermalResistor R_pipeToGrout(R=(x_grout_center)*log(BHEdata.dBorehole/BHEdata.dPipe2)/(2*Modelica.Constants.pi*groutData.lamda*segmentLength*nParallel)) "conductive thermal resistance from outer pipe to grout centre of mass" annotation(Placement(transformation(
  origin={40,25},
  extent={{-10,-10},{10,10}},
  rotation=-90)));
 parameter Real x_grout_center=log(sqrt(BHEdata.dBorehole^2+BHEdata.dPipe2^2)/(sqrt(2)*BHEdata.dPipe2))/log(BHEdata.dBorehole/BHEdata.dPipe2) "auxillary variable for grout centre of mass";
 parameter Real segmentLength(
  quantity="Length",
  displayUnit="m") "length of pipe segment";
equation
  //convective resistances
  Rconv_inner.Rc=Radvective[1]/(nParallel*segmentLength);
  Rconv_annularInner.Rc=Radvective[2]/(nParallel*segmentLength);
  Rconv_annularOuter.Rc=Radvective[3]/(nParallel*segmentLength);
  connect(bottomReturnPort,outerPipe.flowPort_b) annotation(Line(points=0));
  connect(bottomSupplyPort,innerPipe.flowPort_a) annotation(Line(points=0));
  connect(topReturnPort,outerPipe.flowPort_a) annotation(Line(points=0));

  connect(topSupplyPort,innerPipe.flowPort_b) annotation(Line(points=0));
  connect(innerPipe.heatPort,Rconv_inner.fluid) annotation(Line(points=0));
  connect(Rconv_inner.solid,R_pipeToPipe.port_a) annotation(Line(points=0));
  connect(R_pipeToPipe.port_b,Rconv_annularInner.solid) annotation(Line(points=0));
  connect(Rconv_annularInner.fluid,thermalCollector1.port_a[2]) annotation(Line(points=0));
  connect(Rconv_annularOuter.fluid,thermalCollector1.port_a[1]) annotation(Line(points=0));
  connect(Rconv_annularOuter.solid,R_pipeToGrout.port_a) annotation(Line(points=0));
  connect(R_pipeToGrout.port_b,C_grout.port) annotation(Line(points=0));
  connect(C_grout.port,R_groutToWall.port_a) annotation(Line(points=0));
  connect(R_groutToWall.port_b,boreholeWallPort) annotation(Line(points=0));
  connect(thermalCollector1.port_b,outerPipe.heatPort) annotation(Line(points=0));
 annotation (
  Icon(graphics={
   Rectangle(
    fillColor={120,120,120},
    fillPattern=FillPattern.Solid,
    extent={{-60.2,100},{63.1,-100}}),
   Rectangle(
    fillColor={87,128,255},
    fillPattern=FillPattern.Solid,
    extent={{-50,100},{53.3,-100}}),
   Rectangle(
    fillColor={120,120,120},
    fillPattern=FillPattern.Solid,
    extent={{-33.3,100},{36.7,-100}}),
   Rectangle(
    fillColor={224,0,0},
    fillPattern=FillPattern.Solid,
    extent={{-23.3,100},{26.7,-100}})}),
  Documentation(info="<html>
<p>
Model of a coaxial borehole heat exchanger segment
</p>



</html>"),
  experiment(
   StopTime=1,
   StartTime=0,
   Tolerance=1e-06,
   Interval=0.002));
end CoaxSegment;