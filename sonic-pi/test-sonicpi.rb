use_random_seed Time.now.to_f
use_bpm 80
use_synth :sine

moto = "/home/cpalmer/Music/samples/motorcycle.wav"

puts current_synth
# functions
# ================================================================================================
define :create_melody do |len|
  result = []
  len.times do
    note = create_note(pitch=choose(scale(:c2, :major, num_octaves: 2)), duration=rrand(0.125, 1.0))
    result.push(note)
  end
  return result
end

define :modify_melody do |l, n_changes|
end

define :create_note do |pitch=60, duration=0.5, amp=0.5, pan=0.0, attack=0.0, decay=0.0, sustain=0.0, release=1.0|
  note = {
    :pitch => pitch,
    :duration => duration,
    :amp => amp,
    :pan => pan,
    :synth => current_synth,
  }
  # play note[:pitch], sustain: note[:duration], amp: note[:amp]
  return note
end


# Variables
# ================================================================================================
melody = create_melody(16)
melody2 = create_melody(16)
sleep_time = 0.125

# live_loops
# ================================================================================================
live_loop :a do
  with_fx :reverb do
    sample moto, amp: rand(0.5), attack: rand(1.0), rate: rrand(0.1, 0.5), pan: rrand(-1.0, 1.0)
  end
  
  sleep rand(2.0)
end


live_loop :melody do
  melody.each do |n|
    play n[:pitch], amp: n[:amp], release: n[:duration]
    sleep n[:duration]
  end
end

live_loop :melody2 do
  melody2.each do |n|
    play n[:pitch], amp: n[:amp], release: n[:duration]
    sleep n[:duration]
  end
end
