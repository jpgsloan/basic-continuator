function [timing] = continuation_timing(last_note_midi, contin_midi)
% last_note_midi - full midi of the LAST note(s) of a node. 
% contin_midi - full midi of the FIRST note(s) of a continuation node.
% timing - the time delay between LAST and FIRST.

end_time = last_note_midi(end,6);
contin_start_time = contin_midi(1,5);

timing = contin_start_time - end_time;

end