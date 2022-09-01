within MoSDH.Parameters.BoreholeHeatExchangers;
record DoubleU_DN40 "2U - DN40 - double-U pipe"
 extends BHEparameters(
  dBorehole=0.15,
  spacing=0.09,
  nShanks=2,
  dPipe1=0.04,
  tPipe1=0.003,
  lamda1=0.4,
  dPipe2=0.04,
  tPipe2=0.003,
  lamda2=0.4);
end DoubleU_DN40;