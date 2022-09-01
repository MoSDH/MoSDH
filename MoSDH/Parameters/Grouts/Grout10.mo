within MoSDH.Parameters.Grouts;
record Grout10 "Grout with low thermal conductivity (Î»=1,0 W/m/K)"
 extends GroutPartial(
  lamda=1.0,
  cp=1300,
  rho=1900);
end Grout10;