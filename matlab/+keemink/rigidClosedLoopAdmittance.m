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

% Keep pre-sensor robot and post-sensor mass separate so that Gf
% correctly scales Z_ps in the denominator (Keemink Appendix 3).
Y_r_int = 1 / (params.mr * s + params.br);   % pre-sensor robot admittance
Z_ps    = params.mps * s;                     % post-sensor impedance
D_ps    = Z_ps - compensation;                % residual after compensation

controller_drive = Cfb + Cff;

num_inner = kr * options.Gf + kr^2 * controller_drive * Yv + 1;
den_inner = kr^2 * controller_drive * Yv * D_ps ...
          + kr^2 * Cfb ...
          + Z_ps * (kr * options.Gf + 1);

Ya = minreal(Y_r_int * num_inner / (Y_r_int * den_inner + 1), 1e-8);
end
