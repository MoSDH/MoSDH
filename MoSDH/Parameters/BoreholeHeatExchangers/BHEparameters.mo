within MoSDH.Parameters.BoreholeHeatExchangers;
partial record BHEparameters "Partial record for BHE data"
 extends Modelica.Icons.Record;
 parameter Real dBorehole(quantity="Length") "borehole diameter" annotation(Dialog(group="Borehole"));
 parameter Real spacing(quantity="Length") "shank spacing (1U2U)" annotation(Dialog(group="Borehole"));
 parameter Integer nShanks "number of shanks (2 for 2U and 1 else)" annotation(Dialog(group="Borehole"));
 parameter Real dPipe1(quantity="Length") "outer diameter" annotation(Dialog(group="Pipe/inner pipe"));
 parameter Real tPipe1(quantity="Length") "wall thickness " annotation(Dialog(group="Pipe/inner pipe"));
 parameter Real lamda1(quantity="ThermalConductivity")=0.4 "thermal conductivity " annotation(Dialog(group="Pipe/inner pipe"));
 parameter Real dPipe2(quantity="Length") "outer diameter" annotation(Dialog(group="Outer pipe (only applies for coax)"));
 parameter Real tPipe2(quantity="Length") "wall thickness " annotation(Dialog(group="Outer pipe (only applies for coax)"));
 parameter Real lamda2(quantity="ThermalConductivity") "thermal conductivity " annotation(Dialog(group="Outer pipe (only applies for coax)"));
end BHEparameters;