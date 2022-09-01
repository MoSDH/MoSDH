within MoSDH.Parameters.Locations;
record FiveLayerLocation "Generic location with 5 layers"
 extends LocationPartial(
  Taverage=284.15,
  geoGradient=0.03,
  layers=5,
  redeclare replaceable parameter Soils.MusselShells strat1,
  redeclare replaceable parameter Soils.Sand_moist strat2,
  redeclare replaceable parameter Soils.Sand_saturated strat3,
  redeclare replaceable parameter Soils.Clay strat4,
  redeclare replaceable parameter Soils.Sandstone strat5,
  layerThicknessVector={1,2,5,20,1000});
end FiveLayerLocation;