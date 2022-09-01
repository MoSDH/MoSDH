within MoSDH.Parameters.DistrictHeatingPipes;
record DN250_500 "DN250 preinsulated district heating pipe with 2x reinforced insulation."
 extends Modelica.Icons.Record;
 extends SinglePipePartial(
  dCasing=0.500,
  tCasing=0.0056,
  lamdaCasing=0.4,
  lamdaInsulation=0.025,
  dPipe=0.273,
  tPipe=0.0063,
  lamdaPipe=0.4);
end DN250_500;