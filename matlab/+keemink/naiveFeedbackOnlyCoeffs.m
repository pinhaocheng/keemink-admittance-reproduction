function [num, den] = naiveFeedbackOnlyCoeffs(mv, mr, mps, br, Kp, Ki)
%NAIVEFEEDBACKONLYCOEFFS Polynomial coefficients for Appendix 3 baseline Ya.

a2 = (mr + mps) * mv;
a1 = (Kp + br) * mv + Kp * mps;
a0 = Ki * (mv + mps);

num = [mv, Kp, Ki];
den = [a2, a1, a0, 0];
end
