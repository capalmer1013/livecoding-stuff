use_random_seed Time.now.to_i
use_bpm 120


# =====================================================================================
# choice utils


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
  # sort notes by how close they are to the previous note
  # random choose with 1.0/i chance of each index
  prev_note = prev_notes.last
  while !prev_note && prev_notes.length > 0
    prev_note = prev_notes.pop
  end
  
  if !prev_note
    return avail_notes.choose
  end
  
  sorted = avail_notes.sort
  i = sorted.index(prev_note)
  return sorted[min(0, max(sorted.length-1, i+rrand_i(-2, 2)))]
end


def create_n_chords(n, key, tonality)
  chords = []
  prev_chord = 1
  n.times do
    chords.push(
      chord_degree(
        prev_chord,
        key,
        tonality
      )
    )
    prev_chord = next_chord(prev_chord)
  end
  return chords
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
    chords = create_n_chords(num_events, key, tonality)
    notes = scale(key, tonality, num_octaves: 3)
    samples = [:bd_fat, :drum_cymbal_closed, :elec_snare]
    subdivisions = [2, 3]
  end
  events = []
  
  ##| new_n_events = subdivisions ? subdivisions.pop : (num_events*0.7).to_i
  ##| new_n_events = (num_events*0.7).to_i
  new_n_events = subdivisions.last ? subdivisions.pop : 0
  
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


