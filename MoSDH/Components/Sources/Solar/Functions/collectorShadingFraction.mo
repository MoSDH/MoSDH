within MoSDH.Components.Sources.Solar.Functions;
function collectorShadingFraction "Collector shading"
 extends Modelica.Icons.Function;
  input Modelica.Units.SI.Angle gamma
    "Azimut angle between collector orientation and south";
  input Modelica.Units.SI.Angle omega "Hour angle";
  input Modelica.Units.SI.Angle beta "Collector inclination";
  input Modelica.Units.SI.Angle theta "Zenit angle of the sun";
  input Modelica.Units.SI.Length H "Collector height";
  input Modelica.Units.SI.Length D
    "Collector row distances (including one collector row)";
 output Real shadingFactor "Fraction of a collector that is shaded by preceeding rows";
algorithm
  shadingFactor:=if theta<Modelica.Constants.pi/2 then min(1,max(0,
  -(D*cos(gamma)^2*cos(theta)-H*cos(beta)*cos(gamma)^2*cos(theta)+ D*cos(theta)*sin(gamma)^2-H*cos(beta)*cos(theta)*sin(gamma)^2-H*cos(gamma)*cos(omega)*sin(beta)*sin(theta)-H*sin(beta)*sin(gamma)*sin(theta)*sin(omega))/(H*(cos(beta)*cos(gamma)^2*cos(theta)+cos(beta)*cos(theta)*sin(gamma)^2+cos(gamma)*cos(omega)*sin(beta)*sin(theta)+sin(beta)*sin(gamma)*sin(theta)*sin(omega))))) else 1;
end collectorShadingFraction;