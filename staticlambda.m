%SYSTEM TOPOLOGY: a dispatcher and N parallel server pools with B servers
%each. Server pools behave as Earlang blocking systems: each server can
%work on a single task and tasks are discarded if they arrive when all
%servers are busy.

%LOAD BALANCING: depends on a threshold L.
%1) If some server pool has strictly less than L tasks then incoming tasks
%are routed to a server pool with strictly less than L tasks, chosen
%uniformly at random.
%2) If all server pools have at least L tasks and at least one server pool
%has exactly L tasks then incoming tasks are routed to a server pool with
%exactly L tasks, chosen uniformly at random.
%3) Otherwise incoming tasks are routed to a server pool chosen uniformly
%at random.

%THRESHOLD UPDATE SCHEME: the threshold is adjusted upon the arrival of
%tasks (after dispatching the task) according to the following rules, which
%depend on the occupation of the system (right before the arrival) and one
%parameter: 0 < alpha < 1.
%1) The threshold is decreased by one if the fraction of server pools with
%at least L tasks is smaller or equal than alpha.
%2) The threshold is increased by one if the fraction of server pools with
%exactly L tasks is larger or equal than N - 1.
%3) The threshold remains the same in all other cases.

%STOCHASTIC PRIMITIVES: tasks arrive as a Poisson process of intensity
%lambda and service requirements are exponential with mean one.

%System parameters:
B = 10;
N = 500;
tf = 10; %simulation time.
lambda = 5.5;
alpha = 0.1 + 0.9 * lambda / (floor(lambda) + 1);
%State variables:
discarded = 0; %discarded tasks (should remain equal to zero).
initial = 2;
i = 1;
t = 0;
if initial == 1
    l = 0;
    h = l + 1;
    yellow = generate(N, 1, 0);
    green = generate(0, 1, N);
    tasks = zeros(1, B * N);
    queues = zeros(1, N);
    state = zeros(1, B);
elseif initial == 2
    l = B - 1;
    h = l + 1;
    tasks = generate(N, B - 1, N);
    queues = (B - 1) * ones(1, N);
    state = N * [ones(1, B - 1) 0];
    yellow = generate(N, 1, 0);
    green = generate(0, 1, N);
else
    l = floor(2 * lambda);
    h = l + 1;
    state = zeros(1, B);
    for i = 1 : l
        state(i) = N;
    end
    state(h) = round(N * (2 * lambda - l));
    [queues, tasks, green, yellow] = initial_conditions(N, B, l, state);
end
%Output data:
events = round(2 * lambda * tf);
T = zeros(events, 1);
D = zeros(events, 1);
L = zeros(events, 1);
Q = zeros(events, N);
S = zeros(events, B);
%Initial value;
L(i) = l;
H(i) = h;
Q(i, :) = queues;
S(i, :) = state;
%Time until next event:
arrival = exprnd(1 / (N * lambda));
departure = exprnd(1 / sum(queues));
[dt, event] = min([arrival departure]);
%Main loop:
while t + dt < tf
    %Time update:
    i = i + 1;
    t = t + dt;
    %Arrival:
    if event == 1
        %Green tokens available:
        if notempty(green)
            k = draw(green);
            tasks = add(tasks, k);
            queues(k) = queues(k) + 1;
            state(queues(k)) = state(queues(k)) + 1;
            if queues(k) == l
                green = remove(green, k);
            end
        %Only yellow tokens available:    
        elseif notempty(yellow)
            k = draw(yellow);
            tasks = add(tasks, k);
            queues(k) = queues(k) + 1;
            state(queues(k)) = state(queues(k)) + 1;
            yellow = remove(yellow, k);
        %No tokens at all:
        else
            k = randi(N);
            if queues(k) < B
                tasks = add(tasks, k);
                queues(k) = queues(k) + 1;
                state(queues(k)) = state(queues(k)) + 1;
            else
                discarded = discarded + 1;
            end
        end
        %Threshold increase:
        if h < B
            if state(h) == N
                %There were at least N - 1 server pools with at least h
                %tasks when the new task arrived.
                l = l + 1;
                h = h + 1;
                for k = 1 : N
                    if queues(k) == l
                        yellow = add(yellow, k);
                    end
                end
            end
        end
        %Thresholds decrease:
        if l > 0
            if state(l) <= alpha * N + 1
                %There were at least alpha N server pools with at least l
                %tasks when the new task arrived.
                l = l - 1;
                h = h - 1;
                for k = 1 : N
                    if queues(k) == h
                        yellow = remove(yellow, k);
                    end
                    if queues(k) == l
                        green = remove(green, k);
                    end
                end
            end
        end
    end
    %Departure:
    if event == 2
        k = draw(tasks);
        tasks = remove(tasks, k);
        state(queues(k)) = state(queues(k)) - 1;
        queues(k) = queues(k) - 1;
        %New green token:
        if queues(k) == l - 1
            green = add(green, k);
        %New yellow token:
        elseif queues(k) == h - 1
            yellow = add(yellow, k);
        end
    end
    %Output data update:
    T(i) = t;
    D(i) = discarded;
    L(i) = l;
    Q(i, :) = queues;
    S(i, :) = state;
    %Time until next event:
    arrival = exprnd(1 / (N * lambda));
    departure = exprnd(1 / sum(queues));
    [dt, event] = min([arrival departure]);
    %Waitbar:
    wbar = waitbar(t / tf);
end
close(wbar);
%Outoput data:
T = T(1 : i);
D = D(1 : i);
L = L(1 : i);
Q = Q(1 : i, :);
S = S(1 : i, :);
f = floor(lambda);
save('data');
%Time until the threshold drops below floor of lambda:
if initial == 1
    t0 = 0;
elseif initial == 2
    u0 = B - 1;
    t0 = log((u0 - lambda) / (alpha * (f + 1) - lambda));
else
    u0 = 2 * lambda;
    t0 = log((u0 - lambda) / (alpha * (f + 1) - lambda));
end
%Upperbound of teq:
t1 = t0 + log((lambda / (lambda - f)));
