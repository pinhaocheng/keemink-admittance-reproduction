function systems = baselineSystems(params)
%BASELINESYSTEMS Build the transfer functions needed for the Figure 6a recreation.

arguments
    params struct = keemink.paperBaselineParams()
end

s = tf("s");

Kp = params.kp * params.kr^2;
Ki = params.ki * params.kr^2;
[num, den] = keemink.naiveFeedbackOnlyCoeffs( ...
    params.mv, params.mr, params.mps, params.br, Kp, Ki);

[passive_num, passive_den] = keemink.naiveFeedbackOnlyCoeffs( ...
    params.mv, params.mr, params.mps, params.br, ...
    params.passive.Kp, params.passive.Ki);

systems = struct();
systems.virtual = 1 / (params.mv * s);
systems.apparent = tf(num, den);
systems.passive = tf(passive_num, passive_den);
systems.robot_apparent = 1 / (((params.mr + params.mps) * s) + params.br);
systems.robot_presensor = 1 / ((params.mr * s) + params.br);
end
