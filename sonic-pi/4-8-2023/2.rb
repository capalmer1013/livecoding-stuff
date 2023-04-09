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
  puts "out of the while"
  
  if !prev_note
    return avail_notes.choose
  end
  puts avail_notes
  sorted = avail_notes.flatten.sort
  i = sorted.index(prev_note)
  if !i
    return avail_notes.choose
  end
  
  i += rrand_i(-2, 2)
  i = [sorted.length-1, [0, i].max].min
  return sorted[ i ]
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
    play n_ote-24, release: r_elease, amp: [1.0, 1.0/r_elease].min, pan: rrand(-1.0, 1.0)
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

def w_chop_amen(slice)
  sample :loop_amen, num_slices: 8, slice: slice, amp: 0.5
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
      ##| w_sample(e[:sample], n_beats/l.length.to_f)
      w_chop_amen(e[:sample])
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




def generate_events(num_events, subdivisions, notes=nil, chords=nil)
  if num_events == 0
    return []
  end
  n_slices = 8
  ##| samples = [:bd_fat, :drum_cymbal_closed, :elec_snare]
  samples = (0..n_slices).to_a
  
  if !notes && !chords
    key = :c
    tonality = :aeolian
    chords = create_n_chords(num_events, key, tonality)
    notes = scale(key, tonality, num_octaves: 3)
    subdivisions = [6, 2]
  end
  events = []
  
  if subdivisions && subdivisions.length > 0
    new_n_events = subdivisions[0]
    subdivisions = subdivisions.slice(1, subdivisions.length-1)
  else
    new_n_events = 0
  end
  
  puts "notes boi", notes
  prev_notes = []
  next_note = notes.choose
  
  num_events.times do |i|
    event = {
      :note   => next_note,
      :sample => samples.choose,
      :chord  => chords ? chords[i]: nil,
      :l      => new_n_events > 0 ? generate_events(
        new_n_events,
        subdivisions=subdivisions,
        notes + (chords ? chords : []).flatten,
        chords=nil,
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
  n_beats = 5
  test = generate_events(n_beats, [6, 4])
  puts test
  ##| stop
  4.times do
    recursive_play(test, n_beats*4)
    
  end
end


