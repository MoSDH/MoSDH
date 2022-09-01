within MoSDH.Components.Sources.Geothermal.BaseClasses;
partial model BHEsegment_partial "common elements of BHE types"
 MoSDH.Utilities.Interfaces.SupplyPort topSupplyPort(medium=medium) "BHE opening at top of section" annotation(Placement(
  transformation(
   origin={-125,95},
   extent={{-10,-10},{10,10}}),
  iconTransformation(extent={{-60,90},{-40,110}})));
 MoSDH.Utilities.Interfaces.ReturnPort topReturnPort(medium=medium) "BHE opening at the bottom of section" annotation(Placement(
  transformation(
   origin={85,95},
   extent={{-10,-10},{10,10}}),
  iconTransformation(extent={{40,90},{60,110}})));
 Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a boreholeWallPort "thermal coupling of local and global solution" annotation(Placement(
  transformation(
   origin={-20,-35},
   extent={{-10,-10},{10,10}}),
  iconTransformation(extent={{86.7,-10},{106.7,10}})));
 MoSDH.Utilities.Interfaces.WarmPort bottomReturnPort(medium=medium) "Filled flow port (used upstream)" annotation(Placement(
  transformation(
   origin={85,5},
   extent={{-10,-10},{10,10}}),
  iconTransformation(extent={{40,-106.7},{60,-86.7}})));
 MoSDH.Utilities.Interfaces.WarmPort bottomSupplyPort(medium=medium) "Hollow flow port (used downstream)" annotation(Placement(
  transformation(
   origin={-125,5},
   extent={{-10,-10},{10,10}}),
  iconTransformation(extent={{-60,-106.7},{-40,-86.7}})));
 Modelica.Blocks.Interfaces.RealInput Radvective[if BHEdata.nShanks==0 then 3 else 1] annotation(Placement(
  transformation(extent={{-105,0},{-85,20}}),
  iconTransformation(extent={{-110,-10},{-90,10}})));
 replaceable parameter MoSDH.Parameters.BoreholeHeatExchangers.DoubleU_DN32 BHEdata constrainedby
    MoSDH.Parameters.BoreholeHeatExchangers.BHEparameters annotation(choicesAllMatching=true);
 replaceable parameter MoSDH.Parameters.Grouts.Grout15 groutData constrainedby
    MoSDH.Parameters.Grouts.GroutPartial annotation(choicesAllMatching=true);
 replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby
    Modelica.Thermal.FluidHeatFlow.Media.Medium annotation(choicesAllMatching=true);
 parameter Integer nParallel=1 "Number of BHEs represented by this component";
  parameter Modelica.Units.SI.Temperature TinitialGrout=283.14999999999998
    "initial BHE temperature";
  parameter Modelica.Units.SI.Temperature TinitialSupply=TinitialGrout
    "Supply initial fluid temperature";
  parameter Modelica.Units.SI.Temperature TinitialReturn=TinitialGrout
    "Return initial fluid temperature";
 annotation(Icon(graphics={
 Rectangle(
  lineColor={127,127,127},
  fillColor={192,192,192},
  fillPattern=FillPattern.Solid,
  extent={{-100,100},{100,-100}})}));
end BHEsegment_partial;