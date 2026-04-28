t_points = [0,  12,  12+5,  12+5+2, ... 
            10+6, 10+6+2, 20, ...
            22, 26, 27, 28, ... 
            30, 33];            

x_points = [0,  4.7+4.6,  0,  0, ...  % Cycle 1: Goes all the way to 6
            4.7,  0,  0, ...      % Cycle 2: Only goes halfway (to 3)
            4.7,  4.7+4.6,  4.7,  0, ...  % Cycle 3: Midpoint, completes to 6, returns to 0
            0,  0];             % Home: Stays at 0

% Z-axis waypoints
z_points = [0,  0,  0,  3, ...  % Cycle 1: Base level, steps to Z=1
            3,  3,  6, ...      % Cycle 2: Stays at Z=1, steps to Z=2
            6.1, 6.1, 6, 6,... % Cycle 3: Dips to 1.5, holds, spikes to 2.5, settles
            3,  0];             % Home: Holds at 2, then smoothly drops to 0

t_smooth = 0:0.01:33;

x_smooth = pchip(t_points, x_points, t_smooth);
z_smooth = pchip(t_points, z_points, t_smooth);

x_signal = timeseries(x_smooth, t_smooth);
z_signal = timeseries(z_smooth, t_smooth);

figure;
plot(t_smooth, x_smooth, 'b', t_smooth, z_smooth, 'r', 'LineWidth', 2);

legend('X Position (Forward/Back)', 'Z Position (Up/Down dips)');
xlabel('Time (s)'); 
ylabel('Position');
title('40s Custom Robot Trajectory with Mid-Path Z-Dips');
grid on;

t_theta = [0, 21, 22, 23, 26, 26.5, 27, 27.5, 28, 33];
theta_deg = [0,  0,  2,  0,  0,    0, -2,    0,  0,  0];

theta_rad = theta_deg * (pi / 180);

theta_smooth = pchip(t_theta, theta_rad, t_smooth);

theta_signal = timeseries(theta_smooth, t_smooth);

figure;
plot(t_smooth, x_smooth, 'b', t_smooth, z_smooth, 'r', ...
     t_smooth, theta_smooth * (180/pi), 'k', 'LineWidth', 2);
legend('X Position (m)', 'Z Position (m)', 'Theta Rotation (Degrees)');
xlabel('Time (s)'); 
ylabel('Amplitude');
title('40s Custom Trajectory with Timed Theta Rotations');
grid on;