# Welcome to Sonic Pi v3.1
use_random_seed Time.now.to_i

a = "C:\\Users\\Chris Palmer\\Desktop\\sounds\\wee woo.wav"
b = "C:\\Users\\Chris Palmer\\Desktop\\sounds\\running.wav"
sploop = "C:\\Users\\Chris Palmer\\Desktop\\sounds\\splops.wav"
nslices = 256

nslice = 8
l = []
loopLen = 32

loopLen.times do
  l.append(rrand_i(0, nslices))
  #d.append(choose([:be_fat, :drum_cymbal_closed, :drum_snare_soft]))
end

live_loop :b do
  stop
  8.times do |i|
    sample b, num_slices: nslices, slice: l[i]#, beat_stretch: 1#, pan: rrand(-1, 1), amp: 3
    sleep 1
  end
end

live_loop :a do
  with_fx :reverb, mix: 1 do
    with_fx :slicer, mix: 0, phase: 0.0125 do
      
      #ssample a, beat_stretch: 1
      16.times do |i|
        if i % 8 == 0
          #sample :bass_dnb_f, beat_stretch: 1, amp: 1
          #sample b, num_slices: nslices, slice: l[i], pan: rrand(-1, 1), rate: -1, amp: 1
        end
        if i % 2 == 0
          #sample :bd_fat
        end
        sample sploop,num_slices: nslices, slice: l[i], rate: -3, pan: rrand(-1, 1), amp: 0.0
        #sample :drum_cymbal_closed, amp: 0.05
        #sample :loop_amen, amp: 0.5, slice: rrand_i(0, nslice), num_slices: nslice, sustain: 0.1, decay: 0.0, rate: 0.5
        sleep 0.125
      end
    end
  end
  
end
