function [V,v] = edit_distance(string1,string2)
% Calculate edit distance between arrays s1 and s2. 
% This gives the min number of operations needed to convert array s1 to s2. 
%
% Adapted from code by Reza Ahmadzadeh

m=length(string1);
n=length(string2);
v=zeros(m+1,n+1);
for i=1:1:m
    v(i+1,1)=i;
end
for j=1:1:n
    v(1,j+1)=j;
end
for i=1:m
    for j=1:n
        if (string1(i) == string2(j))
            v(i+1,j+1)=v(i,j);
        else
            v(i+1,j+1)=1+min(min(v(i+1,j),v(i,j+1)),v(i,j));
        end
    end
end
V=v(m+1,n+1);
end