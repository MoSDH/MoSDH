within MoSDH.Components.Storage.StratifiedTank.BaseClasses;
type BuoyancyModels = enumeration(
    aixLib
        "AixLib approach",
    buildings
           "Buildings approach",
    buildingSystems
                 "BuildingSystems approach") "Choises for the buoyancy model" annotation(initValue=aixLib);