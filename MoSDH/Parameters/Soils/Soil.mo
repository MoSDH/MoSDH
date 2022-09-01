within MoSDH.Parameters.Soils;
record Soil "Generic soil"
 extends SoilPartial(
  rho=2500,
  cp=800,
  lamda=2.5);
end Soil;