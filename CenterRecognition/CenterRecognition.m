function [centerArray] = CenterRecognition(imageAddress, NumberOfCubesInRow, NumberOfCubesInColumn, sizeOfTheCenter)    


    % IN THIS CODE WE RECOGNISE THE CENTER OF EVERY CUBES!
    %
    % INPUTS:   imageAddress: THE ADDRESS OF THE IMAGE
    %           NumberOfCubesInRow: a number which reperesent number of cubes in row
    %           NumberOfCubesInColumn: a number which reperesent number of cubes in column
    %           sizeOfTheCenter: a number which reperesent number of pixels
    %           of the center that you want
    %
    % OUTPUTS:  centerArray:   a 2D Array, every
    %                          sizeOfTheCenter*sizeOfTheCenter reperesent a
    %                          center of a cube! 
    
    LinToShow = imread(imageAddress);
    
    sizeOfTheCenter = sizeOfTheCenter - 1;
   
    lengthForJ = size(LinToShow,1)/NumberOfCubesInRow;
    lengthForI = size(LinToShow,2)/NumberOfCubesInColumn;
    
    for j = 1 : NumberOfCubesInRow
        for i = 1 : NumberOfCubesInColumn
            cube = LinToShow(floor((j - 1) * lengthForJ) + 1 : floor((j - 1) * lengthForJ + lengthForJ),  floor((i - 1) * lengthForI) + 1 : floor((i - 1) * lengthForI + lengthForI));

            %remove border
            % Reminder: borders are at right and bottom
            cube = cube(1: (size(cube,1)/7) * 6, 1: (size(cube,2)/7) * 6);
            figure, imshow(cube);

            % picking up the center      
            centerArray(((i - 1) * j + (j - 1)) * (sizeOfTheCenter + 1) + 1:((i - 1) * j + (j - 1)) * (sizeOfTheCenter + 1) + 10,1:sizeOfTheCenter + 1) = cube(size(cube,1)/2 - sizeOfTheCenter/2 : size(cube,1)/2 + sizeOfTheCenter/2 , size(cube,2)/2 - sizeOfTheCenter/2 : size(cube,2)/2 + sizeOfTheCenter/2);
       end
    end
