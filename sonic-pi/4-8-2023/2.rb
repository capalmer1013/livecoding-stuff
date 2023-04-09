use_random_seed Time.now.to_i
use_bpm 120

##| event = {
##|   :note   => note(:c4),
##|   :sample => :bd_fat,
##|   :chord  => chord(:c4, :M7),
##|   :l      => []
##| }



# =====================================================================================
# choice utils

##| def create_smooth_chord_cycle(key, num_chords)
##|   n_iterations = 2
##|   result = []
##|   num_chords.times do

##|   end
##| end


def next_chord(prev_chord_deg)
  chord_graph = {
    1=> [2, 3, 4, 5, 6, 7],
    2=> [1, 3, 4, 5, 6],
    3=> [2, 4, 6],
    4=> [1, 2, 5, 6],
    5=> [1, 2, 6],
    6=> [3, 4, 5, 7],
    7=> [1],
  }
  return chord_graph[prev_chord_deg].choose
end

def get_next_note(prev_notes, avail_notes)
  
end


# =====================================================================================
# Wrappers

def w_play(n_ote, r_elease) # n as in note
  with_synth :bass_foundation do
    play n_ote, release: r_elease, amp: [1.0, 1.0/r_elease].min, pan: rrand(-1.0, 1.0)
  end
end


def w_sample(s_ample, r_elease)
  with_fx :bitcrusher, bits: 8, sample_rate: 8000 do
    sample s_ample, release: r_elease, amp: 0.5
  end
end


def w_play_chord(c_hord, r_elease)
  ##| with_synth :blade do
  play_chord c_hord, release: r_elease, amp: 0.7, sustain: r_elease
  ##| end
end

# =====================================================================================
# recursive play and generate


def recursive_play(l, n_beats)
  puts n_beats
  l.each do |e|  # event
    if e[:note]
      w_play(e[:note], n_beats/l.length.to_f)
    end
    if e[:sample]
      w_sample(e[:sample], n_beats/l.length.to_f)
    end
    if e[:chord]
      w_play_chord(e[:chord], n_beats/l.length.to_f)
    end
    if e[:l] && e[:l].length > 0
      recursive_play(e[:l], n_beats/l.length.to_f)
    else
      puts n_beats/l.length.to_f
      sleep n_beats/l.length.to_f
    end
  end
end


def generate_events(num_events, notes=nil, samples=nil, chords=nil, subdivisions=nil)
  if num_events == 0
    return []
  end
  
  if !notes && !samples && !chords
    key = :c
    tonality = :aeolian
    chords = []
    prev_chord = 1
    num_events.times do
      chords.push(
        chord_degree(
          prev_chord,
          key,
          tonality
        )
      )
      prev_chord = next_chord(prev_chord)
    end
    
    notes = scale(key, tonality, num_octaves: 3)
    samples = [:bd_fat, :drum_cymbal_closed, :elec_snare]
    puts chords
    puts chords.length
    subdivisions = [2, 3]
  end
  events = []
  
  ##| new_n_events = subdivisions ? subdivisions.pop : (num_events*0.7).to_i
  new_n_events = (num_events*0.7).to_i
  
  prev_notes = []
  next_note = choose([nil]*4+[notes.choose])
  
  num_events.times do |i|
    event = {
      :note   => next_note,
      :sample => choose([nil]*4+[samples.choose]),
      :chord  => chords ? chords[i]: nil,
      :l      => new_n_events > 0 ? generate_events(
        new_n_events,
        notes + (chords ? chords: []),
        samples,
        chords=nil,
        subdivisions=subdivisions
      ): nil
    }
    
    prev_notes.push(next_note)
    next_note = get_next_note(prev_notes, notes)
    events.push(event)
    
  end
  
  return events
end



# =====================================================================================
# live loops

live_loop :a do
  n_beats = 7
  test = generate_events(n_beats)
  4.times do
    recursive_play(test, n_beats*2)
    
  end
end


