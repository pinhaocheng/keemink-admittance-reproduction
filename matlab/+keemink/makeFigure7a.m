function output_path = makeFigure7a()
%MAKEFIGURE7A Recreate the accommodation control Bode plot from Keemink Figure 7a.

params = keemink.paperBaselineParams();
systems = keemink.baselineSystems(params);

if ~exist(params.output_dir, "dir")
    mkdir(params.output_dir);
end

freq_hz = params.freq_hz;
s = tf("s");

% Accommodation control: virtual dynamics Yv = 1/bv (pure damper)
bv = 80;  % Ns/m

Kp = params.kp * params.kr^2;
Ki = params.ki * params.kr^2;

% Virtual admittance
Yv = tf(1, bv);

% Apparent admittance from Appendix 3
b2 = (params.mr + params.mps) * bv + Kp * params.mps;
Ya = ((Kp + bv)*s + Ki) / (b2*s^2 + ((Kp + params.br)*bv + Ki*params.mps)*s + bv*Ki);

    curves = [ ...
        struct("sys", Yv,               "label", "$Y_v$",          "color", [0.8500, 0.3250, 0.0980], "style", "-",  "width", 1.8), ...
        struct("sys", Ya,               "label", "$Y_a$",          "color", [0.0000, 0.4470, 0.7410], "style", "-",  "width", 1.8), ...
        struct("sys", systems.robot_apparent, "label", "$Y_r$",    "color", [0.4660, 0.6740, 0.1880], "style", "-",  "width", 1.8) ...
        ];

fig = figure( ...
    "Color", "w", ...
    "Position", [120, 120, 820, 720], ...
    "MenuBar", "none", ...
    "ToolBar", "none", ...
    "Name", "Keemink Figure 7a Recreation");

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
title("Figure 7a Recreation", "FontWeight", "bold");
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

png_path = fullfile(params.output_dir, "fig07a_accommodation_bode.png");
fig_path = fullfile(params.output_dir, "fig07a_accommodation_bode.fig");

exportgraphics(fig, png_path, "Resolution", 200);
savefig(fig, fig_path);
close(fig);

output_path = string(png_path);
end
