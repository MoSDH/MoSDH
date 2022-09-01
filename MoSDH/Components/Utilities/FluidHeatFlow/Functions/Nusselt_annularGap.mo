within MoSDH.Components.Utilities.FluidHeatFlow.Functions;
function Nusselt_annularGap "Nusselt number for annular gap"
 extends Modelica.Icons.Function;
  input Modelica.Units.SI.Length Di "inner diameter of annular gap";
  input Modelica.Units.SI.Length Do "outer diameter of annular gap";
 input Real gamma "auxillary variable gamma";
  input Modelica.Units.SI.Length L "characteristic length";
 input Real Pr "Prandtl number";
 input Real Re "Reynolds number";
 input Real Xi "auxillary variable";
 output Real Nu "Nusselt number of annular gap fluid";
algorithm
  // enter your algorithm here
  Nu:=if
    Re<2300
   then
    3.66+(4-0.102/(Di/Do+0.02))*(Di/Do)^(0.04)
   else if
    Re >= 10^4
   then
    (Xi/8)*Re*Pr/(1+12.7*sqrt(Xi/8)*(Pr^(2/3)-1))*(1+((Do-Di)/L)^(2/3))*(0.86*(Di/Do)^(0.84)+(1-0.14*(Di/Do)^0.6))/(1+(Di/Do))
   else
    (1-gamma)*(3.66+(4-0.102/(Di/Do+0.02))*(Di/Do^0.04))+gamma*(0.0308/8*10^4*Pr/(1+12.7*sqrt(0.0308/8)*(Pr^(2/3)-1))*(1+((Do-Di)/L)^(2/3))*(0.86*(Di/Do)^0.84+(1-0.14*(Di/Do)^0.6))/(1+(Di/Do)));
end Nusselt_annularGap;