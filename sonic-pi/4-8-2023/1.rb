use_random_seed Time.now.to_i
use_bpm 120

event = {
  :note   => note(:c4),
  :sample => :bd_fat,
  :chord  => chord(:c4, :M7),
  :l      => []
}


def recursive_play(l, n_beats=4)
  l.each do |e|  # event
    if e[:note]
      play e[:note], release: n_beats*0.75, amp: [1.0, 1.0/(n_beats/2.0)].min
    end
    if e[:sample]
      sample e[:sample], release: n_beats/2.0, amp: 0.5
    end
    if e[:chord]
      play_chord e[:chord], release: n_beats/2.0
    end
    if e[:l].length > 0
      recursive_play(e[:l], n_beats/l.length.to_f)
    else
      sleep n_beats
    end
  end
end

def generate_events(num_events, notes, samples, chords)
  events = []
  
  num_events.times do
    event = {
      :note   => choose([nil]*4+[notes.choose]),
      :sample => choose([nil]*4+[samples.choose]),
      ##| :chord  => choose([nil]*8+[chords.choose]),
      :l      => generate_events(num_events/2, notes, samples, chords)
    }
    events.push(event)
  end
  
  events
end

chords = []
4.times do
  chords.push(chord_degree(rrand_i(1,7), :c3, :aeolian))
end

test = generate_events(7, scale(:c3, :aeolian, num_octaves: 3), [:bd_fat, :drum_cymbal_closed, :elec_snare], chords)
puts test


live_loop :a do
  16.times do
    recursive_play(test, 32)
  end
end


