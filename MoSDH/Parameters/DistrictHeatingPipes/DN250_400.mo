within MoSDH.Parameters.DistrictHeatingPipes;
record DN250_400 "DN250 preinsulated district heating pipe with normal insulation."
 extends Modelica.Icons.Record;
 extends SinglePipePartial(
  dCasing=0.4,
  tCasing=0.0048,
  lamdaCasing=0.4,
  lamdaInsulation=0.025,
  dPipe=0.273,
  tPipe=0.0071,
  lamdaPipe=0.4);
end DN250_400;