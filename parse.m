function [p] = parse(m)

% error checking stage wants only integer values between 0 and 127,
% with at least two values

% input 'm' for MIDI is MIDI pitch values already parsed from MIDI data

% output 'p' for prefixes is a multi-dimensional cell array

p = cell(length(m)-1,1);

for i = length(m)-1:-1:1
    
    p{i} = m(i:-1:1);

end