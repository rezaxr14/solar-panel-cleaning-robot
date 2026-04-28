t_points = [0,  6,  8,  10, ... % Cycle 1 (Ends at t=10, Z=1)
            16, 18, 20, ...     % Cycle 2 (Ends at t=20, Z=2)
            26, 28, 30, ...     % Cycle 3 (Ends at t=30, Z=3)
            40];                % Return to Base (Takes 10s, Ends at t=40)

x_points = [0,  4.8,  0,  0, ...  % Cycle 1
            4.8,  0,  0, ...      % Cycle 2
            4.8,  0,  0, ...      % Cycle 3
            0];                 % Return to Base (stays at 0)

z_points = [0,  0,  0,  3, ...  % Cycle 1
            3,  3,  6, ...      % Cycle 2
            6,  6,  3, ...      % Cycle 3
            0];                 % Return to Base (comes down to 0)

t_smooth = 0:0.01:40;

x_smooth = pchip(t_points, x_points, t_smooth);
z_smooth = pchip(t_points, z_points, t_smooth);

x_signal = timeseries(x_smooth, t_smooth);
z_signal = timeseries(z_smooth, t_smooth);

figure;
plot(t_smooth, x_smooth, 'b', t_smooth, z_smooth, 'r', 'LineWidth', 2);
legend('X Position (Slow Forward / Fast Back)', 'Z Position (Up/Down)');
xlabel('Time (s)'); 
ylabel('Position');
title('40-Second Robot Trajectory (Asymmetric Speeds)');
grid on;

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
