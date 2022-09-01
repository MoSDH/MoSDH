within MoSDH.Components.Sources.Electric;
model ExampleHeatPump "Heat Pump example model"
 extends Modelica.Icons.Example;
 HeatPump hp(
  
  MiminumShift(displayUnit="K"),
  TmaxLoad=363.15, TmaxSource = 323.15,
  TminLoad=308.15, TminSource = 278.15,
  Tref= 343.15,
  constrainPower=true,
  loadPipe(T0(displayUnit="degC")=303.15), powerScaling = 0.25,
  setAbsoluteLoadPressure=false,sourcePipe(T0(displayUnit="degC")=278.15),
  volFlowLoad(displayUnit="l/s")) annotation(Placement(transformation(
  origin={0,-5},
  extent={{-20,-20},{20,20}})));
 Utilities.FluidHeatFlow.fluidSourceHot loadSideSupply(
  redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium,
  Tsource=333.15) annotation(Placement(transformation(extent={{35,-5},{45,5}})));
 Utilities.FluidHeatFlow.fluidSourceCold loadSideReturn(
  redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium,
  Tsource=303.15) annotation(Placement(transformation(extent={{35,-15},{45,-5}})));
 Utilities.FluidHeatFlow.fluidSourceHot sourceSideSupply(
  redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium,
  Tsource(displayUnit="K")=sourceTemperature.y) annotation(Placement(transformation(extent={{-35,-5},{-45,5}})));
 Utilities.FluidHeatFlow.fluidSourceCold sourceSideReturn(
  redeclare replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium,
  Tsource(displayUnit="K")=sourceTemperature.y) annotation(Placement(transformation(extent={{-35,-15},{-45,-5}})));
 Modelica.Blocks.Sources.Sine sourceTemperature(amplitude = 30, f = 1 / (8760 * 3600), offset = 298.15)  annotation(
    Placement(visible = true, transformation(origin = {-84, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(sourceSideSupply.fluidPort,hp.supplyPortSource) annotation(Line(
   points={{-35,0},{-30,0},{-25,0},{-20,0}},
   color={255,0,0},
   thickness=1));
  connect(hp.returnPortSource,sourceSideReturn.fluidPort) annotation(Line(
   points={{-20,-10},{-25,-10},{-30,-10},{-35,-10}},
   color={0,0,255},
   thickness=1));
  connect(hp.supplyPortLoad,loadSideSupply.fluidPort) annotation(Line(
   points={{19.7,0},{24.7,0},{30,0},{35,0}},
   color={255,0,0},
   thickness=1));
  connect(hp.returnPortLoad,loadSideReturn.fluidPort) annotation(Line(
   points={{19.7,-10},{24.7,-10},{30,-10},{35,-10}},
   color={0,0,255},
   thickness=1));
 annotation (
  Documentation(info= "<html><head></head><body><h4>Example model for the <a href=\"modelica://MoSDH.Components.Sources.Electric.HeatPump\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">heat pump</a> model:</h4><div><ul><li>A time-varying source temperature is defined (<b>sourceTemperature</b>).</li><li>The heat pump is operated in<b> mode SourceFlowRate </b>for wich the&nbsp;supply temperature&nbsp;<b>Tref</b>&nbsp;and power&nbsp;<b>Pref</b>&nbsp;on load side as well as volume flow rate&nbsp;<b>volfFlow</b>&nbsp;on source side have to be defined.</li><li>The heat pump power is constrained by the map (<b>constrainPower</b>=true) given as input data (<b>HPdataFile</b>).</li><li>The heating power from the map is scaled by factor 0.25 (<b>powerScaling</b>).</li><li>The heat pump is operated on maximum thermal power (<b>hpCtrl.Pref</b>=-1).</li><li>Return flow mixing is enabled (<b>enableReturnFlowMixing</b>).</li><li>Once the source temperature exceeds the maximum <b>TsourceMax</b> of 50°C, return flow mixing is used to lower the temperature at the evaporator.</li><li>Once the source temperature falls below the minimum <b>TsourceMin</b> of 5°C, the heat pump is turned off, but the source side circulation pump is kept running until explicitly turned off (<b>on</b>=false).</li></ul></div><div><h4><br></h4></div><table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: Source temperature, temperature at evaporator and heating power.</strong></caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/HeatPumpExample.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>

</body></html>"),
  experiment(
   StopTime = 3.1536e+07,
   StartTime=0,
   Tolerance=1e-06,
   Interval=3600));
end ExampleHeatPump;
