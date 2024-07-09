%% NHTSA Pedestrian Data Import
% UVA CAB: James Caldwell, Ethan Camacho
% June-July 2024

% This code imports Vicon and DAS data into matlab from the 2024 NHTSA
% Pedestrian-Truck test series

clear

% Initialize Struct
Ped_Data.Run_01 = struct();
Ped_Data.Run_02 = struct();
Ped_Data.Run_03 = struct();
Ped_Data.Run_04 = struct();

%% Impact Speeds
    % Calculated from velocity gate 
    % "\\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1CustomCode\Experimental Data Processing\VelocityCalculator.m"

Ped_Data.Run_01.Speed_mph = 25.1;
Ped_Data.Run_02.Speed_mph = 25.5;
Ped_Data.Run_03.Speed_mph = 25.4;
Ped_Data.Run_04.Speed_mph = 35.3;


%% Vicon Data Import
run_1_file_path = '\\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-RAW\VIA Sled Tests\01_HIII_25mph\Vicon\NHTSA_Pedestrian_Run_01.csv';
Ped_Data = vicon_import(run_1_file_path,Ped_Data,'Run_01');
Ped_Data = vicon_fix_run_01(Ped_Data); % Run 01's Coordinate system was setup inconsistently with the rest of the runs

run_2_file_path = '\\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-RAW\VIA Sled Tests\02_HIII_25mph\Vicon\Run 02 HIII\NHTSA_Pedestrian_Run_02.csv';
Ped_Data = vicon_import(run_2_file_path,Ped_Data,'Run_02');

run_3_file_path = '\\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-RAW\VIA Sled Tests\03_HIII_25mph\Vicon\NHTSA_Pedestrian_Run_03.csv';
Ped_Data = vicon_import(run_3_file_path,Ped_Data,'Run_03');

run_4_file_path = '\\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-RAW\VIA Sled Tests\04_HIII_35mph\Vicon\Run 04 HIII\NHTSA_Pedestrian_Run_04.csv';
Ped_Data = vicon_import(run_4_file_path,Ped_Data,'Run_04');

%% Fix Vicon Names

Ped_Data.Run_04.Vicon.T1_1 = Ped_Data.Run_04.Vicon.T11;    
Ped_Data.Run_04.Vicon = rmfield(Ped_Data.Run_04.Vicon, 'T11'); % Remove old field

Ped_Data.Run_04.Vicon.T8_1 = Ped_Data.Run_04.Vicon.T81;    
Ped_Data.Run_04.Vicon = rmfield(Ped_Data.Run_04.Vicon, 'T81'); % Remove old field


%% Trim Vicon Data
    % For the vicon_plots.m, we were interested in only a trimmed section of the vicon data
    % Remove the data that was significantly before impact

Ped_Data.Run_01.Vicon_Trimmed = trim_vicon_data(Ped_Data.Run_01.Vicon,2755); % These values were determined by hand
Ped_Data.Run_02.Vicon_Trimmed = trim_vicon_data(Ped_Data.Run_02.Vicon,1075);
Ped_Data.Run_03.Vicon_Trimmed = trim_vicon_data(Ped_Data.Run_03.Vicon,2740);
Ped_Data.Run_04.Vicon_Trimmed = trim_vicon_data(Ped_Data.Run_04.Vicon,1000);

%% DAS Import
run_1_file_path_DAS = '\\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-RAW\VIA Sled Tests\01_HIII_25mph\DAS\Sled DAS\NHTSA_Pedestrian_Run_01_DAS.csv';
Ped_Data = DAS_import(run_1_file_path_DAS,Ped_Data,'Run_01');

run_2_file_path_DAS = '\\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-RAW\VIA Sled Tests\02_HIII_25mph\DAS\Sled DAS\NHTSA_Pedestrian_Run_02.csv';
Ped_Data = DAS_import(run_2_file_path_DAS,Ped_Data,'Run_02');

run_3_file_path_DAS = '\\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-RAW\VIA Sled Tests\03_HIII_25mph\DAS\Onboard\NHTSA_Pedestrian_Run_03.csv';
Ped_Data = DAS_import(run_3_file_path_DAS,Ped_Data,'Run_03');

run_4_file_path_DAS = '\\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-RAW\VIA Sled Tests\04_HIII_35mph\DAS\Onboard DAS\NHTSA_Pedestrian_Run_04\NHTSA_Pedestrian_Run_04.csv';
Ped_Data = DAS_import(run_4_file_path_DAS,Ped_Data,'Run_04');

%% Save Ped_Data struct
save('\\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-ANALYZED\Experimental Results\Ped_Data.mat', 'Ped_Data');

%% Vicon Import Function
% This function takes a filepath, the Ped_Data struct, and the run name
    % (ex: Run_01) and imports the Vicon data for that run
function [Ped_Data] = vicon_import(filepath,Ped_Data,run_name)

    dataTable = readcell(filepath);
    data_values = dataTable (6:end,:); % Cut away the headers
    
    % Assign frame number values
    Ped_Data.(run_name).Vicon.Frame = data_values(:,1);
    
    % Assign each marker x, y, and z values (in mm)
        % Go by each column of vicon data and assign to a variable
    for i_vicon = 3:3:(width(data_values)-1) % Skip by 3's since each marker has an x, y, and z. Skip the last column which is nan's
        marker_name = dataTable(3,i_vicon);
        
        % Ensure marker_name is a character vector
        marker_name = char(marker_name);
    
        % Fix Marker name formatting
            % Ex: HIII_Run01:HoodLeftCenterRight1 -> HoodLeftCenterRight1
        run_name_vicon = strrep(run_name,'_','');
        string_to_remove = strcat('HIII_',run_name_vicon,':');
        marker_name = strrep(marker_name,string_to_remove,''); % replaces string to remove with nothing ''
        string_to_remove = strcat(run_name_vicon,':');
        marker_name = strrep(marker_name,string_to_remove,''); % replaces string to remove with nothing ''

        % Assign data to marker's x, y, and z
        x_data = data_values(:,i_vicon);
        y_data = data_values(:,(i_vicon+1));
        z_data = data_values(:,(i_vicon+2));

        % Call function to replace missing values with Nans and convert to matlab vectors
        x_data = fix_NaNs_and_formatting(x_data);
        y_data = fix_NaNs_and_formatting(y_data);
        z_data = fix_NaNs_and_formatting(z_data);

        % Assign data to Ped_Data Struct
        Ped_Data.(run_name).Vicon.(marker_name).X = x_data;
        Ped_Data.(run_name).Vicon.(marker_name).Y = y_data;
        Ped_Data.(run_name).Vicon.(marker_name).Z = z_data;    
    end

end


function [Ped_Data] = DAS_import(filepath,Ped_Data,run_name)

    warning('off', 'all'); % Turned off warnings to ignore date-time warnings.
    dataTable = readcell(filepath);
    warning('on', 'all');
    data_values = dataTable(24:end,:); % Cut away the headers

    % Assign time number values
    Ped_Data.(run_name).DAS.Time = data_values(:,1);

    for i_DAS = 2:3:(width(data_values))

        marker_name = dataTable(10,i_DAS);

        % Ensure marker_name is a character vector
        marker_name = char(marker_name);

        % Fix Marker name formatting
        marker_name = strrep(marker_name,'X', ' ');
        marker_name = strrep(marker_name,' ','');

        % Assign data to marker's x, y, and z
        Ped_Data.(run_name).DAS.(marker_name).X = data_values(:,i_DAS);
        Ped_Data.(run_name).DAS.(marker_name).Y = data_values(:,(i_DAS+1));
        Ped_Data.(run_name).DAS.(marker_name).Z = data_values(:,(i_DAS+2));

    end



end

function data_fixed = fix_NaNs_and_formatting(data_raw)
    % Replace 1x1 missing cells it NaN
    data_raw(cellfun(@(x) any(ismissing(x)), data_raw)) = {NaN};
    % Convert cells to matlab vector
    data_fixed = cell2mat(data_raw);

end

%% Fix vicon Coordinate System (CS) for Run 01
    % The test team made an error and setup Run 01's CS incorrectly.
        % X and Y were rotated 180 deg
        % The opposite corner vicon balls were used
    % Thus, Vicon Run 01's data needs to be rotated 180 in XY and
        % translated +X 100mm and +Y 100mm
function Ped_Data = vicon_fix_run_01(Ped_Data)

    all_fields = fieldnames(Ped_Data.Run_01.Vicon);
    all_fields = all_fields(2:end); % Remove frame number

    % Iterate through each field of Run 01 Vicon data and transform it
    for i_vf = 1:length(all_fields) % i_vf is short for i_vicon_fix
        marker_name = char(all_fields(i_vf));

        % Collect data
        X = Ped_Data.Run_01.Vicon.(marker_name).X;  
        Y = Ped_Data.Run_01.Vicon.(marker_name).Y; 
        Z = Ped_Data.Run_01.Vicon.(marker_name).Z;  
        
        num_points = length(X);
        
        % Create a matrix of points in homogeneous coordinates (7000x4)
        points = [X, Y, Z, ones(num_points, 1)];
        
        % Define the transformation matrix
        M = [-1,  0,  0, 100;
              0, -1,  0, 100;
              0,  0,  1,   0;
              0,  0,  0,   1];
        
        % Apply the transformation matrix to each point
        transformed_points = (M * points')';
        
        % Extract the transformed x, y, z coordinates
        X_transformed = transformed_points(:, 1);
        Y_transformed = transformed_points(:, 2);
        Z_transformed = transformed_points(:, 3);
        
        % Reassign X_transformed, Y_transformed, and Z_transformed to Ped_Data struct
        Ped_Data.Run_01.Vicon.(marker_name).X = X_transformed;
        Ped_Data.Run_01.Vicon.(marker_name).Y = Y_transformed;
        Ped_Data.Run_01.Vicon.(marker_name).Z = Z_transformed;

    end
    
end

%% Trime Vicon Data
% Trim vicon data from (1:end) to (frame_start:end)
function data_trimmed = trim_vicon_data(data,frame_start)
    data_trimmed = struct();
    marker_names = fields(data);
    for trim_index = 2:length(marker_names) % 2 because skip frame #'s
        marker_name = char(marker_names(trim_index));
        data_trimmed.(marker_name).X = data.(marker_name).X(frame_start:end);
        data_trimmed.(marker_name).Y = data.(marker_name).Y(frame_start:end);
        data_trimmed.(marker_name).Z = data.(marker_name).Z(frame_start:end);
    end
end 

