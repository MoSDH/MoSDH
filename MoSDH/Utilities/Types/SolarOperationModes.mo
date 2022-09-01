within MoSDH.Utilities.Types;
type SolarOperationModes = enumeration(
    Active
        "Activate solar field",
    NightCooling
              "Night cooling mode",
    Idle
      "Idle mode") "Solar operation modes" annotation(Documentation(info="<html>

<p>
Possible options for BTES Co-simulation:
</p>
<ul>
<li>Convective (fluid properties)</li>
<li>Conductive (borehole wall)</li>
</ul>
</html>"));