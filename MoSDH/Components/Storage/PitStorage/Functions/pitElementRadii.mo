within MoSDH.Components.Storage.PitStorage.Functions;
function pitElementRadii "Dimensions for isovolumetric pit elements"
input Modelica.Units.SI.Volume storageVolume "=true, if inner triangular region";
 input Modelica.Units.SI.Length storageHeight "Number of elements";
  input Real slope "Wall slope";
  input Integer nElements "Pit elements";
 output Modelica.Units.SI.Length elementRadii[nElements+1] "Array of pit radii";
protected
 Integer i;
 Modelica.Units.SI.Length heights[nElements] "Array of pit heights";
 Modelica.Units.SI.Length radii[nElements+1] "Array of pit radii";
algorithm
 radii[1]:=(sqrt(12*storageHeight*slope^4*storageVolume - storageHeight^4*Modelica.Constants.pi*slope^2)/(storageHeight*sqrt(3*Modelica.Constants.pi)*slope) - storageHeight)/(2*slope);
  for i in 1:nElements loop
    heights[i]:=(Modelica.Constants.pi*radii[i]^3 *slope^3 +3*slope^2*storageVolume/nElements)^(1/3)/(Modelica.Constants.pi^(1/3))-radii[i]*slope;
    radii[i+1]:=radii[i]+heights[i]/slope;
  end for;
  elementRadii:=radii;
 annotation(Icon(graphics={
  Rectangle(
   fillColor={255,255,255},
   fillPattern=FillPattern.Solid,
   extent={{-100,-50},{-50,-100}}),
  Rectangle(
   fillColor={255,255,255},
   fillPattern=FillPattern.Solid,
   extent={{-50,-50.2},{0,-100.2}}),
  Rectangle(
   fillColor={255,255,255},
   fillPattern=FillPattern.Solid,
   extent={{-0.3,-50.2},{49.7,-100.2}}),
  Rectangle(
   fillColor={255,255,255},
   fillPattern=FillPattern.Solid,
   extent={{-49.8,0},{0.2,-50}}),
  Rectangle(
   fillColor={255,255,255},
   fillPattern=FillPattern.Solid,
   extent={{-0.1,-0.3},{49.9,-50.3}}),
  Rectangle(
   fillColor={255,255,255},
   fillPattern=FillPattern.Solid,
   extent={{-0.1,50.2},{49.9,0.2}}),
  Text(
   textString="r",
   extent={{-232.9,153.1},{100.1,-76.59999999999999}}),
  Line(
   points={{-30,76.7},{70,76.7}},
   arrow={
    Arrow.None,Arrow.Filled},
   thickness=4.5)}),             Icon(graphics={
  Rectangle(
   fillColor={255,255,255},
   fillPattern=FillPattern.Solid,
   extent={{-100,-50},{-50,-100}}),
  Rectangle(
   fillColor={255,255,255},
   fillPattern=FillPattern.Solid,
   extent={{-50,-50.2},{0,-100.2}}),
  Rectangle(
   fillColor={255,255,255},
   fillPattern=FillPattern.Solid,
   extent={{-0.3,-50.2},{49.7,-100.2}}),
  Rectangle(
   fillColor={255,255,255},
   fillPattern=FillPattern.Solid,
   extent={{-49.8,0},{0.2,-50}}),
  Rectangle(
   fillColor={255,255,255},
   fillPattern=FillPattern.Solid,
   extent={{-0.1,-0.3},{49.9,-50.3}}),
  Rectangle(
   fillColor={255,255,255},
   fillPattern=FillPattern.Solid,
   extent={{-0.1,50.2},{49.9,0.2}}),
  Text(
   textString="r",
   extent={{-232.9,153.1},{100.1,-76.59999999999999}}),
  Line(
   points={{-30,76.7},{70,76.7}},
   arrow={
    Arrow.None,Arrow.Filled},
   thickness=4.5)}));
end pitElementRadii;