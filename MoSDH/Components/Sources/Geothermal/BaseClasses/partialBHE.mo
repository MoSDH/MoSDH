within MoSDH.Components.Sources.Geothermal.BaseClasses;
partial model partialBHE "base class for borehole heat exchangers"
 MoSDH.Utilities.Interfaces.SupplyPort supplyPort(medium=medium) "connection to supply line" annotation(Placement(
  transformation(
   origin={-60,90},
   extent={{-10,-10},{10,10}}),
  iconTransformation(extent={{-60,190},{-40,210}})));
 MoSDH.Utilities.Interfaces.ReturnPort returnPort(medium=medium) "connection to return line" annotation(Placement(
  transformation(
   origin={-10,90},
   extent={{-10,-10},{10,10}}),
  iconTransformation(extent={{40,190},{60,210}})));
 Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a boreholeWallPort[nSegments] "thermal coupling of local and global solution" annotation(Placement(
  transformation(
   origin={5,20},
   extent={{-10,-10},{10,10}}),
  iconTransformation(extent={{86.7,-10},{106.7,10}})));
 parameter Integer nSegments "Number of segments";
 outer parameter Integer iGroutChange "Index of the first element of the main/lower grout section.";
 parameter Modelica.Units.SI.Length segmentLengths[nSegments] "Vector containing length of each segment";
 parameter Integer nParallel=1 "Number of BHEs represented by this component";
 replaceable parameter MoSDH.Parameters.BoreholeHeatExchangers.DoubleU_DN32 BHEdata constrainedby
    MoSDH.Parameters.BoreholeHeatExchangers.BHEparameters                                                                                               annotation(choicesAllMatching=true);
 replaceable parameter MoSDH.Parameters.Grouts.Grout15 groutData constrainedby
    MoSDH.Parameters.Grouts.GroutPartial                                                                            annotation (
  choicesAllMatching=true,
  Dialog(
   group="Borehole Heat Exchangers",
   tab="Design",
   enable=BHEmodeIsUsed));
 replaceable parameter MoSDH.Parameters.Grouts.Grout15 groutDataUpper constrainedby
    MoSDH.Parameters.Grouts.GroutPartial                                                                                 "Grout dataset" annotation (
  choicesAllMatching=true,
  Dialog(
   group="Borehole Heat Exchangers",
   tab="Design",
   enable=(useUpperGroutSection and BHEmodeIsUsed)));
 replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby
    Modelica.Thermal.FluidHeatFlow.Media.Medium                                                                                    annotation(choicesAllMatching=true);
 parameter Modelica.Units.SI.Temperature TinitialGrout[nSegments]=283.15 "initial BHE temperature";
 parameter Modelica.Units.SI.Temperature TinitialSupply[nSegments]=TinitialGrout "Supply initial fluid temperature";
 parameter Modelica.Units.SI.Temperature TinitialReturn[nSegments]=TinitialGrout "Return initial fluid temperature";
 outer parameter Modelica.Units.SI.Length BHElength "Length of BHEs" annotation(Dialog(
  group="Dimensions",
  tab="Design"));
 Modelica.Units.SI.Temperature Tsupply=supplyPort.h/medium.cp "BHE supply temperature";
 Modelica.Units.SI.Temperature Treturn=returnPort.h/medium.cp "BHE return temperature";
 Modelica.Units.SI.VolumeFlowRate volFlow=supplyPort.m_flow/(medium.rho*
        nParallel) "Volume flow rate through a single BHE";
 annotation(Icon(
  coordinateSystem(extent={{-100,-200},{100,200}}),
  graphics={
  Rectangle(
   lineColor={127,127,127},
   fillColor={192,192,192},
   fillPattern=FillPattern.Solid,
   extent={{-103.3,200},{100,-200}})}));
end partialBHE;
