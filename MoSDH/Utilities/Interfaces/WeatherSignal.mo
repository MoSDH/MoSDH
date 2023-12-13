within MoSDH.Utilities.Interfaces;
connector WeatherSignal "Weather data connector"
	output Modelica.Units.SI.Temperature Tambient "Ambient temperature";
	output Modelica.Units.SI.Irradiance beamIrradiation[3] "Beam irradiance vector {E,N,U}";
	output Modelica.Units.SI.Irradiance diffuseIrradiation "Diffuse irradiance";
	output Modelica.Units.SI.Irradiance totalIrradiation "Diffuse irradiance";
	output Modelica.Units.SI.Velocity windSpeed "Wind speed";
	output Modelica.Units.SI.Angle zenitAngle "Zenit angle of the sun";
	output Modelica.Units.SI.Angle hourAngle "Hour angle of the sun";
	output Integer monthOfTheYear "Counter for the current month of the calendar year";
	output Integer dayOfTheMonth "Counter for the current day of the month";
	output Integer dayOfTheYear "Counter for the current day of the calendar year";
	output Integer yearOfSimulation "Counter for the current month of the simulation";
	output Modelica.Units.SI.Time timeOfTheYear "Time of the year";
	output Integer season "Season of the year";
	annotation(
		Icon(graphics = {Ellipse(lineColor = {0, 176, 80}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 0.3, extent = {{-98, 98}, {98, -98}}), Polygon(origin = {0, 25}, lineColor = {0, 170, 0}, fillColor = {0, 170, 0}, fillPattern = FillPattern.Solid, points = {{-80, -71}, {80, -71}, {0, 65}, {0, 65}, {-80, -71}})}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
		Diagram(graphics = {Ellipse(lineColor = {0, 176, 80}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 0.3, extent = {{-48, 48}, {48, -48}}), Text(textColor = {0, 0, 255}, extent = {{-100, 110}, {100, 50}}, textString = "%name")}, coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end WeatherSignal;
