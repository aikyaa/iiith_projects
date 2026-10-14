%P 2-link
%Assign the given masses and lengths

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

%P gains for all joints

P_values = [1, 10, 50, 100];

for i = 1:length(P_values)
kp1 = P_values(i);
kp2 = P_values(i);

%Initial conditions for the ODE solver
IC = [q10, q20, q1dot0, q2dot0];

%Options for the ODE solver
options = odeset('RelTol', 1e-3, 'AbsTol', 1e-6);

%Solve the system of ODEs using ode45
[time, state_values] = ode45(@(t,s) p_2link(t, s, q1_fin, q2_fin, m1, m2, l1, l2, g, kp1, kp2), tspan, IC, options);

%Extract the joint angles and velocities from the state values
q1 = state_values(:,1);
q2 = state_values(:,2);

%Plot the joint angles over time
figure;
subplot(2,1,1);
plot(time, q1, 'r', 'LineWidth', 1.5);
title('Joint Angle 1 vs Time');
xlabel('Time (s)');
ylabel('Angle (rad)');
subplot(2,1,2);
plot(time, q2, 'b', 'LineWidth', 1.5);
title('Joint Angle 2 vs Time');
xlabel('Time (s)');
ylabel('Angle (rad)');

%Plot error over time
e1 = q1_fin - q1;
e2 = q2_fin - q2;

figure;
subplot(2,1,1);
plot(time, e1, 'r', 'LineWidth', 1.5);
title('Error in Joint Angle 1 vs Time');
xlabel('Time (s)');
ylabel('Error (rad)');
subplot(2,1,2);
plot(time, e2, 'b', 'LineWidth', 1.5);
title('Error in Joint Angle 2 vs Time');
xlabel('Time (s)');
ylabel('Error (rad)');

end