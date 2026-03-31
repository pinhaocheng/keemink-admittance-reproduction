function params = paperBaselineParams()
%PAPERBASELINEPARAMS Baseline rigid-robot parameters from Keemink Table 1.

project_root = fileparts(fileparts(fileparts(mfilename("fullpath"))));

params = struct();
params.project_root = project_root;
params.output_dir = fullfile(project_root, "outputs", "figures");
params.freq_hz = logspace(-2, 2, 800);

params.mv = 2;
params.kr = 1;
params.mr = 10;
params.mps = 2;
params.br = 5;
params.kp = 100;
params.ki = 2000;

passive_Kp = params.br * params.mv / (params.mr - params.mv);

params.passive = struct();
params.passive.Kp = passive_Kp;
params.passive.Ki = 0;
params.passive.kp = passive_Kp / params.kr^2;
params.passive.ki = 0;
end
