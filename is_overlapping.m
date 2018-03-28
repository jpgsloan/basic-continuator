function [is_overlapping] = is_overlapping(note1, note2)

is_overlapping = false;

start_time1 = note1(5);
end_time1 = note1(6);

start_time2 = note2(5);
end_time2 = note2(6);

if ((end_time1 - start_time2) > 0.03)
   is_overlapping = true; 
end

end