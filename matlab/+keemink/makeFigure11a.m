function output_path = makeFigure11a()
%MAKEFIGURE11A Recreate the virtual-damping Bode plot from Keemink Figure 11a.

params = keemink.paperBaselineParams();
systems = keemink.baselineSystems(params);

if ~exist(params.output_dir, "dir")
    mkdir(params.output_dir);
end

freq_hz = params.freq_hz;

% --- Virtual damping parameters ---
bv = 2;                             % virtual damping [Ns/m]

% Virtual admittance with damping: Yv = 1 / (mv*s + bv)
s = tf("s");
Yv = 1 / (params.mv * s + bv);
Cfb = params.kp + params.ki / s;
Ya = keemink.rigidClosedLoopAdmittance(params, Yv, Cfb);

% --- Curves to plot ---
curves = [ ...
    struct("sys", Yv,                     "label", "$Y_v$ (damped)",     "color", [0.8500, 0.3250, 0.0980], "style", "-",  "width", 1.8), ...
    struct("sys", Ya,                     "label", "$Y_a$ (damped)",     "color", [0.0000, 0.4470, 0.7410], "style", "-",  "width", 1.8), ...
    struct("sys", systems.apparent,       "label", "$\bar{Y}_a$",        "color", [0.0000, 0.4470, 0.7410], "style", "--", "width", 1.4), ...
    struct("sys", systems.robot_apparent, "label", "$Y_r$",              "color", [0.4660, 0.6740, 0.1880], "style", "-",  "width", 1.8) ...
    ];

% --- Figure ---
fig = figure( ...
    "Color", "w", ...
    "Position", [120, 120, 820, 720], ...
    "MenuBar", "none", ...
    "ToolBar", "none", ...
    "Name", "Keemink Figure 11a Recreation");

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
title("Figure 11a Recreation", "FontWeight", "bold");
subtitle("b_v = 2 Ns/m");
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
png_path = fullfile(params.output_dir, "fig11a_virtualdamping_bode.png");
fig_path = fullfile(params.output_dir, "fig11a_virtualdamping_bode.fig");

exportgraphics(fig, png_path, "Resolution", 200);
savefig(fig, fig_path);
close(fig);

output_path = string(png_path);
end
