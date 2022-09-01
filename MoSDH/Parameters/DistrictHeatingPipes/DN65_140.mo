within MoSDH.Parameters.DistrictHeatingPipes;
record DN65_140 "DN65 preinsulated pipe with standard insulation"
	extends Modelica.Icons.Record;
	extends SinglePipePartial(
		dCasing=0.140,
		tCasing=0.0036,
		lamdaCasing=0.4,
		lamdaInsulation=0.024,
		dPipe=0.0761,
		tPipe=0.0032,
		lamdaPipe=55.2);
end DN65_140;