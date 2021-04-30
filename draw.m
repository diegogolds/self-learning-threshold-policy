%A token-vector is an integer valued vector such that its first entries are
%postive and increasing, and the remaining entries are zero.
%This function chooses at random one of the nonzero entries of a
%token-vector.
function v = draw(x)
    if notempty(x)
        nonzero = find(x, 1, 'last');
        i = randi(nonzero);
        v = x(i);
    else
        error(strcat("There are no ", inputname(1), " tokens at the dispatcher"));
    end
end
