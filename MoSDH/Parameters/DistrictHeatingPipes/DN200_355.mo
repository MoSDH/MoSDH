within MoSDH.Parameters.DistrictHeatingPipes;
record DN200_355 "DN200 preinsulated pipe with reinforced insulation"
 extends Modelica.Icons.Record;
 extends SinglePipePartial(
  dCasing=0.355,
  tCasing=0.0045,
  lamdaCasing=0.4,
  lamdaInsulation=0.024,
  dPipe=0.2191,
  tPipe=0.0063,
  lamdaPipe=55.2);
end DN200_355;