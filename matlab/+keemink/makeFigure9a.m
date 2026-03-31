function output_path = makeFigure9a()
%MAKEFIGURE9A Recreate the force-filtering Bode plot from Keemink Figure 9a.

params = keemink.paperBaselineParams();
systems = keemink.baselineSystems(params);

if ~exist(params.output_dir, "dir")
    mkdir(params.output_dir);
end

freq_hz = params.freq_hz;

% --- Build the force-filtered apparent admittance ---
s = tf("s");

tau_f = 0.05;                         % first-order filter time constant
Sf = 1 / (tau_f * s + 1);
Yv_filtered = (1 / (params.mv * s)) * Sf;
Cfb = params.kp + params.ki / s;

% Figure 9a is matched best by placing the force low-pass ahead of the
% virtual dynamics, so both the external-force and post-sensor force
% components are filtered before they enter the PI velocity loop.
Ya_filtered = keemink.rigidClosedLoopAdmittance(params, Yv_filtered, Cfb);

% Intended virtual inertia
Yv = 1 / (params.mv * s);

curves = [ ...
    struct("sys", Yv,                     "label", "$Y_v$",              "color", [0.8500, 0.3250, 0.0980], "style", "-",  "width", 1.8), ...
    struct("sys", Ya_filtered,            "label", "$Y_a$ (filtered)",   "color", [0.0000, 0.4470, 0.7410], "style", "-",  "width", 1.8), ...
    struct("sys", systems.apparent,       "label", "$\bar{Y}_a$",        "color", [0.0000, 0.4470, 0.7410], "style", "--", "width", 1.4), ...
    struct("sys", systems.robot_apparent, "label", "$Y_r$",              "color", [0.4660, 0.6740, 0.1880], "style", "-",  "width", 1.8) ...
    ];

fig = figure( ...
    "Color", "w", ...
    "Position", [120, 120, 820, 720], ...
    "MenuBar", "none", ...
    "ToolBar", "none", ...
    "Name", "Keemink Figure 9a Recreation");

tiledlayout(fig, 2, 1, "TileSpacing", "compact", "Padding", "compact");

% ---- Magnitude ----
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
title("Figure 9a Recreation", "FontWeight", "bold");
subtitle("first-order filter, \tau_f = 0.05 s");
ax1.XScale = "log";
ax1.XTick = [1e-2, 1e-1, 1, 10, 100];
ax1.XTickLabel = [];
ax1.Box = "on";

% ---- Phase ----
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

% ---- Save ----
png_path = fullfile(params.output_dir, "fig09a_forcefilter_bode.png");
fig_path = fullfile(params.output_dir, "fig09a_forcefilter_bode.fig");

exportgraphics(fig, png_path, "Resolution", 200);
savefig(fig, fig_path);
close(fig);

output_path = string(png_path);
end
