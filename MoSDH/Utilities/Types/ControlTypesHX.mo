within MoSDH.Utilities.Types;
type ControlTypesHX = enumeration(
    Passive
         "Passive: no pumps",
    CoupleSource
              "Coupled: sourcePump.volFlow = c*volFlowLoad",
    SourcePump
            "Source pump controlled via input/ no load pump",
    CoupleLoad
            "Coupled: loadPump.volFlow = c*volFlowSource",
    LoadPump
          "Load pump controlled via input/ no source pump") "Control types for heat exchangers" annotation(Documentation(info="<html>

<p>
Possible options for BTES Co-simulation:
</p>
<ul>
<li>Convective (fluid properties)</li>
<li>Conductive (borehole wall)</li>
</ul>
</html>"));