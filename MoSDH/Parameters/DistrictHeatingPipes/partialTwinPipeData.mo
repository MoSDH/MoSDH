within MoSDH.Parameters.DistrictHeatingPipes;
partial record partialTwinPipeData "Partial record for twin pipe data"
 extends Modelica.Icons.Record;
 parameter Real dCasing(quantity="Length") "casing diameter" annotation(Dialog(group="Composite"));
 parameter Real spacing(quantity="Length") "pipe spacing (center to center)" annotation(Dialog(group="Composite"));
 parameter Real dPipe(quantity="Length") "outer pipe diameter" annotation(Dialog(group="Medium pipes"));
 parameter Real tPipe(quantity="Length") "wall thickness " annotation(Dialog(group="Medium pipes"));
 parameter Real lamda(quantity="ThermalConductivity")=0.4 "thermal conductivity of pipes" annotation(Dialog(group="Medium pipes"));
end partialTwinPipeData;