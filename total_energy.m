function [E] = total_energy(m, k, x, v)
    Ep = k/2 * x.^2;
    Ek = m/2 * v.^2;
    E = [Ep; Ek; Ep + Ek];
end
