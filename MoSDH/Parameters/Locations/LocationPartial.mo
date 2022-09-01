within MoSDH.Parameters.Locations;
partial record LocationPartial
 extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Temperature Taverage(displayUnit="degC")
    "average ambience temperature";
 parameter Real geoGradient "geothermal gradient (K/m)";
 parameter Integer layers(
  min=1,
  max=5,
  fixed=true) "number of ground layers";
 replaceable parameter MoSDH.Parameters.Soils.Soil strat1 constrainedby
    MoSDH.Parameters.Soils.SoilPartial                                                                     "thermo physical properties layer 1";
 replaceable parameter MoSDH.Parameters.Soils.Soil strat2 constrainedby
    MoSDH.Parameters.Soils.SoilPartial                                                                     "thermo physical properties layer 2";
 replaceable parameter MoSDH.Parameters.Soils.Soil strat3 constrainedby
    MoSDH.Parameters.Soils.SoilPartial                                                                     "thermo physical properties layer 3";
 replaceable parameter MoSDH.Parameters.Soils.Soil strat4 constrainedby
    MoSDH.Parameters.Soils.SoilPartial                                                                     "thermo physical properties layer 4";
 replaceable parameter MoSDH.Parameters.Soils.Soil strat5 constrainedby
    MoSDH.Parameters.Soils.SoilPartial                                                                     "thermo physical properties layer 5";
  parameter Modelica.Units.SI.Length layerThicknessVector[5](each min=1) = {
    1000,1,1,1,1} "Thickness of all ground layers.";
 final parameter Real cpVector[5]={strat1.cp,strat2.cp,strat3.cp,strat4.cp,strat5.cp};
 final parameter Real rhoVector[5]={strat1.rho,strat2.rho,strat3.rho,strat4.rho,strat5.rho};
 final parameter Real lamdaVector[5]={strat1.lamda,strat2.lamda,strat3.lamda,strat4.lamda,strat5.lamda};
end LocationPartial;