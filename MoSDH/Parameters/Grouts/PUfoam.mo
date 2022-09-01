within MoSDH.Parameters.Grouts;
record PUfoam "PU foam for insulation of twin pipes"
 extends GroutPartial(
  lamda=0.024,
  cp=1000,
  rho=23);
end PUfoam;