import UIKit
import AudioKit

class ViewController: UIViewController {

    @IBOutlet weak var keyboardView: KeyboardView!

    var synthEngine: SynthEngine?

    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardView.delegate = self

        synthEngine = SynthEngine()
    }
}

extension ViewController: KeyboardDelegate {
    func noteOn(note: MIDINoteNumber) {
        synthEngine?.noteOn(note: note)
        print("note on: \(note)")
    }

    func noteOff(note: MIDINoteNumber) {
        synthEngine?.noteOff(note: note)
        print("note off: \(note)")
    }
}

