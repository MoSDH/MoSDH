within MoSDH.Parameters.DistrictHeatingPipes;
record DN150_280 "DN150 preinsulated pipe with reinforced insulation"
 extends Modelica.Icons.Record;
 extends SinglePipePartial(
  dCasing=0.280,
  tCasing=0.0039,
  lamdaCasing=0.4,
  lamdaInsulation=0.024,
  dPipe=0.1683,
  tPipe=0.0045,
  lamdaPipe=55.2);
end DN150_280;