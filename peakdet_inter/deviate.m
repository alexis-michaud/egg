function [Sderiv] = deviate(SIG)
    for w = 1 : length(SIG) - 1
       Sderiv (w) = SIG (w + 1) - SIG (w);
    end
end