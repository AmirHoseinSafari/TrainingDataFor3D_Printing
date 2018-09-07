
function [FinalArray] = HilbertArrayMaker(NumberOfCubesInRow, NumberOfCubesInColumn, zBase)    
   
    FinalArray = []; 

    % IN THIS CODE WE USE THE .mat FILES WHICH ARE 3D HILBERT CURVES WITH
    % DIFFERENT THIKNESS AND LEVELS! THEN WE MAKE THE FINAL ARRAY WHICH IS A COLLECTION OF CURVES 
    % USING THESE FILES.
    %
    % INPUTS:   NumberOfCubesInRow: a number which reperesent number of cubes in row
    %           NumberOfCubesInColumn: a number which reperesent number of cubes in column
    %           zBase: a number which reperesent number of layers of the base
    %
    % loop over the number of rows and columns in our final array
    
    numOfVoxelsinRowAndCulomn = 60; % 60 is the num of voxels in x and y and z axis
    numOfVoxelsinBorder = 10; % 10 is the num of voxels of thickness of border.
    thicknessOfCube = numOfVoxelsinRowAndCulomn + numOfVoxelsinBorder;
    
    for i1 = 1 : NumberOfCubesInRow
        for i2 = 1 : NumberOfCubesInColumn
            disp(i2);
            disp(i1);

            % base on this random value we will decide to put which cube in the (i1,i2)
            % position of our final STL files

            % As you can see the first number in 'mat' files show the level of
            % the Hilbert curve and the second number show the orientation or
            % thickness
            mainRand = randi ([0 26]) + 1;

            % try to have a good distribution of cubes in our final STL files 
            if mainRand == 1
                randOfLevel = 1;
                randOfrand = randi([0 3]);
                randOfOri = 1;
            elseif mainRand <= 26
                randOfLevel = randi([1 5]) + 1;
                randOfOri = randi([0 2]) + 1;
                randOfrand = randi([0 3]);
            elseif mainRand == 27
                randOfLevel = 7;
                randOfOri = 1;
                randOfrand = randi([0 5]);
            else
                randOfOri = 1;
            end
            
            % Load the proper .mat file
            arr = load (strcat(num2str(randOfLevel),'to' ,num2str(randOfOri) , '.mat'));
            arr = arr.arr;

            % Add randomeness to our cubes! we reduces some lines randomely
            for ii1 = 1 : min(size(arr,1) , numOfVoxelsinRowAndCulomn)
                for ii2 = 1 : min(size(arr,2) , numOfVoxelsinRowAndCulomn)
                    for ii3 = 1 : min(size(arr,3) , numOfVoxelsinRowAndCulomn)
                        randf = randi ([0 , 10]) + 1;
                        if arr(ii1,ii2,ii3) == 1 && randf < randOfrand
                           arr(ii1,ii2,ii3) = 0;  
                        end
                    end     
                end
            end

            s3 = size(arr);

            arr = arr (2:s3(1),:,:);
            arr = arr (:,2:s3(2),:);
            arr = arr (:,:,2:s3(3));
            s = size (arr);

            % put base zBase layer, for example here we have 50 layer of base
            for i = 1 : numOfVoxelsinRowAndCulomn
                for j = 1 : numOfVoxelsinRowAndCulomn
                    for z = 1 : zBase
                       FinalArray(i,j,z) = 0; 
                    end
                end
            end

            % if the dimension of loaded cube is less than numOfVoxelsinRowAndCulomn*numOfVoxelsinRowAndCulomn*numOfVoxelsinRowAndCulomn then we
            % magnify the array otherwise we'll compress it!  
            if s(1) < numOfVoxelsinRowAndCulomn
                tmp = ones(round(numOfVoxelsinRowAndCulomn / s(1)));
                tmp2 = ones(round(numOfVoxelsinRowAndCulomn / s(2)));
                t2 = round(numOfVoxelsinRowAndCulomn / s(2));
                if (round(numOfVoxelsinRowAndCulomn / s(1)) == 1)
                    tmp = ones(2);
                end
                for z = 1 : s(3)
                    a2 = kron(arr(:,:,z),tmp);
                    sizeofa2 = size(a2);
                    pada2 = zeros(numOfVoxelsinRowAndCulomn);
                    pada2 (1:sizeofa2(1),1:sizeofa2(2)) = a2;
                    a2 = pada2;
                    if randOfLevel == 1 
                        for ii1 = 1 : numOfVoxelsinRowAndCulomn
                            for ii2 = 1 : numOfVoxelsinRowAndCulomn
                                randd = randi([0 3]) + 1;
                                if a2(ii1,ii2) == 1 && randd == 1
                                    a2(ii1,ii2) = 0;
                                end
                            end
                        end
                    end

                    for tt = 1 : t2
                        if ((z - 1) * t2 + tt <= numOfVoxelsinRowAndCulomn)
                            FinalArray(((i1 - 1) * thicknessOfCube) + 1:((i1 - 1) * thicknessOfCube) + numOfVoxelsinRowAndCulomn, ((i2 - 1) * thicknessOfCube) + 1 :((i2 - 1) * thicknessOfCube) + numOfVoxelsinRowAndCulomn,(z - 1) * t2 + tt + zBase) = a2(1:numOfVoxelsinRowAndCulomn,1:numOfVoxelsinRowAndCulomn);
                        end
                    end
                end
            else
                tmp = round(s(1) / numOfVoxelsinRowAndCulomn);
                tmp2 = round(s(2) / numOfVoxelsinRowAndCulomn);
                t2 = round(numOfVoxelsinRowAndCulomn / s(2));
                for z = 1 : numOfVoxelsinRowAndCulomn
                    if (z <= numOfVoxelsinRowAndCulomn)
                        FinalArray(((i1 - 1) * thicknessOfCube) + 1:((i1 - 1) * thicknessOfCube) + numOfVoxelsinRowAndCulomn, ((i2 - 1) * thicknessOfCube) + 1 :((i2 - 1) * thicknessOfCube) + numOfVoxelsinRowAndCulomn,z + zBase) = arr(1:numOfVoxelsinRowAndCulomn, 1:numOfVoxelsinRowAndCulomn,z);
                    end
                end
            end


            % put right and button border
            for i = 1 : numOfVoxelsinBorder
                for j = 1 : thicknessOfCube
                    for z = 1 : numOfVoxelsinRowAndCulomn + zBase
                        FinalArray(i + (i1 - 1) * thicknessOfCube + numOfVoxelsinRowAndCulomn ,j + (i2 - 1) * thicknessOfCube,z) = 1;
                    end
                end
            end
            for i = 1 : thicknessOfCube
                for j = 1 : numOfVoxelsinBorder
                    for z = 1 : numOfVoxelsinRowAndCulomn + zBase
                        FinalArray(i + (i1 - 1) * thicknessOfCube ,j + (i2 - 1) * thicknessOfCube + numOfVoxelsinRowAndCulomn,z) = 1;
                    end
                end
            end
            % each cube with border is thicknessOfCube * thicknessOfCube px
        end
    end

    % save the layers as fig
    for ii = zBase : zBase + numOfVoxelsinRowAndCulomn
       imagesc(FinalArray(:,:,ii));
       savefig(strcat('H',int2str(ii),'.fig'));
    end

    save('H20to4041B.mat','FinalArray')

