within MoSDH.Parameters;
package Fluids "heat carrier fluid data"
 extends Modelica.Icons.MaterialPropertiesPackage;

 record fluidData "heat carrier fluid"
  extends Modelica.Thermal.FluidHeatFlow.Media.Medium(
    rho=995.6,
    cp=4000,
    cv=4000,
    lambda=0.615,
    nu=0.3E-6);
  annotation(Documentation(info="<html>
Medium: properties of water
</html>"));
 end fluidData;

 record fluidData_vW "heat carrier fluid van waasen"
  extends Modelica.Thermal.FluidHeatFlow.Media.Medium(
    rho=996.5,
    cp=4194,
    cv=4194,
    lambda=0.58,
    nu=0.3E-6);
  annotation(Documentation(info="<html>
Medium: properties of water
</html>"));
 end fluidData_vW;

 record SKEWSfluid "SKEWS heat carrier fluid"
  extends Modelica.Thermal.FluidHeatFlow.Media.Medium(
    rho=977,
    cp=4145,
    cv=4145,
    lambda=0.65,
    nu=0.1E-6);
  annotation(Documentation(info="<html>
Medium: properties of water
</html>"));
 end SKEWSfluid;

 record fluid_MDBTESpaper "Characteristics of MDBTES paper"
  extends Modelica.Thermal.FluidHeatFlow.Media.Medium(
    rho=1000,
    cp=4200,
    cv=4200,
    lambda=0.58,
    nu=0.3E-6);
  annotation(Documentation(info="<html>
Medium: properties of water
</html>"));
 end fluid_MDBTESpaper;

 record CoSimFluid "Co-Simulation paper fluid"
  extends Modelica.Thermal.FluidHeatFlow.Media.Medium(
    rho=995.6,
    cp=4200,
    cv=4200,
    lambda=0.65,
    nu=3E-6);
  annotation (
   defaultComponentPrefixes="parameter",
   Documentation(info="<html>
Medium: properties of water
</html>"));
 end CoSimFluid;

 record Gylcol34_50degC "Medium: properties of glycol:water 34:64 at 50 degC and 1 bar"
  extends Modelica.Thermal.FluidHeatFlow.Media.Medium(
    rho=1038.5,
    cp=3705,
    cv=3705,
    lambda=0.474,
    nu=1.25E-6);
  annotation (
   defaultComponentPrefixes="parameter",
   Documentation(info="<html>
  Medium: properties of glycol:water 50:50 (anti-freeze -40&deg;C) at 20&deg;C and 1 bar
</html>"));
 end Gylcol34_50degC;

 annotation (
  dateModified="2020-06-04 17:40:38Z",
  Documentation(info="<html>
<p>
Datasets containg information about the thermophysical parameters of different heat carrier fluids
</p>

</html>"));
end Fluids;