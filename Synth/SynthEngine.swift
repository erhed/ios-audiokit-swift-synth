import Foundation
import AudioKit

final class SynthEngine {

    var oscillator: AKOscillatorBank!
    var velocity: MIDIVelocity!

    init() {

        velocity = MIDIVelocity(100)

        let sawWave = AKTable(.sawtooth)

        oscillator = AKOscillatorBank(waveform: sawWave, attackDuration: 0.1, decayDuration: 2.0, sustainLevel: 0.3, releaseDuration: 0.5)

        //let envelope = AKAmplitudeEnvelope(oscillator, attackDuration: 0.01, decayDuration: 0.1, sustainLevel: 1.0, releaseDuration: 0.1)

        AudioKit.output = oscillator

        do {
            try AudioKit.start()
        } catch {
            print("ERROR")
        }
    }

    func noteOn(note: MIDINoteNumber) {
        oscillator.play(noteNumber: note, velocity: velocity)
    }

    func noteOff(note: MIDINoteNumber) {
        oscillator.stop(noteNumber: note)
    }
}
