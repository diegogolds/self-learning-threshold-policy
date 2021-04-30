%A token-vector is an integer valued vector such that its first entries are
%postive and increasing, and the remaining entries are zero.
%This function adds the number v to the token-vector x.
function y = add(x, v)
    if x(end) == 0
        m = max(x);
        if m == 0
            j = 1;
        elseif v <= m
            j = find(x >= v, 1, 'first');
        else
            j = find(x == m, 1, 'last') + 1;
        end
        y = [x(1 : j - 1) v x(j : length(x) - 1)];
    else
        error(strcat("Attempted to add a ", inputname(1), " token from queue number ", num2str(v), " but it is not possible to have more of these tokens"));
    end
end
