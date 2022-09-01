within MoSDH.Utilities.Types;
type IrradiationDataDirection = enumeration(
    horizontal
            "Direct and diffuse irradiation data on a horizontal.",
    sun
     "Direct irradiation data in sun beam direction and diffuse on horizontal.",
    surface
         "Total irradiation measured on tilted surface.") "Direction of solar irradiation data.";