%PI 2-link
%Assign masses and lengths
m1 = 10; % Mass of link 1
m2 = 5;  % Mass of link 2
l1 = 0.2; % Length of link 1
l2 = 0.1; % Length of link 2
g = 9.81; % Gravitational acceleration

%Initial values for joint angles and velocities
x10 = 0; % Initial integral error for joint 1
x20 = 0; % Initial integral error for joint 2
q10 = 0.1;  % Initial angle of link 1
q20 = 0.1;  % Initial angle of link 2
q1dot0 = 0;  % Initial angular velocity of link 1
q2dot0 = 0;  % Initial angular velocity of link 2

%Time span for the simulation
t0 = 0;
tf = 10;
tspan = [t0, tf];

%Desired final angles for all joints
q1_fin = 0;
q2_fin = 0;

%PI gains for all joints
% kp1 = 10; ki1 = 0;
% kp2 = 10; ki2 = 0;
% kp1 = 50; ki1 = 0;
% kp2 = 50; ki2 = 0;
% kp1 = 100; ki1 = 0;
% kp2 = 100; ki2 = 0;
% kp1 = 500; ki1 = 0;
% kp2 = 500; ki2 = 0;
% kp1 = 500; ki1 = 1;
% kp2 = 500; ki2 = 1;
% kp1 = 500; ki1 = 10;
% kp2 = 500; ki2 = 10;
kp1 = 500; ki1 = 50;
kp2 = 500; ki2 = 50;

%Initial conditions for the ODE solver
IC = [q10, q20, x10, x20, q1dot0, q2dot0];

%Options for the ODE solver
options = odeset('RelTol', 1e-3, 'AbsTol', 1e-6);

%Solve the system of ODEs using ode45
[time, state_values] = ode45(@(t,s) pi_2link(t, s, q1_fin, q2_fin, m1, m2, l1, l2, g, kp1, kp2, ki1, ki2), tspan, IC, options);

%Extract the joint angles and velocities from the state values
q1 = state_values(:,1);
q2 = state_values(:,2);
e1 = q1_fin - q1;
e2 = q2_fin - q2;
%Plot the joint angles over time
figure;
subplot(2,1,1);
plot(time, q1, 'b', 'LineWidth', 1.5);
title('Joint Angle q1 vs Time');
xlabel('Time (s)');
ylabel('Joint Angle q1 (rad)');
grid on;
subplot(2,1,2);
plot(time, q2, 'r', 'LineWidth', 1.5);
title('Joint Angle q2 vs Time');
xlabel('Time (s)');
ylabel('Joint Angle q2 (rad)');
grid on;

%Error Plots
figure;
subplot(2,1,1);
plot(time, e1, 'b', 'LineWidth', 1.5);
title('Error e1 vs Time');
xlabel('Time (s)');
ylabel('Error e1 (rad)');
grid on;
subplot(2,1,2);
plot(time, e2, 'r', 'LineWidth', 1.5);
title('Error e2 vs Time');
xlabel('Time (s)');
ylabel('Error e2 (rad)');
grid on;
