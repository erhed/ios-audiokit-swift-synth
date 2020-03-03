import Foundation
import AudioKit

final class SynthEngine {

    var oscillator: AKOscillator!

    init() {

        let sawWave = AKTable(.sawtooth)

        oscillator = AKOscillator(waveform: sawWave)
        oscillator.frequency = 100.0
        oscillator.rampDuration = 2.0
        oscillator.amplitude = 0.5

        let envelope = AKAmplitudeEnvelope(oscillator, attackDuration: 0.01, decayDuration: 0.1, sustainLevel: 1.0, releaseDuration: 0.1)

        AudioKit.output = envelope

        do {
            try AudioKit.start()
        } catch {
            print("ERROR")
        }
    }

    func play() {
        oscillator.play()
    }
}
