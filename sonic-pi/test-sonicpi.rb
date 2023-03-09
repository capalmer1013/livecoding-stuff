use_random_seed Time.now.to_f
use_bpm 80
use_synth :sine
moto = "/home/cpalmer/Music/samples/motorcycle.wav"

root = 108
wave_freq = 15

use_tuning :just, hz_to_midi(root)


# functions
# ================================================================================================
define :create_melody do |len, max_depth=2|
  result = []
  len.times do
    # 1. note
    # 2. list
    # 3. :r
    puts [1, 2] + [2]*max_depth
    note_type = choose([1, 2] + [2]*max_depth)
    if max_depth > 0
      case note_type
      when 1
        note = create_note(pitch=choose(chord(hz_to_midi(root), :major, num_octaves: 3)))
      when 2
        note = create_melody(rrand_i(1, len), max_depth=max_depth-1)
      when 3
        note = :r
      end
    else
      note = create_note(pitch=choose(chord(hz_to_midi(root), :major, num_octaves: 2)))
    end
    result.push(note)
  end
  return result
end

define :play_melody do |melody, t|
  puts melody
  new_t = t/melody.length
  melody.each do |n|
    if n.is_a?(Array)
      play_melody(n, new_t)
      
    elsif n.is_a? Hash
      play n[:pitch], amp: n[:amp], release: new_t, attack: n[:attack], pan: n[:pan]
      sleep new_t
      
    end
  end
end

define :create_note do |pitch=60, amp=0.7, pan=0.0, attack=0.0, decay=0.0, sustain=0.0|
  attack_values = [0.125, 0.25, 0.5, 1]
  note = {
    :pitch => pitch,
    :amp => rrand(0.2, 0.8),
    :pan => rrand(-0.8, 0.8),
    :synth => current_synth,
    :attack => choose(attack_values),
  }
  return note
end

def signal_chain(fx_list, &play_fn)
  if fx_list.empty?
    play_fn.call()
  else
    this_fx = fx_list.pop
    with_fx this_fx do
      signal_chain(fx_list, play_fn)
    end
  end
end

# live_loops
# ================================================================================================
live_loop :binaural_beats do
  amp = 0.05
  with_synth :sine do
    play hz_to_midi(root),           release: 8, decay: 0, sustain: 7, pan: -1, amp: amp, attack: 1.0
    play hz_to_midi(root+wave_freq), release: 8, decay: 0, sustain: 7, pan: 1,  amp: amp, attack: 1.0
  end
  with_synth :pnoise do
    play root, release: 8, decay: 0, sustain: 8, amp: amp*0.05, attack: 1.0
  end
  sleep 8
end

live_loop :a do
  # sample moto, amp: rand(0.1), attack: rand(1.0), rate: rrand(0.1, 0.5), pan: rrand(-1.0, 1.0)
  sleep rand(2.0)
end

live_loop :bc do
  melody = create_melody(3, max_depth=1)
  fx_list = [:bitcrusher, :reverb]
  play_fn = lambda { play_melody(melody, 3.0) }
  4.times do
    play_melody(melody, 12.0)
  end
  
end
puts chord(:c, '11+')