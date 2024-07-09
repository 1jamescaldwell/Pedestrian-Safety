% Plot base markers
    % Used in main_import for fixing Run 01 Coordinate systems
close all 
hold on
plot3d_points(Ped_Data.Run_01.Vicon.Base1,'r')
plot3d_points(Ped_Data.Run_01.Vicon.Base2,'b')
plot3d_points(Ped_Data.Run_01.Vicon.Base3,'g')
plot3d_points(Ped_Data.Run_01.Vicon.Base4,'k')

x1 = mean(Ped_Data.Run_01.Vicon.Base1.X(1:200));
x2 = mean(Ped_Data.Run_01.Vicon.Base2.X(1:200));

y1 = mean(Ped_Data.Run_01.Vicon.Base2.Y(1:200));
y2 = mean(Ped_Data.Run_01.Vicon.Base3.Y(1:200));

dx = x1 - x2
dy = y1 - y2
%% 3D plotting function
    % Given a vicon marker name, plot the x, y, and z 
function plot3d_points(data,color)
    plot3(data.X,data.Y,data.Z,color)
end