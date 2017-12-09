% function [p] = parse(m)
% 
% % error checking stage wants only integer values between 0 and 127,
% % with at least two values,
% % and needs m to be a column vector
% 
% % input 'm' for MIDI is MIDI pitch values already parsed from MIDI data
% 
% % output 'p' for prefixes is a multi-dimensional cell array
% 
% p = cell(length(m)-1, 1);
% 
% if size(m,2) > size(m,1)
%     m = m';
% end
% 
% for i = length(m)-1:-1:1
%     
%     co = ones(i,1) * i + 1;
%     p{length(m)-i} = [m(i:-1:1),co];
% 
% end

function [prefix] = parse(midi_input)

            % error checking stage wants only integer values between 0 and 127,
            % with at least two values,
            % and needs m to be a column vector

            % input 'm' for MIDI is MIDI pitch values already parsed from MIDI data

            % output 'p' for prefixes is a multi-dimensional cell array

            prefix = [];
            overall = 0;%length(obj.training_input);

            if size(midi_input,2) > size(midi_input,1)
                midi_input = midi_input';
            end

            for i = length(midi_input)-1:-1:1
    
                contin_indices = ones(i,1) * i + 1 + overall;
                prefix = [midi_input(i:-1:1),contin_indices];

                new_nodes(size(prefix,1),1) = Node;
                for j = size(prefix, 1):-1:1
                    new_nodes(j).note_value = prefix(j,1);
                    new_nodes(j).add_contin(prefix(j,2));
                    if j < size(prefix, 1)
                       new_nodes(j).add_child(new_nodes(j+1));
                    end
                end
                
%                 obj.add_input(new_nodes(1));
                clear new_nodes;
            end
        end