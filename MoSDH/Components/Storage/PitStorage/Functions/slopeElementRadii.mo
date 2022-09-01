within MoSDH.Components.Storage.PitStorage.Functions;
function slopeElementRadii "calculates radius the ground elements in the triangular regions of the embankment"
 input Boolean isInnerSlope "=true, if inner triangular region";
 input Integer nElements "Number of elements";
  input Modelica.Units.SI.Length radii[:];
 output Real elementRadii[nElements] "Matrix containing the ground data";
protected
  Integer i "element index";
algorithm
  /*------ EMBANKMENT ELEMENT NUMBERING 'i' ------
			INNER SLOPE 		OUTER SLOPE
					6		1
				4	5		2	3
			1	2	3		4	5	6
			-------------------------------*/
  i:=1;
  for z in 1:size(radii,1) loop
   for r in 1:size(radii,1) loop
    if  isInnerSlope and r>=z then
     elementRadii[i]:=radii[r];
     i:=i+1;
    elseif not
              (isInnerSlope) and r<=z then
     elementRadii[i]:=radii[r];
     i:=i+1;
    end if;
   end for;
  end for;
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
   thickness=4.5)}));
end slopeElementRadii;