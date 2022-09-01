within MoSDH.Components.Storage.StratifiedTank;
model ExampleBuffer "Buffer storage example model"
 extends Modelica.Icons.Example;
 TTES bufferStorage1(
  storageVolume=20000,
  storageHeight=10) annotation(Placement(transformation(extent={{-15,-5},{15,55}})));
 Weather.WeatherData weatherData1(weatherData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/Weather/DWD/TRY2017_Darmstadt.txt")) annotation(Placement(transformation(extent={{-20,-60},{20,-20}})));
 Sources.Electric.ElectricHeatingRod electricHeatingRod1(
  medium=bufferStorage1.medium,
  PelMax(displayUnit="MW")=10000000,
  deltaTmin(displayUnit="K"),
  on=activate,
  Pref(displayUnit="MW")=7000000,
  Tref=353.15) annotation(Placement(transformation(extent={{-80,5},{-40,45}})));
 Loads.HeatDemand heatDemand1(
  medium=bufferStorage1.medium,
  loadData=Modelica.Utilities.Files.loadResource("modelica://MoSDH/Data/HeatDemand/Darmstadt_TRY2015_25GWh.txt")) annotation(Placement(transformation(extent={{35,5},{75,45}})));
 parameter Modelica.Units.SI.Temperature TsupplyRef=353.15;
 Boolean activate;
initial algorithm
  if bufferStorage1.Tlayers[2] > TsupplyRef then
    activate := false;
  else
    activate := true;
  end if;
algorithm
  when bufferStorage1.Tlayers[2] > TsupplyRef then
    activate := false;
  elsewhen bufferStorage1.Tlayers[ 9] < TsupplyRef then
    activate := true;
  end when;
equation
  connect(weatherData1.weatherPort,bufferStorage1.weatherPort) annotation(Line(
   points={{0,-20},{0,-15},{0,-4.67},{0,-4.67}},
   color={0,176,80}));
  connect(weatherData1.weatherPort,heatDemand1.weatherPort) annotation (
   Line(
    points={{0,-20},{0,-10},{55,-10},{55,5.33}},
    color={0,176,80}));
  connect(electricHeatingRod1.supplyPort,bufferStorage1.sourceIn) annotation(Line(
   points={{-40.3,30},{-35.3,30},{-20,30},{-20,50},{-15,50}},
   color={255,0,0},
   thickness=1));
  connect(electricHeatingRod1.returnPort,bufferStorage1.sourceOut) annotation(Line(
   points={{-40.3,20},{-35.3,20},{-20,20},{-20,0},{-15,0}},
   color={0,0,255},
   thickness=1));
  connect(heatDemand1.returnPort,bufferStorage1.loadIn) annotation(Line(
   points={{35,20},{30,20},{19.7,20},{19.7,0},{14.67,0}},
   color={0,0,255},
   thickness=1));
  connect(heatDemand1.supplyPort,bufferStorage1.loadOut) annotation(Line(
   points={{35,30},{30,30},{19.7,30},{19.7,50},{14.67,50}},
   color={255,0,0},
   thickness=1));
 annotation (
  __OpenModelica_simulationFlags(
   lv="LOG_STATS",
   s="dassl"),
  Documentation(info= "<html><head></head><body><p>A fluctuating <a href=\"modelica://MoSDH.Components.Loads.HeatDemand\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">heat demand</a> is met by an <a href=\"modelica://MoSDH.Components.Sources.Electric.ElectricHeatingRod\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">electric heat source</a> with a constant power of 10 MW. The <a href=\"modelica://MoSDH.Components.Storage.StratifiedTank.TTES\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">buffer storage</a> of 10.000 m³ is used to balance generation and consumption.</p><p>
A simple control strategy is defined: 
</p>
<ul>
<li>The load component draws hot water from the buffer storage top. The volume flow rate is calculated to meet the demand and the reference return temperature <b>TreturnGrid</b>.</li>
<li>The electric heat source is turned on when the temperature at the buffer top (layer 9/10) falls below <b>TsupplyRef</b></li>
<li>The electric heat source is turned off once the temperature at the buffer bottom (layer 2/10) exceeds&nbsp;<b>TsupplyRef</b>.</li>
<li>The electric heating source supplies heat 5K above the&nbsp;<b>TsupplyRef</b>.</li>
</ul>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>TTES layer temperatures</caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/TTESexampleA.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>
<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>TTES thermal power on source side (boiler) and load side (demand). </caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/TTESexampleB.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>


</body></html>"),
  experiment(
   StopTime=31536000,
   StartTime=0,
   Tolerance=0.0001,
   Interval=900));
end ExampleBuffer;
