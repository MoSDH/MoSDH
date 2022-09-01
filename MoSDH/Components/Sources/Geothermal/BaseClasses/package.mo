within MoSDH.Components.Sources.Geothermal;
package BaseClasses "Borehole heat exchanger base classes"
 extends Modelica.Icons.BasesPackage;

 annotation (
  dateModified="2020-07-15 10:07:39Z",
  Documentation(info="<html>
<p>
There are currently the following components for the simulation of borehole heat exchangers:
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr><th>Components</th> <th>Description</th></tr>

<tr><td >
 <a href=\"modelica://MoSDH.Components.Sources.Geothermal.BaseClasses.BHEhead\">BHEhead</a>
 </td>
 <td>
 
Borehole heat exchanger head model. Includes hydraulic utility components and can be regarded as an interface for the different BHE types.
 </td>
</tr>
<tr><td >
 <a href=\"modelica://MoSDH.Components.Sources.Geothermal.BaseClasses.CoaxSegment\">Coaxial</a><br>
 </td>
 <td>
Model of a coaxial borehole heat exchanger segment
 </td>
</tr>
<tr><td >
 <a href=\"modelica://MoSDH.Components.Sources.Geothermal.BaseClasses.SingleUsegment\">Single-U</a><br>
 </td>
 <td>
Model of a single-U borehole heat exchanger segment
 </td>
</tr>

<tr><td >
 <a href=\"modelica://MoSDH.Components.Sources.Geothermal.BaseClasses.DoubleUsegment\">Double-U</a><br>
 </td>
 <td>
 
Model of a double-U borehole heat exchanger segment
 </td>
</tr>
</table>

</html>"));
end BaseClasses;