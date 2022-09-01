within MoSDH.Parameters.DistrictHeatingPipes;
record DN200_400 "DN200 preinsulated pipe with 2x reinforced insulation"
 extends Modelica.Icons.Record;
 extends SinglePipePartial(
  dCasing=0.400,
  tCasing=0.0048,
  lamdaCasing=0.4,
  lamdaInsulation=0.024,
  dPipe=0.2191,
  tPipe=0.0063,
  lamdaPipe=55.2);
end DN200_400;