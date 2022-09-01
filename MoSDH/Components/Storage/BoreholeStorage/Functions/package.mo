within MoSDH.Components.Storage.BoreholeStorage;
package Functions "builder functions"
 function BHE_HeadElementIndex "vector containing indices of outlet BHEs"
  extends Modelica.Icons.Function;
  input Real meshZ[:];
  input Real bheStart;
  output Integer bheHeadElementIndex;
 algorithm
   for z in 1:size(meshZ,1) loop
    if meshZ[z]>bheStart then
     bheHeadElementIndex:=z-1;
     break;
    end if;
   end for;
  annotation(Documentation(info="<html>
<h4>
<strong>Syntax</strong>
</h4>
<p>
BHE_HeadElementIndex(meshZ,BHEstart) 
</p>
<h4>
<strong>Description</strong>
</h4>
<p>
Returns the vertical index of the global model elements that contain BHE heads.
</p>
<h4>
<strong>Input arguments</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Real[:]</strong>	vertical model discretization</li>
<li><strong style=\"color:red\">Real</strong>	depth of BHE heads</li>
</ul>
<h4>
<strong>Outputs</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Integer</strong>	vertical index of BHE head elements</li>
</ul>
</html>"));
 end BHE_HeadElementIndex;

 function BHE_BottomElementIndex "vector containing indices of outlet BHEs"
  extends Modelica.Icons.Function;
  input Real meshZ[:];
  input Real bheStart;
  input Real bheLength;
  output Integer bheBottomElementIndex;
 algorithm
   for z in 1:size(meshZ,1) loop
    if meshZ[z]>bheStart+bheLength then
     bheBottomElementIndex:=z-2;
     break;
    end if;
   end for;
  annotation(Documentation(info="<html>
<h4>
<strong>Syntax</strong>
</h4>
<p>
BHE_BottomElementIndex(meshZ,BHEstart,BHElength) 
</p>
<h4>
<strong>Description</strong>
</h4>
<p>
Returns the vertical index of the global model elements that contain BHE bottom
</p>
<h4>
<strong>Input arguments</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Real[:]</strong>	vertical model discretization [m]</li>
<li><strong style=\"color:red\">Real</strong>	depth of BHE heads [m]</li>
<li><strong style=\"color:red\">Real</strong>	length of BHEs [m]</li>
</ul>
<h4>
<strong>Outputs</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Integer</strong>	vertical index of BHE bottom elements</li>
</ul>
</html>"));
 end BHE_BottomElementIndex;

 function ElementHeights "function for the vertical model discretization"
  extends Modelica.Icons.Function;
  input Real supermesh[:];
  input Integer nx "axial refinement parameter - choose between 3-6";
  input Real dZmin "desired smallest vertical discretization";
  input Real growthFactor;
  input Integer outputSize;
  output Real heightVector[outputSize] "number of elements for axial refinement";
protected
   Real deltaSupermesh[size(supermesh,1)-1] "vector conatining max depth of each layer";
   Integer cutNelements "counter for how many elements should be cut at the end";
   Real deltaZmin "minimum axial element size";
   Real nxActual[:] "number of elements for each half deltaSupermesh";
   Real usedSpace "dummyvariable for the spce already filled in a segment";
   Integer numberOfElements "counts the number of elements";
 algorithm
    for iDummy in 1:1 loop //necessary to force GSA to execute whole function

   /* delta supermesh of interest----------------------------------------------------------------------------*/

     deltaSupermesh:={supermesh[2]-supermesh[1]};
     for i in 2:(size(supermesh,1)-1) loop
      deltaSupermesh:=cat(1,deltaSupermesh,{supermesh[i+1]-supermesh[i]});
     end for;
      deltaSupermesh[size(supermesh,1)-1]:=2*deltaSupermesh[size(supermesh,1)-1];
     /* calculation of the element heights----------------------------------------------------------------------------*/
     //initialize
       heightVector:={0.0};
       numberOfElements:=1; //iterator for the element number offset of each segment
       /*determine deltaZmin by considering regular discretiation of the biggest segment or take the smallest segment as deltaZmin if this is smaller*/
       deltaZmin:=min(min(min(deltaSupermesh),max(deltaSupermesh)/2*(growthFactor-1)/(growthFactor^nx-1)),dZmin);
       nxActual:=fill(0,size(deltaSupermesh,1));

       /* seperate discretization for each segment*/
       for i_segment in 1:size(deltaSupermesh,1) loop
       cutNelements:=0;

       /*determine for every segment how much elements fit into it without rounding*/
         nxActual[i_segment]:=log((2*deltaZmin-deltaSupermesh[i_segment]+growthFactor*deltaSupermesh[i_segment])/(2*deltaZmin))/log(growthFactor);
        /*segment size below 2 times deltazMin */
        if deltaSupermesh[i_segment]<=growthFactor*deltaZmin then
         heightVector:=cat(1,heightVector,{deltaSupermesh[i_segment]});
         numberOfElements:=numberOfElements+1;

        /* segment can be discretized by regular scheme without rest*/
        elseif  integer(nxActual[i_segment])==nxActual[i_segment] then //check weither segment can be discretized by "regular" scheme

         for i_element in 0:(integer(nxActual[i_segment])-1) loop
          heightVector:=cat(1,heightVector,{deltaZmin*growthFactor^i_element});
          numberOfElements:=numberOfElements+1;
         end for;
         for i_element in 0:(integer(nxActual[i_segment])-1) loop
          heightVector:=cat(1,heightVector,{deltaZmin*growthFactor^(integer(nxActual[i_segment])-1-i_element)});
          numberOfElements:=numberOfElements+1;
          cutNelements:=cutNelements+1;
         end for;

        else

         usedSpace:=0;  //space already used in the current segment
        /*regular scheme first half with elements from deltaZmin to deltaZmax*/
         for i_element in 0:(integer(nxActual[i_segment])-1) loop
          heightVector:=cat(1,heightVector,{deltaZmin*growthFactor^i_element});
          usedSpace:=usedSpace+deltaZmin*growthFactor^i_element;
          numberOfElements:=numberOfElements+1;


         end for;
        /*middle elements*/
        /*remaining rest of the regular scheme will be a) added to the biggest elements b) covered by one extra element or c) two elements*/
         /*a) rest is smaller than deltaZmax/growthFactor*/
         if deltaSupermesh[i_segment]-2*usedSpace < deltaZmin*growthFactor^(integer(nxActual[i_segment])-2) then

          heightVector[numberOfElements]:=heightVector[numberOfElements]+deltaSupermesh[i_segment]/2-usedSpace;
          heightVector:=cat(1,heightVector,{heightVector[numberOfElements]});
          numberOfElements:=numberOfElements+1;
          cutNelements:=cutNelements+1;
         /*b) rest is smaller than deltaZmax*growthFactor and put into one extra element*/
         elseif deltaSupermesh[i_segment]-2*usedSpace < deltaZmin*growthFactor^(integer(nxActual[i_segment])) and i_segment<size(deltaSupermesh,1) then

          heightVector:=cat(1,heightVector,{deltaSupermesh[i_segment]-2*usedSpace});
          numberOfElements:=numberOfElements+1;
          heightVector:=cat(1,heightVector,{deltaZmin*growthFactor^(integer(nxActual[i_segment])-1)});
          numberOfElements:=numberOfElements+1;
         /*c) rest is put into two segments*/
         else

          heightVector:=cat(1,heightVector,{deltaSupermesh[i_segment]/2-usedSpace});
          numberOfElements:=numberOfElements+1;
          heightVector:=cat(1,heightVector,{deltaSupermesh[i_segment]/2-usedSpace});
          numberOfElements:=numberOfElements+1;
          cutNelements:=cutNelements+1;
          heightVector:=cat(1,heightVector,{deltaZmin*growthFactor^(integer(nxActual[i_segment])-1)});
          numberOfElements:=numberOfElements+1;
          cutNelements:=cutNelements+1;

         end if;
         /*second part of the reggular scheme, starting with second biggest element, since biggest has been added in the part above*/
         if integer(nxActual[i_segment])>=2 then
          for i_element in 1:(integer(nxActual[i_segment])-1) loop
           heightVector:=cat(1,heightVector,{deltaZmin*growthFactor^(integer(nxActual[i_segment])-1-i_element)});
           numberOfElements:=numberOfElements+1;
           cutNelements:=cutNelements+1;

          end for;
         end if;
        end if;

       if i_segment == size(deltaSupermesh,1) then
        heightVector:={heightVector[k] for k in 2:(size(heightVector,1)-cutNelements)};

       end if;
       end for;

       end for;
  annotation(Documentation(info="<html>
<h4>
<strong>Syntax</strong>
</h4>
<p>
ElementHeights(supermesh,nx,dZmin,growthFactor,outputSize) 
</p>
<h4>
<strong>Description</strong>
</h4>
<p>
Returns an array with the heights of the global model elements from top to bottom
</p>
<h4>
<strong>Input arguments</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Real[:]</strong> supermesh	<i style=\"color:brown\">vertical supermesh (boundary mesh) [m]</i></li>
<li><strong style=\"color:red\">Integer</strong> nx	<i style=\"color:brown\">discretiaztion factor</i></li>
<li><strong style=\"color:red\">Real</strong> dZmin	<i style=\"color:brown\">desired size of smallest element [m]</i></li>
<li><strong style=\"color:red\">Real</strong> growthFactor	<i style=\"color:brown\">relative size difference between adjoining elements</i></li>
<li><strong style=\"color:red\">Integer</strong> outputSize	<i style=\"color:brown\">dimension of the output array/ number of vertical elements </i></li>
</ul>
<h4>
<strong>Outputs</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Real[:]</strong> heightVector	<i style=\"color:brown\">vertical model discretization [m]</i></li>
</ul>
</html>"));
 end ElementHeights;

 function ElementGroundData "determine type of ground for each element"
  extends Modelica.Icons.Function;
  input Real heightVector[:] "vector containing element heights";
  input Integer rings "how many rings";
  replaceable input MoSDH.Parameters.Locations.SingleLayerLocation location constrainedby
    MoSDH.Parameters.Locations.LocationPartial                                                                                       "stratigraphy at location" annotation(choicesAllMatching=true);
  output Real elementGroundDataMatrix[3,size(heightVector,1),rings] "=fill(Parameters.Soils.Soil(),size(heightVector,1),rings) vector containing Cp vor each element";
protected
   Real cumStratDepth[location.layers] "vector containing absolute depths of ground layers";
   Real elementTotalDepth "utility parameter to store end depth of element";
   Real rhoMatrix[size(heightVector,1),rings];
   Real cpMatrix[size(heightVector,1),rings];
   Real lamdaMatrix[size(heightVector,1),rings];
 algorithm
   //create vector with layer depths
   for z in 1:location.layers-1 loop
     cumStratDepth[z] := sum(location.layerThicknessVector[i] for i in 1:z);
   end for;
   cumStratDepth[location.layers]:= sum(heightVector[i] for i in 1:size(heightVector,1));
   //assign ground properties to element
   for z in 1:size(heightVector, 1) loop
     elementTotalDepth := sum(heightVector[i] for i in 1:z);
     for layerIndex in 1:location.layers loop
       if elementTotalDepth <= cumStratDepth[location.layers - layerIndex + 1] then
         for r in 1:rings loop
           rhoMatrix[z, r] := location.rhoVector[location.layers - layerIndex + 1];
           cpMatrix[z, r] := location.cpVector[location.layers - layerIndex + 1];
           lamdaMatrix[z, r] := location.lamdaVector[location.layers - layerIndex + 1];
         end for;
       else
         break;
       end if;
     end for;
   end for;
   elementGroundDataMatrix := {rhoMatrix, cpMatrix, lamdaMatrix};
  annotation(Documentation(info="<html>
<h4>
<strong>Syntax</strong>
</h4>
<p>
elementGroundDataMatrix:=ElementGroundData(heightVector,rings,dZmin,growthFactor,outputSize) 
</p>
<h4>
<strong>Description</strong>
</h4>
<p>
Returns a matrix {rho[nZ,nR],cP[nZ,nR],lamda[nZ,nR]} which contains the thermphyiscal parameters of the model elements, where nZ is the vertical number of model elements and nR is the radial number.
</p>
<h4>
<strong>Input arguments</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Real[:]</strong> heightVector	<i style=\"color:brown\">vertical discretization [m]</i></li>
<li><strong style=\"color:red\">Integer</strong> rings	<i style=\"color:brown\">number of radial elements</i></li>
<li><strong style=\"color:red\">MoSDH.Parameters.Locations.locationPartial</strong> location <i style=\"color:brown\">record with depths and themrophysical properties at the storage site</i></li>
</ul>
<h4>
<strong>Outputs</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Real[3,:,:]</strong> elementGroundDataMatrix	<i style=\"color:brown\">matrix with thermophysical model element properties</i></li>
</ul>
</html>"));
 end ElementGroundData;

 function MeshR "vector with all inner radii"
  extends Modelica.Icons.Function;
  input Integer nBHEsPerRing[:] "number of rings containing BHEs";
  input Real referenceRadius "minimum radial difference";
  input Integer nElementsR "refinement parameter - 3:min refined/6:max refined";
  output Real radiiVector[nElementsR+1] "vector containing mesh radii for the global solution";
 algorithm
   for doAllThis in 1:1 loop
    radiiVector[1]:=0.0;
    for r in 1:nElementsR loop
     if r<=size(nBHEsPerRing,1) then
      radiiVector[r+1]:=referenceRadius*sqrt(sum(nBHEsPerRing[i] for i in 1:r));
     elseif r<=size(nBHEsPerRing,1)+3 then
      radiiVector[r+1]:=radiiVector[r]+(radiiVector[r]-radiiVector[r-1]);
     else
      radiiVector[r+1]:=radiiVector[r]+(radiiVector[r]-radiiVector[r-1])*sqrt(2);
     end if;
    end for;
   end for;
  annotation(Documentation(info="<html>
<h4>
<strong>Syntax</strong>
</h4>
<p>
radiiVector:=MeshR(nBHEsPerRing,referenceRadius,nElementsR) 
</p>
<h4>
<strong>Description</strong>
</h4>
<p>
Returns an array with the radial mesh of the model.
</p>
<h4>
<strong>Input arguments</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Integer[:]</strong> nBHEsPerRing	<i style=\"color:brown\">Array with the number of BHEs inside the model rings which do contain BHEs</i></li>
<li><strong style=\"color:red\">Real</strong> referenceRadius	<i style=\"color:brown\">Radius of the local model (resulting in an equal area/BHE as the actual rectangular/cylindircal/hexagonal layout</i></li>
<li><strong style=\"color:red\">Integer</strong> nElementsR <i style=\"color:brown\">Total number of radial elements</i></li>
</ul>
<h4>
<strong>Outputs</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Real[:]</strong> radiiVector	<i style=\"color:brown\">Radial mesh</i></li>
</ul>
</html>"));
 end MeshR;

 function nElementsZ "function for the number of vertical model elements"
  extends Modelica.Icons.Function;
  input Real supermesh[:];
  input Integer nx "axial refinement parameter - choose between 3-6";
  input Real dZmin "desired smallest element height";
  input Real growthFactor;
  output Integer noe;
protected
   Real heightVector[:] "number of elements for axial refinement";
   Real deltaSupermesh[size(supermesh,1)-1] "vector conatining max depth of each layer";
   Integer cutNelements "counter for how many elements should be cut at the end";
   Real deltaZmin "minimum axial element size";
   Real nxActual[:] "number of elements for each half deltaSupermesh";
   Real usedSpace "dummyvariable for the spce already filled in a segment";
   Integer numberOfElements "counts the number of elements";
 algorithm
    for iDummy in 1:1 loop //necessary to force GSA to execute whole function

   /* delta supermesh of interest----------------------------------------------------------------------------*/

     deltaSupermesh:={supermesh[2]-supermesh[1]};
     for i in 2:(size(supermesh,1)-1) loop
      deltaSupermesh:=cat(1,deltaSupermesh,{supermesh[i+1]-supermesh[i]});
     end for;
      deltaSupermesh[size(supermesh,1)-1]:=2*deltaSupermesh[size(supermesh,1)-1];

     /*D) calculation of the element heights----------------------------------------------------------------------------*/
     //initialize
       numberOfElements:=0; //iterator for the element number offset of each segment
       /*determine deltaZmin by considering regular discretiation of the biggest segment or take the smallest segment as deltaZmin if this is smaller*/
       deltaZmin:=min(min(min(deltaSupermesh),max(deltaSupermesh)/2*(growthFactor-1)/(growthFactor^nx-1)),dZmin);
       nxActual:=fill(0,size(deltaSupermesh,1));
       heightVector:={0.0};

       /* seperate discretization for each supermesh segment*/
       for i_segment in 1:size(deltaSupermesh,1) loop
       cutNelements:=0;

       /*determine for every segment how much elements fit into it without rounding*/
         nxActual[i_segment]:=log((2*deltaZmin-deltaSupermesh[i_segment]+growthFactor*deltaSupermesh[i_segment])/(2*deltaZmin))/log(growthFactor);
        /*segment size below 2 times deltazMin */
        if deltaSupermesh[i_segment]<=growthFactor*deltaZmin then
         heightVector:=cat(1,heightVector,{deltaSupermesh[i_segment]});
         numberOfElements:=numberOfElements+1;

        /* segment can be discretized by regular scheme without rest*/
        elseif  integer(nxActual[i_segment])==nxActual[i_segment] then //check weither segment can be discretized by "regular" scheme
         for i_element in 0:(integer(nxActual[i_segment])-1) loop
          heightVector:=cat(1,heightVector,{deltaZmin*growthFactor^i_element});
          numberOfElements:=numberOfElements+1;
         end for;
         for i_element in 0:(integer(nxActual[i_segment])-1) loop
          heightVector:=cat(1,heightVector,{deltaZmin*growthFactor^(integer(nxActual[i_segment])-1-i_element)});
          numberOfElements:=numberOfElements+1;
          cutNelements:=cutNelements+1;
         end for;

        else
         usedSpace:=0;
        /*regular scheme first half with elements from deltaZmin to deltaZmax*/
         for i_element in 0:(integer(nxActual[i_segment])-1) loop
          heightVector:=cat(1,heightVector,{deltaZmin*growthFactor^i_element});
          usedSpace:=usedSpace+deltaZmin*growthFactor^i_element;
          numberOfElements:=numberOfElements+1;
         end for;
        /*middle elements*/
        /*remaining rest of the regular scheme will be a) added to the biggest elements b) covered by one extra element or c) two elements*/
         /*a) rest is smaller than deltaZmax/growthFactor*/
         if deltaSupermesh[i_segment]-2*usedSpace < deltaZmin*growthFactor^(integer(nxActual[i_segment])-2) then
          heightVector[numberOfElements]:=heightVector[numberOfElements]+deltaSupermesh[i_segment]/2-usedSpace;
          heightVector:=cat(1,heightVector,{heightVector[numberOfElements]+deltaSupermesh[i_segment]/2-usedSpace});
          numberOfElements:=numberOfElements+1;
          cutNelements:=cutNelements+1;
         /*b) rest is smaller than deltaZmax*growthFactor and put into one extra element*/
         elseif deltaSupermesh[i_segment]-2*usedSpace < deltaZmin*growthFactor^(integer(nxActual[i_segment])) and i_segment<size(deltaSupermesh,1) then
          heightVector:=cat(1,heightVector,{deltaSupermesh[i_segment]-2*usedSpace});
          numberOfElements:=numberOfElements+1;
          heightVector:=cat(1,heightVector,{deltaZmin*growthFactor^(integer(nxActual[i_segment])-1)});
          numberOfElements:=numberOfElements+1;
         /*c) rest is put into two segments*/
         else
          heightVector:=cat(1,heightVector,{deltaSupermesh[i_segment]/2-usedSpace});
          numberOfElements:=numberOfElements+1;
          heightVector:=cat(1,heightVector,{deltaSupermesh[i_segment]/2-usedSpace});
          numberOfElements:=numberOfElements+1;
          cutNelements:=cutNelements+1;
          heightVector:=cat(1,heightVector,{deltaZmin*growthFactor^(integer(nxActual[i_segment])-1)});
          numberOfElements:=numberOfElements+1;
          cutNelements:=cutNelements+1;
         end if;
         /*second part of the reggular scheme, starting with second biggest element, since biggest has been added in the part above*/
         if integer(nxActual[i_segment])>=2 then
          for i_element in 1:(integer(nxActual[i_segment])-1) loop
           heightVector:=cat(1,heightVector,{deltaZmin*growthFactor^(integer(nxActual[i_segment])-1-i_element)});
           numberOfElements:=numberOfElements+1;
           cutNelements:=cutNelements+1;
          end for;
         end if;
        end if;
       if i_segment == size(deltaSupermesh,1) then
        heightVector:={heightVector[k] for k in 2:(size(heightVector,1)-cutNelements)};
       end if;
       end for;
       noe:=size(heightVector,1);
       end for;
  annotation(Documentation(info="<html>
<h4>
<strong>Syntax</strong>
</h4>
<p>
outputSize:=nElementsZ(supermesh,nx,dZmin,growthFactor) 
</p>
<h4>
<strong>Description</strong>
</h4>
<p>
Returns the number of vertical elements of the global model's mesh. This is used as input for the actual meshing function and is a workaround for function handling of arrays with variable size. The function body is equal to the body of the function <a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.Functions.ElementHeights\">ElementHeights</a>.
<h4>
<strong>Input arguments</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Real[:]</strong> supermesh	<i style=\"color:brown\">vertical supermesh (boundary mesh) [m]</i></li>
<li><strong style=\"color:red\">Integer</strong> nx	<i style=\"color:brown\">discretiaztion factor</i></li>
<li><strong style=\"color:red\">Real</strong> dZmin	<i style=\"color:brown\">desired size of smallest element [m]</i></li>
<li><strong style=\"color:red\">Real</strong> growthFactor	<i style=\"color:brown\">relative size difference between adjoining elements</i></li>

</ul>
<h4>
<strong>Outputs</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Integer</strong> outputSize	<i style=\"color:brown\">dimension of the output array/ number of vertical elements </i></li>
</ul>
</html>"));
 end nElementsZ;

 function NumberOfBHErings "determines how many rings with BHEs are used"
  extends Modelica.Icons.Function;
  input Integer nBHEs "ring number";
  output Integer nRings "number of BHEs in ring";
protected
   Integer iRing;
   Integer nBHEsUsed;
 algorithm
   if nBHEs <=3 then
    nRings:=1;
   else
    iRing:=1;
    nBHEsUsed:=1;
    while nBHEsUsed<nBHEs loop
     iRing:=iRing+1;
     nBHEsUsed:=nBHEsUsed+integer(2*Modelica.Constants.pi*(iRing-1));
    end while;
    nRings:=iRing;
   end if;
  annotation(Documentation(info="<html>
<h4>
<strong>Syntax</strong>
</h4>
<p>
nRings:=NumberOfBHErings(nBHEs) 
</p>
<h4>
<strong>Description</strong>
</h4>
<p>
Returns the number of BHE rings the model uses. For each ring only one characteristic BHE is simulated. This function is only used for parallel BHE connection.
</p>
<h4>
<strong>Input arguments</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Integer</strong> nBHEs	<i style=\"color:brown\">Total number of BHEs</i></li>
</ul>
<h4>
<strong>Outputs</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Integer</strong> nRings	<i style=\"color:brown\">Number of rings that contain BHEs</i></li>
</ul>
</html>"));
 end NumberOfBHErings;

 function NumberOfBHEsPerRing "determines number of BHEs in ring"
  extends Modelica.Icons.Function;
  input Integer nBHEs "number of BHEs";
  input Integer nRings "number of rings to assign the BHEs to";
  output Integer BHEsPerRingVector[nRings] "vector containing the number of BHEs for each ring";
protected
   Real hypotheticalRadii[nRings];
   Integer positionOfSmallestElement;
 algorithm
   for DoAllThis in 1:1 loop
    BHEsPerRingVector:=fill(1,nRings); //start with one BHE in each ring
    /*distribute BHEs to the rings until all BHEs are added*/
    while sum(BHEsPerRingVector[i] for i in 1:nRings)<nBHEs loop
     /*hypothetically add one BHE to each ring and see how the radius would change*/
     hypotheticalRadii[1]:=sqrt(BHEsPerRingVector[1]+1);
     for iRad in 2:nRings loop
      hypotheticalRadii[iRad]:= sqrt(sum(BHEsPerRingVector[i] for i in 1:iRad)+1)-sqrt(sum(BHEsPerRingVector[i] for i in 1:(iRad-1)));
     end for;
     /*find the position of the smallest element*/
     for el in 1:nRings loop
      if hypotheticalRadii[el]<=min(hypotheticalRadii) then
       positionOfSmallestElement:=el;
       break;
      end if;
     end for;
     /*add one BHE to the identified ring*/
     BHEsPerRingVector[positionOfSmallestElement]:=BHEsPerRingVector[positionOfSmallestElement]+1;
    end while;
   end for;
  annotation(Documentation(info="<html>
<h4>
<strong>Syntax</strong>
</h4>
<p>
BHEsPerRingVector:=NumberOfBHEsPerRing(nBHEs,nRings) 
</p>
<h4>
<strong>Description</strong>
</h4>
<p>
Distributes a given number of BHEs to a given number of model rings/regions. The algorith tries to generate a distribution with rings of equal thickness.
</p>
<h4>
<strong>Input arguments</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Integer</strong> nBHEs	<i style=\"color:brown\">Total number of BHEs</i></li>
<li><strong style=\"color:red\">Integer</strong> nRings	<i style=\"color:brown\">Number of rings to distribute the BHEs to.</i></li>
</ul>
<h4>
<strong>Outputs</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Integer[:]</strong> BHEsPerRingVector	<i style=\"color:brown\">Array with the number of BHEs for each ring.</i></li>
</ul>
</html>"));
 end NumberOfBHEsPerRing;

 function SupermeshZ "determines points of interest in depth (supermesh)"
  extends Modelica.Icons.Function;
  input Real BHEstart "depth of BHE head";
  input Boolean useUpperGroutSection;
  input Real lengthUpperGroutSection;
  input Real BHELength "length of the bhe";
  input Real relativeModelDepth "model depth in relation to bhe bottom";
  input Real stratVector[:];
  output Real supermesh[:];
protected
   Real pointsOfInterest[:] "vector containing the heights of the layer";
   Real BHEbottom=BHEstart+BHELength "depth of BHE bottom";
   Real groutChange=BHEstart+lengthUpperGroutSection;
   Integer indexMax "indexMax for determination vector length";
 algorithm
   //load depth of layer starts

     if size(stratVector,1)>1 then
      pointsOfInterest:=cat(1,{0},{sum(stratVector[j] for j in 1:i) for i in 1:(size(stratVector,1)-1)}); //prepend ground surface and delete end of stratigraphy
     else
      pointsOfInterest:={0};
     end if;

     //insert BHEstart into vector
     for i in 1:size(stratVector,1) loop //search through vector
      if pointsOfInterest[i]==BHEstart then //if BHEstart falls on a layerchange no additional entry is necessary
      break;
      elseif pointsOfInterest[i]>BHEstart then //if the vector entry is lager, BHEstart is inserted before the entry
      pointsOfInterest:=cat(1,{pointsOfInterest[j] for j in 1:i-1},{BHEstart},{pointsOfInterest[k] for k in i:size(stratVector,1)});
      break;
      elseif i==size(stratVector,1) then  //if no layerchange is bigger than BHEstart, BHEstart is appended
      pointsOfInterest:=cat(1,{pointsOfInterest[i] for i in 1:size(stratVector,1)},{BHEstart});
      end if;
     end for;

     //insert groutChange into vector
    if useUpperGroutSection then
     indexMax:=size(pointsOfInterest,1);
     for i in 1:indexMax loop //search through vector
      if pointsOfInterest[i]==groutChange then //if groutChange falls on a layerchange no additional entry is necessary
      break;
      elseif pointsOfInterest[i]>groutChange then //if vector entry i is larger, groutChange is inserted before the entry
      pointsOfInterest:=cat(1,{pointsOfInterest[j] for j in 1:i-1},{groutChange},{pointsOfInterest[k] for k in i:indexMax});
      break;
      elseif i==indexMax then  //if no layerchange is bigger than groutChange, groutChange is appended
      pointsOfInterest:=cat(1,pointsOfInterest,{groutChange});
      end if;
     end for;
    end if;

     //insert BHEbottom into vector
     indexMax:=size(pointsOfInterest,1);
     for i in 1:indexMax loop //search through vector
      if pointsOfInterest[i]==BHEbottom then //if BHEbottom falls on a layerchange no additional entry is necessary
      break;
      elseif pointsOfInterest[i]>BHEbottom then //if vector entry i is larger, BHEbottom is inserted before the entry
      pointsOfInterest:=cat(1,{pointsOfInterest[j] for j in 1:i-1},{BHEbottom},{pointsOfInterest[k] for k in i:indexMax});
      break;
      elseif i==indexMax then  //if no layerchange is bigger than BHEbottom, BHEbottom is appended
      pointsOfInterest:=cat(1,pointsOfInterest,{BHEbottom});
      end if;
     end for;

     //insert model bottom and determine size of chopped of part

      indexMax:=size(pointsOfInterest,1);
      for i in 1:indexMax loop //search through vector
       if pointsOfInterest[i]==(BHEbottom*relativeModelDepth) then //if model bottom falls on a layerchange no additional entry is necessary
        indexMax:=i;
        break;
       elseif pointsOfInterest[i]>(BHEbottom*relativeModelDepth) then //if the vector entry is larger, model bottom is inserted before the entry
        pointsOfInterest:=cat(1,{pointsOfInterest[j] for j in 1:i-1},{(BHEbottom*relativeModelDepth)},{pointsOfInterest[k] for k in i:indexMax});
        indexMax:=i;
        break;
       elseif i==indexMax then  //if no layerchange is bigger than model bottom, model bottom is appended
        pointsOfInterest:=cat(1,{pointsOfInterest[i] for i in 1:indexMax},{(BHEbottom*relativeModelDepth)});
        indexMax:=indexMax+1;
       end if;
      end for;

     supermesh:={pointsOfInterest[i] for i in 1:indexMax};
  annotation(Documentation(info="<html>
<h4>
<strong>Syntax</strong>
</h4>
<p>
supermesh:=SupermeshZ(BHEstart,BHELength,relativeModelDepth,stratVector) 
</p>
<h4>
<strong>Description</strong>
</h4>
<p>
Returns the supermesh for the vertical model discretization. The supermesh (boundary mesh) comprises all \"depths of interest\", i.e. changes in the model's parameters or geometry.
</p>
<h4>
<strong>Input arguments</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Real</strong> BHEstart	<i style=\"color:brown\">Depth of BHE heads [m]</i></li>
<li><strong style=\"color:red\">Real</strong> BHELength	<i style=\"color:brown\">Length of BHEs [m]</i></li>
<li><strong style=\"color:red\">Real</strong> relativeModelDepth	<i style=\"color:brown\">Desired depth of the model in relation to the borehole bottom.</i></li>
<li><strong style=\"color:red\">Real[:]</strong> stratVector	<i style=\"color:brown\">Array with thicknesses of all geological layers [m]</i></li>
</ul>
<h4>
<strong>Outputs</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Real[:]</strong> supermesh	<i style=\"color:brown\">Array with vertical model sections with constant parameters.</i></li>
</ul>
</html>"));
 end SupermeshZ;

 function xGroutCenter_2U "determine grout center for double-U BHE"
  extends Modelica.Icons.Function;
  input MoSDH.Parameters.BoreholeHeatExchangers.DoubleU_DN32 bheData=MoSDH.Parameters.BoreholeHeatExchangers.DoubleU_DN32() "number of rings containing BHEs";
  input MoSDH.Parameters.Grouts.Grout10 groutData=MoSDH.Parameters.Grouts.Grout10();
  output Real xGroutCenter "Relative position of grout mass center.";
protected
   Real xGuess=log(sqrt(bheData.dBorehole^2+4*bheData.dPipe1^2)/(2*sqrt(2)*bheData.dPipe1))/log(bheData.dBorehole/(2*bheData.dPipe1));
   Real R_grout_spec=Modelica.Math.acosh((bheData.dBorehole^2+bheData.dPipe1^2-bheData.spacing^2)/(2*bheData.dBorehole*bheData.dPipe1))/(2*Modelica.Constants.pi*groutData.lamda)*(3.098-4.432*bheData.spacing/bheData.dBorehole+2.364*bheData.spacing^2/bheData.dBorehole^2);
   Real R_pipeToPipe_spec=Modelica.Math.acosh((bheData.spacing^2-bheData.dPipe1^2)/(bheData.dPipe1^2))/(2*Modelica.Constants.pi*groutData.lamda);
   Real R_groutToWall=(1-xGuess)*R_grout_spec;
   Real R_groutToGrout=(2*(1-xGuess)*R_grout_spec*(R_pipeToPipe_spec-2*xGuess*R_grout_spec))/(2*(1-xGuess)*R_grout_spec-R_pipeToPipe_spec+2*xGuess*R_grout_spec);
 algorithm
   xGuess:=log(sqrt(bheData.dBorehole^2+4*bheData.dPipe1^2)/(2*sqrt(2)*bheData.dPipe1))/log(bheData.dBorehole/(2*bheData.dPipe1));
   R_grout_spec:=Modelica.Math.acosh((bheData.dBorehole^2+bheData.dPipe1^2-bheData.spacing^2)/(2*bheData.dBorehole*bheData.dPipe1))/(2*Modelica.Constants.pi*groutData.lamda)*(3.098-4.432*bheData.spacing/bheData.dBorehole+2.364*bheData.spacing^2/bheData.dBorehole^2);
   R_pipeToPipe_spec:=Modelica.Math.acosh((bheData.spacing^2-bheData.dPipe1^2)/(bheData.dPipe1^2))/(2*Modelica.Constants.pi*groutData.lamda);
   R_groutToWall:=(1-xGuess)*R_grout_spec;
   R_groutToGrout:=(2*(1-xGuess)*R_grout_spec*(R_pipeToPipe_spec-2*xGuess*R_grout_spec))/(2*(1-xGuess)*R_grout_spec-R_pipeToPipe_spec+2*xGuess*R_grout_spec);
   while ((1/R_groutToGrout+0.5/R_groutToWall)^(-1) < 0) and
                                                            xGuess <0.99 loop
    xGuess:=if 1/R_groutToGrout > 0.5/R_groutToWall then min(0.99,xGuess+0.05) else max(0.01,xGuess-0.05);
    R_groutToWall:=(1-xGuess)*R_grout_spec;
    R_groutToGrout:=(2*(1-xGuess)*R_grout_spec*(R_pipeToPipe_spec-2*xGuess*R_grout_spec))/(2*(1-xGuess)*R_grout_spec-R_pipeToPipe_spec+2*xGuess*R_grout_spec);
   end while;
   xGroutCenter:=xGuess;
  annotation(Documentation(info="<html>
<h4>
<strong>Syntax</strong>
</h4>
<p>
xGroutCenter:=xGroutCenter_2U(bheData,groutData) 
</p>
<h4>
<strong>Description</strong>
</h4>
<p>
Returns the relative position of the center of mass for the grout sections for double-U BHEs. The algorithm ensures that the thermal resistance between the grout sections is positive (see Bauer 2011: Zur thermischen Modellierung von ErdwÃ¤rmesonden und Erdsonden-WÃ¤rmespeichern). If the position of the grout is adjusted, a warning is given.
</p>
<h4>
<strong>Input arguments</strong>
</h4>
<ul>
<li><strong style=\"color:red\">MoSDH.Parameters.BoreholeHeatExchangers.BHEparameters</strong> bheData	<i style=\"color:brown\">BHE dataset</i></li>
<li><strong style=\"color:red\">MoSDH.Parameters.Grouts.GroutPartial</strong> groutData	<i style=\"color:brown\">Grout dataset</i></li>
</ul>
<h4>
<strong>Outputs</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Real</strong> xGroutCenter	<i style=\"color:brown\">Relative position of the grout's center of mass (0 < x < 1). </i></li>
</ul>
</html>"));
 end xGroutCenter_2U;

 function xGroutCenter_1U "determine grout center for single-U BHE"
  extends Modelica.Icons.Function;
  input MoSDH.Parameters.BoreholeHeatExchangers.SingleU_DN32 bheData=MoSDH.Parameters.BoreholeHeatExchangers.SingleU_DN32() "number of rings containing BHEs";
  input MoSDH.Parameters.Grouts.Grout10 groutData=MoSDH.Parameters.Grouts.Grout10();
  output Real xGroutCenter "Relative position of grout mass center.";
protected
   Real xGuess=log(sqrt(bheData.dBorehole^2+2*bheData.dPipe1^2)/(2*bheData.dPipe1))/log(bheData.dBorehole/(sqrt(2)*bheData.dPipe1)) "auxillary variable for grout centre of mass";
   Real R_grout_spec=Modelica.Math.acosh((bheData.dBorehole^2+bheData.dPipe1^2-bheData.spacing^2)/(2*bheData.dBorehole*bheData.dPipe1))/(2*Modelica.Constants.pi*groutData.lamda)*(1.601-0.888*bheData.spacing/bheData.dBorehole);
   Real R_pipeToPipe_spec=Modelica.Math.acosh((2*bheData.spacing^2-bheData.dPipe1^2)/(bheData.dPipe1^2))/(2*Modelica.Constants.pi*groutData.lamda);
   Real R_groutToWall=(1-xGuess)*R_grout_spec;
   Real R_groutToGrout=((2*(1-xGuess)*R_grout_spec*(R_pipeToPipe_spec-2*xGuess*R_grout_spec))/(2*(1-xGuess)*R_grout_spec-R_pipeToPipe_spec+2*xGuess*R_grout_spec));
   Boolean changeFlag=false "=true, if xGrout is adapted";
 algorithm
   xGuess:=log(sqrt(bheData.dBorehole^2+4*bheData.dPipe1^2)/(2*sqrt(2)*bheData.dPipe1))/log(bheData.dBorehole/(2*bheData.dPipe1));
   R_grout_spec:=Modelica.Math.acosh((bheData.dBorehole^2+bheData.dPipe1^2-bheData.spacing^2)/(2*bheData.dBorehole*bheData.dPipe1))/(2*Modelica.Constants.pi*groutData.lamda)*(1.601-0.888*bheData.spacing/bheData.dBorehole);
   R_pipeToPipe_spec:=Modelica.Math.acosh((2*bheData.spacing^2-bheData.dPipe1^2)/(bheData.dPipe1^2))/(2*Modelica.Constants.pi*groutData.lamda);
   R_groutToWall:=(1-xGuess)*R_grout_spec;
   R_groutToGrout:=((2*(1-xGuess)*R_grout_spec*(R_pipeToPipe_spec-2*xGuess*R_grout_spec))/(2*(1-xGuess)*R_grout_spec-R_pipeToPipe_spec+2*xGuess*R_grout_spec));
   if ((1/R_groutToGrout+0.5/R_groutToWall)^(-1) < 0) then
    Modelica.Utilities.Streams.print("BHE pipes too close to borehole wall for model --> autoadjustement:\n original xGroutCenter: "+String(xGuess),"");
    changeFlag:=true;
   end if;
   while ((1/R_groutToGrout+0.5/R_groutToWall)^(-1) < 0) and
                                                            xGuess <0.99 loop
    xGuess:=if 1/R_groutToGrout > 0.5/R_groutToWall then min(0.99,xGuess+0.05) else max(0.01,xGuess-0.05);
    R_groutToWall:=(1-xGuess)*R_grout_spec;
    R_groutToGrout:=((2*(1-xGuess)*R_grout_spec*(R_pipeToPipe_spec-2*xGuess*R_grout_spec))/(2*(1-xGuess)*R_grout_spec-R_pipeToPipe_spec+2*xGuess*R_grout_spec));
   end while;
   if changeFlag then
    Modelica.Utilities.Streams.print("Final xGrout: "+String(xGuess),"");
   end if;
   xGroutCenter:=xGuess;
  annotation(Documentation(info="<html>
<h4>
<strong>Syntax</strong>
</h4>
<p>
xGroutCenter:=xGroutCenter_1U(bheData,groutData) 
</p>
<h4>
<strong>Description</strong>
</h4>
<p>
Returns the relative position of the center of mass for the grout sections for single-U BHEs. The algorithm ensures that the thermal resistance between the grout sections is positive (see Bauer 2011: Zur thermischen Modellierung von ErdwÃ¤rmesonden und Erdsonden-WÃ¤rmespeichern). If the position of the grout is adjusted, a warning is given.
</p>
<h4>
<strong>Input arguments</strong>
</h4>
<ul>
<li><strong style=\"color:red\">MoSDH.Parameters.BoreholeHeatExchangers.BHEparameters</strong> bheData	<i style=\"color:brown\">BHE dataset</i></li>
<li><strong style=\"color:red\">MoSDH.Parameters.Grouts.GroutPartial</strong> groutData	<i style=\"color:brown\">Grout dataset</i></li>
</ul>
<h4>
<strong>Outputs</strong>
</h4>
<ul>
<li><strong style=\"color:red\">Real</strong> xGroutCenter	<i style=\"color:brown\">Relative position of the grout's center of mass (0 < x < 1). </i></li>
</ul>
</html>"));
 end xGroutCenter_1U;

 extends Modelica.Icons.FunctionsPackage;

 annotation (
  dateModified="2020-05-29 13:16:40Z",
  Documentation(info="<html>
<p>
Collection of functions:
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr>
  <td><a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.Functions.BHE_HeadElementIndex\">BHE_HeadElementIndex</a></td>
  <td>Returns the depth-index of the volume element containing the BHE head</td>
</tr>
<tr>
  <td><a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.Functions.BHE_BottomElementIndex\">BHE_BottomElementIndex</a></td>
  <td>Returns the depth-index of the volume element containing the BHE bottom</td>
</tr>
<tr>
  <td><a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.Functions.ElementHeights\">ElementHeights</a></td>
  <td>Returns an array with the vertical discretization of the model</td>
</tr>
<tr>
  <td><a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.Functions.ElementGroundData\">ElementGroundData</a></td>
  <td>Returns a matrix that contains the thermal properties of each global model element</td>
</tr>
<tr>
  <td><a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.Functions.MeshR\">MeshR</a></td>
  <td>Returns an array with the radial mesh</td>
</tr>
<tr>
  <td><a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.Functions.nElementsZ\">nElementsZ</a></td>
  <td>Returns the vertical number of elements in the model (necessary input for the meshing function)</td>
</tr>
<tr>
  <td><a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.Functions.NumberOfBHERings\">NumberOfBHERings</a></td>
  <td>Returns the number of model rings that contain BHEs</td>
</tr>
<tr>
  <td><a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.Functions.NumberOfBHEsPerRing\">NumberOfBHEsPerRing</a></td>
  <td>Returns an array with the number of BHEs inside each model ring that contains BHEs</td>
</tr>
<tr>
  <td><a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.Functions.SupermeshZ\">SupermeshZ</a></td>
  <td>Returns an array with the vertical supermesh (boundary mesh), i.e. all depth levels with significant changes of the model (geology, BHEs)</td>
</tr>
<tr>
  <td><a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.Functions.xGroutCenter_2U\">xGroutCenter_2U</a></td>
  <td>Returns the relative positioning of the grout's center of mass inside the borehole for double-U BHEs</td>
</tr>
<tr>
  <td><a href=\"modelica://MoSDH.Components.Storage.BoreholeStorage.Functions.xGroutCenter_1U\">xGroutCenter_1U</a></td>
  <td>Returns the relative positioning of the grout's center of mass inside the borehole for single-U BHEs</td>
</tr>
</table>

</html>"));
end Functions;