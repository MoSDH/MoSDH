within MoSDH.Components.Sources.Solar;
model SolarThermalField "Solar thermal collector field"
	MoSDH.Utilities.Interfaces.SupplyPort supplyPort(medium=medium) "Flow port (hot)" annotation(Placement(
		transformation(extent={{105,30},{125,50}}),
		iconTransformation(extent={{186.7,40},{206.7,60}})));
	MoSDH.Utilities.Interfaces.ReturnPort returnPort(medium=medium) "Return port (cool)" annotation(Placement(
		transformation(extent={{105,-50},{125,-30}}),
		iconTransformation(extent={{206.7,-60},{186.7,-40}})));
	Modelica.Units.SI.Temperature Tsupply(displayUnit="degC") "Flow temperature";
	Modelica.Units.SI.Temperature Treturn(displayUnit="degC") "Return temperature";
	Modelica.Units.SI.Temperature Tcollectors[nSeries](each displayUnit="degC") "Collector temperatures of one row";
	Modelica.Units.SI.VolumeFlowRate volFlow "Volume flow";
	Modelica.Units.SI.Power Pthermal(displayUnit="kW") "Thermal power";
	Modelica.Units.SI.Energy Qthermal(
		start=0,
		fixed=true) "Thermal energy budget";
	Modelica.Units.SI.Power Pelectric(displayUnit="kW") "Electrical power of PV modules";
	Modelica.Units.SI.Energy Eelectric(
		start=0,
		fixed=true) "Electricity production of PV modules";
	Modelica.Units.SI.Pressure dp "pressure drop (return->flow)";
	MoSDH.Utilities.Interfaces.Weather weatherPort "Weather data connection" annotation(Placement(
		transformation(extent={{-10,-110},{10,-90}}),
		iconTransformation(extent={{-10,-206.7},{10,-186.7}})));
	Modelica.Units.SI.Energy specificYield(start=0) "Solar yield per square meter";
	Modelica.Units.SI.Energy specificElectricYield(start=0) "Photovoltaic yield per square meter";
	Distribution.Pump pump(
		medium=medium,
		volFlowRef=volFlowSet) "Pump component" annotation(Placement(
		transformation(extent={{85,-30},{65,-50}}),
		iconTransformation(extent={{86.7,-60},{106.7,-40}})));
	CollectorModel solarModule[nSeries](
		each apertureArea=apertureArea * nParallel,
		each height=height,
		each T0=T0,
		each V_flowLaminar=nAbsorberPipes * nParallel * 580 * dAbsorberPipe * Modelica.Constants.pi * medium.nu,
		each dpLaminar=74240 * apertureArea / height * medium.nu ^ 2 * medium.rho / dAbsorberPipe ^ 3,
		each V_flowNominal=nAbsorberPipes * nParallel * 2500 * dAbsorberPipe * Modelica.Constants.pi * medium.nu,
		each dpNominal=1.582 * 1e+06 * apertureArea / height * medium.nu ^ 2 * medium.rho / dAbsorberPipe ^ 3,
		each medium=medium,
		each eta0=eta0,
		each a1=a1,
		each a2=a2,
		each Uabs=Uabs,
		each Cabs=Cabs,
		each Upvt=Upvt,
		each cWind=cWind,
		each cWindRel=cWindRel,
		each etaElectric=etaElectric,
		each etaElectricThermalCoefficient=etaElectricThermalCoefficient,
		each aEl=aEl,
		each bEl=bEl,
		each cEl=cEl,
		pipes(each m=V_collector* medium.rho)) annotation(
		Placement(
			transformation(extent={{-25,-25},{25,25}}),
			iconTransformation(extent={{86.7,-60},{106.7,-40}})),
		Dialog(
			group="Design",
			tab="Module"));
	BaseClasses.CollectorIrradiation collectorIrradiation(
		azimut=azimut,
		nParallel=nParallel,
		collectorRowDistance=collectorRowDistance,
		useShading=true,
		diffuseReflectance=diffuseReflectance,
		height=height,
		beta=beta,
		tableOnFile=tableOnFile,
		IAMtable=IAMtable,
		tableName=tableName,
		table=table) annotation(Placement(transformation(extent={{-90,-25},{-36,25}})));
	Utilities.FluidHeatFlow.MixingVolume supplyMix(
		medium=medium,
		V_flowNom=V_flowMax*nParallel,
		tau=tau) annotation(Placement(transformation(
		origin={80,40},
		extent={{-5,-5},{5,5}},
		rotation=-90)));
	Utilities.FluidHeatFlow.MixingVolume returnMix(
		medium=medium,
		V_flowNom=V_flowMax*nParallel,
		tau=tau) annotation(Placement(transformation(
		origin={95,-40},
		extent={{-5,-5},{5,5}},
		rotation=-90)));
	replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Gylcol20_20degC medium constrainedby Modelica.Thermal.FluidHeatFlow.Media.Medium "Grid heat carrier fluid" annotation(
		choicesAllMatching=true,
		Dialog(
			group="Properties",
			tab="Design"));
	parameter Modelica.Units.SI.Temperature T0=283.15 "Initial temperature" annotation(Dialog(
		group="Properties",
		tab="Design"));
	parameter Modelica.Units.SI.Length collectorRowDistance(min=height * cos(beta))=3 "Distance from start of one row to the next row" annotation(Dialog(
		group="Geometry",
		tab="Design"));
	parameter Modelica.Units.SI.Angle azimut=0 "Azimut angle of collectors(S=0Â°,W=90Â°,E=-90Â°)" annotation(Dialog(
		group="Geometry",
		tab="Design"));
	parameter Modelica.Units.SI.Angle beta(
		min=0,
		max=Modelica.Constants.pi / 2)=0.7853981633974483 "Collector inclination angle" annotation(Dialog(
		group="Geometry",
		tab="Design"));
	parameter Real nParallel(min=1)=1 "Number of collector arrays connected in parallel" annotation(Dialog(
		group="Geometry",
		tab="Design"));
	parameter Integer nSeries(
		min=1,
		max=20)=5 "Number of collector modules connected in series." annotation(Dialog(
		group="Geometry",
		tab="Design"));
	parameter Real diffuseReflectance(
		min=0,
		max=1)=0.2 "Albedo factor of ground" annotation(Dialog(
		group="Properties",
		tab="Design"));
	replaceable model CollectorModel = MoSDH.Components.Sources.Solar.BaseClasses.SolarThermalModule constrainedby MoSDH.Components.Sources.Solar.BaseClasses.partialSolarThermalModule "Collector modelling approach" annotation(
		Dialog(
			group="Design",
			tab="Module"),
		choicesAllMatching=true);
	parameter Modelica.Units.SI.Area apertureArea=10 "Collector area of a single module" annotation(Dialog(
		group="Design",
		tab="Module"));
	parameter Modelica.Units.SI.Length height=2 "Gross collector height" annotation(Dialog(
		group="Design",
		tab="Module"));
	parameter Modelica.Units.SI.Length dAbsorberPipe=0.008 "Inner diameter of absorber pipes" annotation(Dialog(
		group="Design",
		tab="Module"));
	parameter Integer nAbsorberPipes=18 "Number of parallel absorber pipes per module" annotation(Dialog(
		group="Design",
		tab="Module"));
	parameter Modelica.Units.SI.CoefficientOfHeatTransfer Uabs=50 "Heat transfer coefficient for heat transfer between absorber and fluid." annotation(Dialog(
		group="Design",
		tab="Module"));
	parameter Real Cabs(unit="J/(m2.K)")=9000 "Absorber heat capacity per square meter" annotation(Dialog(
		group="Design",
		tab="Module"));
	parameter Modelica.Units.SI.VolumeFlowRate V_flowMax=0.001 "Maximum volume flow per module" annotation(Dialog(
		group="Design",
		tab="Module"));
	parameter Modelica.Units.SI.Volume V_collector=0.004 "Collector fluid volume" annotation(Dialog(
		group="Design",
		tab="Module"));
	parameter Modelica.Units.SI.Time tau=300 "Time constant for dynamic behaviour" annotation(Dialog(
		group="Design",
		tab="Module"));
	parameter Real eta0(
		min=0,
		max=1)=0.778 "Optical efficiency of the collector" annotation(Dialog(
		group="Efficiency",
		tab="Module"));
	parameter Modelica.Units.SI.CoefficientOfHeatTransfer a1=2.551 "Linear thermal loss coefficient" annotation(Dialog(
		group="Efficiency",
		tab="Module"));
	parameter Real a2(unit="W/(m2.K2)")=0.0 "Quadratic thermal loss coefficient" annotation(Dialog(
		group="Efficiency",
		tab="Module"));
	parameter Boolean tableOnFile=false "=true, if IAM data from file" annotation(Dialog(
		group="Efficiency",
		tab="Module",
		loadSelector(
			filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
			caption="Open file in which table is present")));
	parameter String IAMtable=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/Solar/ARCON-HTSA-288-IAM.txt") "IAM table file" annotation(Dialog(
		group="Efficiency",
		tab="Module",
		enable=tableOnFile,
		loadSelector(
			filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
			caption="Open file in which table is present")));
	parameter String tableName="IAM" "IAM table name" annotation(Dialog(
		group="Efficiency",
		tab="Module",
		enable=tableOnFile,
		loadSelector(
			filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
			caption="Open file in which table is present")));
	parameter Real table[:,:]={{0, 1}, {0.174, 0.999}, {0.349, 0.999}, {0.4363, 0.998}, {0.610, 0.994}, {0.698, 0.989}, {0.872, 0.967}, {1.047, 0.916}, {1.134, 0.869}, {1.221, 0.799}, {1.396, 0.546}, {1.483, 0.325}, {1.57, 0}} "IAM table data" annotation(Dialog(
		group="Efficiency",
		tab="Module",
		enable=not tableOnFile));
	parameter Modelica.Units.SI.CoefficientOfHeatTransfer Upvt=31.15 "Heat transfer coefficient for heat transfer between PV cell and fluid." annotation(Dialog(
		group="Heat transfer",
		tab="PV",
		enable=solarModule[1].isPVT));
	parameter Real cWind(unit="J/(m3.K)")=1.7 "Wind loss coefficient 'c3'" annotation(Dialog(
		group="Heat transfer",
		tab="PV",
		enable=solarModule[1].isPVT));
	parameter Real cWindRel=0.5 "Wind data conversion factor vcol/v10m" annotation(Dialog(
		group="Heat transfer",
		tab="PV",
		enable=solarModule[1].isPVT));
	parameter Real etaElectric=0.15 "Electrical efficiency at reference temperature 'Î·elRef'" annotation(Dialog(
		group="Electric",
		tab="PV",
		enable=solarModule[1].isPVT));
	parameter Modelica.Units.SI.LinearTemperatureCoefficient etaElectricThermalCoefficient=0.0044 "Temperature dependance of electrical efficiency 'Î²'" annotation(Dialog(
		group="Electric",
		tab="PV",
		enable=solarModule[1].isPVT));
	parameter Real etaElectricWindCoefficient(final unit="s/m")=0.031 "Wind speed dependence of Electrical efficiency at standard conditions 'c6'" annotation(Dialog(
		group="Electric",
		tab="PV",
		enable=solarModule[1].isPVT));
	parameter Real aEl(unit="W/m2")=-0.00007 "Electrical loss coefficient due to irradiance 'a'" annotation(Dialog(
		group="Electric efficiency",
		tab="PV",
		enable=solarModule[1].isPVT));
	parameter Real bEl=-0.03588 "Electrical loss coefficient due to irradiance 'b'" annotation(Dialog(
		group="Electric efficiency",
		tab="PV",
		enable=solarModule[1].isPVT));
	parameter Real cEl=-1.387 "Electrical loss coefficient due to irradiance 'c'" annotation(Dialog(
		group="Electric efficiency",
		tab="PV",
		enable=solarModule[1].isPVT));
	MoSDH.Utilities.Types.ControlTypesSolar mode=MoSDH.Utilities.Types.ControlTypesSolar.RefTemp "Definition of controlled inputs" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	Boolean on=true "=true, if component is enabled" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	Modelica.Units.SI.Temperature Tref=343.15 "Reference supply/return temperature" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	Modelica.Units.SI.VolumeFlowRate volFlowRef=0.01 "Reference volume flow rate" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	protected
		Modelica.Blocks.Interfaces.RealOutput volFlowSet;
		Boolean pumpON "Pump turn on signal";
		constant Modelica.Units.SI.Length lengthDummy=1;
		constant Modelica.Units.SI.Temperature temperatureDummy=1;
	initial equation
		pre(pumpON) = false;
	algorithm
		when on and solarModule[nSeries].pipes.T > Tref + 2 or mode == MoSDH.Utilities.Types.ControlTypesSolar.RefTempCooling then
		  pumpON := true;
		elsewhen (not on or solarModule[nSeries].pipes.T < Tref - 1.5) and not mode == MoSDH.Utilities.Types.ControlTypesSolar.RefTempCooling then
		  pumpON := false;
		end when;
	equation
		Tsupply = supplyMix.T;
				  Treturn = returnMix.T;
				  Tcollectors=solarModule.Tcollector;
				  volFlow = returnPort.m_flow / medium.rho;
				  Pthermal = -(supplyPort.H_flow + returnPort.H_flow);
				  der(Qthermal) = Pthermal;
				  Pelectric = sum(solarModule[i].Pelectric for i in 1:nSeries);
				  der(Eelectric) = Pelectric;
				  dp = pump.dp;
				  specificYield = Qthermal / (nSeries * nParallel * apertureArea * max(1, time / (8760 * 3600))) * lengthDummy;
				  specificElectricYield = Eelectric / (nSeries * nParallel * apertureArea * max(1, time / (8760 * 3600))) * lengthDummy;
		// Control strategy
		  if mode == MoSDH.Utilities.Types.ControlTypesSolar.RefTemp then
		// solar control type 1: reference supply temperature defined
		    volFlowSet = if pumpON then min(max(sum(solarModule[i].pipes.Q_flow for i in 1:nSeries) / (medium.cp * medium.rho * max(1, Tref - Treturn)), V_flowMax * apertureArea / lengthDummy ^ 2 * nParallel * 0.0001), V_flowMax * apertureArea / lengthDummy ^ 2 * nParallel) else 0;
		//volFlowSet = if pumpON then min(max(solarModule[nSeries].pipes.Q_flow/ (medium.cp * medium.rho * max(1, Tref - solarModule[nSeries].pipes.T_a)), V_flowMax * apertureArea / lengthDummy ^ 2 * nParallel * 0.0001), V_flowMax * apertureArea / lengthDummy ^ 2 * nParallel) else 0;
		  elseif mode == MoSDH.Utilities.Types.ControlTypesSolar.RefFlow then
		// solar control type 2: volume flow defined
		    volFlowSet = min(V_flowMax * nParallel, volFlowRef);
		  else
		// solar control type 3: reference return temperature defined for night cooling
		    volFlowSet = if pumpON then max(min(sum(solarModule[i].pipes.Q_flow for i in 1:nSeries) / (medium.cp * medium.rho * min(-0.1, Tref - Tsupply)), -V_flowMax * apertureArea / lengthDummy ^ 2 * nParallel * 0.0001), -V_flowMax * apertureArea / lengthDummy ^ 2 * nParallel) else 0;
		  end if;
		//Component connections
		  for iSeries in 1:nSeries loop
		    if iSeries < nSeries then
		      connect(solarModule[iSeries].supplyPort, solarModule[iSeries + 1].returnPort) annotation(
		        Line(points = 0));
		    end if;
		    connect(weatherPort, solarModule[iSeries].weatherPort) annotation(
		      Line(points = {{0, -100}, {0, -60}, {0, -24.66667175292969}}, color = {0, 176, 80}));
		    connect(collectorIrradiation.collectorIrradiation, solarModule[iSeries].irradiation) annotation(
		      Line(points = {{-36.3, 0}, {-31.3, 0}, {-30, 0}, {-25, 0}}, color = {0, 0, 127}, thickness = 0.0625));
		  end for;
				  
				connect(weatherPort,collectorIrradiation.weatherPort) annotation(Line(
					points={{0,-100},{0,-60},{-50.3,-60},{-65,-60},{-63,-24.66667175292969}},
					color={0,176,80}));
				  
				  
				connect(solarModule[1].returnPort,pump.flowPort_b) annotation(Line(
					points={{24.7,-12.7},{29.7,-12.7},{60.7,-12.7},{60.7,-40},{65.7,-40}},
					color={0,0,255},
					thickness=1));
				  
				connect(supplyPort,supplyMix.fluidPort_a[1]) annotation(Line(
					points={{115,40},{110,40},{90,40},{85,40}},
					color={255,0,0},thickness=1));
				connect(solarModule[nSeries].supplyPort,supplyMix.fluidPort_b[1]) annotation(Line(
					points={{24.7,12.3},{29.7,12.3},{70.3,12.3},{70.3,40},{75.3,40}},
					color={255,0,0},thickness=1));
				connect(returnPort,returnMix.fluidPort_a[1]) annotation(Line(
					points={{115,-40},{110,-40},{105,-40},{100,-40}},
					color={0,0,255},thickness=1));
				connect(pump.flowPort_a,returnMix.fluidPort_b[1]) annotation(Line(points={{85,-40},{90,-40},{85.3,-40},{90.3,-40}},thickness=1,color={0,0,255}));
	annotation(
		defaultComponentName="solarField",
		Icon(
			coordinateSystem(extent={{-200,-200},{200,200}}),
			graphics={
							Bitmap(
								imageSource="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
DGUxXxiYEaSjH/28ujOicNPefX/yr8+oP0vxtubVe7nVGBFF2apffHN588ezbssGhEOboSzmCwMz
giQH1HIPX22HROG28N13ObCQAwztZynejn3sC+4Z0OBWY0QUS/JGMBAabYaymC8MzAjWwff9nboz
onDT3n2XIVr7WYo3OeViIbntlPazREQhJRcyXHgrRcA6bYaymC8MzC3b+v/+P7TI/vLf/rt71Bqc
2xhnC999v3rtRv11be1nKd641RgRxZpc1HLUsz/+onrcQ3SrtmkzlMV8YWBumfaiIL3tX/m5Msn7
7pFr7N7/IXVnROGmvfsuFwTTfpbibduu97i1P49bjRFRDMm2bKHfv/TL6rEPkdQ2bYaymC8MzC3T
XhR09z7577dfSfni899Rd0YUdgvffb/w3FX15yju5PU9iluNEVEsybdmRn3+Pz6hHvcQSW3TZiiL
+cLA3DLtRUF3b9fXX1lmReoevcb23/tzdWdE4aa9+7515xPqz1K87XrrMbf2G/LNA/kGgvazREQh
JddlGCXHNm+4+J/UYx+itmkzlMV8YWBumfaioHv3jz+8/T6tZ774nLozorB75kvPuzXckHNatZ+j
eJNz169d/6F7BjS41RgRxZLcAWDUx7/3PvW4h6ht2gxlMV8YmFumvSjo3r3lX37NPXrzNr7unerO
iMJt4bvv8umiXD1Z+1mKN241RkSxtuftH3ZbtkYvu1lfr0U79qFu1zZthrKYLwzMLdNeFHT/vtH7
snsEG8dPnVN3RhR2C999P/rRz6s/R/Em91vnVmNEFGNypw+548eoD3znT9TjHup2bdNmKIv5wsDc
Mu1FQffv4JX/6h7BRn8w5NzGCFv47rusZxmgtJ+leDvyN59zz4DGlW9/n1uNEVEUPf7+208zuz64
Wr7mn39aPfah7tY2bYaymC8MzC3TXhR0/2RnIjuVUYeOflrdGVG4ae++H3jvKfVnKd4e2LqfW40R
UZTJm/3yZvCox178HfXYh7pb27QZymK+MDC3THtR0OKSry2Nkq9tyoCl7ZAo3O54970aoFnP3evk
p28/DeP8sy+qP0dEFFrHPvYFt2VrXJ75inrcQ92tbdoMZTFfGJhbpr0oaHH9l6/8bH2BjFF733VC
3RlRuK159d473n3fvf9D6s9SvG3+zcfd2p/HrcaIKIY2/Po73FZtnlzgVDv2oW7WNm2GspgvDMwt
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
3LgBb37qp/5/DFPTXS6sftUAAAAASUVORK5CYII=",
								extent={{-199.8,-200},{199.8,200}})}),
		Documentation(info="<html><head></head><body><ul><li>Component of a solar thermal collector field with calculation of shading between collector rows.</li><li>The total irradiation on the collector is calculated according to the isotropic diffuse sky model&nbsp;<a href=\"modelica://MoSDH.UsersGuide.References\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">[Liu1963]</a>.</li><li>An incidence angle modifier can be defined by parameter or is read from a file.</li><li>Flat plate collector module: Second order efficiency model (<b>eta0</b>,<b>a1</b>,<b>a2,a3=0</b>)&nbsp;<a href=\"modelica://MoSDH.UsersGuide.References\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">[Duffie1991]</a>.&nbsp;</li><li>PVT collector modules:&nbsp;<span style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">Two node PVT model with one thermal capacity after&nbsp;</span><a href=\"modelica://MoSDH.UsersGuide.References\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">[Jonas2019]</a>. &nbsp;&nbsp;</li><li>The field can be enabled/disabled by the variable&nbsp;<b>on</b>.</li><li>Three control modes&nbsp;(<b>mode</b>) can be selected dynamically. Depending on the chosen mode, one input variable is used:</li><ol><li><b>RefTemp</b>: Define the reference supply temperature by the input/field&nbsp;<b>Tref</b>.</li><li><b>RefFlow</b>: Define the volume flow explicity by the input&nbsp;<b>volFlow</b>.</li><li><b>RefTempCool</b>: Define the reference return temperature for night cooling mode by&nbsp;<b>Tref</b>. The flow direction is reversed to the normal operation.</li></ol></ul>

</body></html>"),
		experiment(
			StopTime=1,
			StartTime=0,
			Tolerance=1e-06,
			Interval=0.001));
end SolarThermalField;
