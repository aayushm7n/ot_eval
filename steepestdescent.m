clc
clear all

format short

%% Define function
syms x1 x2

f = x1 - x2 + 2*x1^2 + 2*x1*x2 + x2^2;

% Convert to function form
fx = inline(f);
fobj = @(x) fx(x(1), x(2));

%% Gradient
grad = gradient(f);
G = inline(grad);
gradx = @(x) G(x(1), x(2));

%% Hessian
H1 = hessian(f);
Hx = inline(H1);

%% Initial values
x0 = [1 1];      % starting point
maxiter = 4;     % iterations
tol = 1e-3;      
iter = 0;

x = [1;1];

while norm(gradx(x0)) > tol && iter < maxiter
    
    X = [x; x0];  % store values
    
    % Direction = negative gradient
    S = -gradx(x0);
    
    % Hessian matrix
    H = Hx(x0);
    
    % Step size (lambda)
    lambda = (S' * S) / (S' * H * S);
    
    % Update point
    xnew = x0 + lambda .* S';
    
    x0 = xnew;
    
    iter = iter + 1;
end

%% Output
fprintf('Optimal X = [%f, %f]\n', x0(1), x0(2))
fprintf('Optimal f(x) = %f\n', fobj(x0))
