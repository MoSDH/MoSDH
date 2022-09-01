within MoSDH.UsersGuide;
class Overview "Overview of Modelica Library"
  extends Modelica.Icons.Information;
  annotation (
    Documentation(info = "<html><head></head><body><p><b><span style=\"font-size: 11pt;\">MoSDH - Modelica Solar District Heating library</span></b></p>
<p>Library for simulation of solar district heating systems with underground thermal energy storage:</p>
<ul>
<li>Based on Modelica.Thermal interfaces (temperature, mass flow rate and pressure calculation using constant media properties)</li>
<li>Easy and fast system model development</li>
<li>Robust and fast system simulations</li>
<li>Standardized component control logic</li>
<li>Models include all sub-components (pumps, sensors,...) to make the construction of hydraulic networks easy</li>
<li>Tool independant: succesfully tested in OpenModelica v1.18, SimulationX 4.3 and Dymola 2021x</li>
<li>Uses Modelica Standard Library version 4.0</li>
</ul>
<p><b>Fig. 1: </b>Solar District Heating system </p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"0\"><tbody><tr>
<td><p><img src=\"modelica://MoSDH/Utilities/Images/MoSDH_system.png\" width=\"700\"> </p></td>
</tr>
</tbody></table>
<p><b>System model development</b></p>
<p>Fast development of small or large SDH system models. Control of components can be defined in the context menu of each component and system control is usually defined on the top level of the model individually for each system model.&nbsp;</p>
<p><b>Fig. 2: </b>MoSDH system model </p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"0\"><tbody><tr>
<td><p><img src=\"modelica://MoSDH/Utilities/Images/MoSDHsystemModel.png\" width=\"700\"> </p></td>
</tr>
</tbody></table>
<p><b>Component control</b></p>
<p>Components have predefined control modes. The <b>mode</b> and the corresponding set points for temperatures, powers and volume flow rates can be defined in the control-tab of the component settings. All of these are variables and can be changed dynamically during simulation (<b>mode</b> as well). A typical heat source component is controlled by 2 of the 3 control variables (Fig. 3 orange), depending on the current setting of <b>mode</b>:</p><ul style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><li><b>RefPowerRefTemp</b>: Define reference thermal power&nbsp;<b>Pref</b>&nbsp;and supply temperature&nbsp;<b>Tref.</b></li><li><b>RefFlowRefTemp</b>: Define reference volume flow&nbsp;<b>volFlow</b>&nbsp;and reference supply temperature&nbsp;<b>Tref</b>.</li><li><b>RefFlowRefPower</b>: Define reference volume flow rate&nbsp;<b>volFlow&nbsp;</b>and reference power&nbsp;<b>Pref</b></li></ul><p>In addition, components have a control variable <b>on</b>, which can be used to disable the component overall. More details and examples on how components are controlled can be found in the documentation of components and the respective example models.</p>
<p><b>Fig. 3: </b>Component control </p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"0\"><tbody><tr>
<td><p><img src=\"modelica://MoSDH/Utilities/Images/ComponentControl.png\" width=\"400\"> </p></td>
</tr>
</tbody></table>
<p><b>Hydraulic networks</b></p>
<p>The volume flow rate of heat source and load components is defined by the internal pump. The direct connection of two such components results in an overdetermined loop (Fig. 4 a). An additional degree of freedom can be introduced by a passive component like hydraulic shunts (Fig. 4 b), a storage (TTES &amp; PTES, Fig. 4 c) or a heat exchanger. </p>
<p><b>Fig. 4: </b>Hydraulic networks</p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"0\"><tbody><tr>
<td><p><img src=\"modelica://MoSDH/Utilities/Images/Hydraulic loops.png\" width=\"700\"> </p></td>
</tr>
</tbody></table>

</body></html>"),
    experiment(StopTime = 1, StartTime = 0, Interval = 0.001));
end Overview;
