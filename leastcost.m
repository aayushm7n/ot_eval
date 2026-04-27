clc;
clear all;

% Cost matrix (transport cost from sources to destinations)
Cost = [11 13 17 14; 
        16 18 14 10; 
        21 24 13 10];

% Supply at each source
supply = [10 5 9];

% Demand at each destination
demand = [8 7 15 4];

% Get dimensions
m = size(Cost,1); % rows (sources)
n = size(Cost,2); % columns (destinations)

% Total supply and demand
S = sum(supply);
D = sum(demand);

% Balance the transportation problem
if (S == D)
    disp('Balanced TP')
elseif (D > S)
    % Add dummy source (extra supply needed)
    Cost(end+1,:) = zeros(1,n);
    supply(end+1) = D - S;
else
    % Add dummy destination
    Cost(:,end+1) = zeros(m,1);
    demand(end+1) = S - D;
end

disp("Balanced TP Table")
[Cost supply'; demand sum(supply)]

% Update size after balancing
[m,n] = size(Cost);

% Initialize allocation matrix
X = zeros(m,n);

% Save original cost matrix
ICost = Cost;

% Main loop until all supply & demand satisfied
while(any(supply ~= 0) || any(demand ~= 0))

    % Find minimum cost in matrix
    min_cost = min(Cost(:));

    % Get position(s) of that minimum cost
    [r, c] = find(Cost == min_cost);

    % Find possible allocations at those positions
    y = min(supply(r), demand(c));

    % Choose maximum allocation among them
    [aloc, index] = max(y);

    % Final selected row & column
    rr = r(index);
    cc = c(index);

    % Allocate
    X(rr, cc) = aloc;

    % Update supply and demand
    supply(rr) = supply(rr) - aloc;
    demand(cc) = demand(cc) - aloc;

    % Mark that cell as used
    Cost(rr, cc) = inf;
end

% Calculate total transportation cost
Cost_eachcell = X .* ICost;
Total_Cost = sum(Cost_eachcell(:))

% Display final allocation
disp(X)
