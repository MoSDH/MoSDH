within MoSDH.Parameters.Grouts;
record Grout20 "Grout with high thermal conductivity (Î»=2,0 W/m/K)"
 extends MoSDH.Parameters.Grouts.GroutPartial(
  lamda=2,
  cp=1300,
  rho=1900);
end Grout20;