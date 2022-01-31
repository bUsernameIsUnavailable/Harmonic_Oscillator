function [zeta] = damping_ratio(m, k, c)
    zeta = c / sqrt(m*k) / 2;
end
