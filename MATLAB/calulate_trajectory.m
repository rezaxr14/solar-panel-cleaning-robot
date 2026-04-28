t_points = [0,  3,  6,  8, ...  % Cycle 1 (Ends at Z = 1)
            11, 14, 16, ...     % Cycle 2 (Ends at Z = 2)
            19, 22, 24, ...     % Cycle 3 (Ends at Z = 3)
            28];                % Return to Base (Ends at Z = 0)

x_points = [0,  4.8,  0,  0, ...  % Cycle 1
            4.8,  0,  0, ...      % Cycle 2
            4.8,  0,  0, ...      % Cycle 3
            0];                 % Return to Base (stays at 0)

z_points = [0,  0,  0,  6/2, ...  % Cycle 1
            6/2,  6/2,  12/2, ...      % Cycle 2
            12/2,  12/2,  6/2, ...      % Cycle 3
            0];                 % Return to Base (comes down to 0)

t_smooth = 0:0.01:max(t_points);

x_smooth = pchip(t_points, x_points, t_smooth);
z_smooth = pchip(t_points, z_points, t_smooth);

x_signal = timeseries(x_smooth, t_smooth);
z_signal = timeseries(z_smooth, t_smooth);

figure;
plot(t_smooth, x_smooth, 'b', t_smooth, z_smooth, 'r', 'LineWidth', 2);
legend('X Position (Forward/Back)', 'Z Position (Up/Down)');
xlabel('Time (s)'); 
ylabel('Position');
title('Smooth 3-Cycle Robot Trajectory (pchip Interpolation)');
grid on;



% 1. Calculate Linear Velocity (dx/dt)
dt = t_smooth(2) - t_smooth(1); % Time step (0.01s)
v_smooth = gradient(x_smooth, dt); % Linear velocity in m/s

gear_ratio = 25.4; % Motor converting rate
radius_cm = 3.0;   % Output shaft radius in cm
radius_m = radius_cm / 100.0; % Convert to meters (0.03 m)

omega_out = v_smooth / radius_m;

omega_motor = omega_out * gear_ratio;

rpm_motor = omega_motor * (60 / (2 * pi));

figure;
plot(t_smooth, rpm_motor, 'g', 'LineWidth', 2);
hold on;
yline(0, 'k-', 'LineWidth', 1);
hold off;

legend('Motor Speed (RPM)');
xlabel('Time (s)'); 
ylabel('RPM');
title('Motor Shaft RPM (3 cm Radius)');
grid on;

