import AudioKit
import UIKit

@IBDesignable class KeyboardView: UIView {

    let keySpacing: CGFloat = 0.5
    let keyNotes = [0, 2, 4, 5, 7, 9, 11]
    var baseMIDINote = 48
    var notesPressed = [(index: Int, row: Int)]()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        let backgroundPath = UIBezierPath(rect: CGRect(x: 0,
                                                       y: 0,
                                                       width: self.frame.width,
                                                       height: self.frame.height))
        UIColor.black.setFill()
        backgroundPath.fill()

        for index in 0..<4 {
            drawRowOfKeys(row: index)
        }
    }

    func drawRowOfKeys(row: Int) {
        let keyWidth = (frame.size.width - keySpacing * 6) / 7
        let keyHeight = (frame.size.height - keySpacing * 3) / 4

        var keys = [UIBezierPath]()

        for index in 0..<7 {
            let keyPath = UIBezierPath(rect: CGRect(x: keyXPosition(index: index, keyWidth: keyWidth),
                                                    y: keyYPosition(row: row, keyHeight: keyHeight),
                                                    width: keyWidth,
                                                    height: keyHeight))
            keys.append(keyPath)
            keyColor(index, row).setFill()
            keys[index].fill()
        }
    }

    func keyXPosition(index: Int, keyWidth: CGFloat) -> CGFloat {
        let position = keyWidth * CGFloat(index) + keySpacing * CGFloat(index)
        return position
    }

    func keyYPosition(row: Int, keyHeight: CGFloat) -> CGFloat {
        let position = keyHeight * CGFloat(row) + keySpacing * CGFloat(row)
        return position
    }

    func keyColor(_ index: Int, _ row: Int) -> UIColor {
        for pressedKey in notesPressed {
            if pressedKey.index == index && pressedKey.row == row {
                return UIColor.yellow
            }
        }

        if index == 0 || index == 2 || index == 4 {
            return UIColor.red
        } else {
            return UIColor.blue
        }
    }

    func getNotesFromTouches(_ touches: Set<UITouch>) -> [MIDINoteNumber] {
        var notes = [MIDINoteNumber]()
        for touch in touches {
            if let note = getNoteFromTouchLocation(touch.location(in: self)) {
                notes.append(note)
            }
        }
        return notes
    }

    func getNoteFromTouchLocation(_ location: CGPoint) -> MIDINoteNumber? {
        guard bounds.contains(location) else {
            return nil
        }

        let keyWidth = (frame.size.width - keySpacing * 6) / 7
        let keyHeight = (frame.size.height - keySpacing * 3) / 4

        let xPosition = location.x
        let yPosition = location.y

        let noteIndex = Int(floor(xPosition / keyWidth))
        let octaveIndex = Int(floor(yPosition / keyHeight))

        notesPressed.append((noteIndex, octaveIndex))

        let octave = 3 - octaveIndex
        let note = keyNotes[noteIndex]

        let noteNumber = baseMIDINote + (octave * 12) + note

        print(noteNumber)

        return MIDINoteNumber(noteNumber)

    }
}

extension KeyboardView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let notes = getNotesFromTouches(touches)
        for touch in touches {
            print(touch.location(in: self))
        }
        setNeedsDisplay()
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let notes = getNotesFromTouches(touches)
        setNeedsDisplay()
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        notesPressed.removeAll()
        setNeedsDisplay()
    }
}
