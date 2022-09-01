within MoSDH.Parameters.Locations;
record SingleLayerLocation "Location with one layer"
 extends LocationPartial(
  Taverage=283.15,
  geoGradient=0.03,
  layers=1,
  layerThicknessVector={1000,1,1,1,1});
end SingleLayerLocation;