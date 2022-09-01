within MoSDH.Parameters.BoreholeHeatExchangers;
record SingleU_DN40 "1U - DN40 - single-U pipe"
 extends BHEparameters(
  dBorehole=0.15,
  spacing=0.08,
  nShanks=1,
  dPipe1=0.04,
  tPipe1=0.003,
  lamda1=0.4,
  dPipe2=0.04,
  tPipe2=0.003,
  lamda2=0.4);
end SingleU_DN40;