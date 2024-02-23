within MoSDH.Components.Storage.BoreholeStorage;
model BTES "BTES model"
 MoSDH.Utilities.Interfaces.SupplyPort supplyPort(
  medium=medium,
  h(start=location.Taverage*medium.cp)) "flow for storage chrging " annotation(Placement(
  transformation(extent={{-55,90},{-35,110}}),
  iconTransformation(extent={{-110,190},{-90,210}})));
 MoSDH.Utilities.Interfaces.ReturnPort returnPort(
  medium=medium,
  h(start=location.Taverage*medium.cp)) "return for storage charging" annotation(Placement(
  transformation(extent={{35,90},{55,110}}),
  iconTransformation(extent={{90,190},{110,210}})));
 Modelica.Units.SI.Temperature Tsupply(displayUnit="degC") "BTES supply temperature";
 Modelica.Units.SI.Temperature Treturn(displayUnit="degC") "BTES return temperature";
 Modelica.Units.SI.Temperature Tstorage(displayUnit="degC") "Average temperature inside storage volume";
 Modelica.Units.SI.VolumeFlowRate volFlow(displayUnit="l/s") "BTES volume flow (flow-> return)";
 Modelica.Units.SI.Power Pthermal(displayUnit="kW") "Thermal power";
 Modelica.Units.SI.Energy Qthermal(
  start=0,
  fixed=true) "Thermal ernergy balance";
 Modelica.Units.SI.Energy QthermalCharged(
  start=0,
  fixed=true) "Thermal energy charged into storage";
 Modelica.Units.SI.Energy QthermalDischarged(
  start=0,
  fixed=true) "Thermal energy discharged from storage";
 Modelica.Units.SI.Pressure dp "Pressure drop (p_flow - p_return)";
 parameter MoSDH.Components.Sources.Geothermal.BaseClasses.BHEfieldLayouts layout=MoSDH.Components.Sources.Geothermal.BaseClasses.BHEfieldLayouts.rectangle "BTES layout" annotation(Dialog(
  group="Dimensions",
  groupImage=if Integer(layout)==1 then "modelica://MoSDH/Utilities/Images/BTESlayout1.png" else
                                                                                                if Integer(layout)==2 then "modelica://MoSDH/Utilities/Images/BTESlayout2.png" else
                                                                                                                                                                                   "modelica://MoSDH/Utilities/Images/BTESlayout3.png",
  tab="Design"));
 inner parameter Integer nBHEs(
  min=1,
  max=1000)=100 "Number of borehole heat exchangers (BHE)" annotation(Dialog(
  group="Dimensions",
  tab="Design"));
 parameter Modelica.Units.SI.Length BHElength(
  displayUnit="m",
  min=20,
  max=2000)=100 "Length of BHEs" annotation(Dialog(
  group="Dimensions",
  tab="Design"));
 inner replaceable parameter MoSDH.Parameters.Locations.SingleLayerLocation location constrainedby
    MoSDH.Parameters.Locations.LocationPartial                                                                                                "Local geology" annotation (
  choicesAllMatching=true,
  Dialog(
   group="Dimensions",
   tab="Design"));
 inner replaceable parameter MoSDH.Parameters.BoreholeHeatExchangers.DoubleU_DN32 BHEdata constrainedby
    MoSDH.Parameters.BoreholeHeatExchangers.BHEparameters                                                                                                     "BHE dataset" annotation (
  choicesAllMatching=true,
  Dialog(
   group="Borehole Heat Exchangers",
   tab="Design"));
 inner parameter Integer nBHEsInSeries(
  min=1,
  max=nBHEs)=1 "Number of BHEs connected in series" annotation(Dialog(
  group="Borehole Heat Exchangers",
  tab="Design"));
 inner replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby
    Modelica.Thermal.FluidHeatFlow.Media.Medium                                                                                          "Medium inside the BHE" annotation (
  choicesAllMatching=true,
  Dialog(
   group="Borehole Heat Exchangers",
   tab="Design"));
 inner parameter Boolean useUpperGroutSection=false "=true, if grout is divided into an upper and a lower section." annotation(Dialog(
  group="Borehole Heat Exchangers",
  tab="Design"));
 inner replaceable parameter MoSDH.Parameters.Grouts.Grout15 groutData constrainedby
    MoSDH.Parameters.Grouts.GroutPartial                                                                                  "Grout dataset" annotation (
  choicesAllMatching=true,
  Dialog(
   group="Borehole Heat Exchangers",
   tab="Design"));
 inner replaceable parameter MoSDH.Parameters.Grouts.Grout15 groutDataUpper constrainedby
    MoSDH.Parameters.Grouts.GroutPartial                                                                                       "Grout dataset" annotation (
  choicesAllMatching=true,
  Dialog(
   group="Borehole Heat Exchangers",
   tab="Design",
   enable=(useUpperGroutSection)));
 inner parameter Modelica.Units.SI.Length lengthUpperGroutSection(
  displayUnit="m",
  min=1,
  max=0.5*BHElength)=1 "Length of upper grout section." annotation(Dialog(
  group="Borehole Heat Exchangers",
  tab="Design",
  enable=(useUpperGroutSection)));
 MoSDH.Components.Distribution.Pump pump(
  medium=medium,
  volFlowRef=volFlowRef) "BHE pumps" annotation(Placement(transformation(
  origin={-45,65},
  extent={{10,-10},{-10,10}},
  rotation=90)));
 MoSDH.Utilities.Interfaces.Weather weatherPort if not useAverageSurfaceTemperature "Temperature at ground surface" annotation(Placement(
  transformation(extent={{-110,20},{-90,40}}),
  iconTransformation(extent={{-10,-206.7},{10,-186.7}})));
 Modelica.Blocks.Sources.RealExpression Tambient(y=weatherPort.Tambient) if not useAverageSurfaceTemperature annotation(Placement(transformation(extent={{-94,-10},{-74,10}})));
 Modelica.Units.SI.Temperature TboreholeWall[nBHEelementsR](each displayUnit="degC") "Borehole wall temperature at half BHE depth";
 Modelica.Units.SI.Efficiency storageUtilization=QthermalDischarged/max(1,
                                    QthermalCharged) "Storage utilization";
 Modelica.Blocks.Sources.RealExpression TsurfaceAverage(y=location.Taverage) if useAverageSurfaceTemperature annotation(Placement(transformation(extent={{-93,3},{-73,23}})));
 parameter Modelica.Units.SI.Length BHEstart(
  displayUnit="m",
  min=0.5,
  max=10)=1 "Depth of BHE heads" annotation(Dialog(
  group="Dimensions",
  tab="Design"));
 parameter Modelica.Units.SI.Length BHEspacing(
  displayUnit="m",
  min=1,
  max=20)=3 "Minimal disctance D between BHEs" annotation(Dialog(
  group="Dimensions",
  tab="Design"));
 replaceable model BHEmodel =
      MoSDH.Components.Sources.Geothermal.BaseClasses.DoubleU_BHE                         constrainedby
    MoSDH.Components.Sources.Geothermal.BaseClasses.partialBHE                                                                                                     "BHE type" annotation (
  choicesAllMatching=true,
  Placement(transformation(extent={{-10, -10}, {10, 10}})),
  Dialog(
   tab="Design",
   group="Borehole Heat Exchangers"));
 replaceable model LOCALmodel = MoSDH.Components.Utilities.Ground.LocalElement_steadyFlux
                                                                                constrainedby
    MoSDH.Components.Utilities.Ground.BaseClasses.LocalElement_partial                                                                                           "Local problem modeling approach" annotation (
  choicesAllMatching=true,
  Dialog(
   group="Local problem & BHEs",
   tab="Modeling"));
 parameter Integer nBHEsgementsMin(
  min=4,
  max=20)=8 "Minimum number of BHE segements" annotation(Dialog(
  group="Meshing",
  tab="Modeling"));
 parameter Integer nCapacitiesLocal(
  min=2,
  max=20)=6 "Number of thermal cpacities/rings of the Finite Differences local model." annotation(Dialog(
  group="Meshing",
  tab="Modeling"));
 parameter Real dZminMax(
  min=0.1,
  max=10,
  quantity="Length",
  displayUnit="m")=10 "Maximum height of the smallest elements" annotation(Dialog(
  group="Meshing",
  tab="Modeling"));
 parameter Real growthFactor(
  min=1,
  max=2)=2 "Growth factor for neighbouring elements." annotation(Dialog(
  group="Meshing",
  tab="Modeling"));
 parameter Real relativeModelDepth(
  min=1.2,
  max=3)=1.5 "Model depth in relation to BHE bottom depth." annotation(Dialog(
  group="Meshing",
  tab="Modeling"));
 parameter Integer nAdditionalElementsR(
  min=4,
  max=15)=8 "Number of additional radial ring elements (nBHErings+3+x)" annotation(Dialog(
  group="Meshing",
  tab="Modeling"));
 parameter Boolean printModelStructure=false "=true, if model structure is printed to output" annotation(Dialog(
  group="General",
  tab="Modeling"));
 parameter Boolean useAverageSurfaceTemperature=true "=true, if temperature boundary condition at model top is defined by the average location temperature, else defined by weather port" annotation(Dialog(
  group="General",
  tab="Modeling"));
 Modelica.Units.SI.VolumeFlowRate volFlowRef=0.001*nBHEs "Volume flow rate" annotation(Dialog(
  group="General",
  tab="Control"));
protected
  parameter Real rEquivalent=if Integer(layout)==1 then BHEspacing / sqrt(Modelica.Constants.pi) elseif Integer(layout)==2 then (MoSDH.Components.Storage.BoreholeStorage.Functions.NumberOfBHErings(nBHEs) - 0.5) * BHEspacing / sqrt(nBHEs) else 3 ^ (1 / 4) * BHEspacing / sqrt(2 * Modelica.Constants.pi) "Radius of BHE volume";
  parameter Real heights[nElementsZ]=MoSDH.Components.Storage.BoreholeStorage.Functions.ElementHeights(MoSDH.Components.Storage.BoreholeStorage.Functions.SupermeshZ(BHEstart,useUpperGroutSection, lengthUpperGroutSection,  BHElength, relativeModelDepth, location.layerThicknessVector), integer(floor(nBHEsgementsMin / 2)), dZminMax, growthFactor, nElementsZ) "Vector for vertical discretization";
  parameter Real meshZ[nElementsZ+1]=cat(1, {0}, array(sum(heights[i] for i in 1:j) for j in 1:nElementsZ)) "Vector containing absolute depth of mesh nodes";
  parameter Real meshR[nElementsR+1]=MoSDH.Components.Storage.BoreholeStorage.Functions.MeshR(nBHEsPerRingVector, rEquivalent, nElementsR) "Vector containing absolute radius of mesh nodes";
  parameter Integer nElementsZ=MoSDH.Components.Storage.BoreholeStorage.Functions.nElementsZ(MoSDH.Components.Storage.BoreholeStorage.Functions.SupermeshZ(BHEstart, useUpperGroutSection, lengthUpperGroutSection,  BHElength, relativeModelDepth, location.layerThicknessVector), integer(floor(nBHEsgementsMin / 2)), dZminMax, growthFactor) "Number of elements in vertcial direction";
  parameter Integer nElementsR=nBHEelementsR + 3 + nAdditionalElementsR "Number of elements in radial direction";
  parameter Integer nBHEelementsR=if nSeries == 1 then MoSDH.Components.Storage.BoreholeStorage.Functions.NumberOfBHErings(nBHEs) else nSeries "Number of rings containg a BHE";
  parameter Integer nBHEelementsZ=iBHEbottomElement - iBHEheadElement + 1 "Number of layers containing  a BHE";
  inner parameter Integer nSeries=if mod(nBHEs, nBHEsInSeries) == 0 then nBHEsInSeries else 1 "Number of BHEs in series";
  parameter Integer nParallel=integer(nBHEs/nSeries);
  parameter Integer nBHEsPerRingVector[nBHEelementsR]=if nSeries == 1 then MoSDH.Components.Storage.BoreholeStorage.Functions.NumberOfBHEsPerRing(nBHEs, nBHEelementsR) else fill(integer(nBHEs / nBHEelementsR), nBHEelementsR) "Vector containing the number of BHEs per ring";
  parameter Integer iBHEheadElement=Modelica.Math.Vectors.find(BHEstart, meshZ,0.01) "Index of the element containg the BHE head";
  inner parameter Integer iGroutChange=if useUpperGroutSection then Modelica.Math.Vectors.find(lengthUpperGroutSection, meshZ[iBHEheadElement:iBHEbottomElement]) else 1 "Index of the first element of the main/lower grout section.";
  parameter Integer iBHEbottomElement=Modelica.Math.Vectors.find(BHEstart+BHElength, meshZ,0.01)-1 "Index of the element containg the BHE bottom";
  parameter Real GLOBAL_innerRadiusMatrix[nElementsZ,nElementsR]=fill(meshR[1:nElementsR], nElementsZ) "Inner radii of volume elements";
  parameter Real GLOBAL_outerRadiusMatrix[nElementsZ,nElementsR]=fill(meshR[2:nElementsR + 1], nElementsZ) "Outer radii of volume elements";
  parameter Real GLOBAL_elementHeightsMatrix[nElementsZ,nElementsR]=transpose(fill(heights, nElementsR)) "Matrix containg heights for each element of the global problem";
  parameter Real GLOBAL_TinitialMatrix[nElementsZ,nElementsR]=array(location.Taverage + (meshZ[z] + heights[z] / 2) * location.geoGradient for r in 1:nElementsR, z in 1:nElementsZ) "Matrix containg initial temperature for each element of the global problem";
  parameter Real GLOBAL_groundDataMatrix[3,nElementsZ,nElementsR]=MoSDH.Components.Storage.BoreholeStorage.Functions.ElementGroundData(heights, nElementsR, location) "Matrix containg thermal properties for each element of the global problem {rho,cp,lamda}" annotation(Evaluate=true);
  parameter Real GLOBAL_capacityMatrix[nElementsZ,nElementsR]=array(GLOBAL_groundDataMatrix[1, z, r] * GLOBAL_groundDataMatrix[2, z, r] * Modelica.Constants.pi * GLOBAL_elementHeightsMatrix[z, r] * (GLOBAL_outerRadiusMatrix[z, r] ^ 2 - GLOBAL_innerRadiusMatrix[z, r] ^ 2) for r in 1:nElementsR, z in 1:nElementsZ) "Matrix containg the thermal capacity for each element of the global problem";
  parameter Real GLOBAL_storageCapacity=sum(GLOBAL_capacityMatrix[z, r] for z in iBHEheadElement:iBHEbottomElement, r in 1:nBHEelementsR);
  parameter Integer BHE_BHEsPerRingMatrix[nBHEelementsZ,nBHEelementsR]=fill(nBHEsPerRingVector, nBHEelementsZ) "Matrix containg number of BHEs within the ring for each element of the local problem";
  replaceable BHEmodel BHEarray[nBHEelementsR] constrainedby
    MoSDH.Components.Sources.Geothermal.BaseClasses.partialBHE(
   each nSegments=nBHEelementsZ,
   each BHElength=BHElength,
   each BHEdata=BHEdata,
   each groutData=groutData,
   each groutDataUpper=groutDataUpper,
   each medium=medium,
   each segmentLengths=heights[iBHEheadElement:iBHEbottomElement],
   each TinitialGrout=GLOBAL_TinitialMatrix[iBHEheadElement:iBHEbottomElement,1],
   each TinitialSupply=GLOBAL_TinitialMatrix[iBHEheadElement:iBHEbottomElement,1],
   each TinitialReturn=GLOBAL_TinitialMatrix[iBHEheadElement:iBHEbottomElement,1],
   nParallel=nBHEsPerRingVector) "Borehole heat exchanger type" annotation (
   Placement(transformation(extent={{-10,-10},{10,10}})),
   Dialog(
    group="Borehole Heat Exchangers",
    tab="Design"));
  MoSDH.Components.Utilities.Ground.GroundElement_externalCapacity GLOBAL_elementMatrix[nElementsZ,nElementsR](
   groundData(
    rho=GLOBAL_groundDataMatrix[1],
    cp=GLOBAL_groundDataMatrix[2],
    lamda=GLOBAL_groundDataMatrix[3]),
   innerRadius=GLOBAL_innerRadiusMatrix,
   outerRadius=GLOBAL_outerRadiusMatrix,
   elementHeight=transpose(fill(heights, nElementsR))) "Global problem modeling approach" annotation(Placement(transformation(extent={{40,20},{60,40}})));
  replaceable LOCALmodel LOCAL_elementMatrix[nBHEelementsZ,nBHEelementsR] constrainedby
    MoSDH.Components.Utilities.Ground.BaseClasses.LocalElement_partial(
   groundData(
    rho=GLOBAL_groundDataMatrix[1, iBHEheadElement:iBHEbottomElement, 1:nBHEelementsR],
    cp=GLOBAL_groundDataMatrix[2, iBHEheadElement:iBHEbottomElement, 1:nBHEelementsR],
    lamda=GLOBAL_groundDataMatrix[3, iBHEheadElement:iBHEbottomElement, 1:nBHEelementsR]),
   numberOfBHEsInRing=BHE_BHEsPerRingMatrix,
   each nRings=nCapacitiesLocal,
   each rEquivalent=rEquivalent,
   each rBorehole=BHEdata.dBorehole / 2,
   elementHeight=GLOBAL_elementHeightsMatrix[iBHEheadElement:iBHEbottomElement, 1:nBHEelementsR],
   Tinitial=GLOBAL_TinitialMatrix[iBHEheadElement:iBHEbottomElement, 1:nBHEelementsR]) "Local problem modeling approach" annotation (
   Placement(transformation(extent={{15,-10},{35,10}})),
   Dialog(
    group="Local problem & BHEs",
    tab="Modeling"));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor GLOBAL_groundCapacitiesTop[iBHEheadElement-1,nElementsR](
   C=GLOBAL_capacityMatrix[1:iBHEheadElement - 1],
   T(
    start=GLOBAL_TinitialMatrix[1:iBHEheadElement - 1],
    fixed=fill(true,iBHEheadElement-1,nElementsR))) "Thermal capacities of global model elements above the storage" annotation (
   choicesAllMatching=true,
   Placement(transformation(extent={{15,35},{35,55}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor GLOBAL_groundCapacitiesSide[iBHEbottomElement-iBHEheadElement+1,nElementsR-nBHEelementsR](
   C=GLOBAL_capacityMatrix[iBHEheadElement:iBHEbottomElement, nBHEelementsR + 1:nElementsR],
   T(
    start=GLOBAL_TinitialMatrix[iBHEheadElement:iBHEbottomElement, nBHEelementsR + 1:nElementsR],
    fixed=fill(true,iBHEbottomElement-iBHEheadElement+1,nElementsR-nBHEelementsR))) "Thermal capacities of global model elements beside the storage" annotation(Placement(transformation(extent={{15,35},{35,55}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor GLOBAL_groundCapacitiesBottom[nElementsZ-iBHEbottomElement,nElementsR](
   C=GLOBAL_capacityMatrix[iBHEbottomElement + 1:nElementsZ],
   T(
    start=GLOBAL_TinitialMatrix[iBHEbottomElement + 1:nElementsZ],
    fixed=fill(true,nElementsZ-iBHEbottomElement,nElementsR))) "Thermal capacities of global model elements below the storage" annotation(Placement(transformation(extent={{15,35},{35,55}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature GLOBAL_outerBC[nElementsZ](T=GLOBAL_TinitialMatrix[:, 1]) "Fixed temperature boundary condition at the model side" annotation(Placement(transformation(extent={{85,20},{65,40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow GLOBAL_innerBC[nElementsZ](each Q_flow=0) "Fixed heat flow boundary condition at the inner model boundary" annotation(Placement(transformation(extent={{15,20},{35,40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature GLOBAL_bottomBC[nElementsR](each T=location.Taverage + meshZ[nElementsZ + 1] * location.geoGradient) "Fixed temperature boundary condition at the model bottom" annotation(Placement(transformation(
   origin={50,5},
   extent={{-10,-10},{10,10}},
   rotation=90)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature GLOBAL_topBC[nElementsR] "Variable temperature boundary condition at the model top" annotation(Placement(transformation(
   origin={50,55},
   extent={{-10,-10},{10,10}},
   rotation=-90)));
  Modelica.Blocks.Sources.RealExpression TboreholeWall_sensor(y=TboreholeWall[1]) annotation(Placement(transformation(
   origin={-85,70},
   extent={{-10,-10},{10,10}},
   rotation=-90)));
initial algorithm
  assert(nBHEsInSeries == nSeries, "Number of BHEs in series and number of BHEs not compatibel. Using parallel connection as fallback!", AssertionLevel.warning);
  if printModelStructure then
    Modelica.Utilities.Streams.print("GLOBAL[" + String(nElementsZ) + "," + String(nElementsR) + "]:", "");
    Modelica.Utilities.Streams.print("superMeshZ: " + Modelica.Math.Vectors.toString(MoSDH.Components.Storage.BoreholeStorage.Functions.SupermeshZ(BHEstart, useUpperGroutSection, lengthUpperGroutSection,  BHElength, relativeModelDepth, location.layerThicknessVector), "", 6), "");
    Modelica.Utilities.Streams.print("meshZ[" + String(nElementsZ) + "]" + Modelica.Math.Vectors.toString(meshZ, "", 6), "");
    Modelica.Utilities.Streams.print("meshR[" + String(nElementsR) + "]" + Modelica.Math.Vectors.toString(meshR, "", 6), "");
    Modelica.Utilities.Streams.print("LOCAL[" + String(nBHEelementsZ) + "," + String(nBHEelementsR) + "]:", "");
    Modelica.Utilities.Streams.print("iBHEheadElement: " + String(iBHEheadElement) + "/ iGroutChange: " + String(iGroutChange) + "/ iBHEbottomElement: " + String(iBHEbottomElement), "");
    Modelica.Utilities.Streams.print("#BHEs in series: " + String(nSeries) + " / #BHEs per ring: " + Modelica.Math.Vectors.toString(nBHEsPerRingVector, "", 3), "");
    Modelica.Utilities.Streams.print("Area/BHE[r] " + Modelica.Math.Vectors.toString(array(Modelica.Constants.pi * (meshR[r] ^ 2 - meshR[r - 1] ^ 2) / nBHEsPerRingVector[r - 1] for r in 2:nBHEelementsR + 1), "", 6), "");
  end if;
equation
  /*Outputs---------------------------------------------*/
    Tsupply = supplyPort.h / medium.cp;
    Treturn = returnPort.h / medium.cp;
    volFlow = supplyPort.m_flow / medium.rho;
    dp=pump.dp;
    Pthermal = (Treturn-Tsupply) * supplyPort.m_flow * medium.cp;
    der(Qthermal) = Pthermal;
    der(QthermalCharged) = abs(min(Pthermal, 0));
    der(QthermalDischarged) = max(Pthermal, 0);

    Tstorage = sum(GLOBAL_elementMatrix[z, r].groundCenterPort.T * GLOBAL_capacityMatrix[z, r] for z in iBHEheadElement:iBHEbottomElement, r in 1:nBHEelementsR) / GLOBAL_storageCapacity;
    TboreholeWall = BHEarray[:].boreholeWallPort[integer((iBHEbottomElement + iBHEheadElement) / 2)].T;

      connect(supplyPort,pump.flowPort_a) annotation (
     Line(
      points={{-45,100},{-45,90},{-45,80},{-45,75}},
      color={255,0,0},
      thickness=1));

    /*GLOBAL model connections----------------------------------------*/
    /*Horizontally*/
  for z in 1:nElementsZ loop
      /*GLOBAL to inner & outer BCs */
  connect(GLOBAL_innerBC[z].port, GLOBAL_elementMatrix[z, 1].innerHeatPort) annotation(Line(
     points={{35,30},{40,30},{35,30},{40,30}},
     color={191,0,0},
     thickness=0.0625));
  connect(GLOBAL_elementMatrix[z,nElementsR].outerHeatPort,GLOBAL_outerBC[z].port) annotation(Line(
     points={{59.67,30},{59.67,30},{60,30},{65,30}},
     color={191,0,0},
     thickness=0.0625));
      /*GLOBAL to GLOBAL*/
  for r in 1:nElementsR - 1 loop
  connect(GLOBAL_elementMatrix[z,r].outerHeatPort,GLOBAL_elementMatrix[z,r+1].innerHeatPort) annotation(Line(points=0));
  end for;
  end for;

    /*Vertically*/
  for r in 1:nElementsR loop
      /*GLOBAL to top & bottom boundary conditions*/
  connect(Tambient.y, GLOBAL_topBC[r].T);
  connect(TsurfaceAverage.y, GLOBAL_topBC[r].T);
  connect(GLOBAL_topBC[r].port,GLOBAL_elementMatrix[1,r].topHeatPort) annotation(Line(
     points={{50,45},{50,40},{50,45},{50,40}},
     color={191,0,0},
     thickness=0.0625));
  connect(GLOBAL_elementMatrix[nElementsZ,r].bottomHeatPort,GLOBAL_bottomBC[r].port)  annotation(Line(
     points={{50,20.33},{50,20.33},{50,20},{50,15}},
     color={191,0,0},
     thickness=0.0625));
      /*GLOBAL to GLOBAL*/
  for z in 1:nElementsZ - 1 loop
  connect(GLOBAL_elementMatrix[z,r].bottomHeatPort,GLOBAL_elementMatrix[z+1,r].topHeatPort) annotation(Line(points=0));
  end for;
  end for;

    /*GLOBAL to external capacities (underground capacities are considered within local modals or externally if no local model is connected)*/
    /*above storage*/
  for r in 1:nElementsR loop
  for z in 1:iBHEheadElement - 1 loop
  connect(GLOBAL_groundCapacitiesTop[z,r].port,GLOBAL_elementMatrix[z,r].groundCenterPort) annotation(Line(
     points={{25,35},{25,30},{25,15.3},{45,15.3},{45,20.3}},
     color={191,0,0},
     thickness=0.0625));
  end for;
  end for;
  /*beside storage*/
  for r in nBHEelementsR + 1:nElementsR loop
  for z in iBHEheadElement:iBHEbottomElement loop
  connect(GLOBAL_groundCapacitiesSide[z-iBHEheadElement+1,r-nBHEelementsR].port,GLOBAL_elementMatrix[z,r].groundCenterPort) annotation(Line(points=0));
  end for;
  end for;
  /*below storage*/
  for r in 1:nElementsR loop
  for z in iBHEbottomElement + 1:nElementsZ loop
  connect(GLOBAL_groundCapacitiesBottom[z-iBHEbottomElement,r].port,GLOBAL_elementMatrix[z,r].groundCenterPort) annotation(Line(points=0));
  end for;
  end for;

    /*LOCAL, BHE & HYDR model connections-------------------------------------------------------------*/
    /*connect BHE outlets*/
  for r in 1:nBHEelementsR loop
  if nSeries == 1 then
  connect(BHEarray[r].returnPort,returnPort) annotation(Line(
     points={{5,10},{5,15},{5,100},{40,100},{45,100}},
     color={0,0,255},
     thickness=1));
  connect(pump.flowPort_b,BHEarray[r].supplyPort) annotation(Line(
     points={{-45,55.7},{-45,50.7},{-45,15},{-5,15},{-5,10}},
     color={0,0,255},
     thickness=1));
  else
  if r==1 then
  connect(pump.flowPort_b,BHEarray[1].supplyPort) annotation(Line(
     points={{-45,55.7},{-45,50.7},{-45,15},{-5,15},{-5,10}},
     color={255,0,0},
     thickness=1));
  else
  connect(BHEarray[r-1].returnPort,BHEarray[r].supplyPort) annotation(Line(points=0));
  end if;
  if r==nBHEelementsR then
  connect(BHEarray[nBHEelementsR].returnPort,returnPort) annotation(Line(
     points={{5,10},{5,15},{5,100},{40,100},{45,100}},
     color={0,0,255},
     thickness=1));
  end if;
  end if;

    /*BHEs to LOCAL elements*/
  for z in 1:nBHEelementsZ loop
  connect(BHEarray[r].boreholeWallPort[z],LOCAL_elementMatrix[z,r].boreholeWallPort);
  connect(LOCAL_elementMatrix[z,r].local2globalPort,GLOBAL_elementMatrix[z+iBHEheadElement-1,r].groundCenterPort);
  end for;
  end for;
 annotation (
  defaultComponentName="btes",
  Icon(
   coordinateSystem(extent={{-200,-200},{200,200}}),
   graphics={
       Bitmap(
        imageSource="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
uEGpdd11/wO49Szo/hIdeQAAAABJRU5ErkJggg==",
        extent={{-199.8,-200},{199.8,200}})}),
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

<body><h4>General</h4>
<p>Modelica Borehole Thermal Energy Storage model (MoBTES)<a href=\"modelica://MoSDH.UsersGuide.References\">[Formhals2020]</a>: The model consists of 3 sub-models (see Fig. 1):</p>
<ol>
<li>Global model</li>
<li>Local model</li>
<li>BHE model</li>
</ol>
<p>For each sub-model different modelling approaches can be selected. Additional approaches can be added by the user, provided that the new model uses the same interface (extends from the global/local/BHE partial model).</p>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>Model structure</caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/BTESstructure.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>

<h5>Global model</h5>
<p>The global model handles the heat diffusion processes between BHEs and the ground surrounding the storage. This process can be sufficiently simulated by considering the average temperature inside each global volume element. The only model which is currently implemented is a 2D finite differences model.</p>

<h5>Local model</h5>
<p>The local models represent the heat diffusion process around single BHEs. Since the storage model assumes radial symmetry, only one local model and one BHE model are simulated per storage ring. The BHEs inside each ring of the storage are assumed to behave similar. Each local model defines the relation between the borehole wall temperature of one BHE segment and the global temperature, i.e. the average temperature inside the volume element. Currently two options are implemented:</p>
<ol>
<li>steady flux model <a href=\"modelica://MoSDH.UsersGuide.References\">[Franke1998]</a></li>
<li>finite differences model</li>
</ol>
<p>The steady flux model exploits the fact that the thermal resistance between the borehole wall and the average volume temperature can be considered constant for the steady-flux regime. The transition period until the steady-flux regime is approximated by an one artificial capacity. This approach is most valid for scenarios with strong thermal interactions between neighbouring BHEs. It should not be used for systems with large disctances between BHEs. The finite differences approach divides the local model into ring segments. The heat diffusion process between the ring segments is handled with the finite-differences method. The weighted average temperature of the rings defines the associated global temperature. The user has the option to choose the number of rings that should be generated.</p>
<h5>BHE model</h5>
<p>For the BHE models there are currently two options. A thermal-resistance model (TRM) which only considers the thermal resistance between the fluid and the borehole wall and a thermal-resistance-capacitance model (TRCM) which additionally considers the thermal capacity of the grout. For each modelling approach models for single-U, double-U and coaxial heat exchangers are available. <a href=\"modelica://MoSDH.UsersGuide.References\">[Bauer2012]</a></p>

<h4>Model parametrization</h4>
<h5>Design</h5>
<p>Even though the actual storage model is a cylindrical model with radial symmetry, the user has the option to choose between different layouts (see Fig. 2). The minimal distance <strong>BHEspacing (D)</strong> beweteen BHEs which is defined by the user is converted to an equivalent distance for the actual model. The resulting cylindrical model has the same specific storage volume per BHE as the configuration defined by the user.</p>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 2: </strong>BTES layout options</caption>
  <tbody><tr>
    <td>
   <img src=\"modelica://MoSDH/Utilities/Images/BHEspacing.png\" width=\"500\">
    </td>
  </tr>
</tbody></table>

<p>The <strong>location</strong> record contains information on the local geology at the storage site. Up to 5 different layers can be defined in the record, including the insulation layer. Each layer is defined by its type of soil/rock and thickness. The layer thickness can generally be any number greater 0.5 m, but it is strongly recommended to use integer values to avoid unwanted model behaviour and to limit the size of the model's mesh. The average surface temperature and the geothermal gradient define the initial temperature of the model and the boundary conditions.</p>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 3: </strong>Vertical cross section</caption>
  <tbody><tr>
    <td>
   <img src=\"modelica://MoSDH/Utilities/Images/BTESsideView.png\" width=\"500\">
    </td>
  </tr>
</tbody></table>
<p>The parameters in the BHE section define the model inside the borehole. The type of BHE can be selected from single-U, double-U or coaxial. Accordingly a matching BHE data record has to be chosen. Optionally an upper grout section can be defined. For each of the two grout sections a different grout data record can be chosen, allowing the user to use a grout material with a reduced thermal conductivity in the top section, thus reducing thermal losses through the surface. </p>
<p>Serial connections can be defined by the parameter <strong>nBHEsInSeries</strong>. If the number of BHEs and the number of BHEs in series are not compatible, a warning is issued and parallel BHE connection is used as fallback option. Name conventions regarding serial connection correspond to charging of the storage from center BHEs to outer BHEs (see Fig. 3). For this case the volume flow <strong>volFlow</strong> is positive. </p>
<p>Charging (volFlow &gt; 0):</p>
<ul>
<li><strong>Tsupply:</strong> inlet temperature of BHEs in the center region of the storage</li>
<li><strong>Treturn:</strong> outlet temperature of BHEs in the outermost region of the storage</li>
</ul>
<p>Discharging (volFlow &lt; 0):</p>
<ul>
<li><strong>Tsupply:</strong> outlet temperature of BHEs in the center region of the storage</li>
<li><strong>Treturn:</strong> inlet temperature of BHEs in the outermost region of the storage</li>
</ul>

<h5>Modeling</h5>
<p>The numerical settings <strong>settingsData</strong> of the model are collected in records. The level of discretization (number of volume elements) are defined by the model's geometry and the parameters <strong>nAdditionalElementsR, dZminMax, nBHEsgementsMin, growthFactor and relativeModelDepth</strong>. The term \"desired\" indicates that the parameter is not fixed and will be ignored if another parameter value results in a finer level of discretization.</p>
<p>If the parameter <strong>useAverageSurfaceTemperature</strong> is set to false, the temperature at the ground surface has to be given to the model by a real input via <strong>Tambient</strong> of the conditional <strong>weatherPort</strong>.</p> 
<h5>Control</h5>
<p>The model contains a pump and the flow rate has to be defined with the control variable <b>volFlowRef</b>.&nbsp;</p>

<h4>Performance</h4><div>Depending on the used software and the size of the model, time for translation, compilation and simulation can vary significantly. The size of the generated model can be printed to the log by setting the parameter <b>printModelStructure</b> to true. The vertical meshing can be optimized by avoiding too small elements sizes, since the smallest element size defines the overall number of elements.&nbsp;</div>
<p style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">(C) Julian Formhals, 2022</p>
</body></html>"),
  experiment(
   StopTime=1,
   StartTime=0,
   Tolerance=1e-06,
   Interval=0.002));
end BTES;
