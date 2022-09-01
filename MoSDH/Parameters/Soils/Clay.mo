within MoSDH.Parameters.Soils;
record Clay "Clay (VDI4640)"
 extends MoSDH.Parameters.Soils.SoilPartial(
  rho=2100,
  cp=1140,
  lamda=1.8);
end Clay;