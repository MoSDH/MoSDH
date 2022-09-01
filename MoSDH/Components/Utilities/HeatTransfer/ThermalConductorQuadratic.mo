within MoSDH.Components.Utilities.HeatTransfer;
model ThermalConductorQuadratic "Lumped thermal element transporting heat without storing it according to quadratic temperature difference"
 extends Modelica.Thermal.HeatTransfer.Interfaces.Element1D;
 parameter Real G2(unit="W/K2") "Quadratic thermal conductance term [W/KÂ²]";
equation
  Q_flow = G2 * sign(dT) * dT ^ 2;
 annotation (
  Icon(graphics={
   Rectangle(
    pattern=LinePattern.None,
    fillColor={192,192,192},
    fillPattern=FillPattern.Backward,
    extent={{-90,70},{90,-70}}),
   Line(
    points={{-90,70},{-90,-70}},
    thickness=0.5),
   Line(
    points={{90,70},{90,-70}},
    thickness=0.5),
   Text(
    textString="%name",
    lineColor={0,0,255},
    extent={{-150,115},{150,75}}),
   Text(
    textString="G=%G",
    extent={{-150,-75},{150,-105}})}),
  Diagram(graphics={
   Line(
    points={{-80,0},{80,0}},
    color={255,0,0},
    arrow={
     Arrow.None,Arrow.Filled},
    thickness=0.5),
   Text(
    textString="Q_flow",
    lineColor={255,0,0},
    extent={{-100,-20},{100,-40}}),
   Text(
    textString="dT = port_a.T - port_b.T",
    extent={{-100,40},{100,20}})}),
  Documentation(info="<html><head></head><body><p>
This is a model for transport of heat without storing it; see also:
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.ThermalResistor\">ThermalResistor</a>.
It may be used for complicated geometries where
the thermal conductance G (= inverse of thermal resistance)
is determined by measurements and is assumed to be constant
over the range of operations. If the component consists mainly of
one type of material and a regular geometry, it may be calculated,
e.g., with one of the following equations:
</p>
<ul>
<li><p>
    Conductance for a <strong>box</strong> geometry under the assumption
    that heat flows along the box length:</p>
    <pre>    G = k*A/L
    k: Thermal conductivity (material constant)
    A: Area of box
    L: Length of box
    </pre>
    </li>
<li><p>
    Conductance for a <strong>cylindrical</strong> geometry under the assumption
    that heat flows from the inside to the outside radius
    of the cylinder:</p>
    <pre>    G = 2*pi*k*L/log(r_out/r_in)
    pi   : Modelica.Constants.pi
    k    : Thermal conductivity (material constant)
    L    : Length of cylinder
    log  : Modelica.Math.log;
    r_out: Outer radius of cylinder
    r_in : Inner radius of cylinder
    </pre>
    </li>
</ul>
<pre>    Typical values for k at 20 degC in W/(m.K):
      aluminium   220
      concrete      1
      copper      384
      iron         74
      silver      407
      steel        45 .. 15 (V2A)
      wood         0.1 ... 0.2
</pre><pre><p style=\"font-family: -webkit-standard; font-size: 13.333333015441895px; white-space: normal;\"><span style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">BSD 3-Clause License Copyright:</span></p><p style=\"font-family: -webkit-standard; font-size: 13.333333015441895px; white-space: normal;\">Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:</p><ul style=\"font-family: -webkit-standard; font-size: 13.333333015441895px; white-space: normal;\"><li style=\"font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt;\">Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.</li><li style=\"font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt;\">Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.</li><li style=\"font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt;\">Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.</li></ul><p style=\"font-family: -webkit-standard; font-size: 13.333333015441895px; white-space: normal;\"><br>THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p></pre>
</body></html>"),
  experiment(
   StopTime=1,
   StartTime=0,
   Tolerance=1e-06,
   Interval=0.001));
end ThermalConductorQuadratic;