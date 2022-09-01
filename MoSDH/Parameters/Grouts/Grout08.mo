within MoSDH.Parameters.Grouts;
record Grout08 "Grout with thermal conductivity of Î»=0.8 W/m/K"
 extends GroutPartial(
  lamda=0.8,
  cp=1300,
  rho=1900);
end Grout08;