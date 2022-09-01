within MoSDH.Components.Sources.Fossil;
model ThermalPowerPlant "Plant with CHP and boiler units"
	MoSDH.Utilities.Interfaces.SupplyPort supplyPort(medium=medium) "Port used for hot fluid" annotation(Placement(
		transformation(extent={{90,30},{110,50}}),
		iconTransformation(extent={{186.7,40},{206.7,60}})));
	MoSDH.Utilities.Interfaces.ReturnPort returnPort(medium=medium) "Port used for cool fluid" annotation(Placement(
		transformation(extent={{90,-50},{110,-30}}),
		iconTransformation(extent={{186.7,-60},{206.7,-40}})));
	MoSDH.Utilities.Interfaces.Weather weather "Weather data connector" annotation(Placement(
		transformation(
			origin={20,-50},
			extent={{-10,-10},{10,10}}),
		iconTransformation(extent={{-10,-206.7},{10,-186.7}})));
	parameter Modelica.Units.SI.Volume storageVolume(min=1)=250 "Volume of the storage" annotation(Dialog(
		group="Dimensions",
		tab="Buffer"));
	parameter Modelica.Units.SI.Length storageHeight(min=1)=10 "Height of the storage" annotation(Dialog(
		group="Dimesnions",
		tab="Buffer"));
	parameter Integer nBufferLayers=20 annotation(Dialog(
		group="Dimensions",
		tab="Buffer"));
	replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium "Medium: properties of water at 30 degC and 1 bar" annotation(Dialog(tab="Design"));
	parameter Modelica.Units.SI.Power CHP_Pthermal_max(displayUnit="MW")=1000000 "Maximum thermal power of one unit" annotation(Dialog(
		group="Design",
		tab="CHP"));
	parameter Modelica.Units.SI.Temperature CHP_deltaTmin(displayUnit="degC")=5 "Minimum temperature delta between flow and return" annotation(Dialog(
		group="Design",
		tab="CHP"));
	parameter Real CHP_fuelEfficiency[:,:]={{0.587, 0.87}, {0.796, 0.872}, {1, 0.874}} "Normalized fuel efficiency data" annotation(Dialog(
		group="Design",
		tab="CHP"));
	parameter Real CHP_power2heatRatio[:,:]={{0.587, 0.847}, {0.796, 0.938}, {1, 0.996}} "Normalized power to heat ratio data" annotation(Dialog(
		group="Design",
		tab="CHP"));
	parameter Integer CHP_units=3 annotation(Dialog(
		group="Design",
		tab="CHP"));
	parameter Integer CHP_firstComponentID=1 "ID of first chp unit" annotation(Dialog(
		group="Control",
		tab="CHP"));
	parameter Real GB_fuelEfficiency[:,:]={{0.1, 0.93}, {0.2, 0.93}, {0.3, 0.925}, {0.40, 0.92}, {1, 0.895}} "Normalized fuel efficiency data" annotation(Dialog(
		group="Design",
		tab="Gas Boiler"));
	parameter Modelica.Units.SI.Power GB_Pthermal_max(displayUnit="MW")=1000000 "Maximum thermal power of one unit" annotation(Dialog(
		group="Design",
		tab="Gas Boiler"));
	parameter Modelica.Units.SI.Temperature GB_deltaTmin(displayUnit="degC")=5 "Minimum temperature delta between flow and return" annotation(Dialog(
		group="Control",
		tab="Gas Boiler"));
	Modelica.Units.SI.Temperature Tsupply "Supply temperature";
	Modelica.Units.SI.Temperature Treturn "Return temperature";
	Modelica.Units.SI.VolumeFlowRate volFlow "Supply temperature";
	MoSDH.Utilities.Types.OperationModes operationMode "Power plant operation mode";
	Modelica.Units.SI.Temperature Buffer_Tlayers[nBufferLayers]=buffer.Tlayers;
	Integer CHP_activeUnits "Number of active CHP units";
	Modelica.Units.SI.Power CHP_Pthermal(displayUnit="kW")=chp.Pthermal;
	Modelica.Units.SI.Energy CHP_Qthermal(displayUnit="MWh")=chp.Qthermal;
	Modelica.Units.SI.Power CHP_Pelectric(displayUnit="kW")=chp.Pelectric;
	Modelica.Units.SI.Energy CHP_Eelectric(displayUnit="MWh")=chp.Eelectric;
	Modelica.Units.SI.Power CHP_Pfuel(displayUnit="kW")=chp.Pfuel;
	Modelica.Units.SI.Energy CHP_Efuel(displayUnit="MWh")=chp.Efuel;
	Modelica.Units.SI.Power GB_Pthermal(displayUnit="kW")=gasBoiler.Pthermal;
	Modelica.Units.SI.Energy GB_Qthermal(displayUnit="MWh")=gasBoiler.Qthermal;
	Modelica.Units.SI.Power GB_Pfuel(displayUnit="kW")=gasBoiler.Pfuel;
	Modelica.Units.SI.Energy GB_Efuel(displayUnit="MWh")=gasBoiler.Efuel;
	Modelica.Units.SI.Power PelectricPump(displayUnit="kW")=bufferBypassPump1.PelectricPump + bufferBypassPump2.PelectricPump + plantPump1.PelectricPump +  chp.PelectricPump + gasBoiler.PelectricPump "Electric pump power";
	Modelica.Units.SI.Energy EelectricPump=bufferBypassPump1.EelectricPump + bufferBypassPump2.EelectricPump + plantPump1.EelectricPump +  chp.EelectricPump + gasBoiler.EelectricPump "Electric pump energy";
	CHP chp(
		medium=medium,
		nUnits=CHP_units,
		Pthermal_max(displayUnit="MW")=CHP_Pthermal_max,
		deltaTmin=CHP_deltaTmin,
		fuelEfficiency=CHP_fuelEfficiency,
		power2heatRatio=CHP_power2heatRatio,
		on=CHP_activeUnits > 0 and on,
		Pref={if iUnit <= CHP_activeUnits then CHP_Pthermal_max else 0 for iUnit in 1:CHP_units},
		Tref=Tref,
		enabledUnits=CHP_activeUnits) annotation(Placement(transformation(extent={{-100,-20},{-60,20}})));
	GasBoiler gasBoiler(
		medium=medium,
		Pthermal_max=GB_Pthermal_max,
		deltaTmin=GB_deltaTmin,
		fuelEfficiency=GB_fuelEfficiency,
		mode=MoSDH.Utilities.Types.ControlTypes.RefFlowRefTemp,
		Tref=Tref,
		volFlowRef=GB_volFlow) annotation(Placement(transformation(extent={{15,-20},{55,20}})));
	Storage.StratifiedTank.TTES buffer(
		storageVolume=storageVolume,
		storageHeight=storageHeight,
		medium=medium,
		nLayers=nBufferLayers,
		setAbsolutePressure=false) annotation(Placement(transformation(extent={{-35,-30},{-5,30}})));
	Distribution.Pump bufferBypassPump1(
		medium=medium,
		volFlowRef=volFlowSetBypass) annotation(Placement(transformation(extent={{-25,35},{-15,45}})));
	Distribution.Pump bufferBypassPump2(
		medium=medium,
		volFlowRef=volFlowSetBypass) annotation(Placement(transformation(extent={{-15,-35},{-25,-45}})));
	Distribution.Pump plantPump1(
		medium=medium,
		volFlowRef=volFlowSetPlant) annotation(Placement(transformation(extent={{75,35},{85,45}})));
	MoSDH.Utilities.Types.ControlTypes mode=MoSDH.Utilities.Types.ControlTypes.RefPowerRefTemp "Definition of controlled inputs" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	Boolean on=true "=true, if component is enabled" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	Integer enabledUnits=CHP_units "Enabled CHP units" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	Modelica.Units.SI.Power Pref=10000000 "Reference thermal power" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	Modelica.Units.SI.Temperature Tref=343.15 "Reference supply temperature" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	Modelica.Units.SI.VolumeFlowRate volFlowRef=0.01 "Reference volume flow rate" annotation(Dialog(
		group="Setpoint",
		tab="Control"));
	protected
		parameter Integer CHP_turnOnThreshold=nBufferLayers - CHP_units annotation(Dialog(
			group="Control",
			tab="CHP"));
		parameter Integer CHP_turnOffThreshold=1 annotation(Dialog(
			group="Control",
			tab="CHP"));
		Modelica.Units.SI.VolumeFlowRate volFlowSetPlant;
		Modelica.Units.SI.VolumeFlowRate volFlowSetBypass;
		Modelica.Units.SI.VolumeFlowRate GB_volFlow;
	public
		Distribution.threeWayValveMix valve annotation(Placement(transformation(extent={{60,-45},{70,-35}})));
		Distribution.threeWayValveMix valve1 annotation(Placement(transformation(
			origin={-50,-25},
			extent={{-5,-5},{5,5}},
			rotation=-90)));
		Distribution.threeWayValveMix valve2 annotation(Placement(transformation(extent={{60,45},{70,35}})));
		Distribution.threeWayValveMix valve3 annotation(Placement(transformation(extent={{0,45},{10,35}})));
		Distribution.threeWayValveMix valve4 annotation(Placement(transformation(extent={{-45,45},{-35,35}})));
	initial algorithm
//CHP operation
  CHP_activeUnits := 0;
		  while buffer.Tlayers[CHP_turnOnThreshold + CHP_activeUnits] < Tref - 1 and CHP_activeUnits < CHP_units and CHP_activeUnits < enabledUnits loop
		    CHP_activeUnits := CHP_activeUnits + 1;
		  end while;
//heat supply mode
  if buffer.Tlayers[nBufferLayers] > Tref - 2 then
    operationMode := MoSDH.Utilities.Types.OperationModes.Discharge;
  else
    operationMode := MoSDH.Utilities.Types.OperationModes.Charge;
  end if;	algorithm
		when change(enabledUnits) then
		    CHP_activeUnits := 0;
		    while buffer.Tlayers[CHP_turnOnThreshold + CHP_activeUnits] < Tref - 1.5 and CHP_activeUnits < enabledUnits and CHP_activeUnits < CHP_units loop
		      CHP_activeUnits := CHP_activeUnits + 1;
		    end while;
		  elsewhen buffer.Tlayers[CHP_turnOnThreshold + pre(CHP_activeUnits)] < Tref - 1.5 and CHP_activeUnits < enabledUnits and CHP_activeUnits < CHP_units then
		    CHP_activeUnits := min(pre(CHP_activeUnits) + 1, CHP_units);
		  elsewhen buffer.Tlayers[CHP_turnOffThreshold + pre(CHP_activeUnits)] > Tref - 1.5 or enabledUnits == 0 then
		    CHP_activeUnits := max(pre(CHP_activeUnits) - 1, 0);
		  end when;
//turn units on if upper buffer layers dont reach target temperature
//turn units off if lower buffer layers reach target temperature
//heat supply mode
		  when pre(operationMode) == MoSDH.Utilities.Types.OperationModes.Discharge and buffer.Tlayers[nBufferLayers] < Tref - 3 then
		    operationMode := MoSDH.Utilities.Types.OperationModes.Charge;
		  elsewhen pre(operationMode) == MoSDH.Utilities.Types.OperationModes.Charge and buffer.Tlayers[2] > Tref - 3 then
		    operationMode := MoSDH.Utilities.Types.OperationModes.Discharge;
		  end when;
	equation
//Plant
  Tsupply = supplyPort.h / medium.cp;
		  Treturn = returnPort.h / medium.cp;
		  volFlow = returnPort.m_flow / medium.rho;
 if on then
    if mode == MoSDH.Utilities.Types.ControlTypes.RefPowerRefTemp and on then
      volFlowSetPlant = Pref / ((Tref - Treturn) * medium.cp * medium.rho);
    else
      volFlowSetPlant = volFlowRef;
    end if;
    if operationMode == MoSDH.Utilities.Types.OperationModes.Charge then
// volume flow from CHP bypasses buffer if plant supplies heat
      volFlowSetBypass = min(chp.volFlow, volFlowSetPlant);
      GB_volFlow = max(0, volFlowSetPlant - volFlowSetBypass);
    else
// buffer is emptied with the maximum power
      volFlowSetBypass = 0;
      GB_volFlow = max(0, volFlowRef - CHP_Pthermal_max * CHP_units / ((Tref - Treturn) * medium.rho * medium.cp));
    end if;
// flow & power
  else
    volFlowSetPlant = 0;
    volFlowSetBypass = 0;
    GB_volFlow = 0;
  end if;
		  
		connect(buffer.weatherPort,weather) annotation(Line(
			points={{-20,-29.7},{-20,-34.7},{-20,-50},{15,-50},{20,-50}},
			color={0,176,80}));
		    
		  
		  
		connect(plantPump1.flowPort_b,supplyPort) annotation(Line(
			points={{84.7,40},{89.7,40},{95,40},{100,40}},
			color={255,0,0},
			thickness=1));
		      
		  
		  
		  
		    
		connect(gasBoiler.returnPort,valve.flowPort_c) annotation(Line(
			points={{54.7,-5},{59.7,-5},{65,-5},{65,-30},{65,-35}},
			color={0,0,255},
			thickness=1));
		connect(valve.flowPort_b,buffer.loadIn) annotation(Line(
			points={{60,-40},{55,-40},{-0.3,-40},{-0.3,-25},{-5.3,-25}},
			color={0,0,255},
			thickness=1));
		connect(buffer.sourceOut,valve1.flowPort_c) annotation(Line(
			points={{-35,-25},{-40,-25},{-45,-25}},
			color={0,0,255},
			thickness=1));
		connect(chp.returnPort,valve1.flowPort_b) annotation(Line(
			points={{-60.3,-5},{-55.3,-5},{-50,-5},{-50,-15},{-50,-20}},
			color={0,0,255},
			thickness=1));
		connect(valve1.flowPort_a,bufferBypassPump2.flowPort_b) annotation(Line(
			points={{-50,-29.7},{-50,-34.7},{-50,-40},{-29.7,-40},{-24.7,-40}},
			color={0,0,255},
			thickness=1));
		connect(bufferBypassPump2.flowPort_a,valve.flowPort_b) annotation(Line(
			points={{-15,-40},{-10,-40},{55,-40},{60,-40}},
			color={0,0,255},
			thickness=1));
		connect(valve2.flowPort_a,plantPump1.flowPort_a) annotation(Line(
			points={{69.7,40},{74.7,40},{70,40},{75,40}},
			color={255,0,0},
			thickness=1));
		connect(gasBoiler.supplyPort,valve2.flowPort_c) annotation(Line(
			points={{54.7,5},{59.7,5},{65,5},{65,30},{65,35}},
			color={255,0,0},
			thickness=1));
		connect(chp.supplyPort,valve4.flowPort_b) annotation(Line(
			points={{-60.3,5},{-55.3,5},{-50,5},{-50,40},{-45,40}},
			color={255,0,0},thickness=1));
		connect(buffer.sourceIn,valve4.flowPort_c) annotation(Line(
			points={{-35,25},{-40,25},{-40,30},{-40,35}},
			color={255,0,0},thickness=1));
		connect(valve4.flowPort_a,bufferBypassPump1.flowPort_a) annotation(Line(
			points={{-35.3,40},{-30.3,40},{-30,40},{-25,40}},
			color={255,0,0},
			thickness=1));
		connect(bufferBypassPump1.flowPort_b,valve3.flowPort_b) annotation(Line(
			points={{-15.3,40},{-10.3,40},{-5,40},{0,40}},
			color={255,0,0},
			thickness=1));
		connect(buffer.loadOut,valve3.flowPort_c) annotation(Line(
			points={{-5.3,25},{-0.3,25},{5,25},{5,30},{5,35}},
			color={255,0,0},thickness=1));
		connect(valve3.flowPort_a,valve2.flowPort_b) annotation(Line(points={{9.699999999999999,40},{14.7,40},{55,40},{60,40}},color={255,0,0},thickness=1));
		connect(returnPort,valve.flowPort_a) annotation(Line(
			points={{100,-40},{95,-40},{74.7,-40},{69.7,-40}},
			color={0,0,255}));
	annotation(
		defaultComponentName="thermalPlant",
		Icon(
			coordinateSystem(extent={{-200,-200},{200,200}}),
			graphics={
							Bitmap(
								imageSource="iVBORw0KGgoAAAANSUhEUgAAA8wAAAPNCAYAAABcdOPLAAAABGdBTUEAALGPC/xhBQAAAAlwSFlz
AAAXEQAAFxEByibzPwAA1TBJREFUeF7s/Qu4XWV9twv3cru7/Xzdbtva88m2brfb16+XX7e7Hz1a
275Wq77Wz9dqa91Wq3IQkFNEQBBIY6ARiGIMijFITMMpBowxYAA5h5wICUlWyIGQA4QQIAYC4Ty+
8ZuZTzLms/5rZR3mfz7PGPO+r+u+AmStOccYcwyecc9x+jnoDUVRvOHll19+d+kJ5T+fXf45sXRm
24WlPy1dWbqldHv5MwAAAAAA0CeoAdotoCZQGywqDb0wsfwRNcQJpe8rfWM7MwDqQ7kSv65ced9e
+i+lCuKrS7XC729tBQAAAAAAAF1AjVF6X7s5JpeqQY4o/+p17TwBSEu5Mr65XCmPKp1TylFhAAAA
AABITtkmu0vnqVXKf31zO18AfClXuN8qV7h/Lf/UaRFbWmsjAAAAAABAxpTtsrN0VvmP/1r6hnbe
AIyPcmV6Vbli/Y/S6aUDWtkAAAAAAADqTNk2ulZajfPR8l9f084fgJFRrjR/Va48l5Y+1VqjAAAA
AAAAGoiap1RHn/+29JXtJALopFw5dD2ybtTFtcgAAAAAANB3qIVKp5T/+LZ2JkE/U64Iv1auELo1
+8rWGgIAAAAAAACK5/vKP75Y/vlb7XyCfqH84N9WfvC6a9wLrbUBAAAAAAAATNRO5R8cdW46+pDb
HzYAAAAAAACMgrKlFpZ//FU7r6Ap6ENtf7gAAAAAAAAwDsq2+mn5B+Fcd/Qhtj9MAAAAAAAA6CJl
a91e/vEP7fyCulB+aH9OKAMAAAAAAPhTtpduovy37RyDXCk/JN31Ws8QAwAAAAAAgB5StticUu6q
nRvlZ/PK8oPR46H2HPioAAAAAAAAoNeUTfZU+ccXS1/ZzjVISfmBHFHKc5QBAAAAAAAyoWy0gfIP
TtNORbnwX19+CJe2Pg0AAAAAAADIjrLZOE2715QL/KhSTr8GAAAAAADInLLdnio9pZ1z4EW5rF9X
Luh5BxY7AAAAAAAA1IWy5RaWf7y+nXfQTcqF+/bSLQcWNQAAAAAAANSNsum2l3/8eTvzoBuUC1V3
wH7hwCIGAAAAAACAutJuuy+2cw/GSrkQOQUbAAAAAACggZStxynaY6VceJyCDQAAAAAA0GDK5uMU
7dFSLjTdBZtTsLvMvmdfLDY8/Exx27qfFQtXPl5cddejLafd8FDL867dVpx91YPF6XMeKI75zoaW
H526rvjwhWsRERERERun9nXDfq/2gbUvrH3isH8c9pe17/zTNXta+9JPPvNie+8aukW7/ThFeySU
C2vKgcUGY+HFl14udjz+bLF005PFD5c/Vnz7xoeLM6/cUnxq+nrzfxKIiIiIiDg6tW+twL7kJw8V
85bubu17b3vs2da+OIydsgUvLv94ZTsNoYoWTLmAZraWFIwIbZD6lksb6X9ct6044bJNHBFGRERE
REyo9sl1lFpHptds31c8/wIRPRrKJry6/INorlIukNeUC4abex2GaiBP+sHW4uMXD5gbKSIiIiIi
5uE/f31dce41D7b24bUvz1How1O24e3lH69p52J/Uy6I17cXCBhseXR/8aMVj7e+pSKQERERERHr
rfbpdfCLgB6eshHvK//4tXY29idaAOWCGGgtETiITt3QTQb+dRrXHSMiIiIiNlkF9NcX7ihWbnmK
eI4oW3Fj+ceb2/nYX2jGywWws7UkoNi557niijt3te7QZ21IiIiIiIjYbI/69oZi9u27WjfxhQOo
GUvf3s7I/qCcb8Xy7gOLoH/Z//xLxY337WndxdraYBARERERsT/VXbh/suoJHmNVUrbjU6VHtHOy
2ZTzq9Ow+/rI8uqt+1qnXegGANbGgYiIiIiIKNUMF8zfXizf/GRfn7Ldbshmn55dzqBu8NWX1yzr
dvK6eZdOs7A2BERERERExOH8zLfubzXFvmf786hz2ZK6prmZNwIrZ0yPjuq7u2FrZb7m7t2tldta
6REREREREUejbg6s5zz34+naZVPq7tnNeuRUOUOvLGesr56zvGffC60L9rnTNSIiIiIieqjTtS+7
ZWerPfqJ9oHYV7Vzs/6UMzTzwKw1n0f3Pt9aabk+GRERERERe6HaQ4+l1ZN3+oWyMa8u/3hlOznr
SzkjUw7MUrPRrd+1kn50KqGMiIiIiIi9Vy0ydcH2Ysuj+9uV0mzK1ry4nZ31pJyBo9rz0lh0jbKO
KBPKiIiIiIiYi5f85KF+uTnY2e38rBdlLL+9tNEn09+xfi93vUZERERExCz91PT1xY337WnXSzNp
N+fftjO0HpQT/Lpywre05qCB6NqAc6950FwpERERERERc/LMK7cU2x57tl0zzaNsTz2juT6Pmyon
uJF3xNazlK+4cxc39EJERERExFqpS0j1FJ/9z7/UrptmUTboovKP/G8CVk7oCQcmuVms3PJUcdx3
N5orHyIiIiIiYh3UJaVLNz3ZrpzGkff1zGUsN+665ceeer64YP52c2VDRERERESso5N+sLX1SNwm
0W7RPK9nLiescdct66iyLpS3VjBERERERMQ6+6/T1jfuaHPZpHlez1xOWGOuW37xpZdb5/dbKxUi
IiIiImKT1GNy1UBNoWzTvK5nLieoMc9b1inYuouctSIhIiIiIiI20S/OfqBRp2iXjXpKO1fTUk7L
68uJacTDvTgFGxERERER+1Wdon3H+r3tOqo3ZaPuL/94Qztb01FOyKUHJqm+cAo2IiIiIiLiAb99
48OtR+rWnbJV57WzNQ3lBBzRnpbawinYiIiIiIiInU6YtbnYuee5djXVl7JZ393O195Svvcryzdf
eWAy6snAjqc5BRsREREREdHw4xcP1P4u2mWzbiz/eFU7Y3tH+cYnHJiEerJ4w97io1PXmSsGIiIi
IiIirm01023rftauqHpStuuX2hnbG8r3/LXyTWt7o6+frHqCWEZERERERByhP1rxeLum6kfZrr29
AVj5hrMOvHX9mLd0t7kCICIiIiIi4tBefusj7aqqH2XD9uYGYOV7/fmBt6wfeiC39cEjIiIiIiLi
4Z12w0OtpwzVkTKa/W8AVr7JT9vvVxv0gU5dsN38wBEREREREXHkXjB/e7H/+ZfatVUfypZd2c5a
H8r3+KsDb1Uf9EGed+0284NGRERERETE0atH89Yxmkv+oZ233aduR5f3Pfsiz1hGRERERER08KTv
bSr27HuhXV/1wO0oc/natTq6rG87iGVEREREREQ/Fc01PNLc/aPMZYkvbL949uiaZU7DRkRERERE
9Ldup2eXbbu4nbndoXzNtx146XrADb4QERERERF7p24EVrO7Z/9VO3fHT1ng89ovmj08OgoRERER
EbH36pFTdUH352rn7vgoX6s2R5fnLd1tfnCIiIiIiIjorw5g1ojxH2Wuy9Hln6x6wvzAEBERERER
sXf+aMXj7UrLm7J1F7Wzd2yUr/Fr5Ytkf5/wxRv2Fh+dus78sBAREREREbG3/nTNnnat5U3Zu29s
5+/oKX/5hPbrZMvAjqeJZURERERExIxUoy3d9GS72rLm7Hb+jp4ymFe2XyRLHnvq+eJT09ebHxAO
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
RU5ErkJggg==",
								extent={{-199.8,-200},{199.8,200}})}),
		Documentation(info= "<html><head></head><body><h4><font face=\"MS Shell Dlg 2\">Thermal power plant component (Sources.Fossil.ThermalPlant):</font></h4><h4><div style=\"font-weight: normal;\"><ul><li><font face=\"MS Shell Dlg 2\">The thermal power plant uses CHP units, a gas boiler and a buffer tank to supply thermal energy.&nbsp;</font></li><li><font face=\"MS Shell Dlg 2\">The buffer storage is sued to maximize run-times of the CHP units. According to the state of charge of the buffer, CHP units are switched on and off.</font></li><li><font face=\"MS Shell Dlg 2\">The required thermal power is supplied directly by the CHP units (bypassing the buffer), by the buffer storage and if required by the gas boiler.</font></li><li>The thermal plant can be enabled/disabled by the control variable&nbsp;<b>on</b>.</li><li>The maximum number of operated CHP units can be limited by the variable&nbsp;<b>activeUnits</b>.</li><li>The thermal plant can operate in three modes (<b>mode</b>) between which it can change dynamically:</li><ul><li><b>RefPowerRefTemp</b>: Define reference thermal power&nbsp;<b>Pref</b>&nbsp;and supply temperature&nbsp;<b>Tref.</b></li><li><b>RefFlowRefTemp</b>: Define reference volume flow&nbsp;<b>volFlow</b>&nbsp;and reference supply temperature&nbsp;<b>Tref</b>.</li><li><b>RefFlowRefPower</b>: Define reference volume flow rate&nbsp;<b>volFlow</b>&nbsp;and reference power&nbsp;<b>Pref</b>.</li></ul></ul></div></h4><table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><strong>Fig. 1: </strong>Thermal power plant model structure</caption>
  <tbody><tr>
    <td>
      <img src=\"modelica://MoSDH/Utilities/Images/ThermalPowerPlant.png\" width=\"700\">
    </td>
  </tr>
</tbody></table>
</body></html>"),
		experiment(
			StopTime=31536000,
			StartTime=0,
			Tolerance=0.0001,
			Interval=60));
end ThermalPowerPlant;
