use_random_seed Time.now.to_i

def randomChord()
  return chord(choose(scale(:c3, :chromatic)), choose(chord_names))
end

def createNode(maxSleep=8.0, n=nil)
  if n == nil
    n = choose(scale(:c3, :chromatic, num_octaves: 3))
  else
    n = n + rand_i(1, 3) *choose([-1, 1])
  end
  #sleepTime = rrand(maxSleep/2.0, maxSleep)
  sleepTime = 0.5
  return {
    children: [],
    sleepTime: sleepTime,
    attkTime: sleepTime/2.0,
    chord: randomChord(),
    note: n,
    maxSleep: maxSleep,
    pan: rrand(-1.0, 1.0),
    amp: rrand(0.001, 1.0),
    ttl: 100,
  }
end

def mutateNode(n)
  if choose([0, 1, 2, 3]) == 1
    n[:children].push(createNode(maxSleep=n[:maxSleep]/2, n=n[:note]))
  end

  if choose([0, 1, 2]) == 1
    n[:sleepTime] += rrand(-0.1, 0.1)
  end

  if choose([0, 1, 2]) == 1
    n[:note] += rrand(-0.1, 0.1)
  end


  n[:children].each do |i|
    mutateNode(i)
  end
end

def playNode(n)
  #play_chord n[:chord], sustain: n[:sleepTime], attack: n[:attkTime]
  if n[:ttl] >= 0
    play n[:note], sustain: n[:sleepTime], attack: n[:attkTime], pan: n[:pan], amp: (n[:amp] * (n[:ttl]/100.0).abs())
    n[:ttl] -= 1
  end
  sleep n[:sleepTime]
  in_thread do
    n[:children].each do |i|
      playNode(i)
    end
  end
end


head = createNode()

live_loop :a do
  with_fx :reverb do
    puts head
    mutateNode(head)
    playNode(head)
  end
end
