within MoSDH.Components.Storage.StratifiedTank.Functions;
function HTcoefficientAlpha "Heat transfer coefficient for free convection at a slab"
  input Modelica.Units.SI.Temperature T_wall "Temperature at the wall";
  input Modelica.Units.SI.Temperature T_fluid
    "Temperature of the fluid far from the wall";
  input Modelica.Units.SI.Length charLength
    "Characteristic Length (height if vertical, area/perimeter if horizontal)";
 input Modelica.Thermal.FluidHeatFlow.Media.Medium medium;
  input Modelica.Units.SI.CubicExpansionCoefficient beta
    "Thermal expansion coefficient of the fluid";
 input Boolean verticalSlab "true if slab is vertical, false if horizontal";
  input Modelica.Units.SI.Angle inclinationAngle
    "0 if vertical/horizontal slab, else inclination angle from vertical";
 input Boolean fluidBelowSlab "True if fluid is located below the horizontal slab";
  output Modelica.Units.SI.CoefficientOfHeatTransfer alpha;
protected
  parameter Modelica.Units.SI.RayleighNumber Ra=Pr*abs(-beta*cos(
      inclinationAngle)*(T_wall - T_fluid)*Modelica.Constants.g_n*(charLength^3)
      /(medium.nu^2));
  parameter Modelica.Units.SI.PrandtlNumber Pr=medium.nu*medium.rho*medium.cp/
      medium.lambda;
  Real f;
  Modelica.Units.SI.NusseltNumber nu;
algorithm
  if verticalSlab then
   //Modelica.Utilities.Streams.print("vertical slab");
   f:=(1+(0.492/Pr)^(9/16))^(-(16/9));
   nu:=(0.825+0.387*((Ra*f)^(1/6)))^2;
  else // horizontal slab
   if (fluidBelowSlab and T_wall<T_fluid) or ((not fluidBelowSlab) and T_wall>T_fluid) then
   // fluid is "driven away" from slab
    f:=(1+(0.322/Pr)^(11/20))^(-20/11);
    if Ra*f<7*10^(-4) then //laminar case
     //Modelica.Utilities.Streams.print("horizontal slab, a, laminar");
     nu:=0.766*(Ra*f)^(1/5);
    else // turbulent case
     //Modelica.Utilities.Streams.print("horizontal slab, a, turbulent");
     nu:=0.15*(Ra*f)^(1/3);
    end if;
   else // fluid is "driven towards" slab
    f:=(1+(0.492/Pr)^(9/16))^(-(16/9));
    /*if T_wall <> T_fluid then
					assert(Ra>10^3,"Turbulent flow ocurring at a horizontal slab is treated as laminar flow!",AssertionLevel.warning);
					assert(f<10^10,"Turbulent flow ocurring at a horizontal slab is treated as laminar flow!",AssertionLevel.warning);
				//else Modelica.Utilities.Streams.print("T_wall=T_fluid=" + String(T_wall)+" , verticalSlab="+String(verticalSlab)+", fluidBelowSlab="+String(fluidBelowSlab));
				end if;*/
    //Modelica.Utilities.Streams.print("Ra="+String(Ra));
    //Modelica.Utilities.Streams.print("f=" + String(f));
    nu:=0.6*(Ra*f)^(1/5);
    //Modelica.Utilities.Streams.print("horizontal slab, b, laminar calculated");
   end if;
  end if;
  alpha :=max(medium.lambda*nu/charLength, 1e-10);
  /*if alpha<0.0001 then
			Modelica.Utilities.Streams.print("alpha="+String(alpha)+", nu="+String(nu)+", Pr="+String(Pr)+", Ra="+String(Ra));
			Modelica.Utilities.Streams.print("T_fluid=" + String(T_fluid)+", T_wall="+String(T_wall)+" , verticalSlab="+String(verticalSlab)+", fluidBelowSlab="+String(fluidBelowSlab));
		end if;*/
 annotation(Icon(graphics={
  Rectangle(
   fillColor={255,255,255},
   fillPattern=FillPattern.Solid,
   extent={{0,103.3},{53.3,-103.3}}),
  Text(
   textString="alpha(Nu_m)",
   extent={{-63.3,26.7},{-3.3,-13.3}})}));
end HTcoefficientAlpha;