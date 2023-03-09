use_random_seed Time.now.to_f
use_bpm 80
use_synth :sine

moto = "/home/cpalmer/Music/samples/motorcycle.wav"

# functions
# ================================================================================================
define :create_melody do |len, max_depth=2|
  result = []
  len.times do
    # 1. note
    # 2. list
    # 3. :r
    note_type = choose([1, 2, 3])
    case note_type
    when 1
      note = create_note(pitch=choose(scale(:c2, :major, num_octaves: 2)), duration=rrand(0.125, 1.0))
    when 2
      note = create_melody(len, max_depth=max_depth-1)
    when 3
      note = :r
    else
      puts "Invalid note type"
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
      play n[:pitch], amp: n[:amp], release: n[:duration]
      sleep new_t
    else
      puts n
      puts "invalid melody thing"
    end
  end
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
melody = create_melody(4)

# live_loops
# ================================================================================================
live_loop :a do
  sample moto, amp: rand(0.5), attack: rand(1.0), rate: rrand(0.1, 0.5), pan: rrand(-1.0, 1.0)
  sleep rand(2.0)
end

live_loop :melody do
  play_melody(melody, 4)
end
