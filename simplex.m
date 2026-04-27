clc
clear all

%% MAX problem

% Objective function coefficients
c = [1 2 3 0 0];

% RHS (constraints)
b = [20; 30];

% Constraint matrix (including slack variables)
A = [1 2 0 1 0; 
     3 0 4 0 1];

m = size(A,1); % number of constraints
n = size(A,2); % number of variables

% Initial basic variables (slack variables)
bv_index = n-m+1 : n;

% Create tableau (A | b)
Y = [A b];

for s = 1:50
    
    % Cost of basic variables
    cb = c(bv_index);
    
    % Values of basic variables
    Xb = Y(:,end);
    
    % Current objective value
    z = cb * Xb;
    
    % Compute Zj - Cj
    zjcj = cb * Y(:,1:n) - c;
    
    % Check optimality condition
    if zjcj >= 0
        disp('Optimal solution achieved');
        Xb
        basic_variables = bv_index
        fprintf("Optimal value = %f", z);
        break
    else
        % Entering variable (most negative)
        [a, EV] = min(zjcj);
        
        % Check unbounded
        if Y(:,EV) < 0
            disp("Unbounded solution")
            break
        else
            % Ratio test
            for j = 1:m
                if Y(j,EV) > 0
                    ratio(j) = Xb(j) / Y(j,EV);
                else
                    ratio(j) = inf;
                end
            end
        end
        
        % Leaving variable
        [k, LV] = min(ratio);
        
        % Update basis
        bv_index(LV) = EV;
    end
    
    % Pivot operation
    pivot = Y(LV,EV);
    
    % Make pivot = 1
    Y(LV,:) = Y(LV,:) / pivot;
    
    % Make other entries zero
    for i = 1:m
        if i ~= LV
            Y(i,:) = Y(i,:) - Y(i,EV) * Y(LV,:);
        end
    end
end
