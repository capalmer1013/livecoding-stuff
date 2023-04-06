use_random_seed Time.now.to_i
s_808 = "C:\\Users\\Chris Palmer\\Desktop\\NS_SamplePack1\\808s"
s_dirt ="C:\\Users\\Chris Palmer\\Desktop\\Dirt-Samples-master\\**"
s_loops = "C:\\Users\\Chris Palmer\\Desktop\\Hainbach - Isolation Loops (soundpack)\\loops"
use_bpm 80

layers= 4
loop_len = 8

slices = []
loop_8 = []

loop_len.times do
  slices.push(rrand_i(0, loop_len))
end

layers.times do
  loop_8.push(rrand_i(0, 1000))
end

4.times do
  slices.each do |i|
    loop_8.each do |j|
      sample s_loops, j, pan: rrand(-1, 1), num_slices: loop_len, slice: i, beat_stretch: loop_len
    end
    sleep 1
  end
end
stop
