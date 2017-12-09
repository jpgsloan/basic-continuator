classdef Node < handle
    
    properties
        
        note_value = [];
        contin_list = [];
        children = [];
        
    end
    
    methods
        
        % initializer
        
        function obj = Node(note_value, contin_list, children)
            
            obj.note_value = note_value;
            obj.contin_list = contin_list;
            obj.children = children;
            
        end
        
        % equality testing function
        
        function [comp] = is_equal(obj, other_node)
           
            comp = (obj.note_value == other_node.note_value);
            
        end
        
        % random continuation function
        
        function [next] = rand_contin(obj)
           
            i = randi(length(obj.contin_list));
            next = obj.contin_list(i);
            
        end
        
        % add to continuation list
        
        function [obj] = add_contin(obj, contin)
            
           obj.contin_list = [obj.contin_list, contin]; 
            
        end
        
        % add child function
        
        function [obj] = add_child(obj, child_node)
            
            obj.children = [obj.children, child_node];
            
        end
        
    end
    
end