function ground = plot_ground_function()

    % Define the four points
P1 = [0,0,257.69];
P2 = [3000, 0, 257.69];
P3 = [3000, -2500, 257.69];
P4 = [0, -2500, 257.69];

% Use three points to define the plane
% Calculate two vectors on the plane
v1 = P2 - P1;
v2 = P3 - P1;

% Calculate the normal vector to the plane
normal = cross(v1, v2);

% Plane equation: normal(1)*X + normal(2)*Y + normal(3)*Z = D
D = dot(normal, P1);

% Define a grid over the desired plotting range
[xGrid, yGrid] = meshgrid(linspace(min([P1(1), P2(1), P3(1), P4(1)]) - 1, max([P1(1), P2(1), P3(1), P4(1)]) + 1, 10), ...
                          linspace(min([P1(2), P2(2), P3(2), P4(2)]) - 1, max([P1(2), P2(2), P3(2), P4(2)]) + 1, 10));

% Solve for Z over the grid
zGrid = (D - normal(1) * xGrid - normal(2) * yGrid) / normal(3);

% Plot the points
% figure;
% plot3(P1(1), P1(2), P1(3), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
% hold on;
% plot3(P2(1), P2(2), P2(3), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
% plot3(P3(1), P3(2), P3(3), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
% plot3(P4(1), P4(2), P4(3), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');

% Plot the plane
% surf(xGrid, yGrid, zGrid, 'FaceAlpha', 0.5);
ground = surf(xGrid, yGrid, zGrid, 'FaceColor', [0.5, 0.5, 0.5], 'FaceAlpha', .3, 'EdgeColor', 'none','HandleVisibility','off');


end