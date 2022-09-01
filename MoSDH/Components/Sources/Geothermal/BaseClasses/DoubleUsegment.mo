within MoSDH.Components.Sources.Geothermal.BaseClasses;
model DoubleUsegment "Double-U borehole heat exchanger"
 extends MoSDH.Components.Sources.Geothermal.BaseClasses.BHEsegment_partial;
  MoSDH.Components.Utilities.FluidHeatFlow.Pipe returnPipe(
    medium=medium,
    m=2*nParallel*((BHEdata.dPipe1/2 - BHEdata.tPipe1)^2*Modelica.Constants.pi*
        segmentLength*medium.rho),
    T0=TinitialReturn,
    T0fixed=true,
    tapT=0.5,
    V_flowLaminar=2*nParallel*580*(BHEdata.dPipe1 - 2*BHEdata.tPipe1)*Modelica.Constants.pi
        *medium.nu,
    dpLaminar=74240*segmentLength*medium.nu^2*medium.rho/((BHEdata.dPipe1 - 2*
        BHEdata.tPipe1)^3),
    V_flowNominal=2*nParallel*6250*(BHEdata.dPipe1 - 2*BHEdata.tPipe1)*Modelica.Constants.pi
        *medium.nu,
    dpNominal=7.86324*1e+06*segmentLength*medium.nu^2*medium.rho/((BHEdata.dPipe1
         - 2*BHEdata.tPipe1)^3),
    useHeatPort=true,
    h_g=0) "annular gap of coaxial pipe" annotation (Placement(transformation(
        origin={80,55},
        extent={{-10,-10},{10,10}},
        rotation=-90)));
  MoSDH.Components.Utilities.FluidHeatFlow.Pipe supplyPipe(
    medium=medium,
    m=2*nParallel*((BHEdata.dPipe1/2 - BHEdata.tPipe1)^2*Modelica.Constants.pi*
        segmentLength*medium.rho),
    T0=TinitialSupply,
    T0fixed=true,
    tapT=0.5,
    V_flowLaminar=2*nParallel*580*(BHEdata.dPipe1 - 2*BHEdata.tPipe1)*Modelica.Constants.pi
        *medium.nu,
    dpLaminar=74240*segmentLength*medium.nu^2*medium.rho/((BHEdata.dPipe1 - 2*
        BHEdata.tPipe1)^3),
    V_flowNominal=2*nParallel*6250*(BHEdata.dPipe1 - 2*BHEdata.tPipe1)*Modelica.Constants.pi
        *medium.nu,
    dpNominal=7.86324*1e+06*segmentLength*medium.nu^2*medium.rho/((BHEdata.dPipe1
         - 2*BHEdata.tPipe1)^3),
    useHeatPort=true,
    h_g(displayUnit="m") = 0) "inner pipe of coaxial pipe" annotation (
      Placement(transformation(
        origin={-120,55},
        extent={{-10,-10},{10,10}},
        rotation=90)));
 Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C_grout_supply(
  C=2*nParallel*Modelica.Constants.pi*((BHEdata.dBorehole/2)^2-4*(BHEdata.dPipe1/2)^2)/4*groutData.cp*groutData.rho*segmentLength,
  T(
   start=TinitialGrout,
   fixed=true)) annotation(Placement(transformation(extent={{-60,70},{-40,90}})));
 Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C_grout_return(
  C=2*nParallel*Modelica.Constants.pi*((BHEdata.dBorehole/2)^2-4*(BHEdata.dPipe1/2)^2)/4*groutData.cp*groutData.rho*segmentLength,
  T(
   start=TinitialGrout,
   fixed=true)) annotation(Placement(transformation(extent={{-5,70},{15,90}})));
 Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor convectiveResistorSupply annotation(Placement(transformation(extent={{-90,45},{-110,65}})));
 Modelica.Thermal.HeatTransfer.Components.ConvectiveResistor convectiveResistorReturn annotation(Placement(transformation(extent={{50,45},{70,65}})));
 Modelica.Thermal.HeatTransfer.Components.ThermalResistor R_groutToGrout(R=((2*(1-x_grout_center)*R_grout_spec*(R_pipeToPipe_spec-2*x_grout_center*R_grout_spec))/(2*(1-x_grout_center)*R_grout_spec-R_pipeToPipe_spec+2*x_grout_center*R_grout_spec))/(2*nParallel*segmentLength)) annotation(Placement(transformation(extent={{-35,55},{-15,75}})));
 Modelica.Thermal.HeatTransfer.Components.ThermalResistor R_fluidToGrout_supply(R=(log(BHEdata.dPipe1/(BHEdata.dPipe1-2*BHEdata.tPipe1))/(2*Modelica.Constants.pi*BHEdata.lamda1)+x_grout_center*R_grout_spec)/(2*nParallel*segmentLength)) annotation(Placement(transformation(extent={{-80,45},{-60,65}})));
 Modelica.Thermal.HeatTransfer.Components.ThermalResistor R_fluidToGrout_return(R=(log(BHEdata.dPipe1/(BHEdata.dPipe1-2*BHEdata.tPipe1))/(2*Modelica.Constants.pi*BHEdata.lamda1)+x_grout_center*R_grout_spec)/(2*nParallel*segmentLength)) annotation(Placement(transformation(extent={{40,45},{20,65}})));
 Modelica.Thermal.HeatTransfer.Components.ThermalResistor R_groutToWall_supply(R=(1-x_grout_center)*R_grout_spec/(2*nParallel*segmentLength)) annotation(Placement(transformation(
  origin={-50,25},
  extent={{-10,-10},{10,10}},
  rotation=-90)));
 Modelica.Thermal.HeatTransfer.Components.ThermalResistor R_groutToWall_return(R=(1-x_grout_center)*R_grout_spec/(2*nParallel*segmentLength)) annotation(Placement(transformation(
  origin={5,25},
  extent={{-10,-10},{10,10}},
  rotation=-90)));
 parameter Real x_grout_center(
  min=0,
  max=1)=MoSDH.Components.Storage.BoreholeStorage.Functions.xGroutCenter_2U(BHEdata,groutData) "auxillary variable for grout centre of mass";
 parameter Real R_grout_spec=Modelica.Math.acosh((BHEdata.dBorehole^2+BHEdata.dPipe1^2-BHEdata.spacing^2)/(2*BHEdata.dBorehole*BHEdata.dPipe1))/(2*Modelica.Constants.pi*groutData.lamda)*(3.098-4.432*BHEdata.spacing/BHEdata.dBorehole+2.364*BHEdata.spacing^2/BHEdata.dBorehole^2);
 parameter Real R_pipeToPipe_spec=Modelica.Math.acosh((BHEdata.spacing^2-BHEdata.dPipe1^2)/(BHEdata.dPipe1^2))/(2*Modelica.Constants.pi*groutData.lamda);
 parameter Real segmentLength(
  quantity="Length",
  displayUnit="m") "length of pipe segment" annotation(Dialog(tab="BHE"));
initial algorithm
  assert(BHEdata.nShanks==2,"Incompatible BHE record. Number of shanks has to be 2 for double-U BHEs!",level=AssertionLevel.error);
equation
  //convective resistances
  convectiveResistorSupply.Rc=Radvective[1]/(2*nParallel*segmentLength);
  convectiveResistorReturn.Rc=Radvective[1]/(2*nParallel*segmentLength);
  //fluid ports
  connect(bottomReturnPort,returnPipe.flowPort_b) annotation(Line(
   points={{85,5},{80,5},{80,40},{80,45}},
   color=DynamicSelect({255,0,0},if time>0.000000 then
                                                      {255,0,0} else
                                                                    if time>0.000000 then
                                                                                         {255,0,0} else
                                                                                                      {0,0,255}),
   thickness=0.0625));
  connect(bottomSupplyPort,supplyPipe.flowPort_a) annotation(Line(
   points={{-125,5},{-120,5},{-120,40},{-120,45}},
   color=DynamicSelect({255,0,0},if time>0.000000 then
                                                      {255,0,0} else
                                                                    if time>0.000000 then
                                                                                         {255,0,0} else
                                                                                                      {0,0,255}),
   thickness=0.0625));
  connect(topReturnPort,returnPipe.flowPort_a) annotation(Line(
   points={{85,95},{80,95},{80,70},{80,65}},
   color=DynamicSelect({255,0,0},if time>0.000000 then
                                                      {255,0,0} else
                                                                    if time>0.000000 then
                                                                                         {255,0,0} else
                                                                                                      {0,0,255}),
   thickness=0.0625));

  connect(topSupplyPort,supplyPipe.flowPort_b) annotation(Line(
   points={{-125,95},{-120,95},{-120,70},{-120,65}},
   color=DynamicSelect({255,0,0},if time>0.000000 then
                                                      {255,0,0} else
                                                                    if time>0.000000 then
                                                                                         {255,0,0} else
                                                                                                      {0,0,255}),
   thickness=0.0625));
  connect(convectiveResistorReturn.fluid,returnPipe.heatPort) annotation(Line(
   points={{70,55}},
   color={191,0,0},
   thickness=0.0625));
  connect(convectiveResistorSupply.fluid,supplyPipe.heatPort) annotation(Line(
   points={{-110,55}},
   color={191,0,0},
   thickness=0.0625));
  //TRCM
  connect(convectiveResistorReturn.solid,R_fluidToGrout_return.port_a) annotation(Line(
   points={{50,55},{45,55},{40,55}},
   color={191,0,0},
   thickness=0.0625));
  connect(convectiveResistorSupply.solid,R_fluidToGrout_supply.port_a) annotation(Line(
   points={{-90,55},{-85,55},{-80,55}},
   color={191,0,0},
   thickness=0.0625));

   //supply part
   connect(R_fluidToGrout_supply.port_b,C_grout_supply.port) annotation(Line(
   points={{-60,55},{-55,55},{-50,55},{-50,65},{-50,70}},
   color={191,0,0},
   thickness=0.0625));
   connect(C_grout_supply.port,R_groutToWall_supply.port_a) annotation(Line(
   points={{-50,70},{-50,65},{-50,40},{-50,35}},
   color={191,0,0},
   thickness=0.0625));
   connect(R_groutToWall_supply.port_b,boreholeWallPort) annotation(Line(
   points={{-50,15},{-50,10},{-50,-35},{-25,-35},{-20,-35}},
   color={191,0,0},
   thickness=0.0625));
   connect(C_grout_supply.port,R_groutToGrout.port_b) annotation(Line(
   points={{-50,70},{-50,65},{-10,65},{-15,65}},
   color={191,0,0},
   thickness=0.0625));
   //return part
   connect(R_fluidToGrout_return.port_b,C_grout_return.port) annotation(Line(
   points={{20,55},{15,55},{5,55},{5,65},{5,70}},
   color={191,0,0},
   thickness=0.0625));
   connect(C_grout_return.port,R_groutToWall_return.port_a) annotation(Line(
   points={{5,70},{5,65},{5,40},{5,35}},
   color={191,0,0},
   thickness=0.0625));
   connect(R_groutToWall_return.port_b,boreholeWallPort) annotation(Line(
   points={{5,15},{5,10},{5,-35},{-15,-35},{-20,-35}},
   color={191,0,0},
   thickness=0.0625));
   connect(C_grout_return.port,R_groutToGrout.port_a) annotation(Line(
   points={{5,70},{5,65},{-40,65},{-35,65}},
   color={191,0,0},
   thickness=0.0625));
 annotation (
  Icon(graphics={
   Rectangle(
    fillColor={150,150,150},
    fillPattern=FillPattern.Solid,
    extent={{38.5,99.8},{75.2,-100.2}}),
   Rectangle(
    fillColor={87,128,255},
    fillPattern=FillPattern.Solid,
    extent={{45.4,-100.2},{68.7,99.8}}),
   Rectangle(
    fillColor={150,150,150},
    fillPattern=FillPattern.Solid,
    extent={{-46.7,99.8},{-10,-100.2}}),
   Rectangle(
    fillColor={224,0,0},
    fillPattern=FillPattern.Solid,
    extent={{-40,-100.2},{-16.7,99.8}}),
   Rectangle(
    fillColor={150,150,150},
    fillPattern=FillPattern.Solid,
    extent={{-72.7,100},{-36,-100}}),
   Rectangle(
    fillColor={224,0,0},
    fillPattern=FillPattern.Solid,
    extent={{-66,-100},{-42.7,100}}),
   Rectangle(
    fillColor={150,150,150},
    fillPattern=FillPattern.Solid,
    extent={{16.2,100.1},{52.9,-99.90000000000001}}),
   Rectangle(
    fillColor={87,128,255},
    fillPattern=FillPattern.Solid,
    extent={{23.1,-99.90000000000001},{46.4,100.1}})}),
  Documentation(info="<html>
<p>
Model of a double-U borehole heat exchanger segment:
</p>



</html>"),
  experiment(
   StopTime=1,
   StartTime=0,
   Tolerance=1e-06,
   Interval=0.001));
end DoubleUsegment;