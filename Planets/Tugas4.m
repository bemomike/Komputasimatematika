clc; clear;

% Constants
G = 6.67430e-11; % gravitational constant
M = 1.989e30;    % solar mass
AU = 1.496e11;   % 1 astronomical unit

% Planetary data: [Name, a (m), e, Einstein correction, T_orbit (s)]
planets = {
    'Mercury', 0.387*AU, 0.206, 5e-7, 7.6e6;
    'Venus',   0.723*AU, 0.007, 3e-8, 1.94e7;
    'Earth',   1.000*AU, 0.017, 2e-8, 3.15e7;
    'Jupiter', 5.204*AU, 0.049, 2e-9, 3.74e8;
    'Pluto',  39.48*AU,  0.248, 4e-10, 7.8e9;
};

n_planets = size(planets,1);

% Define Sun's limited galactic motion speed (in m/s)
sun_speed = 1e3;

for p = 1:n_planets
    name = planets{p,1};
    a = planets{p,2}; e = planets{p,3}; eps = planets{p,4}; T = planets{p,5};
    steps = 4000;
    dt = T / steps;
    t = linspace(0, T, steps);

    % Initial conditions
    r0 = [a*(1-e), 0];
    v0 = [0, sqrt(G*M*(1+e)/(a*(1-e)))];

    % Newtonian
    rN = zeros(steps,2); vN = zeros(steps,2);
    rN(1,:) = r0; vN(1,:) = v0;

    % Einsteinian
    rE = zeros(steps,2); vE = zeros(steps,2);
    rE(1,:) = r0; vE(1,:) = v0;

    for i = 1:steps-1
        rNmag = norm(rN(i,:));
        rEmag = norm(rE(i,:));

        % Newtonian acceleration
        aN = -G*M * rN(i,:) / rNmag^3;
        vN(i+1,:) = vN(i,:) + aN * dt;
        rN(i+1,:) = rN(i,:) + vN(i+1,:) * dt;

        % Einsteinian acceleration
        precess = 1 + eps / rEmag^2;
        aE = -G*M * rE(i,:) / rEmag^3 * precess;
        vE(i+1,:) = vE(i,:) + aE * dt;
        rE(i+1,:) = rE(i,:) + vE(i+1,:) * dt;
    end

    % Sun's limited 3D drift for this planet's time
    z = linspace(0, 1, steps);
    sun_path = [sun_speed * dt * (1:steps)' / AU, zeros(steps,1), z'];

    % Plot each planet
    figure('Name',['Orbit of ',name],'NumberTitle','off');

    % 2D Orbit
    subplot(1,2,1); hold on; axis equal; grid on;
    plot(rN(:,1)/AU, rN(:,2)/AU, 'b-', 'DisplayName','Newtonian');
    plot(rE(:,1)/AU, rE(:,2)/AU, 'r--', 'DisplayName','Einsteinian');
    plot(sun_path(:,1), sun_path(:,2), 'y-', 'LineWidth', 1.5, 'DisplayName','Sun Path');
    xlabel('X (AU)'); ylabel('Y (AU)');
    title(['2D Orbit - ',name]); legend;

    % 3D Helical Orbit
    subplot(1,2,2); hold on; grid on;
    plot3(rN(:,1)/AU, rN(:,2)/AU, z, 'b-', 'DisplayName','Newtonian');
    plot3(rE(:,1)/AU, rE(:,2)/AU, z, 'r--', 'DisplayName','Einsteinian');
    plot3(sun_path(:,1), sun_path(:,2), sun_path(:,3), 'y-', 'LineWidth', 1.5, 'DisplayName','Sun Path');
    xlabel('X (AU)'); ylabel('Y (AU)'); zlabel('Time (norm.)');
    title(['3D Helical Orbit - ',name]); legend;
    view(45,30);

    % Output info
    fprintf('\n===== %s =====\n', name);
    fprintf('Semi-major axis (AU): %.3f\n', a/AU);
    fprintf('Eccentricity: %.3f\n', e);
    fprintf('Newtonian Final r: %.3e m\n', norm(rN(end,:)));
    fprintf('Einsteinian Final r: %.3e m\n', norm(rE(end,:)));
end

%% Final Comparison Plot
fprintf('\n==== COMPARISON BASED ON PLUTO TIME ====\n');
T_pluto = planets{5,5}; steps = 8000; dt = T_pluto / steps;
z_global = linspace(0, 1, steps);
colors = lines(n_planets);
r_all = cell(n_planets,1); r3_all = cell(n_planets,1);

% Sun path
sun_path = [sun_speed * dt * (1:steps)' / AU, zeros(steps,1), z_global'];

% Orbits
for p = 1:n_planets
    a = planets{p,2}; e = planets{p,3};
    r0 = [a*(1-e), 0]; v0 = [0, sqrt(G*M*(1+e)/(a*(1-e)))];

    r = zeros(steps,2); v = zeros(steps,2);
    r(1,:) = r0; v(1,:) = v0;
    for i = 1:steps-1
        rmag = norm(r(i,:));
        aN = -G*M * r(i,:) / rmag^3;
        v(i+1,:) = v(i,:) + aN * dt;
        r(i+1,:) = r(i,:) + v(i+1,:) * dt;
    end
    r_all{p} = r(:,1:2)/AU;
    r3_all{p} = [r(:,1:2)/AU, z_global'];
end

% Final comparison plot
figure('Name','All Planets Orbit Comparison','NumberTitle','off');

subplot(1,2,1); hold on; axis equal; grid on;
title('2D Orbits (Pluto Ref)');
for p = 1:n_planets
    plot(r_all{p}(:,1), r_all{p}(:,2), 'Color', colors(p,:), 'DisplayName', planets{p,1});
end
plot(sun_path(:,1), sun_path(:,2), 'y-', 'LineWidth', 1.5, 'DisplayName','Sun Path');
xlabel('X (AU)'); ylabel('Y (AU)'); legend;

subplot(1,2,2); hold on; grid on;
title('3D Helical Orbits (Pluto Ref)');
for p = 1:n_planets
    plot3(r3_all{p}(:,1), r3_all{p}(:,2), r3_all{p}(:,3), 'Color', colors(p,:), 'DisplayName', planets{p,1});
end
plot3(sun_path(:,1), sun_path(:,2), sun_path(:,3), 'y-', 'LineWidth', 1.5, 'DisplayName','Sun Path');
xlabel('X (AU)'); ylabel('Y (AU)'); zlabel('Time (norm.)');
view(45,30); legend;
