within MoSDH.Utilities.Types;
type OperationModes = enumeration( 
	FullLoad "Component delivers full load", 
	PartLoadParallel "Component delivers part of the volume flow at reference temperature", 
	BackFlowMixing "High supply temperature is lowered by backflow mixing", 
	PartLoadSerial "Component delivers full volume flow below reference temperature", 
	PartLoadMixing "Component delivers part of the volume flow below reference temperature", 
	Charge "Charging ", 
	Discharge "Discharging", 
	HeatPumpDischarge "Discharging via heat pump", 
	HeatPumpCharge "Charging via heat pump", 
	ReferenceTsupply "Reference supply temperature", 
	ReferenceDeltaT "Reference temperature delta", 
	Idle "Component is idle", 
	PartLoad "Component supplies in part load mode", 
	On "Turned on", 
	Off "Turend off", 
	Heating "Heating mode", 
	Cooling "Cooling mode", 
	Regeneration "Regeneration mode") "Component operation modes" annotation(Documentation(info= "<html><head></head><body><p>
Collection of operation modes for naming:</p><pre style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><ol><li><span style=\"font-family: 'Courier New'; font-size: 12pt;\">Charge </span><span style=\"font-family: 'Courier New'; font-size: 12pt; color: rgb(0, 139, 0);\">\"Charging \"</span><span style=\"font-family: 'Courier New'; font-size: 12pt;\"> </span></li><li><span style=\"font-family: 'Courier New'; font-size: 12pt;\">Discharge </span><span style=\"font-family: 'Courier New'; font-size: 12pt; color: rgb(0, 139, 0);\">\"Discharging\"</span><span style=\"font-family: 'Courier New'; font-size: 12pt;\"> </span></li><li><span style=\"font-family: 'Courier New'; font-size: 12pt;\">HeatPumpDischarge </span><span style=\"font-family: 'Courier New'; font-size: 12pt; color: rgb(0, 139, 0);\">\"Discharging via heat pump\"</span></li><li><span style=\"font-family: 'Courier New'; font-size: 12pt;\">HeatPumpCharge </span><span style=\"font-family: 'Courier New'; font-size: 12pt; color: rgb(0, 139, 0);\">\"Charging via heat pump\"</span></li><li><span style=\"font-family: 'Courier New'; font-size: 12pt;\">ReferenceTsupply </span><span style=\"font-family: 'Courier New'; font-size: 12pt; color: rgb(0, 139, 0);\">\"Reference supply temperature\"</span></li><li><span style=\"font-family: 'Courier New'; font-size: 12pt;\">ReferenceDeltaT </span><span style=\"font-family: 'Courier New'; font-size: 12pt; color: rgb(0, 139, 0);\">\"Reference temperature delta\"</span></li><li><span style=\"font-family: 'Courier New'; font-size: 12pt;\">Idle </span><span style=\"font-family: 'Courier New'; font-size: 12pt; color: rgb(0, 139, 0);\">\"Component is idle\"</span></li><li><span style=\"font-family: 'Courier New'; font-size: 12pt;\">PartLoad </span><span style=\"font-family: 'Courier New'; font-size: 12pt; color: rgb(0, 139, 0);\">\"Component supplies in part load mode\"</span></li><li><span style=\"font-family: 'Courier New'; font-size: 12pt;\">On </span><span style=\"font-family: 'Courier New'; font-size: 12pt; color: rgb(0, 139, 0);\">\"Turned on\"</span></li><li><span style=\"font-family: 'Courier New'; font-size: 12pt;\">Off </span><span style=\"font-family: 'Courier New'; font-size: 12pt; color: rgb(0, 139, 0);\">\"Turend off\"</span><span style=\"font-family: 'Courier New'; font-size: 12pt;\">, </span></li><li><span style=\"font-family: 'Courier New'; font-size: 12pt;\">Heating </span><span style=\"font-family: 'Courier New'; font-size: 12pt; color: rgb(0, 139, 0);\">\"Heating mode\"</span><span style=\"font-family: 'Courier New'; font-size: 12pt;\"> </span></li><li><span style=\"font-family: 'Courier New'; font-size: 12pt;\">Cooling </span><span style=\"font-family: 'Courier New'; font-size: 12pt; color: rgb(0, 139, 0);\">\"Cooling mode\"</span></li><li><span style=\"font-family: 'Courier New'; font-size: 12pt;\">Regeneration </span><span style=\"font-family: 'Courier New'; font-size: 12pt; color: rgb(0, 139, 0);\">\"Regeneration mode\"</span></li></ol><!--StartFragment--></pre>

</body></html>"));
