within MoSDH.Components.Utilities.FluidHeatFlow;
model HeatTransmissionResistance "Resistance for heat transmission between fluid and pipe wall"
 Modelica.Blocks.Interfaces.RealInput volFlow(quantity="VolumeFlowRate") "volume flow of fluid" annotation(Placement(
  transformation(extent={{-20,-20},{20,20}}),
  iconTransformation(extent={{-120,-20},{-80,20}})));
 Modelica.Blocks.Interfaces.RealOutput R(quantity="ThermalResistance") "thermal resistance" annotation(Placement(
  transformation(extent={{-10,-10},{10,10}}),
  iconTransformation(extent={{86.7,40},{106.7,60}})));
 Real Re "Reynolds number";
  Modelica.Units.SI.Velocity vFluid "fluid velocity in pipe";
 Real Xi "auxillary variable";
 Real gamma "auxillary varibale";
 Real Nu "Nusselt number";
 replaceable parameter Modelica.Thermal.FluidHeatFlow.Media.Water medium constrainedby
    Modelica.Thermal.FluidHeatFlow.Media.Medium annotation(choicesAllMatching=true);
 parameter Boolean isAnnularGap=false "=true, if annular gap of coax pipe";
 parameter Boolean innerGapSurface=false "=true, if inner contact surface of gap" annotation(Dialog(enable=isAnnularGap));
  parameter Modelica.Units.SI.Length Lchar "Characteristic Length";
  parameter Modelica.Units.SI.Length diameter=0.1 "Diameter of pipe";
  parameter Modelica.Units.SI.Length dInnerGap(min=0.000001) = 0.01
    "Inner diameter of annular gap" annotation (Dialog(enable=isAnnularGap));
protected
  parameter Modelica.Units.SI.Area Apipe=if isAnnularGap then Modelica.Constants.pi
      *(diameter^2 - dInnerGap^2)/4 else Modelica.Constants.pi*(diameter^2)/4
    "Pipe cross section";
  parameter Real Pr=MoSDH.Components.Utilities.FluidHeatFlow.Functions.Prandtl(medium.rho*medium.nu, medium.cp,medium.lambda)
                                                                                                                             "Prandtl number";
  parameter Modelica.Units.SI.Length hydrDiameter=if isAnnularGap then diameter
       - dInnerGap else diameter "Hydraulic diameter";
equation
  vFluid= max(abs(volFlow),Modelica.Constants.small)/Apipe;
  Re=MoSDH.Components.Utilities.FluidHeatFlow.Functions.Reynolds(
    vFluid,
    hydrDiameter,
    medium.nu);
  Xi=  MoSDH.Components.Utilities.FluidHeatFlow.Functions.Xi(Re);
  gamma= MoSDH.Components.Utilities.FluidHeatFlow.Functions.Gamma(Re);
  if not
        (isAnnularGap) then
   Nu=MoSDH.Components.Utilities.FluidHeatFlow.Functions.Nusselt_pipe(diameter,gamma,Lchar,Pr,Re,Xi);
   R=1/(Nu*medium.lambda*Modelica.Constants.pi);
  else
   Nu=MoSDH.Components.Utilities.FluidHeatFlow.Functions.Nusselt_annularGap(dInnerGap,diameter,gamma,Lchar,Pr,Re,Xi);
   if innerGapSurface then
    R=1/(Nu*medium.lambda*Modelica.Constants.pi)*hydrDiameter/dInnerGap;
   else
    R=1/(Nu*medium.lambda*Modelica.Constants.pi)*hydrDiameter/diameter;
   end if;
  end if;
 annotation (
  Icon(graphics={
   Text(
    textString="%name",
    lineColor={0,0,255},
    extent={{-153.3,138.2},{146.7,98.2}}),
   Text(
    textString="G=%G",
    extent={{-150,-75},{150,-105}}),
   Ellipse(
    fillColor={0,192,255},
    fillPattern=FillPattern.Solid,
    lineThickness=4.5,
    extent={{79.7,74.09999999999999},{-70,-66.90000000000001}}),
   Line(
    points={{0,73.3},{0,3.3},{30,3.3},{33.3,3.3}},
    thickness=1),
   Line(
    points={{0,73.3},{30,60},{33.3,3.3},{30,3.3}},
    smooth=Smooth.Bezier,
    thickness=1.5),
   Line(
    points={{0,60},{23.3,60}},
    arrow={
     Arrow.None,Arrow.Filled},
    thickness=1.5),
   Line(
    points={{0.2,46.6},{26.7,46.7}},
    arrow={
     Arrow.None,Arrow.Filled},
    thickness=1.5),
   Line(
    points={{0,33.3},{33.3,33.3}},
    arrow={
     Arrow.None,Arrow.Filled},
    thickness=1.5),
   Line(
    points={{0,16.7},{33.3,16.7}},
    arrow={
     Arrow.None,Arrow.Filled},
    thickness=1.5),
   Text(
    textString="dp & alpha",
    textStyle={
     TextStyle.Bold},
    extent={{-69.90000000000001,6.6},{80.09999999999999,-30.1}})}),
  experiment(
   StopTime=1,
   StartTime=0,
   Tolerance=1e-06,
   Interval=0.002));
end HeatTransmissionResistance;