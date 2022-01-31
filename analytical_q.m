function [x, v] = analytical_q(m, k, c, x0, v0, f, time)
    syms t;
    assume(0 <= t);

    omega0 = undamped_angular_frequency(m, k);
    zeta = damping_ratio(m, k, c);
    
    square_root = sqrt(abs(zeta^2 - 1));
    square_root_minus_zeta = square_root - zeta;
    square_root_plus_zeta = square_root + zeta;
    
    omega0_zeta = omega0 * zeta;
    omega0_square_root = omega0 * square_root;
    
    f1(t) = f(t)/m .* exp(t * omega0_zeta);
    f2(t) = f(t)/m .* exp(t * omega0_zeta);
    if zeta > 1.0
        f1(t) = f1(t) .* exp(t * omega0_square_root);
        f2(t) = f2(t) .* exp(-t * omega0_square_root);
    elseif zeta < 1.0
        f1(t) = f1(t) .* cos(t * omega0_square_root);
        f2(t) = f2(t) .* sin(t * omega0_square_root);
    else
        f2(t) = f2(t) .* t;
    end
    
    F1(t) = int(f1);
    F2(t) = int(f2);
    
    C1 = eval(F1(0));
    C2 = eval(F2(0));
    if zeta > 1.0
        C1 = v0 - omega0 * x0 * square_root_minus_zeta - C1;
        C2 = v0 + omega0 * x0 * square_root_plus_zeta - C2;
    elseif zeta < 1.0
        C1 = v0 + zeta * x0 - C1;
        C2 = -omega0 * x0 * square_root - C2;
    else
        C1 = v0 + omega0 * x0 - C1;
        C2 = -x0 - C2;
    end
    
    x(t) = exp(-t * omega0_zeta);
    v(t) = exp(-t * omega0_zeta);
    if zeta > 1.0
        x(t) = x(t) / square_root / omega0 / 2 .* ( ...
            exp(t * omega0_square_root) .* (C2 + F2(t)) ...
            - exp(-t * omega0_square_root) .* (C1 + F1(t)) ...
        );
        
        v(t) = v(t) / square_root / omega0 / 2 .* ( ...
            exp(t * omega0_square_root) .* ( ...
                omega0 * square_root_minus_zeta * (C2 + F2(t)) + f2(t) ...
            ) + exp(-t * omega0_square_root) .* (...
                omega0 * square_root_plus_zeta * (C1 + F1(t)) - f1(t) ...
            ) ...
        );
    elseif zeta < 1.0
        x(t) = x(t) / square_root / omega0 .* ( ...
            sin(t * omega0_square_root) .* (C1 + F1(t)) ...
            - cos(t * omega0_square_root) .* (C2 + F2(t)) ...
        );
        
        v(t) = v(t) / square_root / omega0 .* ( ...
            cos(t * omega0_square_root) .* (...
                omega0 * ( ...
                    zeta * (C2 + F2(t)) ...
                    + square_root * (C1 + F1(t)) ...
                ) - f2(t) ...
            ) - sin(t * omega0_square_root) .* (...
                omega0 * ( ...
                    zeta * (C1 + F1(t)) ...
                    - square_root * (C2 + F2(t)) ...
                ) - f1(t) ...
            ) ...
        );
    else
        x(t) = x(t) .* ( ...
            t .* (C1 + F1(t)) - C2 - F2(t) ...
        );
        
        v(t) = v(t) .* (...
            C1 + F1(t) + omega0 * (C2 + F2(t)) - f2(t) ...
            - t .* (omega0 * (C1 + F1(t)) - f1(t)) ...
        );
    end
    
    x = real(eval(x(time))); % displacement
    v = real(eval(v(time))); % velocity
end