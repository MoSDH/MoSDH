within MoSDH.Components.Storage.PitStorage;
model PTES "Pit thermal energy storage with 3 ports"
 MoSDH.Utilities.Interfaces.WarmPort midPort(medium=medium) "Port used for warm fluid" annotation(Placement(
  transformation(extent={{-135,-10},{-115,10}}),
  iconTransformation(extent={{-410,-10},{-390,10}})));
 MoSDH.Utilities.Interfaces.SupplyPort topPort(medium=medium) "Source side flow" annotation(Placement(
  transformation(extent={{-135,15},{-115,35}}),
  iconTransformation(extent={{-410,40},{-390,60}})));
 MoSDH.Utilities.Interfaces.ReturnPort bottomPort(medium=medium) "Source side return" annotation(Placement(
  transformation(extent={{-135,-35},{-115,-15}}),
  iconTransformation(extent={{-410,-60},{-390,-40}})));
 MoSDH.Utilities.Interfaces.Weather weatherPort "Weather data connector" annotation(Placement(
  transformation(extent={{-85,-110},{-65,-90}}),
  iconTransformation(extent={{-10,-156.7},{10,-136.7}})));
 StratifiedTank.BaseClasses.StratifiedStorageVolume pit(
  medium=medium,
  beta=beta,
  buoyancyMode=buoyancyMode,
  tau=tau,
  elementHeights=pitLayerHeights,
  elementVolumes=fill(storageVolume / nLayers, nLayers),
  inclinationAngle=atan(slope),
  nLayers=nLayers,
  Tinitial=Tinitial,
  tInsulationWall=tInsulationWall,
  tInsulationLid=0.05,
  tInsulationBottom=tInsulationBottom,
  lamdaInsulationWall=lamdaInsulationWall,
  lamdaInsulationBottom=lamdaInsulationBottom,
  lamdaInsulationLid=0.4,
  setAbsolutePressure=setAbsolutePressure,
  absolutePressure=absolutePressure) annotation(Placement(transformation(extent={{-85,-25},{-65,15}})));
 BaseClasses.FloatingLid lid(
  nLidLayers=nLidLayers,
  nLidElementsR=1 + nLidOverlapElements,
  radii=cat(1, {0}, meshR[iEmbankmentCenterStartR:iEmbankmentCenterStartR + nLidOverlapElements]),
  tInsulationLid=tInsulationLid,
  lamdaInsulationLid_c0=lamdaInsulationLid_c0,
  lamdaInsulationLid_c1=lamdaInsulationLid_c1,
  cpInsulationLid=cpInsulationLid,
  rhoInsulationLid=rhoInsulationLid) annotation(Placement(transformation(extent={{-30,25},{20,35}})));
 MoSDH.Components.Utilities.Ground.CylinderGroundMesh groundRight(
  nElementsR=nGroundRightElementsR,
  nElementsZ=nGroundRightElementsZ,
  meshR=meshR[iGroundRightStartR:iGroundRightEndR + 1],
  meshZ=meshZ[iGroundRightStartZ:iGroundRightEndZ + 1],
  Tinitial=fill(location.Taverage, nGroundRightElementsZ, nGroundRightElementsR),
  groundData=location.strat1) annotation(Placement(transformation(extent={{35,-50},{55,-30}})));
 MoSDH.Components.Utilities.Ground.CylinderGroundMesh groundLeft(
  nElementsR=nGroundLeftElementsR,
  nElementsZ=nGroundLeftElementsZ,
  meshR=meshR[iGroundLeftStartR:iGroundLeftEndR + 1],
  meshZ=meshZ[iGroundLeftStartZ:iGroundLeftEndZ + 1],
  Tinitial=fill(location.Taverage, nGroundLeftElementsZ, nGroundLeftElementsR),
  groundData=location.strat1) annotation(Placement(transformation(extent={{-55,-70},{-35,-50}})));
 MoSDH.Components.Utilities.Ground.CylinderGroundMesh embankmentCenter(
  nElementsR=nEmbankmentTopR,
  nElementsZ=nEmbankmentLayers,
  meshR=meshR[iEmbankmentCenterStartR:iEmbankmentCenterEndR + 1],
  meshZ=meshZ[iEmbankmentCenterStartZ:iEmbankmentCenterEndZ + 1],
  Tinitial=fill(location.Taverage, nEmbankmentLayers, nEmbankmentTopR),
  groundData=location.strat1) annotation(Placement(transformation(extent={{10,-5},{30,15}})));
 MoSDH.Components.Utilities.Ground.CylinderGroundMeshInnerSlope embankmentLeft(
  nElementsR=nEmbankmentLeftR,
  meshR=meshR[iEmbankmentLeftStartR:iEmbankmentLeftEndR + 1],
  meshZ=meshZ[iEmbankmentLeftStartZ:iEmbankmentLeftEndZ + 1],
  Tinitial=fill(location.Taverage, nEmbankmentLeftR),
  groundData=location.strat1) annotation(Placement(transformation(extent={{-25,-20},{-5,0}})));
 MoSDH.Components.Utilities.Ground.CylinderGroundMeshOuterSlope embankmentRight(
  nElementsR=nEmbankmentRightR,
  meshR=meshR[iEmbankmentRightStartR:iEmbankmentRightEndR + 1],
  meshZ=meshZ[iEmbankmentRightStartZ:iEmbankmentRightEndZ + 1],
  Tinitial=fill(location.Taverage, nEmbankmentRightR),
  groundData=location.strat1) annotation(Placement(transformation(extent={{45,-10},{65,10}})));
 Modelica.Thermal.HeatTransfer.Sources.FixedTemperature BC_outer[nGroundRightElementsZ](T(each fixed=true)=fill(location.Taverage, nGroundRightElementsZ)) "Fixed heat flow boundary condition at the model side" annotation(Placement(transformation(extent={{145,-50},{125,-30}})));
 Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow BC_inner[nGroundLeftElementsZ](each Q_flow=0) "Fixed heat flow boundary condition at the inner model boundary" annotation(Placement(transformation(extent={{-145,-65},{-125,-45}})));
 Modelica.Thermal.HeatTransfer.Sources.FixedTemperature BC_bottom[nElementsR](T(each fixed=true)=fill(location.Taverage, nElementsR)) "Fixed temperature boundary condition at the model bottom" annotation(Placement(transformation(
  origin={-20,-90},
  extent={{-10,-10},{10,10}},
  rotation=90)));
 Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature BC_top[nLidOverlapElements+1] "Variable temperature boundary condition at the model top" annotation(Placement(transformation(
  origin={-5,60},
  extent={{-10,-10},{0,0}},
  rotation=-90)));
 Modelica.Thermal.HeatTransfer.Components.ThermalCollector storageBottomCollector(m=nPitBottomElementsR) "Collects the heat flows of the ground elements below storage element no.1" annotation(Placement(transformation(extent={{-85,-30},{-65,-50}})));
 Modelica.Thermal.HeatTransfer.Components.ThermalConductor conductorAir[nLidOverlapElements+1](G=cat(1, {alphaAir * Modelica.Constants.pi * pitLayerRadii[nLayers + 1] ^ 2}, {alphaAir * Modelica.Constants.pi * (meshR[iR + 1] ^ 2 - meshR[iR] ^ 2) for iR in iEmbankmentCenterStartR:iEmbankmentCenterStartR + nLidOverlapElements - 1})) annotation(Placement(transformation(
  origin={-5,45},
  extent={{-10,-10},{0,0}},
  rotation=-90)));
 Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature BC_top_smooth[nGroundRightElementsR-nLidOverlapElements] "Variable temperature boundary condition at the model top" annotation(Placement(transformation(
  origin={30,60},
  extent={{-10,-10},{0,0}},
  rotation=-90)));
 Modelica.Blocks.Continuous.FirstOrder TambientSmooth(
  T(displayUnit="d")=1728000,
  initType=Modelica.Blocks.Types.Init.SteadyState,
  y_start=283.15) annotation(Placement(transformation(extent={{0,80},{10,90}})));
 Modelica.Units.SI.Temperature Tlayers[nLayers] "Temperature of each volume element of the storage";
 Modelica.Units.SI.Power Pthermal(displayUnit="kW") "Thermal power";
 Modelica.Units.SI.Energy Qthermal(
  start=0,
  fixed=true,
  displayUnit="MWh") "Thermal energy budget";
 Modelica.Units.SI.Energy QthermalCharged(
  start=0,
  fixed=true,
  displayUnit="MWh") "Thermal energy charged into storage";
 Modelica.Units.SI.Energy QthermalDischarged(
  start=0,
  fixed=true,
  displayUnit="MWh") "Thermal energy discharged from storage";
 Modelica.Units.SI.Temperature TdiffuserTop "Fluid temperature of top diffuser";
 Modelica.Units.SI.Temperature TdiffuserMid "Fluid temperature of top diffuser";
 Modelica.Units.SI.Temperature TdiffuserBottom "Fluid temperature of top diffuser";
 Modelica.Units.SI.VolumeFlowRate volFlowTop "Top diffuser volume flow rate";
 Modelica.Units.SI.VolumeFlowRate volFlowMid "Mid diffuser volume flow rate";
 Modelica.Units.SI.VolumeFlowRate volFlowBottom "Bottom diffuser volume flow rate";
 Modelica.Units.SI.Power PthermalWall "Heat loss rate to the surrounding ground through wall";
 Modelica.Units.SI.Power PthermalBottom "Heat loss rate to the surrounding ground through bottom";
 Modelica.Units.SI.Power PthermalLid "Heat loss rate through lid";
 Modelica.Units.SI.Energy QthermalWall(
  start=0,
  fixed=true) "Heat losses to the surrounding ground";
 Modelica.Units.SI.Energy QthermalBottom(
  start=0,
  fixed=true) "Heat losses to the surrounding ground";
 Modelica.Units.SI.Energy QthermalLid(
  start=0,
  fixed=true) "Heat losses through lid";
 Modelica.Units.SI.Energy QthermalLoss=QthermalLid + QthermalWall + QthermalBottom "Heat losses through lid";
 replaceable parameter Parameters.Locations.SingleLayerLocation location constrainedby
    MoSDH.Parameters.Locations.LocationPartial                                                                                    "Local geology" annotation (
  choicesAllMatching=true,
  Dialog(
   group="Location",
   tab="Storage"));
 parameter Modelica.Units.SI.CoefficientOfHeatTransfer alphaAir=25 "Heat transfer coefficient ground/lid to air" annotation(Dialog(
  group="Location",
  tab="Storage"));
 parameter Modelica.Units.SI.Volume storageVolume(min=1)=25000 "Volume of the storage" annotation(Dialog(
  group="Dimensions",
  tab="Storage"));
 parameter Modelica.Units.SI.Length storageHeight(min=1)=10 "Height of the storage pit (bottom to lid)" annotation(Dialog(
  group="Dimensions",
  tab="Storage"));
 parameter Real slope(
  min=0.25,
  max=2)=1 "Pit wall slope (Îh/Îr=tan(angle))" annotation(Dialog(
  group="Dimensions",
  tab="Storage"));
 parameter Integer nLayers(
  min=10,
  max=100)=10 "Number of stratified pit layers" annotation(Dialog(
  group="Storage volume",
  tab="Storage"));
 parameter Modelica.Units.SI.Length heightMidPort(
  min=1,
  max=storageHeight - 1)=5 "Height of mid diffusor port (approximation)" annotation(Dialog(
  group="Storage volume",
  tab="Storage"));
 replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby
    Modelica.Thermal.FluidHeatFlow.Media.Medium                                                                                    "Storage medium" annotation (
  choicesAllMatching=true,
  Dialog(
   group="Storage volume",
   tab="Storage"));
 parameter Modelica.Units.SI.CubicExpansionCoefficient beta=350 * 10 ^ (-6) "Thermal expansion coefficient of medium to model buoyancy" annotation(Dialog(
  group="Storage volume",
  tab="Storage"));
 parameter StratifiedTank.BaseClasses.BuoyancyModels buoyancyMode=StratifiedTank.BaseClasses.BuoyancyModels.aixLib "Mode of buoyancy calculation" annotation(Dialog(
  group="Storage volume",
  tab="Storage"));
 parameter Modelica.Units.SI.Time tau=900 "Time constant for buoyancy calculation after Modelica buildings library" annotation(Dialog(
  group="Storage volume",
  tab="Storage",
  enable=Integer(buoyancyMode)==2));
 parameter Integer nLidLayers=1 "Number of lid layers" annotation(Dialog(
  group="Lid",
  tab="Insulation"));
 parameter Modelica.Units.SI.Length lidOverlap(
  min=0.5,
  max=embankmentWidth)=1 "Overlap of the insulation on the embankment top" annotation(Dialog(
  group="Lid",
  tab="Insulation"));
 parameter Modelica.Units.SI.Length embankmentHeight(
  min=0.5,
  max=storageHeight)=1 "Height of the embankment from ground level" annotation(Dialog(
  group="Dimensions",
  tab="Storage"));
 parameter Modelica.Units.SI.Length embankmentWidth(min=1)=2 "Width of embankment top" annotation(Dialog(
  group="Dimensions",
  tab="Storage"));
 parameter Modelica.Units.SI.Length tInsulationLid[nLidLayers]=fill(0.1, nLidLayers) "Lid insulation thickness" annotation(Dialog(
  group="Lid",
  tab="Insulation"));
 parameter Modelica.Units.SI.ThermalConductivity lamdaInsulationLid_c0[nLidLayers]=fill(0.03, nLidLayers) "Thermal conductivity of lid layers at 10Â°C" annotation(Dialog(
  group="Lid",
  tab="Insulation"));
 parameter Modelica.Units.SI.ThermalConductivity lamdaInsulationLid_c1[nLidLayers]=fill(0, nLidLayers) "Thermal conductivity of lid layers linear coefficient [W/(m*KÂ²])" annotation(Dialog(
  group="Lid",
  tab="Insulation"));
 parameter Modelica.Units.SI.HeatCapacity cpInsulationLid[nLidLayers]=fill(1500, nLidLayers) "Thermal capacity of lid layers" annotation(Dialog(
  group="Lid",
  tab="Insulation"));
 parameter Modelica.Units.SI.Density rhoInsulationLid[nLidLayers]=fill(900, nLidLayers) "Density of lid layers" annotation(Dialog(
  group="Lid",
  tab="Insulation"));
 parameter Modelica.Units.SI.Length tInsulationWall=0.1 "Pit wall insulation thickness" annotation(Dialog(
  group="Ground",
  tab="Insulation"));
 parameter Modelica.Units.SI.Length tInsulationBottom=0.1 "Pit bottom insulation thickness" annotation(Dialog(
  group="Ground",
  tab="Insulation"));
 parameter Modelica.Units.SI.ThermalConductivity lamdaInsulationWall=0.03 "Thermal conductivity of the pit wall insulation" annotation(Dialog(
  group="Ground",
  tab="Insulation"));
 parameter Modelica.Units.SI.ThermalConductivity lamdaInsulationBottom=0.03 "Thermal conductivity of the bottom insulation" annotation(Dialog(
  group="Ground",
  tab="Insulation"));
 parameter Modelica.Units.SI.Temperature Tinitial[nLayers]=linspace(303.15, 363.15, nLayers) "Inital Temperature of the volume elements" annotation(Dialog(
  group="Initial and boundary conditions",
  tab="Modeling"));
 parameter Boolean setAbsolutePressure=true "=true, if absolute pressure is defined at the top layer" annotation(Dialog(
  group="Initial and boundary conditions",
  tab="Modeling"));
 parameter Modelica.Units.SI.Pressure absolutePressure=100000 "Absolute pressure at the storage top" annotation(Dialog(
  group="Initial and boundary conditions",
  tab="Modeling",
  enable=setAbsolutePressure));
 parameter Boolean printModelStructure=false "=true, prints model sturcture to log area for debugging." annotation(Dialog(
  group="Initial and boundary conditions",
  tab="Modeling"));
protected
  Modelica.Blocks.Interfaces.RealInput Tambient annotation(Placement(transformation(extent={{-70,65},{-30,105}})));
  parameter Integer iMidPort(
   min=1,
   max=nLayers)=MoSDH.Components.Utilities.Ground.Functions.findPositionInMesh({storageHeight - meshZ[nLayers + 1 - i] for i in 1:nLayers}, heightMidPort) "Layer of the mid diffuser port";
  parameter Integer nEmbankmentLayers=max(1, MoSDH.Components.Utilities.Ground.Functions.findPositionInMesh(meshZ, embankmentHeight)) "Embankment height (number of pit layers above ground level)" annotation(Dialog(
   group="Dimensions",
   tab="Storage"));
  parameter Integer nLayersSubsurface=nLayers - nEmbankmentLayers "Number of pit layers below ground level";
  parameter Modelica.Units.SI.Length pitLayerHeights[nLayers]=MoSDH.Components.Storage.PitStorage.Functions.pitElementHeights(storageVolume, storageHeight, slope, nLayers);
  parameter Integer nLidOverlapElements=integer(max(1, lidOverlap / embankmentWidth * nEmbankmentTopR));
  parameter Modelica.Units.SI.Length pitLayerRadii[nLayers+1]=MoSDH.Components.Storage.PitStorage.Functions.pitElementRadii(storageVolume, storageHeight, slope, nLayers) "Radii of pit elements";
  parameter Modelica.Units.SI.Length elementWidths[nElementsR]=cat(1, fill(pitLayerRadii[1] / nPitBottomElementsR, nPitBottomElementsR), {pitLayerRadii[i + 1] - pitLayerRadii[i] for i in 1:nLayers}, fill(embankmentWidth / nEmbankmentTopR, nEmbankmentTopR), {pitLayerRadii[nLayers - i + 1] - pitLayerRadii[nLayers - i] for i in 1:nEmbankmentLayers - 1}, {(pitLayerRadii[nLayers - nEmbankmentLayers] - pitLayerRadii[nLayers - nEmbankmentLayers - 1]) * sqrt(2) ^ r for r in 1:nAdditionalElementsR}) "Vector with radial width of elements";
  parameter Modelica.Units.SI.Length elementHeights[nElementsZ]=cat(1, {pitLayerHeights[nLayers - i + 1] for i in 1:nLayers}, fill(pitLayerHeights[1], 2), {pitLayerHeights[1] * sqrt(2) ^ r for r in 1:4}) "Vector with element heights";
  parameter Real meshZ[nElementsZ+1]=cat(1, {0}, {sum(elementHeights[i] for i in 1:j) for j in 1:nElementsZ}) "Vector containing absolute depth of mesh nodes" annotation(Evaluate=true);
  parameter Real meshR[nElementsR+1]=cat(1, {0}, {sum(elementWidths[i] for i in 1:j) for j in 1:nElementsR}) "Vector containing absolute radii of mesh nodes" annotation(Evaluate=true);
  parameter Integer nEmbankmentTopR=integer(ceil(embankmentWidth / pitLayerHeights[nLayers]));
  parameter Integer nPitBottomElementsR=max(min(integer(pitLayerRadii[1] / (pitLayerRadii[2] - pitLayerRadii[1])), 5), 3) "Number of elements connected to storage bottom";
  parameter Integer nGroundLeftElementsR=nPitBottomElementsR + nLayers;
  parameter Integer nAdditionalElementsR=4 "Number of ground elements in radial direction after embankment";
  parameter Integer nGroundRightElementsR=nEmbankmentTopR + nEmbankmentLayers - 1 + nAdditionalElementsR "Number of ground elements in r-direction outside the storage vicinity";
  parameter Integer nElementsR=nGroundLeftElementsR + nGroundRightElementsR;
  parameter Integer nGroundLeftElementsZ=6 "Number of ground elements below the pit";
  parameter Integer nGroundRightElementsZ=nLayersSubsurface + nGroundLeftElementsZ "Number of elements from ground level to model bottom";
  parameter Integer nElementsZ=nLayers + nGroundLeftElementsZ "Number of elements from embankment top to model bottom";
  parameter Integer nEmbankmentLeft=sum(r for r in 1:nLayers) "Number of elements in the inner triangular region of the embankment";
  parameter Integer nEmbankmentLeftZ=nLayers "Height of the inner triangular region";
  parameter Integer nEmbankmentLeftR=nEmbankmentLeftZ "Width of the inner triangular region";
  parameter Integer nEmbankmentRight=sum(r for r in 1:nEmbankmentLayers) "Number of elements in the outer triangular region of the embankment";
  parameter Integer nEmbankmentRightZ=nEmbankmentLayers "Height of the outer triangular region";
  parameter Integer nEmbankmentRightR=nEmbankmentRightZ "Width of the outer triangular region";
  parameter Integer iGroundLeftStartZ=nLayers + 1;
  parameter Integer iGroundLeftEndZ=nElementsZ;
  parameter Integer iGroundLeftStartR=1;
  parameter Integer iGroundLeftEndR=nGroundLeftElementsR;
  parameter Integer iGroundRightStartZ=nEmbankmentLayers + 1;
  parameter Integer iGroundRightEndZ=nElementsZ;
  parameter Integer iGroundRightStartR=iGroundLeftEndR + 1;
  parameter Integer iGroundRightEndR=nElementsR;
  parameter Integer iEmbankmentCenterStartZ=1;
  parameter Integer iEmbankmentCenterEndZ=nEmbankmentLayers;
  parameter Integer iEmbankmentCenterStartR=nGroundLeftElementsR + 1;
  parameter Integer iEmbankmentCenterEndR=nGroundLeftElementsR + nEmbankmentTopR;
  parameter Integer iEmbankmentLeftStartZ=1;
  parameter Integer iEmbankmentLeftEndZ=nLayers;
  parameter Integer iEmbankmentLeftStartR=nPitBottomElementsR + 1;
  parameter Integer iEmbankmentLeftEndR=nGroundLeftElementsR;
  parameter Integer iEmbankmentRightStartZ=1;
  parameter Integer iEmbankmentRightEndZ=iEmbankmentCenterEndZ;
  parameter Integer iEmbankmentRightStartR=iEmbankmentCenterEndR + 1;
  parameter Integer iEmbankmentRightEndR=iEmbankmentRightStartR + nEmbankmentRightR - 1;
  parameter Integer componentID(min=1)=1 "Doesn't work yet: ID if more than one PTES component is connected to the bus system" annotation(Dialog(
   group="Ports",
   tab="Modeling"));
  parameter Integer numberOfComponents(min=1)=1 "Doesn't work yet: Overall number of PTES components connected to the bus system" annotation(Dialog(
   group="Ports",
   tab="Modeling"));
  constant Modelica.Units.SI.Temperature dummyTemperature=1 "For unit consistency";
initial algorithm
  if printModelStructure then
  Modelica.Utilities.Streams.print("equivalent radii: top = " + String(pitLayerRadii[nLayers + 1]) + " m, bottom = " + String(pitLayerRadii[1]) + "m", "");
    Modelica.Utilities.Streams.print("Actual embankment height= " + String(meshZ[nEmbankmentLayers + 1]) + " m; Setting:" + String(embankmentHeight) + " m", "");
    Modelica.Utilities.Streams.print("Actual height of mid port: " + String((sum(pitLayerHeights[i] for i in 1:iMidPort) + sum(pitLayerHeights[i] for i in 1:iMidPort - 1)) / 2) + " m; Setting:" + String(heightMidPort) + " m", "");
    Modelica.Utilities.Streams.print("meshZ[" + String(nElementsZ + 1) + "]" + Modelica.Math.Vectors.toString(meshZ, "", 3), "");
    Modelica.Utilities.Streams.print("meshR[" + String(nElementsR + 1) + "]" + Modelica.Math.Vectors.toString(meshR, "", 3), "");
  end if;
//---------------------------------------------------------------------------------
equation
//------------------------------------- Outputs -------------------------------------
  TdiffuserTop = topPort.h / medium.cp;
    TdiffuserMid = midPort.h / medium.cp;
    TdiffuserBottom = bottomPort.h / medium.cp;
    volFlowTop = topPort.m_flow / medium.rho;
    volFlowMid = midPort.m_flow / medium.rho;
    volFlowBottom = bottomPort.m_flow / medium.rho;
    Pthermal = -(bottomPort.H_flow + topPort.H_flow + midPort.H_flow);
    der(Qthermal) = Pthermal;
    der(QthermalCharged) = max(0, -Pthermal);
    der(QthermalDischarged) = max(0, Pthermal);
    PthermalLid = lid.bottomPort[1].Q_flow;
    der(QthermalLid) = PthermalLid;
    PthermalBottom = -pit.bottomHeatPort.Q_flow;
    der(QthermalBottom) = PthermalBottom;
    PthermalWall = -sum(pit.wallHeatPort[z].Q_flow for z in 1:nLayers);
    der(QthermalWall) = PthermalWall;
    Tlayers = pit.Tlayers;
//------------------------------- BC + INNER CONNECTIONS --------------------------
  Tambient = weatherPort.Tambient;
// Top BC & lid
  for iR in 1:1 + nLidOverlapElements loop
    connect(BC_top[iR].T, Tambient) annotation(
      Line(points = {{-10, 71}, {-10, 76}, {-10, 85}, {-45, 85}, {-50, 85}}, color = {0, 0, 127}, thickness = 0.0625));
  end for;
    for iR in 1:nGroundRightElementsR - nLidOverlapElements loop
      connect(TambientSmooth.y, BC_top_smooth[iR].T) annotation (
        Line(points = {{10.5, 85}, {10.5, 85}, {25, 85}, {25, 76}, {25, 71}}, color = {0, 0, 127}, thickness = 0.0625));
    end for;
    connect(conductorAir[:].port_a, BC_top[:].port) annotation (
      Line(points = {{-10, 55}, {-10, 60}, {-10, 55}, {-10, 60}}, color = {191, 0, 0}, thickness = 0.0625));
    connect(embankmentCenter.topPort[1:nLidOverlapElements], lid.bottomPort[2:nLidOverlapElements + 1]) annotation (
      Line(points = {{20, 15}, {20, 20}, {-10, 20}, {-10, 25.33}}, color = {191, 0, 0}, thickness = 0.0625));
    connect(embankmentCenter.topPort[nLidOverlapElements + 1:nEmbankmentTopR], BC_top_smooth[1:nEmbankmentTopR - nLidOverlapElements].port) annotation (
      Line(points = {{20, 15}, {20, 20}, {20, 40}, {25, 40}, {25, 60}}, color = {191, 0, 0}, thickness = 0.0625));
    connect(lid.topPort[:], conductorAir[1:nLidOverlapElements + 1].port_b) annotation (
      Line(points = {{-10, 35}, {-10, 40}, {-10, 45}}, color = {191, 0, 0}, thickness = 0.0625));
    connect(embankmentRight.slopePort[1:nEmbankmentRightR], BC_top_smooth[nEmbankmentTopR - nLidOverlapElements + 1:nEmbankmentTopR + nEmbankmentRightR - nLidOverlapElements].port) annotation (
      Line(points = {{65, 0}, {70, 0}, {70, 40}, {25, 40}, {25, 55}, {25, 60}}, color = {191, 0, 0}, thickness = 0.0625));
    connect(groundRight.topPort[nEmbankmentTopR + nEmbankmentRightR + 1:nGroundRightElementsR], BC_top_smooth[nEmbankmentTopR + nEmbankmentRightR - nLidOverlapElements + 1:nGroundRightElementsR - nLidOverlapElements].port) annotation (
      Line(points = {{45, -30}, {40, -25}, {110, -25}, {110, 40}, {25, 40}, {25, 60}}, color = {191, 0, 0}, thickness = 0.0625));
// Inner BC
  connect(groundLeft.innerPort, BC_inner.port) annotation(
    Line(points = {{-55, -60}, {-60, -60}, {-120, -60}, {-120, -55}, {-125, -55}}, color = {191, 0, 0}, thickness = 0.0625));
// Bottom BC
  connect(groundLeft.bottomPort[:], BC_bottom[1:iGroundLeftEndR].port) annotation(
    Line(points = {{-45, -69.67}, {-45, -69.67}, {-45, -75}, {-20, -75}, {-20, -80}}, color = {191, 0, 0}, thickness = 0.0625));
    connect(BC_bottom[iGroundRightStartR:iGroundRightEndR].port, groundRight.bottomPort[:]) annotation (
      Line(points = {{-20, -80}, {-20, -75}, {45, -75}, {45, -49.67}}, color = {191, 0, 0}, thickness = 0.0625));
//Right BC
  connect(groundRight.outerPort[:], BC_outer[:].port) annotation(
    Line(points = {{55, -40}, {60, -40}, {120, -40}, {125, -40}}, color = {191, 0, 0}, thickness = 0.0625));
//Pit
  connect(pit.lidHeatPort, lid.bottomPort[1]) annotation(
    Line(points = {{-80, 15}, {-80, 20}, {-80, 20.3}, {-10, 20.3}, {-10, 25.33}}, color = {191, 0, 0}, thickness = 0.0625));
    connect(pit.wallHeatPort[:], embankmentLeft.slopePort[:]) annotation (
      Line(points = {{-65.33, -15}, {-65.33, -15}, {-30, -15}, {-30, -10}, {-25, -10}}, color = {191, 0, 0}, thickness = 0.0625));
    connect(storageBottomCollector.port_b, pit.bottomHeatPort) annotation (
      Line(points = {{-75, -30}, {-75, -25}, {-75, -24.67}, {-75, -24.67}}, color = {191, 0, 0}, thickness = 0.0625));
//Left ground top
  connect(groundLeft.topPort[1:nPitBottomElementsR], storageBottomCollector.port_a[:]) annotation(
    Line(points = {{-45, -50}, {-45, -45}, {-60, -45}, {-60, -55}, {-75, -55}, {-75, -50}}, color = {191, 0, 0}, thickness = 0.0625));
    connect(groundLeft.topPort[iEmbankmentLeftStartR:iEmbankmentLeftEndR], embankmentLeft.bottomPort[:]) annotation (
      Line(points = {{-45, -50}, {-45, -45}, {-15, -45}, {-15, -19.67}}, color = {191, 0, 0}, thickness = 0.0625));
//Left ground to the right
  connect(groundLeft.outerPort[:], groundRight.innerPort[iGroundLeftStartZ - nEmbankmentLayers:nGroundRightElementsZ]) annotation(
    Line(points = {{-35, -60}, {-30, -60}, {25, -60}, {25, -40}, {35, -40}}, color = {191, 0, 0}, thickness = 0.0625));
//Left embankment to the righ
  connect(embankmentLeft.outerPort[1:nEmbankmentLayers], embankmentCenter.innerPort[:]) annotation(
    Line(points = {{-5, -10}, {0, -10}, {5, -10}, {5, 5}, {10, 5}}, color = {191, 0, 0}, thickness = 0.0625));
    connect(embankmentLeft.outerPort[iGroundRightStartZ:nEmbankmentLeftZ], groundRight.innerPort[1:nEmbankmentLeftZ - nEmbankmentLayers]) annotation (
      Line(points = {{-5, -10}, {0, -10}, {5, -10}, {5, -25}, {25, -25}, {25, -40}, {35, -40}}, color = {191, 0, 0}, thickness = 0.0625));
//Right ground top
  connect(groundRight.topPort[1:nEmbankmentTopR], embankmentCenter.bottomPort[:]) annotation(
    Line(points = {{45, -30}, {45, -25}, {45, -15}, {20, -15}, {20, -4.67}}, color = {191, 0, 0}, thickness = 0.0625));
    connect(groundRight.topPort[nEmbankmentTopR + 1:nEmbankmentTopR + nEmbankmentRightR], embankmentRight.bottomPort[:]) annotation (
      Line(points = {{45, -30}, {45, -25}, {45, -14.7}, {55, -14.7}, {55, -9.67}}, color = {191, 0, 0}, thickness = 0.0625));
//Embankment center to the tight
  connect(embankmentCenter.outerPort[:], embankmentRight.innerPort[:]) annotation(
    Line(points = {{30, 5}, {35, 5}, {40, 5}, {40, 0}, {45, 0}}, color = {191, 0, 0}, thickness = 0.0625));
    connect(topPort, pit.sourcePorts[nLayers]) annotation (
      Line(points = {{-125, 25}, {-90, 25}, {-90, -5}, {-85, -5}}, color = {255, 0, 0}, thickness = 1));
    connect(midPort, pit.sourcePorts[iMidPort]) annotation (
      Line(points = {{-125, 0}, {-90, 0}, {-90, -5}, {-85, -5}}, color = {177, 0, 177}, thickness = 1));
    connect(bottomPort, pit.sourcePorts[1]) annotation (
      Line(points = {{-125, -25}, {-90, -25}, {-90, -5.9}, {-85, -5.9}}, color = {0, 0, 255}, thickness = 1));
    connect(TambientSmooth.u, Tambient) annotation (
      Line(points = {{-1, 85}, {-6, 85}, {-45, 85}, {-50, 85}}, color = {0, 0, 127}, thickness = 0.0625));
 annotation (
  Line(
   points={{9.67, -45}, {9.67, -45}, {90, -45}, {90, -45}},
   color={191, 0, 0},
   thickness=0.0625),
  defaultComponentName="pit",
  Icon(
   coordinateSystem(extent={{-400,-150},{400,150}}),
   graphics={
       Bitmap(
        imageSource="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",
        extent={{-406.9,-157.7},{413.1,139.8}})}),
  Diagram(
   coordinateSystem(extent={{-150,-100},{150,100}}),
   graphics={
    Rectangle(
     fillColor={190,112,59},
     fillPattern=FillPattern.Solid,
     extent={{-125,-30},{5,-80}}),
    Rectangle(
     fillColor={190,112,59},
     fillPattern=FillPattern.Solid,
     extent={{5,-15},{125,-80}}),
    Polygon(
     points={{-125,-30},{-55,-30},{5,25},{-125,25},{-125,25}},
     fillColor={216,237,242},
     fillPattern=FillPattern.Solid),
    Rectangle(
     fillColor={190,112,59},
     fillPattern=FillPattern.Solid,
     extent={{5,25},{40,-15}}),
    Polygon(
     points={{-70,-30},{5,25},{5,-30}},
     fillColor={190,112,59},
     fillPattern=FillPattern.Solid),
    Polygon(
     points={{40,25},{40,-15},{100,-15}},
     fillColor={190,112,59},
     fillPattern=FillPattern.Solid),
    Polygon(
     points={{-125,25},{-125,35},{0,35},{20,25}},
     fillColor={215,215,215},
     fillPattern=FillPattern.Solid)}),
  Documentation(info= "<html><head>
<style type=\"text/css\">
a {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt;}
body, blockquote, table, p, li, dl, ul, ol {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; color: black;}
h3 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11pt; font-weight: bold;}
h4 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: bold;}
h5 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: bold;}
h6 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: bold; font-style:italic}
pre {font-family: Courier, monospace; font-size: 9pt;}
td {vertical-align:top;}
th {vertical-align:top;}
</style>
</head>

<body><h4>Pit thermal energy storage model (PTES):</h4><h5>Storage</h5><div><ul><li>For a detailed model description see&nbsp;<a href=\"modelica://MoSDH.UsersGuide.References\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">[Formhals2022]</a> and <a href=\"modelica://MoSDH.UsersGuide.References\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">[Kirschstein2021]</a>&nbsp;</li><li><span style=\"font-size: 10pt;\">Model of a PTES with inclined walls (</span><b style=\"font-size: 10pt;\">slope</b><span style=\"font-size: 10pt;\">), an embankment and ports at top, mid and bottom. The height of the mid port can be defined approximately by the parameter </span><b style=\"font-size: 10pt;\">heightMidPort</b><span style=\"font-size: 10pt;\"> and is connected to the pit element closest to the parameter choice.</span></li><li>The meshing is generated automatically creating pit elements of equal volume (unlike Fig. 1).</li><li>The pit is modeled using the base class of the TTES model and effects like buoyancy are handled likewise.</li><li>The ground has uniform thermal parameters according to <b>location.strat1</b>.&nbsp;</li></ul>

<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>Model structure</caption><caption align=\"bottom\"><br></caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/PTES.png\" width=\"700\">
    </td>
  </tr>
</tbody></table></div>
<div><p>
</p><h5>Insulation</h5><div><ul><li>Insulation of the lid can consideres several layers (<b>nLidLayers</b>) with thickness, thermal conductivity and capacity.&nbsp;</li><li>The themral conductivity can be defined as a function of temperature lamda(T)=<b>lamdaInsulation_c0</b>+<b>lamdaInsulation_c1</b>*(T-283.15)</li><li>Insulation on the walls and at the bottom are defined individually.</li><li>The lid overlap on the embankment top is defined by the parameter <b>lidOverlap</b> and the actual dimensions of the mesh (closest to setting).</li></ul><div></div>
<p></p></div>
</div></body></html>"),
  experiment(
   StopTime=1,
   StartTime=0,
   Tolerance=1e-06,
   Interval=0.001));
end PTES;
