rand_seed = 6000
# rand_seed = Time.now.to_i
use_random_seed rand_seed
use_bpm 120

p = []  # p for pattern
s = []  # s for slices

n_slices = 128


16.times do
  p.push(choose([:r, :bd_fat]))
end

32.times do
  s.push(rrand_i(0, n_slices))
end



# ======================================================================

live_loop :l do
  p.each do |i|
    if i != :r
      sample i, pan: -1, amp: 0.5
    end
    sleep 0.125001
  end
end

live_loop :r do
  p.each do |i|
    if i != :r
      sample i, pan: 1, amp: 0.5
    end
    sleep 0.125
  end
end

live_loop :l2 do
  p.each do |i|
    if i != :r
      sample i, pan: -0.5, amp: 0.75
    end
    sleep 0.1250001
  end
end

live_loop :r2 do
  p.each do |i|
    if i != :r
      sample i, pan: 0.5, amp: 0.75
    end
    sleep 0.12501
  end
end


live_loop :micro do
  sleep 1
end



