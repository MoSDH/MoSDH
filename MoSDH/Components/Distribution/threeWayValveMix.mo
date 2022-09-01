within MoSDH.Components.Distribution;
model threeWayValveMix "3 way valve with mixing volume and simple linear Ã¼ressure drop"
 import Mode = MoSDH.Utilities.Types.ValveOpeningModes;
 MoSDH.Utilities.Interfaces.FluidPort flowPort_a(medium=medium) "Residual port volFlow=f(1-y) " annotation(Placement(
  transformation(extent={{30,40},{50,60}}),
  iconTransformation(
   origin={46.7,0},
   extent={{-10,-10},{10,10}},
   rotation=180)));
 MoSDH.Utilities.Interfaces.FluidPort flowPort_b(medium=medium) "Controlled port volFlow=f(y)" annotation(Placement(
  transformation(extent={{-110,40},{-90,60}}),
  iconTransformation(extent={{-60,-10},{-40,10}})));
 MoSDH.Utilities.Interfaces.FluidPort flowPort_c(medium=medium) "Open port" annotation(Placement(
  transformation(extent={{-40,85},{-20,105}}),
  iconTransformation(extent={{-10,40},{10,60}})));
 Modelica.Units.SI.VolumeFlowRate volFlowB=flowPort_b.m_flow/medium.rho "Volume flow rate at port b";
 Modelica.Units.SI.VolumeFlowRate volFlowA=flowPort_a.m_flow/medium.rho "Volume flow rate at port a";
 Modelica.Units.SI.VolumeFlowRate volFlowC=flowPort_c.m_flow/medium.rho "Volume flow rate at port c";
 Modelica.Units.SI.Temperature Ta=flowPort_a.h/medium.cp "Temperature at port a";
 Modelica.Units.SI.Temperature Tb=flowPort_b.h/medium.cp "Temperature at port b";
 Modelica.Units.SI.Temperature Tc=flowPort_c.h/medium.cp "Temperature at port c";
 Modelica.Units.SI.Temperature T(
  start=Tinitial,
  fixed=true) "Temperature of medium";
 replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby
    Modelica.Thermal.FluidHeatFlow.Media.Medium                                                                                    "Heat carrier fluid" annotation(choicesAllMatching=true);
 Mode controlMode=Mode.free "Define closed ports" annotation(Dialog(tab="Control"));
 parameter Modelica.Units.SI.VolumeFlowRate V_flowNom=0.01 "Nominal volume flow rate";
 parameter Modelica.Units.SI.Pressure dpNom=1000 "Standard pressure drop of open ports at nominal volume flow";
 parameter Modelica.Units.SI.VolumeFlowRate V_leakage=V_flowNom*0.01 "Leakage volume flow at dp0";
 parameter Modelica.Units.SI.Pressure dp0=dpNom*1e-2 "Leakage pressure drop";
 parameter Modelica.Units.SI.Time tau=300 "Time constant for first order filter";
 parameter Modelica.Units.SI.Temperature Tinitial(displayUnit="degC")=293.15 "Initial temperature of medium" annotation(Dialog(enable=m>Modelica.Constants.small));
protected
  Modelica.Units.SI.PressureDifference p "Inpternal pressure";
  parameter Modelica.Units.SI.Mass m(min=1)=V_flowNom*medium.rho*tau "Mass of medium";
equation
  //Mass balance
  flowPort_a.m_flow+flowPort_b.m_flow+flowPort_c.m_flow=0;

  //Energy balance
  flowPort_a.H_flow+flowPort_b.H_flow+flowPort_c.H_flow=m*medium.cp*der(T);

  //ports
  flowPort_a.H_flow = semiLinear(flowPort_a.m_flow,flowPort_a.h,T*medium.cp);
  flowPort_b.H_flow = semiLinear(flowPort_b.m_flow,flowPort_b.h,T*medium.cp);
  flowPort_c.H_flow = semiLinear(flowPort_c.m_flow,flowPort_c.h,T*medium.cp);

  if controlMode==Mode.closeA then
    flowPort_a.p=p+volFlowA/V_leakage*dp0;
    flowPort_b.p=p+volFlowB/V_flowNom*dpNom;
    flowPort_c.p=p+volFlowC/V_flowNom*dpNom;
  elseif controlMode==Mode.closeB then
    flowPort_a.p=p+volFlowA/V_leakage*dpNom;
    flowPort_b.p=p+volFlowB/V_flowNom*dp0;
    flowPort_c.p=p+volFlowC/V_flowNom*dpNom;
  elseif controlMode==Mode.closeC then
    flowPort_a.p=p+volFlowA/V_leakage*dpNom;
    flowPort_b.p=p+volFlowB/V_flowNom*dpNom;
    flowPort_c.p=p+volFlowC/V_flowNom*dp0;
  else
    flowPort_a.p=p+volFlowA/V_leakage*dpNom;
    flowPort_b.p=p+volFlowB/V_flowNom*dpNom;
    flowPort_c.p=p+volFlowC/V_flowNom*dpNom;
  end if;
 annotation (
  defaultComponentName="valve",
  Icon(
   coordinateSystem(extent={{-50,-50},{50,50}}),
   graphics={
    Line(
     points={{-50,0},{46.7,0}},
     thickness=1),
    Line(
     points={{0,0},{0,50}},
     thickness=1),
    Polygon(
     points={{0.7,0},{-46,33.3},{-46,-33.3}},
     fillPattern=FillPattern.Solid),
    Polygon(
     points={{1.3,-0.2},{48,33.1},{48,-33.5}},
     fillPattern=FillPattern.Solid),
    Polygon(
     points={{-31.1,0},{15.6,33.3},{15.6,-33.3}},
     fillPattern=FillPattern.Solid,
     origin={-0.6,31.3},
     rotation=90),
    Polygon(
     points={{-10,0},{-39.7,20},{-39.7,-20}},
     fillColor={255,255,255},
     fillPattern=FillPattern.Solid),
    Polygon(
     points={{12.1,0.3},{41.8,20.3},{41.8,-19.7}},
     fillColor={255,255,255},
     fillPattern=FillPattern.Solid),
    Polygon(
     points={{19.8,0},{-9.9,20},{-9.9,-20}},
     fillColor={255,255,255},
     fillPattern=FillPattern.Solid,
     origin={-0.1,31.3},
     rotation=-90)}),
  experiment(
   StopTime=1,
   StartTime=0,
   Tolerance=1e-06,
   Interval=0.001));
end threeWayValveMix;