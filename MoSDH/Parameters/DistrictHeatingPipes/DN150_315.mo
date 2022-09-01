within MoSDH.Parameters.DistrictHeatingPipes;
record DN150_315 "DN150 preinsulated pipe with 2x reinforced insulation"
 extends Modelica.Icons.Record;
 extends SinglePipePartial(
  dCasing=0.315,
  tCasing=0.0041,
  lamdaCasing=0.4,
  lamdaInsulation=0.024,
  dPipe=0.1683,
  tPipe=0.0045,
  lamdaPipe=55.2);
end DN150_315;