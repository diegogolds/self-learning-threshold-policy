%This function generates an increasing vector with the numbers 1,...,n
%repeated r times each and z zeros on the right.
function x = generate(n, r, z)
    x = zeros(1, n * r + z);
    for i = 1 : n
        for j = 1 : r
            x((i - 1) * r + j) = i;
        end
    end
end
