within MoSDH.Utilities.Types;
type ControlTypes = enumeration(
    RefPowerRefTemp
                 "Define thermal power output at reference supply temperature",
    RefFlowRefTemp
                "Define volume flow at reference supply temperature",
    RefFlowRefPower
                 "Define thermal power output and volume flow") annotation(Documentation(info="<html>

<p>
Possible options for BTES Co-simulation:
</p>
<ul>
<li>Convective (fluid properties)</li>
<li>Conductive (borehole wall)</li>
</ul>
</html>"));