function Widthfactor = wratio(ratio)

% function Widthfactor = wratio(ratio)
%   This function takes the width ratio, ratio, and 
%   calculates the width factor, Widthfactor, by looking
%   up within the data set previously determined
%
%   inputs:
%       ratio           the width ratio, 0<ratio<2
%   outputs:
%       Widthfactor     the corresponding width factor
%

% if the width ratio is out of range, give an error
if (ratio>2)||(ratio<0)
    disp('error in width ratio range');
    return
end

% load the previously determined width factor data
temp = load('width');
W = temp.W;
wr = temp.wr;

% for the given width ratio, find what the width factor is
% first determine which value of 'wr' is closest to 'ratio'
for n = 1:length(wr),
    if ratio > wr(n),
        index = n;
    end
end

Widthfactor = W(index);
