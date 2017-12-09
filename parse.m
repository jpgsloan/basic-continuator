function [p] = parse(m)

% error checking stage wants only integer values between 0 and 127,
% with at least two values,
% and needs m to be a column vector

% input 'm' for MIDI is MIDI pitch values already parsed from MIDI data

% output 'p' for prefixes is a multi-dimensional cell array

p = cell(length(m)-1, 1);

if size(m,2) > size(m,1)
    m = m';
end

for i = length(m)-1:-1:1
    
    co = ones(i,1) * i + 1;
    p{i} = [m(i:-1:1),co];

end