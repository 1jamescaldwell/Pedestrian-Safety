% Vicon Calculate Head Completeness
% James Caldwell, UVA CAB
% 7/5/24

% This script was used to determine the percentage of the HIII's head
% markers were lost at one point during the trajectory

close all

% Run 1
X1 = Ped_Data.Run_01.Vicon_Trimmed.HeadRight1.X(1:end);
X2 = Ped_Data.Run_01.Vicon_Trimmed.HeadLeft1.X(1:end);
X3 = Ped_Data.Run_01.Vicon_Trimmed.HeadAnterior1.X(1:end);
X4 = Ped_Data.Run_01.Vicon_Trimmed.HeadPosterior1.X(1:end);
vicon_head_calc(X1,X2,X3,X4,'Run 01')
save_fig('Run 1')

% Run 2
X1 = Ped_Data.Run_02.Vicon_Trimmed.HeadRight1.X(1:end);
X2 = Ped_Data.Run_02.Vicon_Trimmed.HeadLeft1.X(1:end);
X3 = Ped_Data.Run_02.Vicon_Trimmed.HeadAnterior1.X(1:end);
X4 = Ped_Data.Run_02.Vicon_Trimmed.HeadPosterior1.X(1:end);
vicon_head_calc(X1,X2,X3,X4,'Run 02')
save_fig('Run 2')

% Run 3
X1 = Ped_Data.Run_03.Vicon_Trimmed.HeadRight1.X(1:4500);
X2 = Ped_Data.Run_03.Vicon_Trimmed.HeadLeft1.X(1:4500);
X3 = Ped_Data.Run_03.Vicon_Trimmed.HeadAnterior1.X(1:4500);
X4 = Ped_Data.Run_03.Vicon_Trimmed.HeadPosterior1.X(1:4500);
vicon_head_calc(X1,X2,X3,X4,'Run 03')
save_fig('Run 3')

% Run 4
X1 = Ped_Data.Run_04.Vicon_Trimmed.HeadRight1.X(1:4500);
X2 = Ped_Data.Run_04.Vicon_Trimmed.HeadLeft1.X(1:4500);
X3 = Ped_Data.Run_04.Vicon_Trimmed.HeadAnterior1.X(1:4500);
X4 = Ped_Data.Run_04.Vicon_Trimmed.HeadPosterior1.X(1:4500);
vicon_head_calc(X1,X2,X3,X4,'Run 04')
save_fig('Run 4')

function vicon_head_calc(X1,X2,X3,X4,run_name)

    % Initialize a figure
    figure;
    
    % Define the number of frames (assumed to be 7000)
    numFrames = length(X1);
    
    % Create bar plots for each variable
    subplot(4, 1, 1);
    createBarPlot(X1, numFrames);
    title('HeadRight1.X');
    
    subplot(4, 1, 2);
    createBarPlot(X2, numFrames);
    title('HeadLeft1.X');
    
    subplot(4, 1, 3);
    createBarPlot(X3, numFrames);
    title('HeadAnterior1.X');
    
    subplot(4, 1, 4);
    createBarPlot(X4, numFrames);
    title('HeadPosterior1.X');
    
    % Add an overall title to the figure
    sgtitle(run_name);

    % Calculate the percentage of frames where at least 3 variables have values
    validFrames = sum(~isnan(X1) + ~isnan(X2) + ~isnan(X3) + ~isnan(X4) >= 3);
    percentage = (validFrames / numFrames) * 100;
    
    fprintf('Percentage of frames with at least 3 variables having values for %s: %.2f%%\n', run_name, percentage);

end

% Function to create a vertical bar plot with colored bars based on presence of data
function createBarPlot(data, numFrames)
    colors = zeros(numFrames, 3); % Initialize colors array
    for i = 1:numFrames
        if isnan(data(i))
            colors(i, :) = [1, 0, 0]; % Red for NaN
        else
            colors(i, :) = [0, 1, 0]; % Green for non-NaN
        end
    end
    b = bar(1:numFrames, ones(1, numFrames), 'FaceColor', 'flat', 'EdgeColor', 'none');
    b.CData = colors;
    xlim([0 numFrames+1]);
end

% Save function
function save_fig(plot_title)
    png_name = strcat('\\cab-fs07.mae.virginia.edu\NewData\NHTSA\2023_Pedestrian_NCAP\1Data-ANALYZED\Experimental Results\Vicon\Completness of vicon data\',plot_title,'.png');
    saveas(gcf, png_name);
end
