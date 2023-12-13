within MoSDH.Utilities.Interfaces;
connector Weather "Weather data connector"
	input Modelica.Units.SI.Temperature Tambient "Ambient temperature";
	input Modelica.Units.SI.Irradiance beamIrradiation[3] "Beam irradiance vector {E,N,U}";
	input Modelica.Units.SI.Irradiance diffuseIrradiation "Diffuse irradiance";
	input Modelica.Units.SI.Irradiance totalIrradiation "Diffuse irradiance";
	input Modelica.Units.SI.Velocity windSpeed "Wind speed";
	input Modelica.Units.SI.Angle zenitAngle "Zenit angle of the sun";
	input Modelica.Units.SI.Angle hourAngle "Hour angle of the sun";
	input Integer monthOfTheYear "Counter for the current month of the calendar year";
	input Integer dayOfTheMonth "Counter for the current day of the month";
	input Integer dayOfTheYear "Counter for the current day of the calendar year";
	input Integer yearOfSimulation "Counter for the current month of the simulation";
	input Modelica.Units.SI.Time timeOfTheYear "Time of the year";
	input Integer season "Season of the year";
	annotation(
		Icon(graphics={
		Ellipse(
			lineColor={0,176,80},
			fillColor={0,176,80},
			fillPattern=FillPattern.Solid,
			lineThickness=0.1,
			extent={{-98,98},{98,-98}})}),
		Diagram(graphics={
			Ellipse(
				lineColor={0,176,80},
				fillColor={0,176,80},
				fillPattern=FillPattern.Solid,
				extent={{-48,48},{48,-48}}),
			Text(
				textString="%name",
				lineColor={0,0,255},
				extent={{-100,110},{100,50}})}));
end Weather;
