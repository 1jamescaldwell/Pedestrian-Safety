%% Vicon Plots
% UVA CAB: James Caldwell
% June 2024

% To run: Ped_Data struct MUST be loaded into matlab
    % That is saved here: "\\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-ANALYZED\Experimental Results\Ped_Data.mat"
    % Otherwise, this code runs entirely without user inputs 
% This code makes vicon visualization plots for 2024 NHTSA Pedestrian
    % The pelvis, elbow, and wrist lines are commented out. We decided to not plot those
% Figures are being saved here:
    % \\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-ANALYZED\Experimental Results\Vicon

%% To Ethan:
    % Uncomment run 4 data onec it's labeled: section starting around line
    % 266

%% For figure adjustments
% Some adjustments to legend/vicon label locations may be needed
% After running the script:
    % Open the saved .fig file: \\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-ANALYZED\Experimental Results\Vicon
        % tools -> edit plot
        % Manually make adjustments needed
        % run line of code below to save 

% save_fig('25mph_HIII_Lateral') % Adjust the name as needed

%%

close all

clearvars -except Ped_Data

save = 0; % Toggle between 1 and 0 to turn save on or off

%% 25 mph Runs

plot_views = {'lateral','overhead','oblique'};

% Loop through each plot view, display it, then save it. 
for view_index = 1:length(plot_views)
    figure
    hold on
    xlabel('X [mm]');
    ylabel('Y [mm]');
    zlabel('Z [mm]');
%     axis equal
    
    plot_silverado_stl_function() % Plot Silverado STL
    plot_origin_and_axis(Ped_Data) % Plot origin and Axis
    ground = plot_ground_function(); % Plot ground
    plot_vicon_25mph(Ped_Data) % Plot vicon markers
    
    legend(NumColumns=1,Location="eastoutside")
    
    title('NHTSA Pedestrian 2024: 2014 Chevy Silverado Pedestrian Impact','FontSize',18)
    subtitle('25mph Runs','FontSize',14)
    set(gcf, 'Position', get(0, 'Screensize'));
    ax = gca;
    ax.Projection = 'orthographic'; % Set projection to orthographic. Perspective looks good except for the pure lateral view it makes the truck look weird
    xlim([-1000 3000])

    plot_view = char(plot_views(view_index));
    

    % These if statements are for setting + saving the plot view
    if strcmp(plot_view,'oblique')
        % Oblique View
            % This view is saved so for the 3d space view
            % The second legend for Run 1, 2, 3 is not use for this view (like it
            % is for lateral/overhead below) because the way the 2nd legend it
            % setup it, it is forced into a 2d view. 
        set(ground, 'EdgeColor', 'none'); % Turn off edge lines for lateral/oblique view
        view([1 1 3])
        if save == 1
            save_fig('25mph_HIII_Oblique')  
        end
    else
        if strcmp(plot_view,'lateral')
            % Lateral View
            set(ground, 'EdgeColor', 'k'); % Turn on edge lines for lateral view
            view(ax,[180, 0]); % Azimuth = 180, Elevation = 0
        elseif strcmp(plot_view,'overhead')
            % Overhead View
            set(ground, 'EdgeColor', 'none'); % Turn off edge lines for lateral/oblique view
            view(ax,180, 90);
        end

         % These lines add a second legend for Run 1, 2, and 3
        data_run_1_legend = Ped_Data.Run_01.Vicon_Trimmed.HeadRight1;
        data_run_2_legend = Ped_Data.Run_02.Vicon_Trimmed.HeadRight1;
        data_run_3_legend = Ped_Data.Run_03.Vicon_Trimmed.HeadRight1;
        run1_legend = plot3(data_run_1_legend.X,data_run_1_legend.Y,data_run_1_legend.Z,'Color','b','LineStyle','-.','LineWidth',1,'HandleVisibility','off');
        run2_legend = plot3(data_run_2_legend.X,data_run_2_legend.Y,data_run_2_legend.Z,'Color','b','LineStyle','--','LineWidth',1,'HandleVisibility','off');
        run3_legend = plot3(data_run_3_legend.X,data_run_3_legend.Y,data_run_3_legend.Z,'Color','b','LineStyle',':','LineWidth',1,'HandleVisibility','off');
        ah1 = axes('position',get(gca,'position'),'visible','off');
        legend(ah1, [run1_legend,run2_legend,run3_legend], {'Run 1','Run 2','Run 3'}, 'Location','north',NumColumns=3,fontsize=18);
        
        save_name = strcat('25mph_HIII_',plot_view);
        if save == 1
            save_fig(save_name)
        end
    end

end

% This adjusts the way the lines are displayed
    % It makes the lines thicker, but then the marker styles are not
    % distinguishable.
    % If used, put after the plot lines are created but before it saves
% set(gcf, 'Renderer', 'painters')

hold off

%% 35 mph Run
fig2 = figure;
hold on
xlabel('X [mm]');
ylabel('Y [mm]');
zlabel('Z [mm]');
% axis equal

plot_silverado_stl_function() % Plot Silverado STL
plot_origin_and_axis(Ped_Data) % Plot origin and Axis
ground = plot_ground_function(); % Plot ground
plot_vicon_35mph(Ped_Data)  % Plot vicon markers

legend(NumColumns=1,Location="eastoutside")
title('NHTSA Pedestrian 2024: 2014 Chevy Silverado Pedestrian Impact','FontSize',18)
subtitle('35mph Run','FontSize',14)
set(gcf, 'Position', get(0, 'Screensize'));
ax = gca;
ax.Projection = 'orthographic'; % Set projection to orthographic. Perspective looks good except for the pure lateral view it makes the truck look weird
xlim([-1000 3500])

% Overhead View
set(ground, 'EdgeColor', 'none'); % Turn off edge lines for lateral/oblique view
view(180, 90);
if save == 1
    save_fig('35mph_HIII_Overhead')
end

% Oblique View
set(ground, 'EdgeColor', 'none'); % Turn off edge lines for lateral/oblique view
view([1 1 3])
if save == 1
    save_fig('35mph_HIII_Oblique')
end

% Lateral View
set(ground, 'EdgeColor', 'k'); % Turn on edge lines for lateral view
view(180, 0); % Azimuth = 180, Elevation = 0
if save == 1
    save_fig('35mph_HIII_Lateral')
end 


%% Functions

%% Plot vicon markers 25 mph Runs
function plot_vicon_25mph(Ped_Data)

    run_colors = jet(9);
    
    %% Run 01
    % Head
    plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.HeadPosterior1,run_colors(1,:),'no legend','-.')
    % Thoracic
    plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.T1_1,run_colors(2,:),'no legend','-.')
    plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.T8_1,run_colors(2,:),'no legend','-.')
    % Shoulder
    plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.RightShoulder1,run_colors(3,:),'no legend','-.')
    plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.LeftShoulder1,run_colors(3,:),'no legend','-.')
    % Elbow
%     plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.RightElbowMedial1,run_colors(4,:),'no legend','-.')
%     plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.RightElbowLateral1,run_colors(4,:),'no legend','-.')
%     plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.LeftElbowMedial1,run_colors(4,:),'no legend','-.')
%     plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.LeftElbowLateral1,run_colors(4,:),'no legend','-.')
    % Pelvis
    plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.PelvisAnterior1,run_colors(5,:),'no legend','-.')
    plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.PelvisPosterior1,run_colors(5,:),'no legend','-.')
    % Wrist
%     plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.RightWrist1,run_colors(6,:),'no legend','-.')
%     plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.LeftWrist1,run_colors(6,:),'no legend','-.')
    % Hip
%     plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.RightHip1,run_colors(7,:),'no legend','-.')
        % plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.LeftHip,run_colors(5,:),'no legend','-.') % Marker lost
    % Knee
        % plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.RightKneeMedial1,run_colors(4,:),'Run 1 Knee') % Marker lost
    plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.RightKneeLateral1,run_colors(8,:),'no legend','-.')
    plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.LeftKneeMedial1,run_colors(8,:),'no legend','-.')
        % plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.LeftKneeLateral1,run_colors(4,:),'no legend','-.') % Marker lost
    % Ankle
    plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.RightAnkleLateral1,run_colors(9,:),'no legend','-.')
    % plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.RightAnkleMedial1,run_colors(9,:),'no legend','-.') % Marker Lost
    plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.LeftAnkleLateral1,run_colors(9,:),'no legend','-.')
    plot3d_points(Ped_Data.Run_01.Vicon_Trimmed.LeftAnkleMedial1,run_colors(9,:),'no legend','-.')
    
    %% Run 02
    % Head
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.HeadPosterior1,run_colors(1,:),'Head','--')
    display_line_name(Ped_Data.Run_02.Vicon_Trimmed.HeadRight1,'Head');
    % Thoracic
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.T1_1,run_colors(2,:),'Thoracic','--')
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.T8_1,run_colors(2,:),'no legend','--')
    display_line_name(Ped_Data.Run_02.Vicon_Trimmed.T1_1,'Thoracic');
    % Chest
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.Chest1,run_colors(2,:),'no legend','--')
    display_line_name(Ped_Data.Run_02.Vicon_Trimmed.Chest1,'Chest');
    % Shoulder
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.RightShoulder1,run_colors(3,:),'Shoulder','--')
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.LeftShoulder1,run_colors(3,:),'no legend','--')
    display_line_name(Ped_Data.Run_02.Vicon_Trimmed.RightShoulder1,'Shoulder');
    % Elbow
%     plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.RightElbowMedial1,run_colors(4,:),'Elbow','--')
%     plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.RightElbowLateral1,run_colors(4,:),'no legend','--')
%     % plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.LeftElbowMedial1,run_colors(4,:),'no legend','--') % Marker lost
%     plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.LeftElbowLateral1,run_colors(4,:),'no legend','--')
    % Pelvis
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.PelvisAnterior1,run_colors(5,:),'Pelvis','--')
    display_line_name(Ped_Data.Run_02.Vicon_Trimmed.PelvisAnterior1,'Pelvis');
    % plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.PelvisPosterior1,run_colors(5,:),'no legend','--') % Marker Lost
    % Wrist
%     plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.RightWrist1,run_colors(6,:),'Wrist','--')
%     plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.LeftWrist1,run_colors(6,:),'no legend','--')
    % Hip
%     plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.RightHip1,run_colors(7,:),'Hip','--')
%     plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.LeftHip1,run_colors(7,:),'no legend','--')
    % Knee
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.RightKneeMedial1,run_colors(8,:),'Knee','--')
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.RightKneeLateral1,run_colors(8,:),'no legend','--')
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.LeftKneeMedial1,run_colors(8,:),'no legend','--')
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.LeftKneeLateral1,run_colors(8,:),'no legend','--') 
    display_line_name(Ped_Data.Run_02.Vicon_Trimmed.LeftKneeMedial1,'Knees');
    % Ankle
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.RightAnkleLateral1,run_colors(9,:),'Ankle','--')
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.RightAnkleMedial1,run_colors(9,:),'no legend','--')
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.LeftAnkleLateral1,run_colors(9,:),'no legend','--')
    plot3d_points(Ped_Data.Run_02.Vicon_Trimmed.LeftAnkleMedial1,run_colors(9,:),'no legend','--')
    display_line_name(Ped_Data.Run_02.Vicon_Trimmed.LeftAnkleLateral1,'Ankles');
    
    %% Run 03
    % Head
    plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.HeadPosterior1,run_colors(1,:),'no legend',':')
    % Thoracic
    plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.T_1,run_colors(2,:),'no legend',':')
    plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.T_8,run_colors(2,:),'no legend',':')
    % Chest
    plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.Chest1,run_colors(2,:),'no legend',':')
    % Shoulder
    plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.RightShoulder1,run_colors(3,:),'no legend',':')
    plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.LeftShoulder1,run_colors(3,:),'no legend',':')
    % Elbow
%     plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.RightElbowMedial1,run_colors(4,:),'no legend',':')
%     plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.RightElbowLateral1,run_colors(4,:),'no legend',':')
%     plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.LeftElbowMedial1,run_colors(4,:),'no legend',':') % Marker lost
%     plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.LeftElbowLateral1,run_colors(4,:),'no legend',':')
    % Pelvis
    plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.PelvisAnterior1,run_colors(5,:),'no legend',':')
    plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.PelvisPosterior1,run_colors(5,:),'no legend',':') % Marker Lost
    % Wrist
%     plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.RightWrist1,run_colors(6,:),'no legend',':')
%     plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.LeftWrist1,run_colors(6,:),'no legend',':')
    % Hip
%     plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.RightHip1,run_colors(7,:),'no legend',':')
%     plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.LeftHip1,run_colors(7,:),'no legend',':')
    % Knee
    plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.RightKneeMedial1,run_colors(8,:),'no legend',':')
    plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.RightKneeLateral1,run_colors(8,:),'no legend',':')
    plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.LeftKneeMedial1,run_colors(8,:),'no legend',':')
        plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.LeftKneeLateral1,run_colors(8,:),'no legend',':') 
    % Ankle
    plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.RightAnkleLateral1,run_colors(9,:),'no legend',':')
    plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.RightAnkleMedial1,run_colors(9,:),'no legend',':') 
    plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.LeftAnkleLateral1,run_colors(9,:),'no legend',':')
    % plot3d_points(Ped_Data.Run_03.Vicon_Trimmed.LeftAnkleMedial1,run_colors(9,:),'no legend',':')

end

%% Plot vicon markers 35 mph Run
function plot_vicon_35mph(Ped_Data)

    run_colors = jet(9);
    
    %% Run 04
    % Head
    plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.HeadPosterior1,run_colors(1,:),'Run 4 Head','-')
    display_line_name(Ped_Data.Run_04.Vicon_Trimmed.HeadRight1,'Head');
    % Thoracic
    plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.T1_1,run_colors(2,:),'Run 4 Thoracic','-')
    plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.T8_1,run_colors(2,:),'no legend','-')
    display_line_name(Ped_Data.Run_04.Vicon_Trimmed.T1_1,'Thoracic');
    % Chest
    plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.Chest1,run_colors(2,:),'no legend','-')
    display_line_name(Ped_Data.Run_04.Vicon_Trimmed.Chest1,'Chest');
    % Shoulder
    plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.RightShoulder1,run_colors(3,:),'Run 4 Shoulder','-')
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.LeftShoulder1,run_colors(3,:),'no legend','-') % Marker lots
    display_line_name(Ped_Data.Run_04.Vicon_Trimmed.RightShoulder1,'Shoulder');
    % Elbow
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.RightElbowMedial1,run_colors(4,:),'Run 4 Elbow','--')
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.RightElbowLateral1,run_colors(4,:),'no legend','--')
    % plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.LeftElbowMedial1,run_colors(4,:),'no legend','--') % Marker lost
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.LeftElbowLateral1,run_colors(4,:),'no legend','--')
    % Pelvis
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.PelvisAnterior1,run_colors(5,:),'Run 4 Pelvis','-')
%     display_line_name(Ped_Data.Run_04.Vicon_Trimmed.PelvisAnterior1,'Pelvis');
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.PelvisPosterior1,run_colors(5,:),'no legend','-') % Marker Lost
    % Wrist
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.RightWrist1,run_colors(6,:),'Run 4 Wrist','-')
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.LeftWrist1,run_colors(6,:),'no legend','-')
    % Hip
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.RightHip1,run_colors(7,:),'Run 4 Hip','-')
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.LeftHip1,run_colors(7,:),'no legend','-') % Marker lost
    % Knee
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.RightKneeMedial1,run_colors(8,:),'Run 4 Knee','-')
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.RightKneeLateral1,run_colors(8,:),'no legend','-')
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.LeftKneeMedial1,run_colors(8,:),'no legend','-')
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.LeftKneeLateral1,run_colors(8,:),'no legend','-')
%     display_line_name(Ped_Data.Run_04.Vicon_Trimmed.LeftKneeLateral1,'Knees');
    % Ankle
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.RightAnkleLateral1,run_colors(9,:),'Run 4 Ankle','-')
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.RightAnkleMedial1,run_colors(9,:),'no legend','-')
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.LeftAnkleLateral1,run_colors(9,:),'no legend','-')
%     plot3d_points(Ped_Data.Run_04.Vicon_Trimmed.LeftAnkleMedial1,run_colors(9,:),'no legend','-')
%     display_line_name(Ped_Data.Run_04.Vicon_Trimmed.LeftAnkleLateral1,'Ankles');

end
%% Truck
% truck = 0;
% if truck == 1
%     figure()
%     xlabel('Time (s)','FontSize',18)
%     ylabel('Displacement (mm)','FontSize',18,'Interpreter','none')
%     
%     hold on
%     
%     % Get all field names of Ped_Data
%     all_fields = fieldnames(Ped_Data.(run_number).Vicon);
%     
%     % Initialize a cell array to store field names containing hood, bumper, or grille
%     truck_fields = {};
%     
%     % Loop through each field name
%     for i = 1:numel(all_fields)
%         % Check if the field name contains the substring
%         if contains(all_fields{i}, 'Hood') || contains(all_fields{i}, 'Bumper') || contains(all_fields{i}, 'Grille')
%             % If yes, add it to the hood_fields cell array
%             truck_fields{end+1} = all_fields{i};
%         end
%     end
%     
%     for j = 1:length(truck_fields)
%         marker_name = char(truck_fields(j));
%         plot3d_points(Ped_Data.(run_number).Vicon.(marker_name),'b','-','Truck')
%     end
%     
%     if save == 1
%         save_fig('truck');
%     end 
% end

%% Truck STL in Vicon Reference Frame

% This section of code was used to by hand put the truck STL into the Vicon coordinate system
% The output of this was the numbers from plot_silverado_stl_function.m
% that were 610, -1261, and 216. 
        % Vehicle.vertices(:, 1) = Vehicle.vertices(:, 1) + 610;
        % Vehicle.vertices(:, 2) = Vehicle.vertices(:, 2) -1261; % Move Y
        % Vehicle.vertices(:, 3) = Vehicle.vertices(:, 3) + 216;

% This code is commented out because it is no longer needed

%To align the truck STL with the truck in Vicon's reference frame, I did this:
        % I used a truck 3d scan to calculate the distance of the truck
        % centerline to vicon origin
            %"\\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-RAW\VIA Sled Tests\02_HIII_25mph\Scans\Truck_PreTest_Run02_6_14_24_withPoints.xrl"
        % Next, I imported the STL
        % I adjusted the STL's location until the truck centerline STL
        % matched the desired point from Vicon
        % I adjusted the STL's location in Main_Silverado.m 
    % These were mostly quick, by-eye calculations. This process assumes
        % that the STL and Vicon's coordinate systems were square with each
        % other, which should be a pretty good assumption.

% Calculate truck centerline point for matching STL to
    % Calculated from scan as described above
% truck_centerline_x = Ped_Data.Run_02.Vicon.Base3.X + 450.6;
% truck_centerline_y = Ped_Data.Run_02.Vicon.Base3.Y - 1261.6;
% truck_centerline_z =Ped_Data.Run_02.Vicon.Base3.Z + 1331.9;
    % Commented out because this point was used for positioning the stl,
    % but it is not needed for visualization of the test
% plot3(truck_centerline_x,truck_centerline_y,truck_centerline_z,'bx','linewidth',1)

%% Functions:

%% Save function

function save_fig(plot_title)
    fig_name = strcat('\\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-ANALYZED\Experimental Results\Vicon\',plot_title,'.fig');
    png_name = strrep(fig_name,'fig','png');
    saveas(gcf,fig_name);
    print(gcf, png_name, '-dpng', '-r900'); % specify higher resolution png photo with r900
end

%% 3D plotting function
    % Given a vicon marker data, plot the x, y, and z 
function plot3d_points(data,color,display_name,line_style)
    if strcmp(display_name, 'no legend')
        plot3(data.X,data.Y,data.Z,'Color',color,'HandleVisibility','off','LineStyle',line_style,'LineWidth',1)
    else
        plot3(data.X,data.Y,data.Z,'Color',color,'DisplayName',display_name,'LineStyle',line_style,'LineWidth',1)
    end
end

%% Plot the origin markers and the XYZ axis for vicon
function plot_origin_and_axis(Ped_Data)

    hold on
    plot3d_points(Ped_Data.Run_02.Vicon.Base1,'b','no legend','-')
    plot3d_points(Ped_Data.Run_02.Vicon.Base2,'b','no legend','-')
    plot3d_points(Ped_Data.Run_02.Vicon.Base3,'r','no legend','-')
    plot3d_points(Ped_Data.Run_02.Vicon.Base4,'b','no legend','-')
    
    plot_xyz_axis(Ped_Data.Run_02.Vicon.Base4,Ped_Data.Run_02.Vicon.Base3,'+X')
    plot_xyz_axis(Ped_Data.Run_02.Vicon.Base4,Ped_Data.Run_02.Vicon.Base2,'+Y')
    % Make a point that is above the origin by 100mm for displaying the Z axis
        z_vector = Ped_Data.Run_02.Vicon.Base4;
        z_vector.Z(1) = z_vector.Z(1) + 90;
    plot_xyz_axis(Ped_Data.Run_02.Vicon.Base4,z_vector,'+Z')
end

%% Plot +X, +Y, or +Z Vector
function plot_xyz_axis(marker_1,marker_2,axis_name)

    % Extract the coordinates for the start and end points of the vector
    x1 = marker_1.X(1);
    y1 = marker_1.Y(1);
    z1 = marker_1.Z(1);
    
    x2 = marker_2.X(1);
    y2 = marker_2.Y(1);
    z2 = marker_2.Z(1);
    
    % Calculate the direction vector
    dx = x2 - x1;
    dy = y2 - y1;
    dz = z2 - z1;
    
    % Scale the direction vector to make it 6 times longer
    x2_new = x1 + 5 * dx;
    y2_new = y1 + 5 * dy;
    z2_new = z1 + 5 * dz;
    
    % Plot the extended vector with an arrow
    quiver3(x1, y1, z1, 4*dx, 4*dy, 4*dz, 'k', 'LineWidth', 2, 'MaxHeadSize', 0.5,'HandleVisibility','off');
    
    % Add a text label "+X" near the end point of the vector
    text(x2_new, y2_new, z2_new, axis_name, 'FontSize', 12, 'Color', 'k', 'HorizontalAlignment', 'right');

end 

%% Display the marker name (ex: 'Head COG') at the start of the plotted line
function display_line_name(data,line_name)
    firstNonNanIndex = find(~isnan(data.X), 1, 'first');
    text(data.X(firstNonNanIndex),data.Y(firstNonNanIndex),data.Z(firstNonNanIndex),line_name ,'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 8, 'Color', 'k')
end
