# metamorphosis 6/26/2020
use_random_seed Time.now.to_i
use_bpm rrand(60, 120)

key = :c1
mode = :lydian
chord_prog =
  sample_dir = "C:\\Users\\Chris Palmer\\Desktop\\Dirt-Samples-master\\**"
puts sample_groups
group_list = [:elec, :sn, :tabla]
#sampleList = [:bd_boom, :bd_klub]
synthList = [:prophet, :fm, :blade, :dsaw, :dtri, :saw, :pulse, :tri]
synth_set = choose(synthList)
puts synth_set
#group_list.each do |i|
#  sampleList += sample_names(i)
#end
tmpsampleList = sample_paths(sample_dir)
sampleList = []
tmpsampleList.each do |i|
  sampleList.push(i.gsub('/', '\\'))
end

#sampleList.delete(:elec_cymbal)

define :play_cycle do |cycle, beats|
  cycle_time = beats.to_f/cycle.length().to_f
  cycle.each do |i|
    do_sleep = true
    if i.is_a? Symbol
      sample i, rate: 0.5
    elsif i.is_a? String
      sample i, rate: 0.5
    elsif i.is_a? Fixnum
      with_synth synth_set do
        play i, release: cycle_time, amp: 0.7 #, pan: rrand(-1, 1)
      end
    elsif i.is_a? Array
      play_cycle(i, cycle_time)
      do_sleep = false
    end
    #puts i.class
    if do_sleep
      sleep cycle_time
    end
    
  end
  
end
define :random_pattern do
  result = []
  rrand_i(1, 4).times do
    choice = rrand_i(1, 3)
    if choice == 1
      tmp = choose(sampleList)
    elsif choice == 2
      tmp = rrand_i(24, 64)
    elsif choice == 3
      tmp = random_pattern()
    end
    result.append(tmp)
  end
  puts result
  return result
end

define :random_single do
  tmp = []
  choose([2, 3, 4, 5]).times do
    choice = rrand_i(1,2)
    #choice = 2
    if choice == 1
      tmp.append(choose(sampleList))
    elsif choice == 2
      tmp.append(choose(scale(key,mode, num_octaves: 3)))
    end
  end
  return tmp
end

define :modify_pattern do |pattern|
  choice = rrand_i(2, 3)
  if choice == 1
    tmp = choose(sampleList)
  elsif choice == 2
    tmp = choose(scale(key,mode, num_octaves: 3))
  elsif choice == 3
    tmp = random_single()  # to keep from nesting too much too fast
  end
  
  choice = choose([1, 3] + [2]*10)  # shrink, stay the same, grow
  #choice = 2
  if choice == 1
    pattern.delete_at(rrand_i(0, pattern.length()))
  elsif choice == 2
    pattern[rrand_i(0, pattern.length())] = tmp
  elsif choice == 3
    pattern.insert(rrand_i(0, pattern.length()), tmp)
  end
  puts pattern
  return pattern
  
end
init_pattern = []
rrand_i(4, 12).times do
  init_pattern.append(choose(scale(key,mode, num_octaves: 3)))
end

rrand_i(0, 12).times do
  init_pattern = modify_pattern(init_pattern)
end


live_loop :a do
  puts init_pattern
  if rrand_i(0, 12) == 0
    puts "boogie time"
    init_pattern = []
    rrand_i(4, 12).times do
      init_pattern.append(choose(scale(key,mode, num_octaves: 3)))
    end
    
    rrand_i(0, 12).times do
      init_pattern = modify_pattern(init_pattern)
    end
  end
  
  current_pattern = init_pattern.clone
  in_thread do
    init_pattern = modify_pattern(init_pattern)
  end
  
  with_fx :reverb, mix: 0.5 do
    with_fx :compressor do
      2.times do  # how often to modify loop
        play_cycle(current_pattern, 4)
      end
    end
  end
end


live_loop :b do
  stop
  play_cycle(init_pattern, 8)
end

# THANK YOU








#init_pattern = random_pattern()