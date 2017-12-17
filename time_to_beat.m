function [beat_numbers] = time_to_beat(times, bpm)

beat_numbers = times * bpm / 60 + 1;

end