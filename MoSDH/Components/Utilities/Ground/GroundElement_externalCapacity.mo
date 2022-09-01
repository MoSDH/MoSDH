within MoSDH.Components.Utilities.Ground;

model GroundElement_externalCapacity "Ground element for radial symmetric models without capacity"
  extends MoSDH.Components.Utilities.Ground.BaseClasses.partialGroundElement;
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor resistanceCenterToInner(R = if innerRadius > 0 then log((innerRadius + outerRadius) / max(0.1, 2 * innerRadius)) / max(0.1, 2 * Modelica.Constants.pi * elementHeight * groundData.lamda) else 1) "Lumped thermal element transporting heat without storing it" annotation(
    Placement(transformation(extent = {{-80, 0}, {-60, 20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor resistanceCenterToOuter(R = if innerRadius > 0 then log(2 * outerRadius / (outerRadius + innerRadius)) / max(0.1, 2 * Modelica.Constants.pi * elementHeight * groundData.lamda) else log(outerRadius / 0.075) / (2 * Modelica.Constants.pi * elementHeight * groundData.lamda)) "Lumped thermal element transporting heat without storing it" annotation(
    Placement(transformation(extent = {{5, 0}, {25, 20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor resistanceCenterToTop(R = elementHeight / max(0.1, 2 * Modelica.Constants.pi * groundData.lamda * (outerRadius ^ 2 - innerRadius ^ 2))) "Lumped thermal element transporting heat without storing it" annotation(
    Placement(transformation(origin = {-32.5, 52.5}, extent = {{-7.5, -7.5}, {12.5, 12.5}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor resistanceCenterToBottom(R = elementHeight / (2 * Modelica.Constants.pi * groundData.lamda * (outerRadius ^ 2 - innerRadius ^ 2))) "Lumped thermal element transporting heat without storing it" annotation(
    Placement(transformation(origin = {-32.5, -7.5}, extent = {{-12.5, -12.5}, {7.5, 7.5}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b groundCenterPort "Thermal port for 1-dim. heat transfer (unfilled rectangular icon)" annotation(
    Placement(transformation(extent = {{25, 45}, {5, 65}}), iconTransformation(extent = {{-60, -106.7}, {-40, -86.7}})));
equation
  connect(resistanceCenterToInner.port_a, innerHeatPort) annotation(
    Line(points = {{-80, 10}, {-85, 10}, {-90, 10}, {-95, 10}}, color = {191, 0, 0}, thickness = 0.0625));
  connect(resistanceCenterToTop.port_a, topHeatPort) annotation(
    Line(points = {{-30, 60}, {-30, 65}, {-30, 75}, {-25, 75}}, color = {191, 0, 0}, thickness = 0.0625));
  connect(resistanceCenterToBottom.port_a, bottomHeatPort) annotation(
    Line(points = {{-30, -20}, {-30, -25}, {-30, -35}, {-25, -35}}, color = {191, 0, 0}, thickness = 0.0625));
  connect(resistanceCenterToOuter.port_b, outerHeatPort) annotation(
    Line(points = {{25, 10}, {30, 10}, {40, 10}, {45, 10}}, color = {191, 0, 0}, thickness = 0.0625));
  connect(resistanceCenterToInner.port_b, groundCenterPort) annotation(
    Line(points = {{-60, 10}, {-55, 10}, {-35, 10}, {-35, 20}, {-30, 20}}, color = {191, 0, 0}, thickness = 0.0625));
  connect(resistanceCenterToBottom.port_b, groundCenterPort) annotation(
    Line(points = {{-30, 0}, {-30, 5}, {-25, 5}, {-25, 20}, {-30, 20}}, color = {191, 0, 0}, thickness = 0.0625));
  connect(resistanceCenterToOuter.port_a, groundCenterPort) annotation(
    Line(points = {{5, 10}, {0, 10}, {-25, 10}, {-25, 20}, {-30, 20}}, color = {191, 0, 0}, thickness = 0.0625));
  connect(resistanceCenterToTop.port_b, groundCenterPort) annotation(
    Line(points = {{-30, 40}, {-30, 35}, {-25, 35}, {-25, 20}, {-30, 20}}, color = {191, 0, 0}, thickness = 0.0625));
  annotation(
    Icon(graphics = {Bitmap(imageSource = "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
AABJRU5ErkJggg==", extent = {{-101.7, -90.3}, {108.3, 89.7}})}),
    Documentation(info = "<html>
<p>
Element for subsurface conductive heat transport.
</p>



</html>"),
    experiment(StopTime = 1, StartTime = 0, Tolerance = 1e-06, Interval = 0.001));
end GroundElement_externalCapacity;
