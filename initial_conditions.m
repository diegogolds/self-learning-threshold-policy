%This function generates vectors 'queues', 'tasks', 'green' and 'yellow'
%corresponding to the initial occupancy state 'state' of a system with N
%server pools, server pool size B and threshold l. The vector 'queues'
%indicates the number of tasks at each server pools. The vector tasks
%contains a list of server pool IDs such that each server pool is
%listed a number of times equal to the number of tasks it has. The
%vector 'green' contains a list of the server pools with a green token
%at the dispatcher. The vector 'yellow' contains a list of the server
%pools with a yellow token at the dispatcher.
function [queues, tasks, green, yellow] = initial_conditions(N, B, l, state)
    %Queues:
    queues = zeros(1, N);
    undef = 1;
    for j = undef : undef + N - state(1) - 1
        queues(j) = 0;
    end
    undef = undef + N - state(1);
    for i = 1 : B - 1
        for j = undef : undef + state(i) - state(i + 1) - 1
            queues(j) = i;
        end
        undef = undef + state(i) - state(i + 1);
    end
    for j = undef : undef + state(B) - 1
        queues(j) = B;
    end
    %Tasks:
    tasks = zeros(1, B * N);
    undef = 1;
    for i = 1 : N
        for j = undef : undef + queues(i) - 1
            tasks(j) = i;
        end
        undef = undef + queues(i);
    end
    %Green:
    green = zeros(1, N);
    for i = 1 : N
        if queues(i) < l
            green(i) = i;
        end
    end
    %Yellow:
    yellow = zeros(1, N);
    for i = 1 : N
        if queues(i) <= l
            yellow(i) = i;
        end
    end
end
