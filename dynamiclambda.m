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

%ARRIVAL RATE
%1) First interval:
%lambda = at in [t0, t1).
%lambda = lambda1 in [t1, t2).
lambda1 = 2.4;
t0 = 0;
t1 = 2;
a = lambda1 / t1;
%2) Second interval (quadratic growth).
%lambda = b(t - t2)^2 + lambda1 in [t2, t3).
%lambda = lambda2 in [t3, t4).
lambda2 = 6.7;
t2 = 15;
t3 = 20;
b = (lambda2 - lambda1) / (t3 - t2)^2;
%3) Third interval (quadratic drop).
%lambda = c(t - t4)^2 + lambda2 in [t4, t5).
%lambda = lambda3 in [t5, tf).
lambda3 = 3;
t4 = 30;
t5 = 33;
c = (lambda3 - lambda2) / (t5 - t4)^2;

%System parameters:
B = 10;
N = 500;
tf = 45; %simulation time.
lambdamax = 10;
alpha = lambdamax / (lambdamax + 1);
%State variables:
discarded = 0; %discarded tasks (should remain equal to zero).
empty = true;
i = 1;
t = 0;
if empty
    l = 0;
    h = l + 1;
    yellow = generate(N, 1, 0);
    green = generate(0, 1, N);
    tasks = zeros(1, B * N);
    queues = zeros(1, N);
    state = zeros(1, B);
else
    l = B - 1;
    h = l + 1;
    tasks = generate(N, B - 1, N);
    queues = (B - 1) * ones(1, N);
    state = N * [ones(1, B - 1) 0];
    yellow = generate(N, 1, 0);
    green = generate(0, 1, N);
end
%Output data:
events = round(2 * lambdamax * tf);
T = zeros(events, 1);
A = zeros(events, 1);
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
dt = 0.1;
event = 1;
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
    %Time until next event:
    if t < t1
        lambda = a * t;
    elseif t < t2
        lambda = lambda1 + 0.3 * sin(2 * pi * t);
    elseif t < t3
        lambda = b * (t - t2)^2 + lambda1;
    elseif t < t4
        lambda = lambda2;
    elseif t < t5
        lambda = c * (t - t4)^2 + lambda2;
    else
        lambda = lambda3 + 0.3 * sin(2 * pi * (t - 3) / 10);
    end
    arrival = exprnd(1 / (N * lambda));
    departure = exprnd(1 / sum(queues));
    [dt, event] = min([arrival departure]);
    %Output data update:
    T(i) = t;
    A(i) = lambda;
    D(i) = discarded;
    L(i) = l;
    Q(i, :) = queues;
    S(i, :) = state;
    %Waitbar:
    wbar = waitbar(t / tf);
end
close(wbar);
%Outoput data:
T = T(1 : i);
A = A(1 : i);
D = D(1 : i);
L = L(1 : i);
Q = Q(1 : i, :);
S = S(1 : i, :);
save('data');
%Even distribution of the load:
qe = zeros(i, B);
for j = 1 : i
    for k = 1 : floor(A(j))
        qe(j, k) = 1;
    end
    qe(j, floor(A(j)) + 1) = A(j) - floor(A(j));
end
%Plot
figure('Name', 'Evolution over time', 'NumberTitle', 'off');
plot(T, sqrt(sum((S / N - qe) .^ 2, 2)), T, max(Q, [], 2));
hold on;
plot(T, A, 'r', 'LineWidth', 1);
plot(T, L, ':b', 'LineWidth', 1);
title('Time-varying arrival rate');
xlabel('t')
legend('||q(t) - q^*(t)||_2', 'max {i : q(t, i) > 0}', '\lambda(t)', 'l(t)');
