
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
    numOfSamples = 70 - 1;   % 70 is number of curves file that we have so it's a constant!
    for i1 = 1 : NumberOfCubesInRow
        for i2 = 1 : NumberOfCubesInColumn
            disp (i1);
            disp (i2);

            % put base zBase layer, for example here we have 50 layer of base
            % 60 is the number of voxels in x and y axis!
            for i = 1 : 60
                for j = 1 : 60
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

                 % if the dimension of loaded cube is less than 60*60*60 then we
                 % magnify the array otherwise we'll cut it!  
                 if size(arr , 1) >= 60 || size(arr , 2) >= 60
                     pada2 = zeros(60);
                     pada2 (1:size(arr , 1),1:size(arr , 2)) = arr;
                     arr = pada2 (1:60,1:60);
                 else 
                     tmp = ones(round(60 / size(arr , 1)));
                     if (round(60 / size(arr , 1)) == 1)
                        tmp = ones(2);
                     end

                     a2 = kron(arr,tmp);
                     if size(a2,1) > 60
                         a2 = a2(1:60,:);
                     end
                     if size(a2,2) > 60
                         a2 = a2(:,1:60);
                     end
                     sizeofa2 = size(a2);

                     pada2 = zeros(60);
                     pada2 (1:sizeofa2(1),1:sizeofa2(2)) = a2;
                     arr = pada2;
                 end

                 % Add randomeness to our cubes! we reduces some points randomely
                 for i3 = 1 : 60
                     for i4 = 1 : 60
                        rand = randi([0 3]) + 1;
                        if rand == 1 && arr (i3,i4) == 1
                            arr(i3,i4) = 0;
                        end 
                     end
                 end

                 % add the cube to the a array
                 FinalArray((i1 - 1) * 70 + 1:(i1 - 1) * 70 + 60, (i2 - 1) * 70 + 1:(i2 - 1) * 70 + 60, (i - 1) * 4 + 1 +zBase) = arr;
                 FinalArray((i1 - 1) * 70 + 1:(i1 - 1) * 70 + 60, (i2 - 1) * 70 + 1:(i2 - 1) * 70 + 60, (i - 1) * 4 + 2 +zBase) = arr;
                 FinalArray((i1 - 1) * 70 + 1:(i1 - 1) * 70 + 60, (i2 - 1) * 70 + 1:(i2 - 1) * 70 + 60, (i - 1) * 4 + 3 +zBase) = arr;
                 FinalArray((i1 - 1) * 70 + 1:(i1 - 1) * 70 + 60, (i2 - 1) * 70 + 1:(i2 - 1) * 70 + 60, (i - 1) * 4 + 4 +zBase) = arr;
            end

            % put right and button border
            for i = 1 : 10
                for j = 1 : 70
                    for z = 1 : 60 + zBase
                        FinalArray(i + (i1 - 1) * 70 + 60 ,j + (i2 - 1) * 70,z) = 1;
                    end
                end
            end
            for i = 1 : 70
                for j = 1 : 10
                    for z = 1 : 60 + zBase
                        FinalArray(i + (i1 - 1) * 70 ,j + (i2 - 1) * 70 + 60,z) = 1;
                    end
                end
            end
            % each cube with border is 70 * 70 px
        end
    end

    % save the layers as fig

    for ii = 1 : 110 % this is the number of total z layers
       imagesc(FinalArray(:,:,ii));
       savefig(strcat(int2str(ii),'.fig'));
    end

    save('R21to41B.mat','FinalArray')

