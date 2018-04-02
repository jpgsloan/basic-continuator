function [nodes] = notes2nodes(notes)
% converts a 1xN array of note values (ints) to Node objects.

chords = group_chords(notes);
length = size(chords,2);
nodes(1,length) = Node;
for i=1:length
   nodes(1,i) = Node(chords{i},[],[]);
    
end

end