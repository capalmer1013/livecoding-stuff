use_random_seed Time.now.to_i
use_bpm 80

layers= 4
loop_len = 8

key = :c3
mode = :lydian
synth_sound = choose([:sine, :fm, :growl, :hollow, :hoover, :mod_beep, :mod_dsaw])
seq_len = 16
rest_amt = 4
sleep_time = 0.5
seq = []

seq_len.times do
  seq.push(choose(scale(key, mode, num_octaves: 2) +[:r]*0 ))
end

puts synth_sound
4.times do
  with_synth synth_sound do
    seq_len.times do |i|
      play seq[i], release: sleep_time + 0.1
      sleep sleep_time
    end
  end
end
stop