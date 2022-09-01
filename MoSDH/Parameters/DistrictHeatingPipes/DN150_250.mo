within MoSDH.Parameters.DistrictHeatingPipes;
record DN150_250 "DN150 preinsulated pipe with normal insulation"
 extends Modelica.Icons.Record;
 extends SinglePipePartial(
  dCasing=0.250,
  tCasing=0.0036,
  lamdaCasing=0.4,
  lamdaInsulation=0.024,
  dPipe=0.1683,
  tPipe=0.0045,
  lamdaPipe=55.2);
end DN150_250;