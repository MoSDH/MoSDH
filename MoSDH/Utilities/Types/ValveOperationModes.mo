within MoSDH.Utilities.Types;
type ValveOperationModes = enumeration(
    ctrlAfreeC
            "Control a: y(a)=bus.y / y(b)=1-bus.y / y(c)=1",
    ctrlCfreeA
            "Control c: y(a)=1 / y(b)=1-bus.y / y(c)=bus.y",
    open
      "Open: y(a)=y(b)=y(c)=1") "Define controlled ports";