%A token-vector is an integer-valued vector such that its first entries are
%postive and increasing, and the remaining entries are zero.
%This function checks if a token-vector is nonzero.
function b = notempty(x)
    b = x(1) > 0;
end
