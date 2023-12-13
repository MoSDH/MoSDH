within MoSDH.Components.Weather;
model WeatherData "Weather data model"
	import Seasons = MoSDH.Utilities.Types.Seasons;
	MoSDH.Utilities.Interfaces.WeatherSignal weatherPort "Weather data connector" annotation(Placement(
		transformation(extent={{-10,190},{10,210}}),
		iconTransformation(extent={{-10,190},{10,210}})));
	Modelica.Units.SI.Angle declinationAngle "Declination of the earth";
	Modelica.Units.SI.Angle hourAngle "Hour angle";
	Modelica.Units.SI.Angle zenitAngle "Zenith angle of the sun";
	Modelica.Units.SI.Irradiance beamIrradiation[3] "Beam radiation vector";
	Modelica.Units.SI.Irradiance beamIrradiationData "Beam radiation on a horizontal";
	Modelica.Units.SI.Irradiance totalIrradiation "Total radiation";
	Modelica.Units.SI.Irradiance diffuseIrradiation "Diffuse irradiance";
	Modelica.Units.SI.Temperature Tambient "Ambient temperature";
	Modelica.Units.SI.Velocity windSpeed "Wind speed";
	Modelica.Units.SI.Time timeOfTheYear=mod(time + timeOffset, 8760 * 3600) "Time of the year";
	Integer dayOfTheMonth(
		start=initialDayOfMonth - 1,
		fixed=true) "Counter for the current month of the year";
	Integer dayOfTheYear(
		start=daysToEndOfMonth[initialMonth] - daysPerMonth[initialMonth] + initialDayOfMonth - 1,
		fixed=true) "Counter for the current month of the year";
	Integer monthOfTheYear(
		start=initialMonth,
		fixed=true) "Counter for the current month of the year";
	Integer yearOfSimulation(
		start=0,
		fixed=true) "Counter for the current year of the simulation";
	protected
		parameter Integer daysPerMonth[12]={31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31} "Tage pro Monat";
		parameter Integer daysToEndOfMonth[12]={sum(daysPerMonth[i] for i in 1:iEnd) for iEnd in 1:12} "Tag des Jahres am Ende von Monat x";
		parameter Modelica.Units.SI.Time timeOffset=(daysToEndOfMonth[initialMonth] - daysPerMonth[initialMonth] + initialDayOfMonth - 1) * 3600 * 24 "Startpoint of the simulation within a year in seconds";
	public
		parameter Modelica.Units.SI.Angle latitude=0.8642870455875921 "Latitude of location";
		parameter String weatherData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/Weather/DWD/TRY2017_Berlin.txt") "File where weather data is stored" annotation(Dialog(loadSelector(
			filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
			caption="Open file in which table is present")));
		parameter Boolean isTRY=true "=true, if data is test refernce year and not continuous.";
		parameter Modelica.Units.SI.Time timeUnitData=3600 "Time unit in weather data";
		parameter Modelica.Units.SI.Temperature temperatureDataOffset=0 "Offset of temperature data (273K for °C data)";
		parameter MoSDH.Utilities.Types.IrradiationDataDirection irradiationDataType=MoSDH.Utilities.Types.IrradiationDataDirection.horizontal "Direction of direct irradiation data";
		parameter Boolean verboseRead=true "= true, if info message that file is loading is to be printed";
		parameter Modelica.Units.SI.Angle azimut=0 "Azimut angle of sensor surface (S=0Â°,W=90Â°,E=-90Â°)" annotation(Dialog(enable=irradiationDataType==MoSDH.Utilities.Types.IrradiationDataDirection.surface));
		parameter Modelica.Units.SI.Angle beta(
			min=0,
			max=Modelica.Constants.pi / 2)=0.7853981633974483 "Sensor surface inclination angle" annotation(Dialog(enable=irradiationDataType==MoSDH.Utilities.Types.IrradiationDataDirection.surface));
		parameter Integer initialMonth(
			min=1,
			max=12)=1 "Initial month of simulation" annotation(Dialog(tab="Calendar"));
		parameter Integer initialDayOfMonth(
			min=1,
			max=daysPerMonth[initialMonth])=1 "Initial day of month of the simulation" annotation(Dialog(tab="Calendar"));
		parameter Boolean fourSeasons=false "=true, if 4 seasons are used. Summer/Winter else" annotation(Dialog(tab="Calendar"));
		parameter Integer summerStartMonth(
			min=1,
			max=12)=5 "Month of summer start" annotation(Dialog(tab="Calendar"));
		parameter Integer summerStartDay(
			min=1,
			max=daysPerMonth[summerStartMonth])=1 "Day of month of summer start" annotation(Dialog(tab="Calendar"));
		parameter Integer winterStartMonth(
			min=1,
			max=12)=10 "Month of winter start" annotation(Dialog(tab="Calendar"));
		parameter Integer winterStartDay(
			min=1,
			max=daysPerMonth[winterStartMonth])=1 "Day of month of winter start" annotation(Dialog(tab="Calendar"));
		parameter Integer springStartMonth(
			min=1,
			max=12)=3 "Month of sping start" annotation(Dialog(
			tab="Calendar",
			enable=fourSeasons));
		parameter Integer springStartDay(
			min=1,
			max=daysPerMonth[springStartMonth])=1 "Day of month of spring start" annotation(Dialog(
			tab="Calendar",
			enable=fourSeasons));
		parameter Integer fallStartMonth(
			min=1,
			max=12)=9 "Month of fall start" annotation(Dialog(
			tab="Calendar",
			enable=fourSeasons));
		parameter Integer fallStartDay(
			min=1,
			max=daysPerMonth[fallStartMonth])=1 "Day of month of fall start" annotation(Dialog(
			tab="Calendar",
			enable=fourSeasons));
		Seasons season "Current season";
		Modelica.Blocks.Tables.CombiTable1Dv beamIrradiationTable(
			tableOnFile=true,
			tableName="beamIrradiation",
			fileName=weatherData,
			verboseRead=verboseRead) annotation(Placement(transformation(extent={{-55,55},{-35,75}})));
		Modelica.Blocks.Tables.CombiTable1Dv diffuseIrradiationTable(
			tableOnFile=true,
			tableName=if Integer(irradiationDataType) == 3 then "totalIrradiation" else "diffuseIrradiation",
			fileName=weatherData,
			verboseRead=verboseRead) annotation(Placement(transformation(extent={{-55,55},{-35,75}})));
		Modelica.Blocks.Tables.CombiTable1Dv TambientTable(
			tableOnFile=true,
			tableName="Tambient",
			fileName=weatherData,
			verboseRead=verboseRead) annotation(Placement(transformation(extent={{-55,55},{-35,75}})));
		Modelica.Blocks.Tables.CombiTable1Dv windSpeedTable(
			tableOnFile=true,
			tableName="WindSpeed",
			fileName=weatherData,
			verboseRead=verboseRead) annotation(Placement(transformation(extent={{-55,55},{-35,75}})));
	initial algorithm
		if initialMonth>=winterStartMonth and initialDayOfMonth>=winterStartDay then
			season:=Seasons.Winter;
		elseif initialMonth>=fallStartMonth and initialDayOfMonth>=fallStartDay and fourSeasons then
			season:=Seasons.Fall;
		elseif initialMonth>=summerStartMonth and initialDayOfMonth>=summerStartDay then
			season:=Seasons.Summer;
		elseif initialMonth>=springStartMonth and initialDayOfMonth>=springStartDay and fourSeasons then
			season:=Seasons.Spring;
		else 
			season:=Seasons.Winter;
		end if;
	algorithm
		when sample(0, 3600 * 24) then
		  if dayOfTheYear == 365 then
		    dayOfTheMonth := 1;
		    dayOfTheYear := 1;
		    monthOfTheYear := 1;
		  elseif daysToEndOfMonth[monthOfTheYear] == dayOfTheYear then
		    dayOfTheMonth := 1;
		    dayOfTheYear := pre(dayOfTheYear) + 1;
		    monthOfTheYear := pre(monthOfTheYear) + 1;
		  else
		    dayOfTheMonth := pre(dayOfTheMonth) + 1;
		    dayOfTheYear := pre(dayOfTheYear) + 1;
		  end if;
		end when;
		when sample(0, 3600 * 8760) then
		  yearOfSimulation := pre(yearOfSimulation) + 1;
		end when;
			when fourSeasons and pre(season)==Seasons.Winter and monthOfTheYear>=springStartMonth and dayOfTheMonth>=springStartDay and not(monthOfTheYear>=summerStartMonth and dayOfTheMonth>=summerStartDay)  then
				season:=Seasons.Spring;
			elsewhen fourSeasons and pre(season)==Seasons.Spring and monthOfTheYear>=summerStartMonth and dayOfTheMonth>=summerStartDay and not(monthOfTheYear>=fallStartMonth and dayOfTheMonth>=fallStartDay) then
				season:=Seasons.Summer;
			elsewhen fourSeasons and pre(season)==Seasons.Summer and monthOfTheYear>=fallStartMonth and dayOfTheMonth>=fallStartDay and not(monthOfTheYear>=winterStartMonth and dayOfTheMonth>=winterStartDay)  then
				season:=Seasons.Fall;
			elsewhen fourSeasons and pre(season)==Seasons.Fall and monthOfTheYear>=winterStartMonth and dayOfTheMonth>=winterStartDay then
				season:=Seasons.Winter;
			end when;
			when not(fourSeasons) and monthOfTheYear>=winterStartMonth and dayOfTheMonth>=winterStartDay then
				season:=Seasons.Winter;
			elsewhen not(fourSeasons) and monthOfTheYear>=summerStartMonth and dayOfTheMonth>=summerStartDay and monthOfTheYear<winterStartMonth  then
				season:=Seasons.Summer;
			end when;
	equation
		//load weather data from file
		  diffuseIrradiationTable.u[1] = if isTRY then timeOfTheYear / timeUnitData else time / timeUnitData;
				  diffuseIrradiation = diffuseIrradiationTable.y[1];
				  beamIrradiationTable.u[1] = if isTRY then timeOfTheYear / timeUnitData else time / timeUnitData;
				  beamIrradiationData = beamIrradiationTable.y[1];
				  TambientTable.u[1] = if isTRY then timeOfTheYear / timeUnitData else time / timeUnitData;
				  Tambient = TambientTable.y[1] + temperatureDataOffset;
				  windSpeedTable.u[1] = if isTRY then timeOfTheYear / timeUnitData else time / timeUnitData;
				  windSpeed = windSpeedTable.y[1];
		//calculation of the sun's position
		  declinationAngle = 0.40928 * sin(2 * Modelica.Constants.pi / 365 * (284 + (time + timeOffset) / 86400));
				  hourAngle = 2 * Modelica.Constants.pi * (mod(time + timeOffset, 86400) - 86400 / 2) / 86400;
				  zenitAngle = Modelica.Math.acos(sin(declinationAngle) * sin(latitude) + cos(declinationAngle) * cos(latitude) * cos(hourAngle));
		//calculation of the beam radiation vector from horizontal measurements
		  if irradiationDataType == MoSDH.Utilities.Types.IrradiationDataDirection.horizontal then
		    totalIrradiation = beamIrradiationData * cos(zenitAngle) + diffuseIrradiation;
		    beamIrradiation = if noEvent(zenitAngle > Modelica.Constants.pi / 2 * 0.99) then {0, 0, 0} else beamIrradiationData / cos(zenitAngle) * {-sin(hourAngle) * sin(zenitAngle), -cos(hourAngle) * sin(zenitAngle), cos(zenitAngle)};
		  elseif irradiationDataType == MoSDH.Utilities.Types.IrradiationDataDirection.sun then
		    totalIrradiation = beamIrradiationData + diffuseIrradiation;
		    beamIrradiation = if noEvent(zenitAngle > Modelica.Constants.pi / 2 * 0.99) then {0, 0, 0} else beamIrradiationData * {-sin(hourAngle) * sin(zenitAngle), -cos(hourAngle) * sin(zenitAngle), cos(zenitAngle)};
		  else
		    totalIrradiation = diffuseIrradiation;
		    beamIrradiation = if noEvent(zenitAngle > Modelica.Constants.pi / 2 * 0.99) then {0, 0, 0} else beamIrradiationData * cos(beta) / cos(zenitAngle) * {-sin(hourAngle) * sin(zenitAngle), -cos(hourAngle) * sin(zenitAngle), cos(zenitAngle)};
		  end if;
		//pass calculated numbers to the weather port
		  weatherPort.beamIrradiation = beamIrradiation;
				  weatherPort.diffuseIrradiation = diffuseIrradiation;
				  weatherPort.totalIrradiation = totalIrradiation;
				  weatherPort.Tambient = Tambient;
				  weatherPort.zenitAngle = zenitAngle;
				  weatherPort.hourAngle = hourAngle;
				  weatherPort.yearOfSimulation = yearOfSimulation;
				  weatherPort.monthOfTheYear = monthOfTheYear;
				  weatherPort.dayOfTheYear = dayOfTheYear;
				  weatherPort.timeOfTheYear = timeOfTheYear;
				  weatherPort.dayOfTheMonth = dayOfTheMonth;
				  weatherPort.windSpeed = windSpeed;
				  weatherPort.season=Integer(season);
	annotation(
		__OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,evaluateAllParameters,NLSanalyticJacobian",
		defaultComponentName="weather",
		Icon(
			coordinateSystem(extent={{-200,-200},{200,200}}),
			graphics={
							Bitmap(
								imageSource="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",
								extent={{-199.8,-200},{199.8,200}})}),
		Documentation(info="<html><head></head><body><h4>weatherData (Components.Weather.WeatherData)</h4><div><p></p><ul><li>Component to read weather data from a text file.</li><li>See 'MoSDH/Data/Weather/Weather data template.txt' for file format (<b>weatherData</b>).</li><li>If&nbsp;<b>isTRY</b>=true, the data is repeated annualy.</li><li>Set&nbsp;<b>timeUnitData</b>&nbsp;to 1s if times are given in seconds in the file.</li><li>Set&nbsp;<b>temperatureDataOffset</b>&nbsp;to 0°C/273.15K if data is given in degrees celsius.</li><li>Beam irradiation data (<b>irradiationDataType</b>) can be interpreted as:</li><ul><li><b>horizontal</b>: Data measured on horizontal (e.g. DWD TRY data)</li><li><b>sun</b>: Data measured in sun direction (e.g. energy plus)&nbsp;</li><li><b>surface</b>: Data is measured on a tilted surface (e.g. collector plane). Parameters&nbsp;<b>azimut</b>&nbsp;and&nbsp;<b>beta</b>&nbsp;are used to define the direction of the plane. This mode can be used for measured data from colelctor fields, but cannot consider shading between collectors, as this data usually does not include information about direct and diffuse parts of the irradiation.</li></ul><li>Direct Irradiation data is converted into a 3D vector according to the setting of&nbsp;<b>latitute</b>.&nbsp;</li><li>The component calculates day, months and year of the simulation and the calendar.</li><li>If <b>fourSeasons</b> is set to false, the output <a href=\"modelica://MoSDH.Utilities.Types.Seasons\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">season</a> switches between Summer and WInter at the day&nbsp;<b>summerStartDay</b> during <b>summerStartMonth</b> and <b>winterStartDay</b> during <b>winterStartMonth</b>. If <b>fourSeasons</b> is true, additional times for Spring and Fall have to be defined.</li></ul></div><table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: Sun irradiation model.</strong></caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/SunIrradiation.png\" width=\"700\">
    </td>
  </tr>
</tbody></table></body></html>"),
		experiment(
			StopTime=1,
			StartTime=0,
			Tolerance=1e-06,
			Interval=0.001));
end WeatherData;
