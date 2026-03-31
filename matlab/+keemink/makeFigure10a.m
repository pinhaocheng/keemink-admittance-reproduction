function output_path = makeFigure10a()
%MAKEFIGURE10A Recreate the post-sensor inertia compensation Bode plot (Keemink Figure 10a).

params = keemink.paperBaselineParams();
systems = keemink.baselineSystems(params);

if ~exist(params.output_dir, "dir")
    mkdir(params.output_dir);
end

freq_hz = params.freq_hz;
s = tf("s");

%% Post-sensor inertia compensation parameters
mu_c  = 2;     % kg  (= mps)
tau_c = 0.1;   % s

%% Apparent admittance with compensation
Yv = 1 / (params.mv * s);
compensation = mu_c * s / (tau_c * s + 1);
Cfb = params.kp + params.ki / s;
Ya_post = keemink.rigidClosedLoopAdmittance(params, Yv, Cfb, ...
    Compensation=compensation);

%% Baseline apparent admittance (standard baseline with ki = 2000)
Ya_bar = systems.apparent;

%% Curves
curves = [ ...
    struct("sys", Yv,                     "label", "$Y_v$",              "color", [0.8500, 0.3250, 0.0980], "style", "-",  "width", 1.8), ...
    struct("sys", Ya_post,                "label", "$Y_a$ (post)",       "color", [0.0000, 0.4470, 0.7410], "style", "-",  "width", 1.8), ...
    struct("sys", Ya_bar,                 "label", "$\bar{Y}_a$",        "color", [0.0000, 0.4470, 0.7410], "style", "--", "width", 1.4), ...
    struct("sys", systems.robot_apparent, "label", "$Y_r$",              "color", [0.4660, 0.6740, 0.1880], "style", "-",  "width", 1.8) ...
    ];

%% Figure
fig = figure( ...
    "Color", "w", ...
    "Position", [120, 120, 820, 720], ...
    "MenuBar", "none", ...
    "ToolBar", "none", ...
    "Name", "Keemink Figure 10a Recreation");

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
title("Figure 10a Recreation", "FontWeight", "bold");
subtitle("$\mu_c = 2$ kg, $\tau_c = 0.1$ s", "Interpreter", "latex");
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
png_path = fullfile(params.output_dir, "fig10a_postsensor_bode.png");
fig_path = fullfile(params.output_dir, "fig10a_postsensor_bode.fig");

exportgraphics(fig, png_path, "Resolution", 200);
savefig(fig, fig_path);
close(fig);

output_path = string(png_path);
end
