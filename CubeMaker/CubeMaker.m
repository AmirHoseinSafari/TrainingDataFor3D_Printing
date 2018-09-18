function [] = CubeMaker(fileAddress,scaleX,scaleY,scaleZ)    


    % IN THIS CODE WE BUILD EVERY SINGLE CUBES FROM THE .mat FILES!
	% AFTER RUNNING THIS CODE YOU WILL HAVE .stl AND .mat FILES OF EVERY CUBES
    %
    % INPUTS:   fileAddress: THE ADDRESS WHICH IS CONTAINS THE FOLFERS 
	%						(FROM 1 TO 15) OF Final_Data WHICH IS AVAILABLE FROM Google Drive
    %           scaleX     - A number which means the X size of every
	%                       voxel in mm
	%           scaleY     - A number which means the Y size of every 
	%                       voxel in mm
	%           scaleZ     - A number which means the Z size of every
	%                       voxel in mm
    %
    % OUTPUTS:  []
    
	% Loop on folders 
    for i = 1 : 15
        path = strcat(fileAddress,num2str(i));
        cd (path);
        
        arr = load(strcat(num2str(i) , '_ArrayOfPrint.mat'));
        arr = arr.a;
		
		% Loop on every cubes in the .mat file
        for i1 = 1 : size(arr,1)/70
            for i2 = 1 : size(arr,2)/70
                cube = arr((i1 - 1)*70 + 1:(i1 - 1)*70 + 60, (i2 - 1)*70 + 1:(i2 - 1)*70 + 60,:);
				% We store them with this approach: 'index in row'_'index in column'
                save(strcat(num2str(i1),'_',num2str(i2),'.mat'),'cube');
                make_STL_of_Array(strcat(num2str(i1),'_',num2str(i2)),cube,scaleX,scaleY,scaleZ);
            end
        end
    end
