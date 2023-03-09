use_random_seed Time.now.to_f
use_bpm 80
moto = "/home/cpalmer/Music/samples/motorcycle.wav"


# functions
# ================================================================================================
define :create_melody do |len|
  result = []
  len.times do
    result.push(choose(scale(:c2, :major, num_octaves: 2)))
  end
  return result
end

define :modify_melody do |l, n_changes|
end

define :create_notehash do ||
  note = {
    :pitch => 60,
    :duration => 0.5,
    :amp => 0.5
  }
  # play note[:pitch], sustain: note[:duration], amp: note[:amp]
  return note
end


# Variables
# ================================================================================================
melody = create_melody(16)
sleep_time = 0.25

# live_loops
# ================================================================================================
live_loop :a do
  with_fx :reverb do
    sample moto, amp: rand(3.0), attack: rand(1.0), rate: rrand(0.1, 0.5), pan: rrand(-1.0, 1.0)
  end
  
  sleep rand(2.0)
end


live_loop :melody do
  melody.each do |n|
    play n, amp: rrand(0.1, 0.3)
    sleep sleep_time
  end
end
