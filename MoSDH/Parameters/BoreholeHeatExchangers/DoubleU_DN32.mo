within MoSDH.Parameters.BoreholeHeatExchangers;
record DoubleU_DN32 "2U - DN32 - double-U pipe"
 extends BHEparameters(
  dBorehole=0.13,
  spacing=0.08,
  nShanks=2,
  dPipe1=0.032,
  tPipe1=0.003,
  lamda1=0.4,
  dPipe2=0.032,
  tPipe2=0.003,
  lamda2=0.4);
end DoubleU_DN32;