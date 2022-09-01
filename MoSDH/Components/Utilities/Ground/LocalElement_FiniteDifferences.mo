within MoSDH.Components.Utilities.Ground;

model LocalElement_FiniteDifferences "Finite differences method model"
  extends MoSDH.Components.Utilities.Ground.BaseClasses.LocalElement_partial;
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor volumeHeatCapacity[nRings](C = numberOfBHEsInRing * groundData.cp * groundData.rho * Modelica.Constants.pi * elementHeight * (rEquivalent ^ 2 - rBorehole ^ 2) * weights, T(each start = Tinitial, each fixed = true)) "Lumped thermal element storing heat" annotation(
    Placement(transformation(extent = {{-15, 40}, {5, 60}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor volumeThermalResitances[nRings](R = thermalResistances);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaTsupplyToLocal[nRings];
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaTsupplyToGlobal;
  Real Tmean(quantity = "CelsiusTemperature") "initial temperature";
  Modelica.Units.SI.HeatFlowRate Qflow;
  parameter Real deltRadiusMin = (rEquivalent - rBorehole) * 2 * (sqrt(2) - 1) / (4 * sqrt(2) - 6 + 2 ^ (nRings / 2));
  parameter Real deltaRadii[nRings + 1] = if nRings <= 3 then cat(1, {rBorehole}, fill((rEquivalent - rBorehole) / nRings, nRings)) else cat(1, {rBorehole, deltRadiusMin, deltRadiusMin, deltRadiusMin}, {deltRadiusMin * sqrt(2) ^ iRing for iRing in 1:nRings - 3});
  parameter Real radii[nRings + 1] = {sum(deltaRadii[i] for i in 1:iRing) for iRing in 1:nRings + 1};
  parameter Real massCenterRadii[nRings] = {sqrt((radii[iRing + 1] ^ 2 + radii[iRing] ^ 2) / 2) for iRing in 1:nRings};
  parameter Real weights[nRings] = {(radii[iRing + 1] ^ 2 - radii[iRing] ^ 2) / (rEquivalent ^ 2 - rBorehole ^ 2) for iRing in 1:nRings} "weighting of ports b for heat flow calculation";
  parameter Real thermalResistances[nRings] = cat(1, {log(massCenterRadii[1] / rBorehole) / (2 * Modelica.Constants.pi * elementHeight * numberOfBHEsInRing * groundData.lamda)}, {log(massCenterRadii[iRing + 1] / massCenterRadii[iRing]) / (2 * Modelica.Constants.pi * elementHeight * numberOfBHEsInRing * groundData.lamda) for iRing in 1:nRings - 1});
equation
  Tmean = sum(volumeHeatCapacity[iRing].T * weights[iRing] for iRing in 1:nRings);
  local2globalPort.T = Tmean;
  heaTsupplyToGlobal.Q_flow = -Qflow;
  connect(heaTsupplyToGlobal.port, local2globalPort);
  for iRing in 1:nRings loop
    heaTsupplyToLocal[iRing].Q_flow = weights[iRing] * Qflow;
    connect(heaTsupplyToLocal[iRing].port, volumeHeatCapacity[iRing].port);
    connect(volumeThermalResitances[iRing].port_b, volumeHeatCapacity[iRing].port);
    if iRing == 1 then
      connect(boreholeWallPort, volumeThermalResitances[iRing].port_a);
    else
      connect(volumeHeatCapacity[iRing - 1].port, volumeThermalResitances[iRing].port_a);
    end if;
  end for;
  annotation(
    Icon(graphics = {Bitmap(imageSource = "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
hQyCvacZAAAAAElFTkSuQmCC", extent = {{-66.8, -83.3}, {66.40000000000001, 66.59999999999999}})}),
    Documentation(info = "<html>
<p>
Element of the local model which connects the global model to the borehole heat exchanger model. This option uses a finite differences approach.
</p>



</html>"),
    experiment(StopTime = 1, StartTime = 0, Tolerance = 1e-06, Interval = 0.001));
end LocalElement_FiniteDifferences;
