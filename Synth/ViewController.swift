import UIKit
import AudioKit

class ViewController: UIViewController {

    @IBOutlet weak var keyboardView: KeyboardView!

    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardView.delegate = self
    }
}

extension ViewController: KeyboardDelegate {
    func noteOn(note: MIDINoteNumber) {
        print("note on: \(note)")
    }

    func noteOff(note: MIDINoteNumber) {
        print("note off: \(note)")
    }
}

