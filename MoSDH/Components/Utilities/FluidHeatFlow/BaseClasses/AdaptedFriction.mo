within MoSDH.Components.Utilities.FluidHeatFlow.BaseClasses;
partial model AdaptedFriction "Simple friction model from MSL.Thermal.FluidHeatFlow with adapted exponent"
 parameter Modelica.Units.SI.VolumeFlowRate V_flowLaminar(
  min=Modelica.Constants.small,
  start=0.1) "Laminar volume flow" annotation(Dialog(group="Simple Friction"));
 parameter Modelica.Units.SI.Pressure dpLaminar(start=0.1) "Laminar pressure drop" annotation(Dialog(group="Simple Friction"));
 parameter Modelica.Units.SI.VolumeFlowRate V_flowNominal(start=1) "Nominal volume flow" annotation(Dialog(group="Simple Friction"));
 parameter Modelica.Units.SI.Pressure dpNominal(start=1) "Nominal pressure drop" annotation(Dialog(group="Simple Friction"));
 parameter Real frictionLoss(
  min=0,
  max=1)=0 "Part of friction losses fed to medium" annotation(Dialog(group="Simple Friction"));
 Modelica.Units.SI.Pressure pressureDrop;
 Modelica.Units.SI.VolumeFlowRate volumeFlow;
 Modelica.Units.SI.Power Q_friction;
protected
  parameter Modelica.Units.SI.Pressure dpNomMin=dpLaminar/V_flowLaminar*
              V_flowNominal;
  parameter Real k(
   final unit="Pa.s2/m6",
   fixed=false);
initial algorithm
  assert(V_flowNominal>V_flowLaminar,
    "SimpleFriction: V_flowNominal has to be > V_flowLaminar!");
  assert(dpNominal>=dpNomMin,
    "SimpleFriction: dpNominal has to be > dpLaminar/V_flowLaminar*V_flowNominal!");
  k:=(dpNominal - dpNomMin)/(V_flowNominal - V_flowLaminar)^(7/4);
equation
  if volumeFlow > +V_flowLaminar then
    pressureDrop = +dpLaminar/V_flowLaminar*volumeFlow + k*abs(volumeFlow - V_flowLaminar)^(7/4);
  elseif volumeFlow < -V_flowLaminar then
    pressureDrop = +dpLaminar/V_flowLaminar*volumeFlow - k*abs(volumeFlow + V_flowLaminar)^(7/4);
  else
    pressureDrop =  dpLaminar/V_flowLaminar*volumeFlow;
  end if;
  Q_friction = frictionLoss*volumeFlow*pressureDrop;
 annotation (
  Diagram(graphics={
   Line(
    points={{-80,0},{80,0}},
    color={0,0,255}),
   Line(
    points={{0,80},{0,-80}},
    color={0,0,255}),
   Line(
    points={{-40,-20},{40,20}},
    color={0,0,255}),
   Line(
    points={{40,20},{60,40},{70,60},{74,80}},
    color={0,0,255}),
   Line(
    points={{-40,-20},{-60,-40},{-70,-60},{-74,-80}},
    color={0,0,255}),
   Line(
    points={{40,20},{40,0}},
    color={0,0,255}),
   Line(
    points={{60,40},{60,0}},
    color={0,0,255}),
   Line(
    points={{40,20},{0,20}},
    color={0,0,255}),
   Line(
    points={{60,40},{0,40}},
    color={0,0,255}),
   Text(
    textString="V_flowLaminar",
    lineColor={0,0,255},
    extent={{18,0},{48,-20}}),
   Text(
    textString="V_flowNominal",
    lineColor={0,0,255},
    extent={{50,0},{80,-20}}),
   Text(
    textString="dpLaminar",
    lineColor={0,0,255},
    extent={{-30,30},{-4,10}}),
   Text(
    textString="dpNominal",
    lineColor={0,0,255},
    extent={{-30,50},{-4,30}}),
   Text(
    textString="dp ~ V_flow",
    lineColor={0,0,255},
    extent={{0,20},{30,0}}),
   Text(
    textString="dp ~ V_flow^2",
    lineColor={0,0,255},
    extent={{30,60},{60,40}})}),
  Documentation(info="<html><head></head><body><p>
Definition of relationship between pressure drop and volume flow rate:
</p>
<ul>
<li>-V_flowLaminar &lt; VolumeFlow &lt; +V_flowLaminar: laminar, i.e., linear dependency of pressure drop on volume flow.</li>
<li>-V_flowLaminar &gt; VolumeFlow or VolumeFlow &lt; +V_flowLaminar: turbulent, i.e., quadratic dependency of pressure drop on volume flow.</li>
</ul>
<p>
Linear and quadratic dependency are coupled smoothly at V_flowLaminar / dpLaminar.
Quadratic dependency is defined by nominal volume flow and pressure drop (V_flowNominal / dpNominal).
See also sketch at diagram layer.
</p><p style=\"font-size: 13.333333015441895px;\"><span style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">BSD 3-Clause License Copyright:</span></p><p style=\"font-size: 13.333333015441895px;\">Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:</p><ul style=\"font-size: 13.333333015441895px;\"><li style=\"font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt;\">Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.</li><li style=\"font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt;\">Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.</li><li style=\"font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt;\">Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.</li></ul><p style=\"font-size: 13.333333015441895px;\"><br>THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p>
</body></html>"));
end AdaptedFriction;