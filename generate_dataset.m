filename = 'test-midi/3a0e08597088225b13edaab26ce1e7d2.mid';
midi = readmidi(filename);
[bpm, ts] = time_calc(midi);

output_data = contins_for_file(filename,1,4);
output_data = analyze_contins(output_data,4,bpm,ts,true);