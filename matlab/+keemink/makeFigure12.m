function output_path = makeFigure12()
%MAKEFIGURE12 Recreate the modified velocity reference Bode plot from Keemink Figure 12.

params = keemink.paperBaselineParams();
systems = keemink.baselineSystems(params);

if ~exist(params.output_dir, "dir")
    mkdir(params.output_dir);
end

freq_hz = params.freq_hz;

% Modified velocity reference parameter
ka = 1;

% Derived gains
kr = params.kr;
mv = params.mv;
mr = params.mr;
mps = params.mps;
br = params.br;
kp = params.kp;
ki = params.ki;

% Build apparent admittance from block diagram with modified Yv.
%   Yv = (ka*s + 1) / (mv*s)
%   Cfb = (kp*s + ki) / s
%   Yr = 1 / ((mr+mps)*s + br)
%
% Closed-loop (solving v/Fext):
%   Ya = (1 + kr^2*Cfb*Yv) / ((mr+mps)*s + br + kr^2*Cfb*(Yv*mps*s + 1))

s = tf("s");

Yv_mod = (ka*s + 1) / (mv*s);
Cfb_tf = (kp*s + ki) / s;

Ya_mod = minreal( ...
    (1 + kr^2 * Cfb_tf * Yv_mod) / ...
    ((mr + mps)*s + br + kr^2 * Cfb_tf * (Yv_mod * mps*s + 1)));

% Intended virtual admittance (unmodified)
Yv0 = 1 / (mv * s);

curves = [ ...
    struct("sys", Yv0,                    "label", "$Y_v$",                  "color", [0.8500, 0.3250, 0.0980], "style", "-",  "width", 1.8), ...
    struct("sys", Ya_mod,                 "label", "$Y_a$ (modified ref)",   "color", [0.0000, 0.4470, 0.7410], "style", "-",  "width", 1.8), ...
    struct("sys", systems.apparent,       "label", "$\bar{Y}_a$",            "color", [0.0000, 0.4470, 0.7410], "style", "--", "width", 1.4), ...
    struct("sys", systems.robot_apparent, "label", "$Y_r$",                  "color", [0.4660, 0.6740, 0.1880], "style", "-",  "width", 1.8) ...
    ];

fig = figure( ...
    "Color", "w", ...
    "Position", [120, 120, 820, 720], ...
    "MenuBar", "none", ...
    "ToolBar", "none", ...
    "Name", "Keemink Figure 12 Recreation");

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
title("Figure 12 Recreation", "FontWeight", "bold");
subtitle("$k_a = 1$", "Interpreter", "latex");
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

png_path = fullfile(params.output_dir, "fig12_modifiedvelref_bode.png");
fig_path = fullfile(params.output_dir, "fig12_modifiedvelref_bode.fig");

exportgraphics(fig, png_path, "Resolution", 200);
savefig(fig, fig_path);
close(fig);

output_path = string(png_path);
end
