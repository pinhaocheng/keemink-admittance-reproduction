function Ya = rigidClosedLoopAdmittance(params, Yv, Cfb, options)
%RIGIDCLOSEDLOOPADMITTANCE Build the stiff-robot apparent admittance from the paper block diagram.

arguments
    params struct
    Yv
    Cfb
    options.Cff = 0
    options.Gf double = 0
    options.Compensation = 0
end

s = tf("s");
kr = params.kr;

Yv = tf(Yv);
Cfb = tf(Cfb);
Cff = tf(options.Cff);
compensation = tf(options.Compensation);

robot_impedance = ((params.mr + params.mps) * s) + params.br;
measured_force_feedback = -params.mps * s + compensation;
controller_drive = Cfb + Cff;

numerator = 1 + kr * options.Gf + kr^2 * controller_drive * Yv;
denominator = robot_impedance + kr^2 * Cfb - kr^2 * controller_drive * Yv * measured_force_feedback;

Ya = minreal(numerator / denominator, 1e-8);
end
