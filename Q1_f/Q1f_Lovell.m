%% JHU INTRODUCTION TO AUGMENTED REALITY (2026)
%% 2026.10.21
%% Q1f. Kalman Filter with PREDICTION ONLY (no measurement correction)
%
% Same setup as Q1e, but the update/correction step is removed. The
% estimate is propagated purely with the model:
%     x_est = x_pred = A*x_est + B*u        (Eq. 1)
%     P     = P_pred = A*P*A' + Q           (Eq. 2)
% Measurements are still generated and plotted for comparison, but they
% are never used by the filter.
 
clear; clc; close all;
 
% rng(0);   % uncomment for a repeatable plot
 
% Simulation parameters
dt = 0.1;        % time step
num_steps = 50;
 
% System model
A = [1 dt;
     0 1];            % state transition matrix
B = [0.5*dt^2;
     dt];             % control matrix (acceleration input)
H = [1 0];            % measurement matrix (position only)
 
% Process and measurement noise
sigma_process = 0.5;
sigma_measure = 2.0;
Q = sigma_process^2 * [dt^4/4, dt^3/2;
                       dt^3/2, dt^2];   % process noise covariance
R = sigma_measure^2;                    % measurement noise covariance
 
% Initialize
x_true = [0.0; 1.0];   % true initial state (position, velocity)
x_est  = [0.0; 0.0];   % estimated initial state (velocity is wrong on purpose)
P = eye(2) * 1.0;      % initial covariance
 
% Plotting arrays
true_positions      = zeros(1, num_steps);
measured_positions  = zeros(1, num_steps);
estimated_positions = zeros(1, num_steps);
pos_std             = zeros(1, num_steps);   % sqrt of P(1,1), position uncertainty
 
% Process noise generator (Q is singular, so use G*randn instead of chol(Q))
G = [dt^2/2; dt];
noise_mean = [0.1; 0];   % mean offset kept from the original Python code
 
% Simulation loop
for k = 1:num_steps
    % True system evolution
    a = 2.0;  % constant acceleration
    process_noise = noise_mean + G * sigma_process * randn();
    x_true = A * x_true + B * a + process_noise;
 
    % Noisy measurement (generated for comparison only, NOT used by the filter)
    measurement_noise = sigma_measure * randn();
    z = H * x_true + measurement_noise;
 
    % ---------------- Kalman Filter: prediction only ----------------
 
    % 1. Prediction
    x_pred = A * x_est + B * a;          % Eq. (1)
    P_pred = A * P * A' + Q;             % Eq. (2)
 
    % 2. "Update" without measurements: keep the prediction as the estimate
    x_est = x_pred;
    P     = P_pred;
 
    % Save plotting arrays
    true_positions(k)      = x_true(1);
    measured_positions(k)  = z;
    estimated_positions(k) = x_est(1);
    pos_std(k)             = sqrt(P(1,1));
end
 
% Plot 1: position estimate vs truth
t = (0:num_steps-1) * dt;
figure('Position', [100 100 1000 500]);
plot(t, true_positions, 'g-', 'LineWidth', 2); hold on;
plot(t, measured_positions, 'b*');
plot(t, estimated_positions, 'r.', 'MarkerSize', 14);
xlabel('Time [s]');
ylabel('Position');
title('1D Kalman Filter: Prediction Only (No Measurement Correction)');
legend('True Position', 'Measured (Noisy, unused)', 'KF Predicted Position', ...
       'Location', 'northwest');
grid on;
 
% Plot 2: estimation error with +/-3 sigma bound from P
figure('Position', [100 100 1000 400]);
err = estimated_positions - true_positions;
plot(t, err, 'r-', 'LineWidth', 1.5); hold on;
plot(t,  3*pos_std, 'k--');
plot(t, -3*pos_std, 'k--');
xlabel('Time [s]');
ylabel('Position error (estimate - true)');
title('Prediction-Only Error and 3\sigma Uncertainty Bound (from P)');
legend('Error', '\pm3\sigma from P', 'Location', 'northwest');
grid on;