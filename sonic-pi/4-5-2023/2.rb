rand_seed = 6000
# rand_seed = Time.now.to_i
use_random_seed rand_seed
use_bpm 120

p = []  # p for pattern
s = []  # s for slices
d = []  # d for drum

n_slices = 128
phrase_length = 32
cycletime = 0.125

# init phase pattern
16.times do
  p.push(choose([:r, :bd_fat]))
end

# init slices
phrase_length.times do
  s.push(rrand_i(0, n_slices))
end

# init drum
phrase_length.times do
  d.push(choose [:bd_fat, :elec_hi_snare, :drum_cymbal_closed])
end


phase_bd = true


# ======================================================================

##| # live loop template

##| live_loop :tmp do
##|   x.times do |i|
##|     sleep cycletime
##|   end
##| end


live_loop :l do
  if !phase_bd
    stop
  end
  
  p.each do |i|
    if i != :r
      sample i, pan: -1, amp: 0.5
    end
    sleep cycletime + 0.00001
  end
end

live_loop :r do
  if !phase_bd
    stop
  end
  
  p.each do |i|
    if i != :r
      sample i, pan: 1, amp: 0.5
    end
    sleep cycletime
  end
end

live_loop :l2 do
  if !phase_bd
    stop
  end
  
  p.each do |i|
    if i != :r
      sample i, pan: -0.5, amp: 0.75
    end
    sleep cycletime + 0.000001
  end
end

live_loop :r2 do
  if !phase_bd
    stop
  end
  
  p.each do |i|
    if i != :r
      sample i, pan: 0.5, amp: 0.75
    end
    sleep cycletime + 0.0001
  end
end


live_loop :micro do
  cue :one
  
  s.each do |i|
    sample :mehackit_robot1, num_slices: n_slices, slice: i
    sleep cycletime
  end
end

live_loop :drums do
  sync :one
  with_fx :bitcrusher, sample_rate: 1000, bits: 12 do
    with_fx :reverb do
      d.each do |i|
        sample i, amp: 0.5
        sleep cycletime
      end
    end
  end
  
end


