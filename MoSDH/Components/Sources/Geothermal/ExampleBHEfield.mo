within MoSDH.Components.Sources.Geothermal;
model ExampleBHEfield "ExampleBHEfield"
 extends Modelica.Icons.Example;
 import HPoperationModes = MoSDH.Utilities.Types.OperationModes;
 Storage.BoreholeStorage.BTES boreholes(
  nBHEs=100,
  BHElength=150,
  nBHEsInSeries=2,
  BHEspacing=10,
  volFlowRef(displayUnit="mÂ³/s")=-heatPump.volFlowSource) annotation(Placement(transformation(
  origin={-30,-25},
  extent={{-20,-20},{20,20}})));
 Electric.HeatPump heatPump(
  mediumSource=boreholes.medium,
  setAbsoluteSourcePressure=true,
  redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water mediumLoad,
  setAbsoluteLoadPressure=false,
  TminSource=268.15,
  TmaxLoad=363.15,
  TminLoad=303.15,
  MiminumShift(displayUnit="K")=20,
  HPdataFile=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatPump/Viessmann_Vitocal_350AHT147.txt"),
  mode=MoSDH.Utilities.Types.ControlTypesHeatPump.SourceFlowRate,
  Pref=PthermalRef,
  Tref=TsupplyRef,
  volFlowRef(displayUnit="mÂ³/s")=boreholes.nBHEs * 0.0005 / boreholes.nBHEsInSeries,
  DeltaTref=5) annotation(Placement(transformation(
  origin={38,20},
  extent={{-20,-20},{20,20}})));
 Distribution.HydraulicShunt hydraulicShunt(
  medium=boreholes.medium,
  setAbsolutePressure=false) annotation(Placement(transformation(
  origin={-2,20},
  extent={{-10,-10},{10,10}})));
 Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot1(
  redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium,
  Tsource=298.15,
  pSource=100000) annotation(Placement(transformation(extent={{88,20},{98,30}})));
 Utilities.FluidHeatFlow.fluidSourceCold fluidSourceCold1(
  redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium,
  Tsource=298.15,
  pSource=100000) annotation(Placement(transformation(extent={{88,10},{98,20}})));
 Modelica.Blocks.Tables.CombiTable1Dv monthlyHeatShare(
  table={{0, 0.1283}, {2678400, 0.1122}, {5097600, 0.1055}, {7776000, 0.0821}, {10368000, 0.0626}, {13046400, 0.0475}, {15638400, 0.0429}, {18316800, 0.0435}, {20995200, 0.0609}, {23587200, 0.0848}, {26265600, 0.1043}, {28857600, 0.1247}},
  smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments) annotation(Placement(visible = true, transformation(extent = {{59, -39}, {79, -19}}, rotation = 0)));
 parameter Modelica.Units.SI.Temperature TsupplyRef=323.15 "Reference supply temperature";
 parameter Modelica.Units.SI.Temperature TboreholeMin=heatPump.TminSource "Minimum allowed entrance temperature of boreholes";
 parameter Modelica.Units.SI.Energy QloadAnnual=3600000000000.0 "Annual heat demand";
 HPoperationModes HPmode "Heat pump operation mode";
 Modelica.Units.SI.Temperature Tmean "Mean BHE temperature";
 Modelica.Units.SI.Power PthermalRef(displayUnit="MW") "Reference thermal power of heat pump";
 Modelica.Units.SI.Power PthermalDemand "Heat load (monthly average)";
 Modelica.Blocks.Sources.RealExpression timeOfTheYear(y= mod(time,8760*3600)) annotation(
    Placement(visible = true, transformation(origin = {34, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial algorithm
 //Dtermine the initial operation mode of the heat pump
  if min(boreholes.TboreholeWall) > TboreholeMin + 1.5 then
      HPmode := HPoperationModes.FullLoad;
    elseif min(boreholes.TboreholeWall) > TboreholeMin + 0.5 then
      HPmode := HPoperationModes.PartLoad;
    else
      HPmode := HPoperationModes.Idle;
    end if;
algorithm
//switch between heat pump operation modes according to the minimum borehole wall temperatures
  when HPmode == HPoperationModes.FullLoad and min(boreholes.TboreholeWall) < TboreholeMin + 1 then
      HPmode := HPoperationModes.PartLoad;
    elsewhen HPmode == HPoperationModes.PartLoad and min(boreholes.TboreholeWall) < TboreholeMin then
      HPmode := HPoperationModes.Idle;
    elsewhen HPmode == HPoperationModes.Idle and min(boreholes.TboreholeWall) > TboreholeMin + 0.5 then
      HPmode := HPoperationModes.PartLoad;
    elsewhen HPmode == HPoperationModes.PartLoad and min(boreholes.TboreholeWall) > TboreholeMin + 1.5 then
      HPmode := HPoperationModes.FullLoad;
    end when;
equation
  // Mean fluid temperatur in the BHEs
    Tmean = (boreholes.Tsupply + boreholes.Treturn) / 2;
    // Monthly extraction power
    PthermalDemand = monthlyHeatShare.y[1] * QloadAnnual /(8760*3600/12);
  //Heat pump operation modes
    if HPmode == HPoperationModes.Idle then
      //Turn HP off
      PthermalRef = 0;
    elseif HPmode == HPoperationModes.PartLoad then
      // Modulate (reduce) extraction power close to the minimum allowed borehole wall temperature
      PthermalRef = PthermalDemand * min(1, max(0.1, (min(boreholes.TboreholeWall) - TboreholeMin) / 1));
    else
      // Full extraction power
      PthermalRef = PthermalDemand;
    end if;
    
    connect(heatPump.supplyPortLoad, fluidSourceHot1.fluidPort) annotation (
      Line(points = {{57.67, 25}, {62.67, 25}, {82.97, 25}, {87.97, 25}}, color = {255, 0, 0}, thickness = 1));
    connect(heatPump.returnPortLoad, fluidSourceCold1.fluidPort) annotation (
      Line(points = {{57.67, 15}, {62.67, 15}, {82.97, 15}, {87.97, 15}}, color = {0, 0, 255}, thickness = 1));
    connect(hydraulicShunt.loadSupply, heatPump.supplyPortSource) annotation (
      Line(points = {{8, 25}, {13, 25}, {18, 25}}, color = {255, 0, 0}, thickness = 1));
    connect(hydraulicShunt.loadReturn, heatPump.returnPortSource) annotation (
      Line(points = {{7.67, 15}, {12.67, 15}, {12.97, 15}, {17.97, 15}}, color = {0, 0, 255}, thickness = 1));
    connect(hydraulicShunt.sourceSupply, boreholes.supplyPort) annotation (
      Line(points = {{-12, 25}, {-17, 25}, {-40, 25}, {-40, 0}, {-40, -5}}, color = {255, 0, 0}, thickness = 1));
    connect(hydraulicShunt.sourceReturn, boreholes.returnPort) annotation (
      Line(points = {{-12, 15}, {-17, 15}, {-20, 15}, {-20, 0}, {-20, -5}}, color = {0, 0, 255}, thickness = 1));
  connect(timeOfTheYear.y, monthlyHeatShare.u[1]) annotation(
    Line(points = {{46, -28}, {58, -28}}, color = {0, 0, 127}));
  //Verbindungen zum Bus-System
 annotation (
  __OpenModelica_simulationFlags(
   lv="LOG_STATS",
   s="dassl"),
  __OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian -d=nonewInst ",
  Icon(coordinateSystem(extent={{-110,-100},{100,100}})),
  Diagram(coordinateSystem(extent={{-150,-100},{150,100}})),
  Documentation(info= "<html><head></head><body><h2>Example borehole heat exchanger field</h2><div>Example model for the BTES component :</div><div><ul><li>A BHE field of 10 x 10 double-U BHEs is coupled to a heat pump.</li><li>The thermal power of the heat pump (load side) is defined by the absolute annual heat demand (parameter QloadAnnual) and a monthly profile (monthlyHeatShare).</li><li>The heat pump is operated in <b>mode</b> SourceFlowRate&nbsp;for which the following signals have to be defined in the control tab:</li><ul><li>source side volume flow rate <b>volFlow</b></li><li>load side supply temperature <b>Tref</b>&nbsp;</li><li>load side thermal power <b>Pref</b>.</li></ul><li>A shunt is used for hydraulic decoupling of the BHEs and the HP. Since both components have internal circulation pumps, the hydraulic circuit would be overdetermined otherwiese</li><li>The heat pumps capacity is larger than the heating power defined by the power map in <b>HPdataFile</b> (<b>constrainPower</b>=false) to allow for changing of the system dimensions without changing the HP data sheet.</li><li>During each month, the heat pump operates with constant powerat PthermalRef,&nbsp;which is caluclated by the annual demand, and the monthly profile.</li><li>If the minimum borehole wall temperature gets close to the threshold defined by <b>TboreholeMin</b>&nbsp;the heat pump power is modulated down to 10%.</li><li>If the threshold is surpassed the heat pump is switched off.</li></ul>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: Inlet, outlet and mean BHE teamperature over 25 years.</strong></caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/BHEfieldExample.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>
</div></body></html>"),
  experiment(
   StopTime = 7.884e+08,
   StartTime=0,
   Tolerance=0.0001,
   Interval=86400));
end ExampleBHEfield;
