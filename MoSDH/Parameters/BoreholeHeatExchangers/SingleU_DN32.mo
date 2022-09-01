within MoSDH.Parameters.BoreholeHeatExchangers;
record SingleU_DN32 "1U - DN32 - single-U pipe"
 extends BHEparameters(
  dBorehole=0.13,
  spacing=0.064,
  nShanks=1,
  dPipe1=0.032,
  tPipe1=0.003,
  lamda1=0.4,
  dPipe2=0.032,
  tPipe2=0.003,
  lamda2=0.4);
end SingleU_DN32;