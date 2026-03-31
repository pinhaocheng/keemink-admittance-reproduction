function [mag_db, phase_deg] = bodeData(sys, freq_hz)
%BODEDATA Sample a transfer function on a Hz grid and return plotting arrays.

w = 2 * pi * freq_hz;
[mag, phase_deg] = bode(sys, w);

mag_db = 20 * log10(squeeze(mag));
phase_deg = squeeze(phase_deg);
phase_deg = mod(phase_deg + 180, 360) - 180;
end
