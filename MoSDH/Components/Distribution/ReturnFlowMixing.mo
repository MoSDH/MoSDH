within MoSDH.Components.Distribution;
model ReturnFlowMixing "Return-flow mixing for lowering of supply temperatures"
 MoSDH.Utilities.Interfaces.ReturnPort returnPortLoad(medium=medium) "Inlet for cold water for cooling" annotation(Placement(
  transformation(extent={{110,-110},{130,-90}}),
  iconTransformation(extent={{86.7,-60},{106.7,-40}})));
 MoSDH.Utilities.Interfaces.SupplyPort supplyPortSource(medium=medium) "Inlet for hot water to be cooled" annotation(Placement(
  transformation(extent={{-75,75},{-55,95}}),
  iconTransformation(extent={{-110,40},{-90,60}})));
 MoSDH.Utilities.Interfaces.ReturnPort returnPortSource(medium=medium) "Remaining cold water outlet" annotation(Placement(
  transformation(extent={{-85,-110},{-65,-90}}),
  iconTransformation(extent={{-110,-60},{-90,-40}})));
 MoSDH.Utilities.Interfaces.SupplyPort supplyPortLoad(medium=medium) "Outlet port for mixing" annotation(Placement(
  transformation(extent={{95,75},{115,95}}),
  iconTransformation(extent={{86.7,40},{106.7,60}})));
 parameter Modelica.Units.SI.VolumeFlowRate V_flowNom=0.01 "Nominal volume flow rate";
 parameter Modelica.Units.SI.Time tau=300 "Time constant for dynamic behaviour";
 parameter Modelica.Units.SI.VolumeFlowRate V_flowLoadmin=V_flowNom*0.01 "Mnimum remaining volume flow on load side";
 parameter Modelica.Units.SI.Temperature deltaTmin(min=0.1)=0.5 "Accepted temperature difference (Tsupply-Tref)";
 parameter Modelica.Units.SI.Temperature TinitialSupply(displayUnit="degC")=333.15 "Initial temperature of medium";
 parameter Modelica.Units.SI.Temperature TinitialReturn(displayUnit="degC")=293.15 "Initial temperature of medium";
 Modelica.Units.SI.VolumeFlowRate volFlowSource "Source side volume flow rate";
 Modelica.Units.SI.VolumeFlowRate volFlowLoad "Load side volume flow rate";
 Modelica.Units.SI.VolumeFlowRate volFlowMix "Return flow mixing volume flow rate";
 Modelica.Units.SI.Temperature TsupplyLoad(displayUnit="degC")=supplyPortLoad.h/medium.cp "Supply temperature on load side";
 Modelica.Units.SI.Temperature TsupplySource(displayUnit="degC")=supplyPortSource.h/medium.cp "Supply temperature on source side";
 Modelica.Units.SI.Temperature TreturnSource(displayUnit="degC")=returnPortSource.h/medium.cp "Return temperature on source side";
 Modelica.Units.SI.Temperature TreturnLoad(displayUnit="degC")=returnPortLoad.h/medium.cp "Return temperature on load side";
 replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby
    Modelica.Thermal.FluidHeatFlow.Media.Medium                                                                                    "Medium" annotation(choicesAllMatching=true);
 threeWayValveMix supplyValve(
  medium=medium,
  controlMode=MoSDH.Utilities.Types.ValveOpeningModes.free,
  V_flowNom=V_flowNom,
  tau=tau,
  Tinitial=TinitialSupply) annotation(Placement(transformation(extent={{30,90},{20,80}})));
 threeWayValveMix returnValve(
  medium=medium,
  controlMode=MoSDH.Utilities.Types.ValveOpeningModes.free,
  V_flowNom=V_flowNom,
  tau=tau,
  Tinitial=TinitialReturn) annotation(Placement(transformation(extent={{30,-105},{20,-95}})));
 Modelica.Blocks.Sources.RealExpression realExpression1 annotation(Placement(transformation(extent={{-60,-25},{-40,-5}})));
 Modelica.Units.SI.Temperature Tref=333.15 "Reference supply temperature" annotation(Dialog(
  group="Setpoint",
  tab="Control"));
protected
  Modelica.Units.SI.MassFlowRate m_flowMix "Cold mass flow for mixing";
  Modelica.Units.SI.VolumeFlowRate volFlowSet;
public
  Pump pump1(
   medium=medium,
   volFlowRef=volFlowSet) annotation(Placement(transformation(
   origin={25,-10},
   extent={{-5,-5},{5,5}},
   rotation=90)));
equation
   m_flowMix= if noEvent(TsupplySource-Tref<deltaTmin) then 0 else  max(0,min(max(returnPortLoad.m_flow-V_flowLoadmin*medium.rho,0),returnPortLoad.m_flow*(TsupplySource-Tref)/max(3,TsupplySource-TreturnLoad)));
   volFlowSet=volFlowMix;
   volFlowSource=supplyPortSource.m_flow/medium.rho;
   volFlowLoad=returnPortLoad.m_flow/medium.rho;
   volFlowMix=m_flowMix/medium.rho;

   connect(returnPortLoad,returnValve.flowPort_b) annotation(Line(
    points={{120,-100},{115,-100},{35,-100},{30,-100}},
    color={0,0,255},
    thickness=1));
   connect(returnPortSource,returnValve.flowPort_a) annotation(Line(
    points={{-75,-100},{-70,-100},{20.33,-100},{20.33,-100}},
    color={0,0,255},
    thickness=1));
   connect(supplyPortSource,supplyValve.flowPort_a) annotation(Line(
    points={{-65,85},{-60,85},{20.33,85},{20.33,85}},
    color={255,0,0},
    thickness=1));
   connect(supplyPortLoad,supplyValve.flowPort_b) annotation(Line(
    points={{105,85},{100,85},{35,85},{30,85}},
    color={255,0,0},
    thickness=1));
   connect(returnValve.flowPort_c,pump1.flowPort_a) annotation(Line(
    points={{25,-95},{25,-90},{25,-20},{25,-15}},
    thickness=0.0625));
   connect(supplyValve.flowPort_c,pump1.flowPort_b) annotation(Line(
    points={{25,80},{25,75},{25,-5.33},{25,-5.33}},
    thickness=0.0625));
 annotation (
  defaultComponentName="rfm",
  Icon(
   coordinateSystem(preserveAspectRatio=false),
   graphics={
       Bitmap(
        imageSource="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
AABJRU5ErkJggg==",
        extent={{-100,-99.40000000000001},{100,99.40000000000001}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
MoBTES model of the BrÃ¦dtrup BTES system:
</p>
<ul>
<li>Monitoring data for the first 1680 days of BTES operation (inlet and outlet temperatures and volume flow on a 5 minute basis)</li>
<li>48 BHEs each 45 m long</li>
<li>6 BHEs in series</li>
<li>Charging from center BHEs to outer BHEs/ reversal of flow for discharging</li>
<li>(Aggregated) thermal properties of the subsurface after <a href=\"modelica://MoBTES.UsersGuide.References\">[Tordrup2017]</a></li>
<li>Parametrization of the grout, BHEs and top insulation after <a href=\"modelica://MoBTES.UsersGuide.References\">[SÃ¸rensen2013]</a></li>
<li>Consideration of the distance between the BTES and monitoring sensors by pipe elements</li>
</ul>


</html>"),
  experiment(
   StopTime=630000000,
   StartTime=0,
   Tolerance=1e-06,
   Interval=3600));
end ReturnFlowMixing;