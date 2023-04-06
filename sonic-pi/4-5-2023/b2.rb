
$sample_dir = "D:\\desktop backup\\Dirt-Samples-master\\**"
"D:\desktop backup\Dirt-Samples-master\all-samples"
use_random_seed Time.now.to_i
use_bpm 200#rrand_i(60, 100)
def modify(a, layers, beatTime)
  rrand_i(1, 2).times do
    a = a.push(makeRecursiveBeats(layers, beatTime))
    a.delete_at(rrand_i(0, a.length))
  end
  return a
end

def makeRecursiveBeats(layers, beatTime)
  loopLen = rrand_i(1, 4)  # the magic number right here
  #loopLen = 3
  if layers < 0
    return choose([:r]+[{s: rrand_i(0, 100000), d: $sample_dir, t: beatTime/loopLen.to_f, a: rrand(0.5, 1.0), p: rrand(-1, 1) }]*4)
  end
  a = []
  loopLen.times do
    #if choose([true]*(layers+2)+[false])
    a.push(makeRecursiveBeats(layers-1, beatTime/loopLen.to_f))
    #else
    #  a.push({s: rrand_i(0, 100000), d: $sample_dir, t: beatTime/loopLen.to_f, })
    #end
  end
  return a
end

def playRecursiveBeat(l, t)
  l.each do |i|
    if t > 1
      sample :bd_fat
    end
    if i.is_a?(Hash)
      sample i[:d], i[:s], sustain: i[:t]*$sustainMult, rate: 0.5, amp: i[:a], pan: i[:p]#, beat_stretch: i[:t]
      sleep i[:t]
      
    elsif i.is_a?(Array)
      playRecursiveBeat(i, t/l.length.to_f)
      
    elsif i.is_a?(Symbol)
      #sample i
      sleep t
    else
      sleep t
    end
  end
end

a = makeRecursiveBeats(2, 16)
$sustainMult = 1.4
layers = 3
a = makeRecursiveBeats(layers, 16)
live_loop :a do
  
  beatTime = 8
  #with_fx :reverb do
  #stop
  with_fx :reverb do
    with_fx :lpf, cutoff: 115 do
      with_fx :bitcrusher, sample_rate: 100 do
        2.times do
          2.times do
            playRecursiveBeat(a, 16)
          end
          a = modify(a, layers, beatTime)
        end
      end
    end
  end
  #end
  stop
  #layers += 1
end
