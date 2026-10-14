%PI code
function output = pi_2link(~, s, q1_fin, q2_fin, m1, m2, l1, l2, g, kp1, kp2, ki1, ki2)
    %Declare the state variables [q1, q2, u1, u2, q1dot, q2dot]
    q1 = s(1); q2 = s(2);
    u1 = s(3); u2 = s(4);
    q1dot = s(5); q2dot = s(6);

    %PI Control Errors
    e1 = q1_fin - q1;
    e2 = q2_fin - q2;

    %PI control inputs
    f1 = kp1 * e1 + ki1 * u1;
    f2 = kp2 * e2 + ki2 * u2;

    %Mass matrix for the 2-link system
    M11 = (m1 + m2) * (l1*l1) + m2 * l2*(l2 + 2 * l1 * cos(q2));
    M22 = m2 * l2*l2;
    M12 = m2*l2*(l2+l1*cos(q2));
    M21 = M12;

    %Create the Mass matrix M (2x2)
    M = [M11, M12; M21, M22];

    %Coriolis and Centrifugal Matrix
    c11 = -m2 * l1 * l2 * sin(q2) * q2dot;
    c12 = -m2 * l1 * l2 * sin(q2) * (q1dot + q2dot);
    c22 = m2 * l1 * l2 * sin(q2) * q2dot;
    c21 = 0;

    %Create the Coriolis and Centrifugal matrix C (2x2)
    C = [c11, c12; c21, c22];

    %Gravitational Matrix
    G1 = m1 * g * l1 * cos(q1) + m2 * g * (l1 * cos(q1) + l2 * cos(q1 + q2));
    G2 = m2 * g * l2 * cos(q1 + q2);

    %Create the Gravitational matrix G (2x1)
    G = [G1; G2];

    %Control input vector (torques)
    f = [f1; f2];

    %Joint velocities and accelerations
    q_dot_matrix = [q1dot; q2dot];
    q_double_dot_matrix = inv(M) * (- C * q_dot_matrix - G) + f;

    %Convert double dot matrix to a row vector
    q_double_dot_matrix_row_1 = q_double_dot_matrix(1);
    q_double_dot_matrix_row_2 = q_double_dot_matrix(2);
    %Output the time derivatives of the state variables
    output = [q1dot; q2dot; e1; e2; q_double_dot_matrix_row_1; q_double_dot_matrix_row_2];
end