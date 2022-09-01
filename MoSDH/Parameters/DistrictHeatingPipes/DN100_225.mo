within MoSDH.Parameters.DistrictHeatingPipes;
record DN100_225 "DN100 preinsulated pipe with reinforced insulation"
	extends Modelica.Icons.Record;
	extends SinglePipePartial(
		dCasing=0.225,
		tCasing=0.0036,
		lamdaCasing=0.4,
		lamdaInsulation=0.024,
		dPipe=0.1143,
		tPipe=0.0036,
		lamdaPipe=55.2);
end DN100_225;