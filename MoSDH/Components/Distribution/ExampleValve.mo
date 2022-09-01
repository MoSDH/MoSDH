within MoSDH.Components.Distribution;
model ExampleValve "Valve example"
 import MoSDH.Components.Sources.Solar.*;
 import MoSDH.Components.Sources.*;
 import MoSDH.Components.Loads.*;
 extends Modelica.Icons.Example;
 threeWayValveMix threeWayValveMix1(controlMode=MoSDH.Utilities.Types.ValveOpeningModes.closeA) annotation(Placement(transformation(
  origin={30,0},
  extent={{-5,-5},{5,5}},
  rotation=90)));
 Pump pump1(volFlowRef=0.01) annotation(Placement(transformation(extent={{-3,-6},{7,4}})));
 Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot1 annotation(Placement(transformation(extent={{62,9},{72,19}})));
 Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot2 annotation(Placement(transformation(extent={{62,-16},{72,-6}})));
 Utilities.FluidHeatFlow.fluidSourceHot fluidSourceHot3 annotation(Placement(transformation(extent={{-28,-6},{-38,4}})));
equation
  connect(fluidSourceHot3.fluidPort,pump1.flowPort_a) annotation(Line(
   points={{-28,-1},{-3,-1}},
   color={255,0,0}));
  connect(pump1.flowPort_b,threeWayValveMix1.flowPort_c) annotation(Line(points={{6.7,-1},{11.7,-1},{20,-1},{20,0},{25,0}}));
  connect(threeWayValveMix1.flowPort_a,fluidSourceHot1.fluidPort) annotation(Line(points={{30,4.7},{30,9.699999999999999},{30,14},{57,14},{62,14}}));
  connect(threeWayValveMix1.flowPort_b,fluidSourceHot2.fluidPort) annotation(Line(points={{30,-5},{30,-10},{30,-11},{57,-11},{62,-11}}));
 annotation (
  __OpenModelica_simulationFlags(
   lv="LOG_STATS",
   outputFormat="mat",
   s="dassl"),
  __OpenModelica_commandLineOptions="--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  Documentation(info="<html>


</html>"),
  experiment(
   StopTime=31536000,
   StartTime=0,
   Tolerance=0.0001,
   Interval=3600));
end ExampleValve;