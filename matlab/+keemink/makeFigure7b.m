function output_path = makeFigure7b()
%MAKEFIGURE7B Recreate the stiffness-control Bode plot from Keemink Figure 7b.

params = keemink.paperBaselineParams();
systems = keemink.baselineSystems(params);

if ~exist(params.output_dir, "dir")
    mkdir(params.output_dir);
end

freq_hz = params.freq_hz;

% --- Stiffness control parameters ---
kv = 1000;                          % virtual stiffness [N/m]
Kp = params.kp * params.kr^2;
Ki = params.ki * params.kr^2;

% Virtual admittance: Yv = s / kv
s = tf("s");
Yv = s / kv;

% Apparent admittance (Appendix 3, stiffness case):
%   Ya = (Kp*s^2 + (Ki+kv)*s) / (Kp*mps*s^3 + gamma2*s^2 + (Kp+br)*kv*s + Ki*kv)
gamma2 = (params.mr + params.mps) * kv + Ki * params.mps;
Ya_num = [Kp, Ki + kv, 0];
Ya_den = [Kp * params.mps, gamma2, (Kp + params.br) * kv, Ki * kv];
Ya = tf(Ya_num, Ya_den);

% --- Curves to plot ---
    curves = [ ...
        struct("sys", Yv,               "label", "$Y_v$",          "color", [0.8500, 0.3250, 0.0980], "style", "-",  "width", 1.8), ...
        struct("sys", Ya,               "label", "$Y_a$ (stiff.)", "color", [0.0000, 0.4470, 0.7410], "style", "-",  "width", 1.8), ...
        struct("sys", systems.robot_apparent, "label", "$Y_r$",    "color", [0.4660, 0.6740, 0.1880], "style", "-",  "width", 1.8) ...
        ];

% --- Figure ---
fig = figure( ...
    "Color", "w", ...
    "Position", [120, 120, 820, 720], ...
    "MenuBar", "none", ...
    "ToolBar", "none", ...
    "Name", "Keemink Figure 7b Recreation");

tiledlayout(fig, 2, 1, "TileSpacing", "compact", "Padding", "compact");

% Magnitude
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
title("Figure 7b Recreation", "FontWeight", "bold");
subtitle("passive stiffness control (k_v = 1000 N/m)");
ax1.XScale = "log";
ax1.XTick = [1e-2, 1e-1, 1, 10, 100];
ax1.XTickLabel = [];
ax1.Box = "on";

% Phase
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

% --- Save ---
png_path = fullfile(params.output_dir, "fig07b_stiffness_bode.png");
fig_path = fullfile(params.output_dir, "fig07b_stiffness_bode.fig");

exportgraphics(fig, png_path, "Resolution", 200);
savefig(fig, fig_path);
close(fig);

output_path = string(png_path);
end
