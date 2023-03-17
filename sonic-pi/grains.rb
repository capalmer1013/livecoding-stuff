# granular
use_random_seed Time.now.to_f
use_bpm 120
use_synth :sine
moto = "/home/cpalmer/Music/samples/motorcycle.wav"

root = 108
wave_freq = 15
n_grains = 128

use_tuning :just, hz_to_midi(root)

grain_sequence = []
16.times do
  grain_sequence.push(rrand_i(0,n_grains))
end


# functions
# ================================================================================================

# live_loops
# ================================================================================================

live_loop :granular do
  grain_sequence.each do |i|
    sample moto, num_slices: n_grains, slice: i, pan: rrand(-1.0, 1.0), amp: 3, release: 0, sustain: 0.05
    sleep rand(0.125)
  end
end

