within MoSDH.Components.Utilities.Ground;

package BaseClasses "Ground element base classes"
  extends Modelica.Icons.BasesPackage;

  partial model LocalElement_partial "partial for local volume element solutions"
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b boreholeWallPort "Thermal port for 1-dim. heat transfer (unfilled rectangular icon)" annotation(
      Placement(transformation(extent = {{-115, 20}, {-135, 40}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b local2globalPort "Thermal port for 1-dim. heat transfer (unfilled rectangular icon)" annotation(
      Placement(transformation(extent = {{145, 20}, {125, 40}}), iconTransformation(extent = {{-10, 90}, {10, 110}})));
    replaceable parameter Parameters.Soils.Soil groundData constrainedby MoSDH.Parameters.Soils.SoilPartial annotation(
       choicesAllMatching = true);
    parameter Integer numberOfBHEsInRing = 1 "amplification at port b";
    parameter Integer nRings(min = 2, max = 20) = 10;
    parameter Real rEquivalent(quantity = "Length", displayUnit = "m", fixed = true) "Radius of BHE volume" annotation(
      Dialog(tab = "Ground"));
    parameter Real rBorehole(quantity = "Length", displayUnit = "m", fixed = true) "inner radius of volume element" annotation(
      Dialog(tab = "Ground"));
    parameter Real elementHeight(quantity = "Length", displayUnit = "m", fixed = true) "height of element" annotation(
      Dialog(tab = "Ground"));
    parameter Real Tinitial(quantity = "CelsiusTemperature", fixed = true) = 283.14999999999998 "initial temperature" annotation(
      Dialog(tab = "Ground"));
    annotation(
      Icon(graphics = {Bitmap(imageSource = "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
MXZqxpKMAAAAAElFTkSuQmCC", extent = {{-92.5, -100}, {92.5, 100}}), Line(points = {{-86.7, 0}, {-46.7, -6.7}}, thickness = 2.25)}),
      experiment(StopTime = 1, StartTime = 0, Interval = 0.002));
  end LocalElement_partial;

  partial model partialGroundElement "Partial model for ground elements"
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a innerHeatPort "Thermal port for a1-dim. heat transfer (filled rectangular icon)" annotation(
      Placement(transformation(extent = {{-105, 0}, {-85, 20}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a topHeatPort "Thermal port for 1-dim. heat transfer (filled rectangular icon)" annotation(
      Placement(transformation(extent = {{-35, 65}, {-15, 85}}), iconTransformation(extent = {{-10, 90}, {10, 110}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b bottomHeatPort "Thermal port for 1-dim. heat transfer (unfilled rectangular icon)" annotation(
      Placement(transformation(extent = {{-35, -45}, {-15, -25}}), iconTransformation(extent = {{-10, -106.7}, {10, -86.7}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b outerHeatPort "Thermal port for 1-dim. heat transfer (unfilled rectangular icon)" annotation(
      Placement(transformation(extent = {{35, 0}, {55, 20}}), iconTransformation(extent = {{86.7, -10}, {106.7, 10}})));
    replaceable parameter Parameters.Soils.Soil groundData constrainedby MoSDH.Parameters.Soils.SoilPartial annotation(
       choicesAllMatching = true);
    parameter Real innerRadius(quantity = "Length", displayUnit = "m", fixed = true, min = 0) "inner radius of volume element" annotation(
      Dialog(tab = "Ground"));
    parameter Real outerRadius(quantity = "Length", displayUnit = "m", fixed = true, min = 1) "outer radius of volume element" annotation(
      Dialog(tab = "Ground"));
    parameter Real elementHeight(quantity = "Length", displayUnit = "m", fixed = true) "height of element" annotation(
      Dialog(tab = "Ground"));
    parameter Real Tinitial(quantity = "CelsiusTemperature", fixed = true) = 283.14999999999998 "initial temperature" annotation(
      Dialog(tab = "Ground"));
    annotation(
      Icon(graphics = {Rectangle(fillColor = {210, 180, 140}, fillPattern = FillPattern.Solid, extent = {{-98.3, 86.3}, {98.3, -80.3}})}),
      experiment(StopTime = 1, StartTime = 0, Interval = 0.002));
  end partialGroundElement;
  annotation(
    dateModified = "2020-05-22 12:16:22Z");
end BaseClasses;
