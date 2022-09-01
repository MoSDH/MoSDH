within MoSDH.Parameters.DistrictHeatingPipes;
partial record SinglePipePartial "Partial record for a single preinsulated district heating pipe"
 extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Length dCasing(displayUnit="mm")
    "Casing pipe outer diameter" annotation (Dialog(group="Casing"));
  parameter Modelica.Units.SI.Length tCasing(displayUnit="mm")
    "Casing pipe thickness" annotation (Dialog(group="Casing"));
  parameter Modelica.Units.SI.ThermalConductivity lamdaCasing
    "Casing pipe thermal conductivity" annotation (Dialog(group="Casing"));
  parameter Modelica.Units.SI.ThermalConductivity lamdaInsulation
    "Casing pipe thermal conductivity" annotation (Dialog(group="Insulation"));
  parameter Modelica.Units.SI.Length dPipe(displayUnit="mm")
    "Medium pipe outer diameter" annotation (Dialog(group="Medium pipe"));
  parameter Modelica.Units.SI.Length tPipe(displayUnit="mm")
    "Medium pipe thickness" annotation (Dialog(group="Medium pipe"));
  parameter Modelica.Units.SI.ThermalConductivity lamdaPipe
    "Medium pipe thermal conductivity" annotation (Dialog(group="Medium pipe"));
end SinglePipePartial;