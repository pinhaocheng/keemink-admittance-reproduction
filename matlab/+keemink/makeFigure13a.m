function output_path = makeFigure13a()
%MAKEFIGURE13A Recreate the differential velocity control Bode plot (Keemink Figure 13a).

params = keemink.paperBaselineParams();
systems = keemink.baselineSystems(params);

if ~exist(params.output_dir, "dir")
    mkdir(params.output_dir);
end

freq_hz = params.freq_hz;
s = tf("s");

%% Differential velocity control parameters
kd    = 25;    % Ns^2/m (kg)
tau_d = 0.1;   % s

Yv = 1 / (params.mv * s);
Cfb = params.kp + params.ki / s + (kd * s) / (tau_d * s + 1);

Ya = keemink.rigidClosedLoopAdmittance(params, Yv, Cfb);

%% Baseline apparent admittance
Ya_bar = systems.apparent;

%% Curves
curves = [ ...
    struct("sys", Yv,                     "label", "$Y_v$",              "color", [0.8500, 0.3250, 0.0980], "style", "-",  "width", 1.8), ...
    struct("sys", Ya,                     "label", "$Y_a$ (diff vel)",   "color", [0.0000, 0.4470, 0.7410], "style", "-",  "width", 1.8), ...
    struct("sys", Ya_bar,                 "label", "$\bar{Y}_a$",        "color", [0.0000, 0.4470, 0.7410], "style", "--", "width", 1.4), ...
    struct("sys", systems.robot_apparent, "label", "$Y_r$",              "color", [0.4660, 0.6740, 0.1880], "style", "-",  "width", 1.8) ...
    ];

%% Figure
fig = figure( ...
    "Color", "w", ...
    "Position", [120, 120, 820, 720], ...
    "MenuBar", "none", ...
    "ToolBar", "none", ...
    "Name", "Keemink Figure 13a Recreation");

tiledlayout(fig, 2, 1, "TileSpacing", "compact", "Padding", "compact");

% --- Magnitude ---
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
title("Figure 13a Recreation", "FontWeight", "bold");
subtitle("$k_d = 25$ Ns$^2$/m, $\tau_d = 0.1$ s", "Interpreter", "latex");
ax1.XScale = "log";
ax1.XTick = [1e-2, 1e-1, 1, 10, 100];
ax1.XTickLabel = [];
ax1.Box = "on";

% --- Phase ---
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

%% Save
png_path = fullfile(params.output_dir, "fig13a_diffvelocity_bode.png");
fig_path = fullfile(params.output_dir, "fig13a_diffvelocity_bode.fig");

exportgraphics(fig, png_path, "Resolution", 200);
savefig(fig, fig_path);
close(fig);

output_path = string(png_path);
end
