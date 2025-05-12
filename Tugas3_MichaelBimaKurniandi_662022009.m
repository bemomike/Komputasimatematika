%Tugas 3 Komputasi MTK
%1. Kerjakan contoh 4.1 pada diktat Metode Numerik halaman 21 menggunakan Matlab 
%   dengan menggunakan metode Jacobi, Gauss Seidel

fprintf('\nContoh 4.1\n');
% Metode Jacobi
A = [10 -1 2 0; -1 11 -1 3; 2 -1 10 -1; 0 3 -1 8];
b = [6; 25; -11; 15];
x = zeros(4,1);
n = length(b);
tol = 1e-5;
max_iter = 100;

for k = 1:max_iter
    x_old = x;
    for i = 1:n
        sigma = 0;
        for j = 1:n
            if j ~= i
                sigma = sigma + A(i,j)*x_old(j);
            end
        end
        x(i) = (b(i) - sigma)/A(i,i);
    end
    if norm(x - x_old, inf) < tol
        break
    end
end

fprintf('Hasil Jacobi:\n');
disp(x);
fprintf('Iterasi ke-%d\n', k);

% Metode Gauss-Seidel 
A = [10 -1 2 0; -1 11 -1 3; 2 -1 10 -1; 0 3 -1 8];
b = [6; 25; -11; 15];
x = zeros(4,1);
n = length(b);
tol = 1e-5;
max_iter = 100;

for k = 1:max_iter
    x_old = x;
    for i = 1:n
        sigma = 0;
        for j = 1:n
            if j ~= i
                sigma = sigma + A(i,j)*x(j);
            end
        end
        x(i) = (b(i) - sigma)/A(i,i);
    end
    if norm(x - x_old, inf) < tol
        break
    end
end

fprintf('Hasil Gauss-Seidel:\n');
disp(x);
fprintf('Iterasi ke-%d\n', k);

%2.	Kerjakan contoh 10.1 pada diktat Metode Numerik halaman 75 menggunakan jumlahan 
%   Riemann dan aturan trapesium 

% Fungsi dan batas
f = @(x) 2*x.^3;
a = 0; b = 1;
h = 0.1;
x = a:h:b;
y = f(x);

% Aturan Trapesium 
T = (h/2)*(y(1) + 2*sum(y(2:end-1)) + y(end));

% Jumlahan Riemann
L_riemann = h * sum(y(1:end-1));                    % Riemann Kiri
R_riemann = h * sum(y(2:end));                      % Riemann Kanan
M_riemann = h * sum(f((x(1:end-1) + x(2:end))/2));  % Riemann Tengah
% NIlai Eksak
L_exact = integral(f, a, b); % = 0.5

fprintf('\nContoh 10.1\n');
fprintf('Aturan Trapesium: %.5f\n', T);
fprintf('Riemann Kiri: %.5f\n', L_riemann);
fprintf('Riemann Kanan: %.5f\n', R_riemann);
fprintf('Riemann Tengah: %.5f\n', M_riemann);
fprintf('Nilai eksak (integral): %.5f\n', L_exact);
