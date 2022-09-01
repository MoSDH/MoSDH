within MoSDH.Parameters.Grouts;
record Grout05 "Grout with very low thermal conductivity (Î»=0.5 W/m/K)"
 extends GroutPartial(
  lamda=1.0,
  cp=1300,
  rho=1900);
end Grout05;