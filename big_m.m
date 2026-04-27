clc
clear all

M = 1e5; % very large penalty

% Objective function (artificial vars have -M)
c = [1 2 3 0 0 -M -M];

b = [20; 30];

A = [1 2 0 1 0 1 0; 
     3 0 4 0 1 0 1];

m = size(A,1);
n = size(A,2);

% Initial basis includes artificial variables
bv_index = n-m+1 : n;

% Tableau
Y = [A b];

for s = 1:50
    
    cb = c(bv_index);
    Xb = Y(:,end);
    z = cb * Xb;
    
    zjcj = cb * Y(:,1:n) - c;
    
    if zjcj >= 0
        disp('Optimal solution achieved');
        Xb
        basic_variables = bv_index
        fprintf("Optimal value = %f", z);
        break
    else
        [a, EV] = min(zjcj);
        
        if Y(:,EV) < 0
            disp("Unbounded solution")
            break
        else
            for j = 1:m
                if Y(j,EV) > 0
                    ratio(j) = Xb(j) / Y(j,EV);
                else
                    ratio(j) = inf;
                end
            end
        end
        
        [k, LV] = min(ratio);
        bv_index(LV) = EV;
    end
    
    pivot = Y(LV,EV);
    Y(LV,:) = Y(LV,:) / pivot;
    
    for i = 1:m
        if i ~= LV
            Y(i,:) = Y(i,:) - Y(i,EV) * Y(LV,:);
        end
    end
end
