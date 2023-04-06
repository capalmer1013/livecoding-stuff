use_bpm 80
noteList = []

noteChoices = chord(:c3, :M7, num_octaves:3) #+ scale(:c4, :aeolian, num_octaves:2)
16.times do
  noteList.push(choose(noteChoices))
end

live_loop :b do
  sync :thepiano
  with_fx :reverb do
    with_synth :pluck do
      2.times do
        j = 0
        noteList.each do |i|
          play choose([i]*5 + [:r]*j), amp: rrand(0.1, 0.5)
          sleep 0.5
          j += 1
        end
      end
    end
  end
end

live_loop :a do
  cue :thepiano
  with_fx :reverb do
    with_synth :blade do
      noteList.each do |i|
        play i, attack: 1, release: 2, sustain: rrand(1, 2), amp: rrand(0.1, 0.3), pan: rrand(-0.5, 0.5)
        sleep 1
      end
    end
  end
end




