%% JHU INTRODUCTION TO AUGMENTED REALITY (2026)
%% Q1e. 1D Kalman Filter for Position and Velocity Estimation
%
% State x = [position; velocity], acceleration is the control input u.

clear; clc; close all;

% Simulation parameters
dt = 0.1;        % time step
num_steps = 50;

% System model
A = [1 dt;
     0 1];            % state transition matrix
B = [0.5*dt^2;
     dt];             % control matrix (acceleration input)
H = [1 0];            % measurement matrix (we measure position only)

% Process and measurement noise
sigma_process = 0.5;
sigma_measure = 2.0;
Q = sigma_process^2 * [dt^4/4, dt^3/2;
                       dt^3/2, dt^2];   % process noise covariance
R = sigma_measure^2;                    % measurement noise covariance

% Initialize
x_true = [0.0; 1.0];   % true initial state (position, velocity)
x_est  = [0.0; 0.0];   % estimated initial state
P = eye(2) * 1.0;      % initial covariance

% Plotting arrays
true_positions      = zeros(1, num_steps);
measured_positions  = zeros(1, num_steps);
estimated_positions = zeros(1, num_steps);

% Process noise generator. Q is rank-1 (singular), so instead of chol(Q)
% we use G*randn, where G = [dt^2/2; dt] gives exactly Cov = sigma^2 * G*G' = Q.
% (Equivalent to mvnrnd(mu, Q) but needs no Statistics Toolbox.)
G = [dt^2/2; dt];
noise_mean = [0.1; 0];   % mean offset kept from the original Python code

% Simulation loop
for k = 1:num_steps
    % True system evolution
    a = 2.0;  % constant acceleration
    process_noise = noise_mean + G * sigma_process * randn();
    x_true = A * x_true + B * a + process_noise;

    % Noisy measurement
    measurement_noise = sigma_measure * randn();
    z = H * x_true + measurement_noise;

    % ---------------- Kalman Filter steps ----------------

    % 1. Prediction
    x_pred = A * x_est + B * a;          % Eq. (1)
    P_pred = A * P * A' + Q;             % Eq. (2)

    % 2. Update
    K     = P_pred * H' / (H * P_pred * H' + R);   % Eq. (3) Kalman gain
    x_est = x_pred + K * (z - H * x_pred);         % Eq. (4) corrected state
    P     = (eye(2) - K * H) * P_pred;             % Eq. (5) corrected covariance

    % Save plotting arrays
    true_positions(k)      = x_true(1);
    measured_positions(k)  = z;
    estimated_positions(k) = x_est(1);
end

% Plot
t = (0:num_steps-1) * dt;
figure('Position', [100 100 1000 500]);
plot(t, true_positions, 'g-', 'LineWidth', 2); hold on;
plot(t, measured_positions, 'b*');
plot(t, estimated_positions, 'r.', 'MarkerSize', 14);
xlabel('Time [s]');
ylabel('Position');
title('1D Kalman Filter Simulation (Position-Velocity Model)');
legend('True Position', 'Measured (Noisy)', 'KF Estimated Position', ...
       'Location', 'northwest');
grid on;