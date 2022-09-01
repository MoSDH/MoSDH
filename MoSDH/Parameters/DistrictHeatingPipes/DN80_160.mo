within MoSDH.Parameters.DistrictHeatingPipes;
record DN80_160 "DN80 preinsulated pipe with standard insulation"
	extends Modelica.Icons.Record;
	extends SinglePipePartial(
		dCasing=0.160,
		tCasing=0.0036,
		lamdaCasing=0.4,
		lamdaInsulation=0.024,
		dPipe=0.0889,
		tPipe=0.0032,
		lamdaPipe=55.2);
end DN80_160;