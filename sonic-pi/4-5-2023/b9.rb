use_bpm 80
use_random_seed Time.now.to_i

a = rrand_i(1, 5)
b = rrand_i(1, 5)
c = rrand_i(2, 8)
samples = [:glitch_perc1, :glitch_perc2, :glitch_perc3, :glitch_perc4, :glitch_perc5]
l = []
mel_list = scale(:g3, :major) + chord(:g2, :maj) *8 + [:r]*4

chop = []
loopLen = 16
loopLen.times do
  chop.push(rrand_i(0, 16))
end


rrand_i(8, 16).times do
  l.push(choose(samples))
end

define :change_melody do
  tmp = []
  loopLen.times do
    tmp.push(choose(mel_list))
  end
  return tmp
end

define :change_one_element do |list|
  list[rrand_i(0, list.length())] = choose(samples)
  return list
end

live_loop :a do
  stop
  rrand_i(16, 32).times do
    sample :bd_fat, pan: 0.75, amp: 0.5
    sleep a
  end
  a = rrand_i(1, 5)
  stop
end

live_loop :b do
  stop
  rrand_i(16, 32).times do
    sample :bd_fat, pan: -0.75, amp: 0.5
    sleep b
  end
  b = rrand_i(1, 5)
  stop
end

live_loop :c do
  stop
  l.each do |i|
    sample i, amp: 0.1, rate: 0.75, release: 1
    sleep c
  end
  c = rrand_i(2, 8)
  l = change_one_element(l)
  stop
end

live_loop :d do
  stop
  rrand_i(2, 32).times do
    mel = change_melody()
    sleepTime = choose([0.25, 0.5, 1])
    mel.each do |i|
      play i, amp: 0.1, release: sleepTime, pan: rrand(-1, 1)
      sleep sleepTime
    end
  end
  stop
end

live_loop :e do
  sleepTime = 0.25
  mel = change_melody()
  chop = []
  loopLen.times do
    chop.push(rrand_i(0, 16))
  end
  with_fx :reverb do
    
    #sample :ambi_choir, beat_stretch: loopLen , amp: 1
    #sample :loop_3d_printer, beat_stretch: loopLen, amp: 0.05, pan: rrand(-0.5, 0.5)
    #sample :ambi_drone, beat_stretch: loopLen, amp: 1, pan: rrand(-0.5, 0.5)
    #sample :ambi_glass_rub, beat_stretch: loopLen, amp: 0.2, pan: rrand(-0.5, 0.5)
    2.times do
      loopLen.times do |i|
        if i.even?
          #sample :bd_fat, rate: 1
          sample :loop_tabla, num_slices: 16, slice: chop[i], pan: rrand(-0.7, 0.7), amp: 0.5
        end
        
        play mel[i], amp: 0.7, release: sleepTime
        #sample :loop_tabla, num_slices: 16, slice: chop[i], pan: rrand(-0.7, 0.7), amp: 0.7
        with_fx :bitcrusher, bits: 88 do
          #sample :loop_amen, num_slices: 16, slice: chop[i], pan: rrand(-0.7, 0.7), amp: 0.5
        end
        
        sleep sleepTime
      end
    end
  end
  #stop
end

