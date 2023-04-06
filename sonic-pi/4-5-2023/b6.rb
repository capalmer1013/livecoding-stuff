sploop = "C:\\Users\\Chris Palmer\\Desktop\\sounds\\splops.wav"
use_random_seed Time.now.to_i
t = 0.125
l = []
d = []
nslices = 256
loopLen = 32
loopLen.times do
  l.append(rrand_i(0, nslices))
  d.append(choose([:bd_fat, :drum_cymbal_closed, :drum_snare_soft]))
end

live_loop :a do
  with_fx :reverb, mix: 1 do
    with_fx :slicer, mix: 0.125, phase: 0.125 do
      
      loopLen.times do |i|
        if i.even?
          sample :bd_fat, amp: 0.2
        end
        sample sploop,num_slices: nslices, slice: l[i], rate: -3, pan: rrand(-1, 1), amp: 2
        with_fx :bitcrusher, bits: 8, sample_rate: 32000 do
          sample d[i], rate: 0.2, amp: 0.5
        end
        sleep t
        
      end
    end
  end
end
