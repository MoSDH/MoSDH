within MoSDH.Components.Utilities.FluidHeatFlow;
model Pipe "Pipe with optional heat exchange and adpated friction model"
 extends Modelica.Thermal.FluidHeatFlow.BaseClasses.TwoPort;
 extends MoSDH.Components.Utilities.FluidHeatFlow.BaseClasses.AdaptedFriction;
 parameter Boolean useHeatPort=false "=true, if HeatPort is enabled" annotation (
  choices(checkBox=true),
  Evaluate=true,
  HideResult=true);
 parameter Modelica.Units.SI.Length h_g(start=0) "Geodetic height (height difference from flowPort_a to flowPort_b)";
 parameter Modelica.Units.SI.Acceleration g(final min=0)=Modelica.Constants.g_n "Gravitation";
 Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort(
  T=T_q,
  Q_flow=Q_flowHeatPort) if useHeatPort annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
protected
  Modelica.Units.SI.HeatFlowRate Q_flowHeatPort "Heat flow at conditional heatPort";
equation
  if not useHeatPort then
       Q_flowHeatPort=0;
     end if;
  // coupling with FrictionModel
      volumeFlow = V_flow;
     dp = pressureDrop + medium.rho*g*h_g;
  // energy exchange with medium
      Q_flow = Q_flowHeatPort + Q_friction;
 annotation (
  Icon(graphics={
   Rectangle(
    lineColor={255,0,0},
    fillColor={0,0,255},
    fillPattern=FillPattern.Solid,
    extent={{-90,20},{90,-20}}),
   Polygon(
    points={{-10,-90},{-10,-40},{0,-20},{10,-40},{10,-90},{-10,
    -90}},
    lineColor={255,0,0},
    visible=useHeatPort),
   Text(
    textString="%name",
    lineColor={0,0,255},
    extent={{-150,80},{150,40}})}),
  Documentation(info="<html><head>
<style type=\"text/css\">
a {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt;}
body, blockquote, table, p, li, dl, ul, ol {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; color: black;}
h3 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11pt; font-weight: bold;}
h4 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt; font-weight: bold;}
h5 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: bold;}
h6 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9pt; font-weight: bold; font-style:italic}
pre {font-family: Courier, monospace; font-size: 9pt;}
td {vertical-align:top;}
th {vertical-align:top;}
</style>
</head>

<body><p>Pipe with optional heat exchange.</p>
<p>
Thermodynamic equations are defined by Partials.TwoPort.
Q_flow is defined by heatPort.Q_flow (useHeatPort=true) or zero (useHeatPort=false).</p>
<p>
<strong>Note:</strong> Setting parameter m (mass of medium within pipe) to zero
leads to neglect of temperature transient cv*m*der(T).
</p>
<p>
<strong>Note:</strong> Injecting heat into a pipe with zero mass flow causes
temperature rise defined by storing heat in medium's mass.</p><p style=\"font-family: -webkit-standard;\"><span style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">BSD 3-Clause License Copyright:</span></p><p style=\"font-family: -webkit-standard;\">Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:</p><ul style=\"font-family: -webkit-standard;\"><li>Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.</li><li>Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.</li><li>Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.</li></ul><p style=\"font-family: -webkit-standard;\"><br>THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p><p><br></p><p><br></p><p><br></p>
</body></html>"),
  experiment(
   StopTime=1,
   StartTime=0,
   Tolerance=1e-06,
   Interval=0.001));
end Pipe;