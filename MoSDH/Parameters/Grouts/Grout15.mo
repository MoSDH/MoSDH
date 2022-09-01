within MoSDH.Parameters.Grouts;
record Grout15 "Grout with average thermal conductivity (Î»=1,5 W/m/K)"
 extends GroutPartial(
  lamda=1.5,
  cp=1300,
  rho=1900);
end Grout15;