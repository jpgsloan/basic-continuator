classdef Node < handle
    
    properties
        contin_list = [];
        children = [];
        
        % matrix of midi notes Nx8 (see Ken Schutte for col values) 
        full_midi = []; 
    end
    
    methods      
        % initializer
        function obj = Node(varargin)
            if nargin == 1
                obj.full_midi = varargin{1};
            elseif nargin == 3
                obj.full_midi = varargin{1};
                obj.contin_list = varargin{2};
                obj.children = varargin{3};
            else
                obj.full_midi = [];
                obj.contin_list = [];
                obj.children = [];
            end
        end
        
        % check if two nodes are equal
        function [comp] = is_equal(obj, other_node)
            
            % TODO: must update to check if note lists are equal.
            obj_note_values = obj.note_values();
            other_note_values = other_node.note_values();
            comp = (obj_note_values == other_note_values);
        end
        
        % pick from continuation list at random 
        function [next] = pick_contin(obj)
            i = randi(length(obj.contin_list));
            next = obj.contin_list(i);
        end
        
        % add to continuation list
        function [obj] = add_contin(obj, contin)
           obj.contin_list = [obj.contin_list, contin]; 
        end
        
        % add child node
        function [obj] = add_child(obj, child_node)
            obj.children = [obj.children, child_node];
        end
        
        function [has] = has_children(obj)
            has = ~isempty(obj.children);
        end
        
        function[note_values] = note_values(obj)
            if ~isempty(obj.full_midi) 
                note_values = obj.full_midi(:,3);
            end
        end
    end 
end