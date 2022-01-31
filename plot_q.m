function plot_q(time, numerical_q, numerical_E, analytical_q, analytical_E)
    figure;
    set(gcf, 'Position', [0.0, 0.0, 1000.0, 500.0]);
    
    subplot(2, 2, 1);
    hold on;
    plot(time, numerical_q(1, :));
    plot(time, numerical_q(2, :));
    hold off;
    legend('Displacement', 'Velocity');
    xlim('tight');
    title('Numerical solution');
    grid on;
    
    subplot(2, 2, 2);
    hold on;
    plot(time, analytical_q(1, :));
    plot(time, analytical_q(2, :));
    hold off;
    legend('Displacement', 'Velocity');
    xlim('tight');
    title('Analytical solution');
    grid on;
    
    subplot(2, 2, 3);
    hold on;
    plot(time, numerical_E(1, :));
    plot(time, numerical_E(2, :));
    plot(time, numerical_E(3, :));
    hold off;
    legend('Potential Energy', 'Kinetic Energy', 'Total Energy');
    xlim('tight');
    grid on;
    
    subplot(2, 2, 4);
    hold on;
    plot(time, analytical_E(1, :));
    plot(time, analytical_E(2, :));
    plot(time, analytical_E(3, :));
    hold off;
    legend('Potential Energy', 'Kinetic Energy', 'Total Energy');
    xlim('tight');
    grid on;
    
    drawnow limitrate;
end
