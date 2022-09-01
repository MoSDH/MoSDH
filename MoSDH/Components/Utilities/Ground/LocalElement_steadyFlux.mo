within MoSDH.Components.Utilities.Ground;

model LocalElement_steadyFlux "Steady flux model"
  extends MoSDH.Components.Utilities.Ground.BaseClasses.LocalElement_partial;
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C_wallToGround_sf(C = numberOfBHEsInRing * elementHeight * rEquivalent ^ 2 / (15 * RsteadyFlux * groundData.lamda / (groundData.rho * groundData.cp)), T(start = Tinitial, fixed = true)) "thermal capacity for steady flux dynamic equivalent model (Franke,1998)" annotation(
    Placement(transformation(origin = {-30, 45}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor R_wallToGround_sf1(R = RsteadyFlux / (2 * elementHeight * numberOfBHEsInRing)) "conductive thermal resistance " annotation(
    Placement(transformation(origin = {-80, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor R_wallToGround_sf2(R = RsteadyFlux / (2 * elementHeight * numberOfBHEsInRing)) "conductive thermal resistance " annotation(
    Placement(transformation(origin = {10, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  parameter Real RsteadyFlux = (log(rEquivalent / rBorehole) - 3 / 4) / (2 * Modelica.Constants.pi * groundData.lamda) "steady flux thermal resistance for the dynamic equivalent model (Franke, 1998)";
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor volumeHeatCapacity(C = groundData.cp * groundData.rho * Modelica.Constants.pi * elementHeight * (rEquivalent ^ 2 - rBorehole ^ 2) * numberOfBHEsInRing, T(start = Tinitial, fixed = true)) "Lumped thermal element storing heat" annotation(
    Placement(transformation(extent = {{40, 35}, {60, 55}})));
equation
  connect(R_wallToGround_sf1.port_a, C_wallToGround_sf.port) annotation(
    Line(points = {{-70, 30}, {-65, 30}, {-30, 30}, {-30, 35}}, color = {191, 0, 0}, thickness = 0.0625));
  connect(C_wallToGround_sf.port, R_wallToGround_sf2.port_a) annotation(
    Line(points = {{-30, 35}, {-30, 30}, {-5, 30}, {0, 30}}, color = {191, 0, 0}, thickness = 0.0625));
  connect(R_wallToGround_sf2.port_b, volumeHeatCapacity.port) annotation(
    Line(points = {{20, 30}, {25, 30}, {50, 30}, {50, 35}}, color = {191, 0, 0}, thickness = 0.0625));
  connect(R_wallToGround_sf1.port_b, boreholeWallPort) annotation(
    Line(points = {{-90, 30}, {-95, 30}, {-120, 30}, {-125, 30}}, color = {191, 0, 0}, thickness = 0.0625));
  connect(volumeHeatCapacity.port, local2globalPort) annotation(
    Line(points = {{50, 35}, {50, 30}, {130, 30}, {135, 30}}, color = {191, 0, 0}, thickness = 0.0625));
  annotation(
    Icon(graphics = {Bitmap(imageSource = "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", extent = {{-67, -92.90000000000001}, {69.7, 73.3}})}),
    Documentation(info = "<html>
<p>
Element of the local model which connects the global model to the borehole heat exchanger model. This option uses the steady flux resistance with one additional thermal capacity to achieve a simple model.
</p>



</html>"),
    experiment(StopTime = 1, StartTime = 0, Tolerance = 1e-06, Interval = 0.001));
end LocalElement_steadyFlux;
