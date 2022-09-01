within MoSDH.Parameters.BoreholeHeatExchangers;
record BraedstrupBHEdata "2U - BrÃ¦dstrup configuration (DN32 - double-U pipe)"
 extends BHEparameters(
  dBorehole=0.15,
  spacing=sqrt(2*0.062^2),
  nShanks=2,
  dPipe1=0.032,
  tPipe1=0.0029,
  lamda1=0.4,
  dPipe2=0.032,
  tPipe2=0.0029,
  lamda2=0.4);
end BraedstrupBHEdata;