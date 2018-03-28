function [nodes] = notes2nodes(notes)
% converts a 1xN array of note values (ints) to Node objects.
% TODO: convert notes to nodes with polyphony
length = size(notes,2);
nodes(1,length) = Node;
for i=1:length
    nodes(1,i) = Node(notes(1,i), [], []);
end

end