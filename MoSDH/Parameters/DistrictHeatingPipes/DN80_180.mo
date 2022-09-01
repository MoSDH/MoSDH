within MoSDH.Parameters.DistrictHeatingPipes;
record DN80_180 "DN80 preinsulated pipe with reinforced insulation"
	extends Modelica.Icons.Record;
	extends SinglePipePartial(
		dCasing=0.180,
		tCasing=0.0036,
		lamdaCasing=0.4,
		lamdaInsulation=0.024,
		dPipe=0.0889,
		tPipe=0.0032,
		lamdaPipe=55.2);
end DN80_180;