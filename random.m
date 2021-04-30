%System parameters:
lambda = 10.5;
tf = 5; %simulation time.
B = 41; %maximum number of tasks per server pool (much larger than lambda).
N = 500; %number of server pools
%State variables:
i = 1;
t = 0;
discarded = 0; %discarded tasks (should remain equal to zero).
%Initial condition:
state = zeros(1, B); %occupancy state.
[queues, tasks, ~, ~] = initial_conditions(N, B, floor(lambda), state);
%Output data:
events = round(2 * lambda * N * tf);
T = zeros(events);
D = zeros(events);
Q = zeros(events, N);
S = zeros(events, B);
%Time until next event:
arrival = exprnd(1 / (lambda * N));
departure = exprnd(1 / sum(queues));
[dt, event] = min([arrival departure]);
%Main loop:
while t + dt < tf
    %Time update:
    i = i + 1;
    t = t + dt;
    %Arrival:
    if event == 1
        k = randi(N);
        if queues(k) < B
            tasks = add(tasks, k);
            queues(k(1)) = queues(k) + 1;
            state(queues(k)) = state(queues(k)) + 1;
        else
            discarded = discarded + 1;
        end
    end
    %Departure:
    if event == 2
        k = draw(tasks);
        tasks = remove(tasks, k);
        state(queues(k)) = state(queues(k)) - 1;
        queues(k) = queues(k) - 1;
    end
    %Output data update:
    T(i) = t;
    D(i) = discarded;
    Q(i, :) = queues;
    S(i, :) = state;
    %Time until next event:
    arrival = exprnd(1 / (lambda * N));
    departure = exprnd(1 / sum(queues));
    [dt, event] = min([arrival departure]);
    %Waitbar:
    wbar = waitbar(t / tf);
end
close(wbar);
%Outoput data:
T = T(1 : i);
D = D(1 : i);
Q = Q(1 : i, :);
S = S(1 : i, :);
save('rnd');
