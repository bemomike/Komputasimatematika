
function [x, galat] = BagiDuaScript(f, X, N, tol)
% BagiDua Menyelesaikan persamaan f(x) = 0 menggunakan metode bagi dua.
%
% Input:
%   f   = fungsi dari x (misal: inline('x^2 - 3','x'))
%   X   = [a b], batas bawah dan atas interval (a < b)
%   N   = maksimum iterasi (default 100)
%   tol = toleransi keakuratan (default 1e-3)
%
% Output:
%   x     = akar hampiran
%   galat = persen galat relatif

if nargin < 4, tol = 1e-3; end
if nargin < 3, N = 100; end

a = X(1);
b = X(2);
x = (a + b) / 2;
n = 1;
galat = 1;

while (n <= N && galat > tol)
    if f(a)*f(x) < 0
        b = x;
    elseif f(a)*f(x) > 0
        a = x;
    else
        break;
    end
    xnew = (a + b) / 2;
    galat = abs((xnew - x)/xnew) * 100;
    x = xnew;
    n = n + 1;
end
end