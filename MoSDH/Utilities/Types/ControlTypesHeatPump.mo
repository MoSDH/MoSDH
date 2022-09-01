within MoSDH.Utilities.Types;
type ControlTypesHeatPump = enumeration(
    SourceFlowRate
                "Define source flow rate and load supply temperature and power",
    DeltaTsource
              "Define source delta T and load supply temperature and power",
    SourcePower
             "Define source power, source delta T and load supply temperature") "Control types forheat pumps" annotation(Documentation(info="<html>

<p>
Possible options for BTES Co-simulation:
</p>
<ul>
<li>Convective (fluid properties)</li>
<li>Conductive (borehole wall)</li>
</ul>
</html>"));