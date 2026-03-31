function output_path = makeFigure15a()
%MAKEFIGURE15A Recreate the flexible-robot Bode plot (Keemink Figure 15a).

params = keemink.paperBaselineParams();
systems = keemink.baselineSystems(params);

if ~exist(params.output_dir, "dir")
    mkdir(params.output_dir);
end

freq_hz = params.freq_hz;

%% Flexible robot parameters
gamma_val = 0.5;
ks_val = 1000;   % N/m
bs_val = 100;    % Ns/m

%% Baseline parameters
mv = params.mv;
mr = params.mr;
mps = params.mps;
br = params.br;
kp = params.kp;
ki = params.ki;
kr = params.kr;
Kp = kp * kr^2;
Ki = ki * kr^2;

%% Appendix 4 coefficient form
z40 = mr * mv * (1 - gamma_val);
z30 = (Kp + br + bs_val) * mv;
z20 = (Ki + ks_val) * mv + bs_val * kp * kr;
z10 = bs_val * ki * kr + kp * kr * ks_val;
z00 = ki * kr * ks_val;

z4 = mv * mr^2 * (gamma_val - gamma_val^2) + mps * mv * mr * (1 - gamma_val);
z3 = ((Kp + br + bs_val) * mps + bs_val * mr + (Kp + br) * gamma_val * mr) * mv;
z2 = (br * bs_val + (Ki + ks_val) * mps + ks_val * mr + bs_val * Kp + gamma_val * Ki * mr) * mv + ...
    bs_val * kp * kr * mps;
z1 = ((Kp + br) * ks_val + bs_val * Ki) * mv + (bs_val * ki + kp * ks_val) * kr * mps;
z0 = Ki * ks_val * mv + ki * ks_val * mps * kr;

Ya_flex = tf([z40, z30, z20, z10, z00], [z4, z3, z2, z1, z0, 0]);

% Physical flexible robot dynamics with the controller disabled.
A = mr * (1 - gamma_val) * tf("s") + br;
C = bs_val + ks_val / tf("s");
Yr_flex = minreal(1 / (((mr * gamma_val + mps) * tf("s")) + C - (C^2) / (A + C)), 1e-8);

%% Reference curves
Yv_plot = tf([1], [mv, 0]);
Ya_bar = systems.apparent;

curves = [ ...
    struct("sys", Yv_plot,               "label", "$Y_v$",                  "color", [0.8500, 0.3250, 0.0980], "style", "-",  "width", 1.8), ...
    struct("sys", Ya_flex,               "label", "$Y_a$ (flexible)",       "color", [0.0000, 0.4470, 0.7410], "style", "-",  "width", 1.8), ...
    struct("sys", Ya_bar,                "label", "$\bar{Y}_a$ (baseline)", "color", [0.0000, 0.4470, 0.7410], "style", "--", "width", 1.4), ...
    struct("sys", Yr_flex,               "label", "$Y_r$",                  "color", [0.4660, 0.6740, 0.1880], "style", "-",  "width", 1.8) ...
    ];

fig = figure( ...
    "Color", "w", ...
    "Position", [120, 120, 820, 720], ...
    "MenuBar", "none", ...
    "ToolBar", "none", ...
    "Name", "Keemink Figure 15a Recreation");

tiledlayout(fig, 2, 1, "TileSpacing", "compact", "Padding", "compact");

ax1 = nexttile;
hold on;
for idx = 1:numel(curves)
    [mag_db, ~] = keemink.bodeData(curves(idx).sys, freq_hz);
    semilogx(freq_hz, mag_db, curves(idx).style, "LineWidth", curves(idx).width, ...
        "Color", curves(idx).color, ...
        "DisplayName", curves(idx).label);
end
grid on;
xlim([freq_hz(1), freq_hz(end)]);
ylim([-80, 20]);
ylabel("Admittance [dB]");
legend("Interpreter", "latex", "Location", "southwest", "NumColumns", 2);
title("Figure 15a Recreation", "FontWeight", "bold");
subtitle("$\gamma = 0.5$, $k_s = 1000$ N/m, $b_s = 100$ Ns/m", "Interpreter", "latex");
ax1.XScale = "log";
ax1.XTick = [1e-2, 1e-1, 1, 10, 100];
ax1.XTickLabel = [];
ax1.Box = "on";

ax2 = nexttile;
hold on;
for idx = 1:numel(curves)
    [~, phase_deg] = keemink.bodeData(curves(idx).sys, freq_hz);
    semilogx(freq_hz, phase_deg, curves(idx).style, "LineWidth", curves(idx).width, ...
        "Color", curves(idx).color, ...
        "DisplayName", curves(idx).label);
end
grid on;
xlim([freq_hz(1), freq_hz(end)]);
ylim([-180, 180]);
yticks(-180:90:180);
xlabel("Frequency [Hz]");
ylabel("Phase [deg]");
ax2.XScale = "log";
ax2.XTick = [1e-2, 1e-1, 1, 10, 100];
ax2.Box = "on";

png_path = fullfile(params.output_dir, "fig15a_flexible_bode.png");
fig_path = fullfile(params.output_dir, "fig15a_flexible_bode.fig");

exportgraphics(fig, png_path, "Resolution", 200);
savefig(fig, fig_path);
close(fig);

output_path = string(png_path);
end
