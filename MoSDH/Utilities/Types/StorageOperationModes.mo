within MoSDH.Utilities.Types;
type StorageOperationModes = enumeration(
    Charge
        "Charging ",
    DirectDischarge
                 "Direct discharging",
    HeatPumpDischarge
                   "Discharging via heat pump",
    Idle
      "Idle mode") "Storage operation modes" annotation(Documentation(info="<html>

<p>
Possible options for BTES Co-simulation:
</p>
<ul>
<li>Convective (fluid properties)</li>
<li>Conductive (borehole wall)</li>
</ul>
</html>"));