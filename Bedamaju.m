%F f(x) = 2x
f = @(x) 2*x;
%Titik eval
x = 1;
%List n(h)
h_values = 0.01;
%h_values = [1e-1, 1e-2, 1e-3, 1e-4];
%Turunan eksak
df_exact = 2;
disp('--- Banding Turunan Num U f(x) = 2x ---')
%Loop u tiap n(h)
%for i = 1:5
for i = 1:5
    h = h_values; 
    %Met maju
    df_forward = (f(x + h) - f(x)) / h;
    %Met mundur
    df_backward = (f(x) - f(x - h)) / h;
    %Met tengah
    df_central = (f(x + h) - f(x - h)) / (2*h);
    %Tampil hasil
    disp(['h = ', num2str(h)])
    disp(['Beda Maju = ', num2str(df_forward)])
    disp(['Beda Mundur = ', num2str(df_backward)])
    disp(['Beda Tengah = ', num2str(df_central)])
    disp(['Turunan Eksak = ', num2str(df_exact)])
    disp(' ')
end