use_random_seed Time.now.to_i
sample_dir = "C:\\Users\\Chris Palmer\\Desktop\\NS_SamplePack1\\808s"
other_samples ="C:\\Users\\Chris Palmer\\Desktop\\Dirt-Samples-master\\**"
#use_bpm rrand_i(40, 80)
use_bpm 60
$a = []
$b = []
$c = []
$d = []
sample_len = 16
$rest_chance = 4
sample_len.times do
  rrand_i(1, 8).times do
    $a.push(choose(scale(:c3, :lydian, num_octaves: 2) + [:r]*$rest_chance + [:c3]*2 + chord(:c, :maj) * 4) )
  end
end

def modify_lists
  $a[rrand_i(0, $a.length)] = choose(scale(:c2, :lydian, num_octaves: 2) + [:r]*$rest_chance)
end

#midi :c4, port: "loopbe_intern"
live_loop :a do
  sample_len.times do |i|
    midi_note_on $a[i], rrand_i(64, 120), release: 1, port: "loopbe_internal_midi"
    #play $a[i], sustain: 0.25
    sleep 0.25
    #midi_note_off $a[i]
  end
  modify_lists
end
