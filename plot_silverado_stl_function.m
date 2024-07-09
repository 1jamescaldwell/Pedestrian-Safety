% close all;clc
%% Read .stl file
dirnm=[cd];
stldir=dirnm;
stlfnm='stl_Silverado.stl';
stlformat=1; %1: ascii, 2:binary
switch stlformat
    case 1
        [Ytemp.vertices,Ytemp.faces,Ytemp.normals]=import_stl_fast([stldir '\' stlfnm],1);
    case 2
        Ytemp=stlread([stldir stlfnm]);
end
Vehicle.faces=Ytemp.faces;
Vehicle.vertices=Ytemp.vertices;

%% Translate the STL into Vicon reference frame
    % This was done by hand
Vehicle.vertices(:, 1) = Vehicle.vertices(:, 1) + 610;
Vehicle.vertices(:, 2) = Vehicle.vertices(:, 2) -1261; % Move Y
Vehicle.vertices(:, 3) = Vehicle.vertices(:, 3) + 216;

%% Stl plot
% figure;
hold all
patch(Vehicle,'FaceColor',[0.35 0.35 0.35],'EdgeColor','none','FaceAlpha',0.1, ...
    'FaceLighting',    'gouraud',     ...
     'AmbientStrength', 1,'HandleVisibility','off');
% view([0 1 0])
camproj('perspective'); % set perspective projection
axis equal
xlabel('X [mm]');
ylabel('Y [mm]');
zlabel('Z [mm]');
% view([1 0 5])
set(gca,'fontsize',18)

% origin
% plot3(0,0,0,'bx','linewidth',2)
%%