within MoSDH.Utilities;
package Icons "NewPackage1"
 extends Modelica.Icons.Package;

 model Legend "Connector type legend"
  annotation (
   Icon(
    coordinateSystem(extent={{-375,-200},{375,200}}),
    graphics={
     Text(
      textString="return line",
      fontSize=16,
      fontName="Arial",
      textStyle={
       TextStyle.Bold},
      horizontalAlignment=TextAlignment.Left,
      extent={{-144.9,46.8},{367.8,-0.1}}),
     Text(
      textString="supply line",
      fontSize=16,
      fontName="Arial",
      textStyle={
       TextStyle.Bold},
      horizontalAlignment=TextAlignment.Left,
      extent={{-140.9,149.9},{435.5,97}}),
     Text(
      textString="weather data",
      fontSize=16,
      fontName="Arial",
      textStyle={
       TextStyle.Bold},
      horizontalAlignment=TextAlignment.Left,
      extent={{-139.7,-58.2},{522.7,-95.7}}),
     Text(
      textString="control bus",
      fontSize=16,
      fontName="Arial",
      textStyle={
       TextStyle.Bold},
      horizontalAlignment=TextAlignment.Left,
      extent={{-142.8,-147.6},{446.3,-205.3}}),
     Ellipse(
      lineColor={255,0,0},
      fillColor={255,0,0},
      fillPattern=FillPattern.Solid,
      extent={{-374.3,153.1},{-320.9,99.8}}),
     Ellipse(
      lineColor={255,0,0},
      fillColor={255,0,0},
      fillPattern=FillPattern.Solid,
      extent={{-228.6,153.9},{-175.2,100.6}}),
     Line(
      points={{-350,126.7},{-200,126.7}},
      color={255,0,0},
      thickness=16),
     Ellipse(
      lineColor={0,0,255},
      fillColor={0,0,255},
      fillPattern=FillPattern.Solid,
      extent={{-374.6,53.4},{-321.2,0.1}}),
     Ellipse(
      lineColor={0,0,255},
      fillColor={0,0,255},
      fillPattern=FillPattern.Solid,
      extent={{-228.9,54.2},{-175.5,0.9}}),
     Line(
      points={{-350.3,27},{-200.3,27}},
      color={0,0,255},
      thickness=16),
     Ellipse(
      lineColor={0,147,0},
      fillColor={0,147,0},
      fillPattern=FillPattern.Solid,
      extent={{-374.9,-46.3},{-321.5,-99.59999999999999}}),
     Ellipse(
      lineColor={0,147,0},
      fillColor={0,147,0},
      fillPattern=FillPattern.Solid,
      extent={{-229.2,-45.5},{-175.8,-98.8}}),
     Line(
      points={{-350.6,-72.7},{-200.6,-72.7}},
      color={0,147,0},
      thickness=8),
     Line(
      points={{-349.9,-172.4},{-199.9,-172.4}},
      color={127,127,127},
      thickness=8),
     Ellipse(
      pattern=LinePattern.Dash,
      lineColor={127,127,127},
      fillColor={255,215,0},
      fillPattern=FillPattern.Solid,
      lineThickness=6,
      extent={{-374.2,-146},{-320.8,-199.3}}),
     Ellipse(
      pattern=LinePattern.Dash,
      lineColor={127,127,127},
      fillColor={255,215,0},
      fillPattern=FillPattern.Solid,
      lineThickness=6,
      extent={{-228.5,-145.2},{-175.1,-198.5}})}),
   experiment(
    StopTime=1,
    StartTime=0,
    Tolerance=1e-06,
    Interval=0.001));
 end Legend;

 annotation (
  dateModified="2021-07-30 10:10:22Z",
  Icon(
   coordinateSystem(preserveAspectRatio=false),
   graphics={
    Polygon(
     points={{-15.833,20},{-15.833,30},{14.167,40},{24.167,20},{4.167,-30},{14.167,
     -30},{24.167,-30},{24.167,-40},{-5.833,-50},{-15.833,-30},{4.167,20},{-5.833,
     20}},
     smooth=Smooth.Bezier,
     pattern=LinePattern.None,
     fillColor={128,128,128},
     fillPattern=FillPattern.Solid,
     origin={-8.167,-17}),
    Ellipse(
     pattern=LinePattern.None,
     fillColor={128,128,128},
     fillPattern=FillPattern.Solid,
     extent={{-12.5,-12.5},{12.5,12.5}},
     origin={-0.5,56.5})}));
end Icons;