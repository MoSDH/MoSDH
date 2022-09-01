within MoSDH.Utilities.Types;
type ControlTypesSolar = enumeration(
    RefTemp
         "Define reference supply temperature",
    RefFlow
         "Define volume flow",
    RefTempCooling
                "Define reference return temperature for night cooling") "ControlTypesSolar" annotation(Documentation(info="<html>

<p>
Possible options for BTES Co-simulation:
</p>
<ul>
<li>Convective (fluid properties)</li>
<li>Conductive (borehole wall)</li>
</ul>
</html>"));