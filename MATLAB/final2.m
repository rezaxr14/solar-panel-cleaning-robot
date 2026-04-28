t_points = [0,  12,  12+5,  12+5+2, ... % Cycle 1: Full Forward, Fast Back, Z-Step
            12+5+2+6, 12+5+2+6+2, 12+5+2+6+2+2, ...     % Cycle 2: Half Forward, Fast Back, Z-Step
            33, 33+6, 39+2, 41+2, ... % Cycle 3: Z-dip, finish X, Z-spike halfway back
            43+2, 43+4];            % Return to Base: Hold briefly, then Z drops to 0

x_points = [0,  4.7+4.6,  0,  0, ...  % Cycle 1: Goes all the way to 6
            4.7,  0,  0, ...      % Cycle 2: Only goes halfway (to 3)
            4.7,  4.7+4.6,  4.7,  0, ...  % Cycle 3: Midpoint, completes to 6, returns to 0
            0,  0];             % Home: Stays at 0

z_points = [0,  0,  0,  3, ...  % Cycle 1: Base level, steps to Z=1
            3,  3,  6, ...      % Cycle 2: Stays at Z=1, steps to Z=2
            6.1, 6.1, 6, 6,... % Cycle 3: Dips to 1.5, holds, spikes to 2.5, settles
            3,  0];             % Home: Holds at 2, then smoothly drops to 0

t_smooth = 0:0.01:47;

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
t_theta = [0, 32.7, 33, 33.3, 40, 40.85, 41, 41.15, 45 47];
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

% 7. Print the maximum required motor speeds
fprintf('Max Forward Motor Speed: %.2f RPM\n', max(rpm_motor));
fprintf('Max Reverse Motor Speed: %.2f RPM\n', abs(min(rpm_motor)));