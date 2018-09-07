
function [FinalArray] = CurvesArrayMaker(NumberOfCubesInRow, NumberOfCubesInColumn, zBase)    
 
    FinalArray = []; % 2900*2900

    % IN THIS CODE WE USE THE .mat FILES WHICH ARE 2D CURVES OF DIFFERENT
    % TYPES AND LEVELS! THEN WE MAKE THE FINAL ARRAY WHICH IS A COLLECTION OF CURVES 
    % USING THESE FILES. AND EVEREY SINGLE CUBE IS A COLLECTION OF
    % DIFFERENT CURVES IN LAYERS!
    %
    % INPUTS:   NumberOfCubesInRow: a number which reperesent number of cubes in row
    %           NumberOfCubesInColumn: a number which reperesent number of cubes in column
    %           zBase: a number which reperesent number of layers of the base
    %
    % loop over the number of rows and columns in our final array
    
    numOfSamples = 70 - 1;  % 70 is number of curves file that we have so it's a constant!
    numOfVoxelsinRowAndCulomn = 60; % 60 is the num of voxels in x and y axis
    numOfVoxelsinBorder = 10; % 10 is the num of voxels of thickness of border.
    thicknessOfCube = numOfVoxelsinRowAndCulomn + numOfVoxelsinBorder;
    for i1 = 1 : NumberOfCubesInRow
        for i2 = 1 : NumberOfCubesInColumn  

            disp (i1);
            disp (i2);

            % put base zBase layer, for example here we have 50 layer of base
            for i = 1 : numOfVoxelsinRowAndCulomn
                for j = 1 : numOfVoxelsinRowAndCulomn
                    for z = 1 : zBase
                       FinalArray(i,j,z) = 0; 
                    end
                end
            end

            for i =  1: 15 
                 % pick one of the curves randomely
                 num = randi([0 numOfSamples]) + 1;
                 arr = load(strcat(num2str(num),'.mat'));
                 arr = arr.res;

                 % if the dimension of loaded cube is less than numOfVoxelsinRowAndCulomn*numOfVoxelsinRowAndCulomn*numOfVoxelsinRowAndCulomn then we
                 % magnify the array otherwise we'll cut it!  
                 if size(arr , 1) >= numOfVoxelsinRowAndCulomn || size(arr , 2) >= numOfVoxelsinRowAndCulomn
                     pada2 = zeros(numOfVoxelsinRowAndCulomn);
                     pada2 (1:size(arr , 1),1:size(arr , 2)) = arr;
                     arr = pada2 (1:numOfVoxelsinRowAndCulomn,1:numOfVoxelsinRowAndCulomn);
                 else 
                     tmp = ones(round(numOfVoxelsinRowAndCulomn / size(arr , 1)));
                     if (round(numOfVoxelsinRowAndCulomn / size(arr , 1)) == 1)
                        tmp = ones(2);
                     end

                     a2 = kron(arr,tmp);
                     if size(a2,1) > numOfVoxelsinRowAndCulomn
                         a2 = a2(1:numOfVoxelsinRowAndCulomn,:);
                     end
                     if size(a2,2) > numOfVoxelsinRowAndCulomn
                         a2 = a2(:,1:numOfVoxelsinRowAndCulomn);
                     end
                     sizeofa2 = size(a2);

                     pada2 = zeros(numOfVoxelsinRowAndCulomn);
                     pada2 (1:sizeofa2(1),1:sizeofa2(2)) = a2;
                     arr = pada2;
                 end

                 % Add randomeness to our cubes! we reduces some points randomely
                 for i3 = 1 : numOfVoxelsinRowAndCulomn
                     for i4 = 1 : numOfVoxelsinRowAndCulomn
                        rand = randi([0 3]) + 1;
                        if rand == 1 && arr (i3,i4) == 1
                            arr(i3,i4) = 0;
                        end 
                     end
                 end

                 % add the cube to the a array
                 FinalArray((i1 - 1) * thicknessOfCube + 1:(i1 - 1) * thicknessOfCube + numOfVoxelsinRowAndCulomn, (i2 - 1) * thicknessOfCube + 1:(i2 - 1) * thicknessOfCube + numOfVoxelsinRowAndCulomn, (i - 1) * 4 + 1 +zBase) = arr;
                 FinalArray((i1 - 1) * thicknessOfCube + 1:(i1 - 1) * thicknessOfCube + numOfVoxelsinRowAndCulomn, (i2 - 1) * thicknessOfCube + 1:(i2 - 1) * thicknessOfCube + numOfVoxelsinRowAndCulomn, (i - 1) * 4 + 2 +zBase) = arr;
                 FinalArray((i1 - 1) * thicknessOfCube + 1:(i1 - 1) * thicknessOfCube + numOfVoxelsinRowAndCulomn, (i2 - 1) * thicknessOfCube + 1:(i2 - 1) * thicknessOfCube + numOfVoxelsinRowAndCulomn, (i - 1) * 4 + 3 +zBase) = arr;
                 FinalArray((i1 - 1) * thicknessOfCube + 1:(i1 - 1) * thicknessOfCube + numOfVoxelsinRowAndCulomn, (i2 - 1) * thicknessOfCube + 1:(i2 - 1) * thicknessOfCube + numOfVoxelsinRowAndCulomn, (i - 1) * 4 + 4 +zBase) = arr;
            end

            % put right and button border
            for i = 1 : 10
                for j = 1 : thicknessOfCube
                    for z = 1 : numOfVoxelsinRowAndCulomn + zBase
                        FinalArray(i + (i1 - 1) * thicknessOfCube + numOfVoxelsinRowAndCulomn ,j + (i2 - 1) * thicknessOfCube,z) = 1;
                    end
                end
            end
            for i = 1 : thicknessOfCube
                for j = 1 : 10
                    for z = 1 : numOfVoxelsinRowAndCulomn + zBase
                        FinalArray(i + (i1 - 1) * thicknessOfCube ,j + (i2 - 1) * thicknessOfCube + numOfVoxelsinRowAndCulomn,z) = 1;
                    end
                end
            end
            % each cube with border is thicknessOfCube * thicknessOfCube px
        end
    end

    % save the layers as fig

    for ii = 1 : numOfVoxelsinRowAndCulomn + zBase
       imagesc(FinalArray(:,:,ii));
       savefig(strcat(int2str(ii),'.fig'));
    end

    save('R21to41B.mat','FinalArray')

