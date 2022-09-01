within MoSDH.Components.Utilities.Ground;
package Functions
  extends Modelica.Icons.FunctionsPackage;
  function findPositionInMesh
    "Returns element indices which is equal or larger to defined input"
   extends Modelica.Icons.Function;
   input Real mesh[:];
   input Real position;
   output Integer positionIndex;
  algorithm
    for z in 1:size(mesh,1) loop
     if mesh[z]>=position then
      positionIndex:=z;
      break;
     end if;
    end for;
  end findPositionInMesh;
end Functions;
