import AudioKit
import UIKit

@objc public protocol KeyboardDelegate: AnyObject {
    func noteOn(note: MIDINoteNumber)
    func noteOff(note: MIDINoteNumber)
}

@IBDesignable class KeyboardView: UIView {

    @IBInspectable var primaryKeyColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    @IBInspectable var accentKeyColor = UIColor(red: 0.8, green: 1.0, blue: 1.0, alpha: 1.0)
    @IBInspectable var pressedKeyColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)

    let keySpacing: CGFloat = 0.5
    let keyNotes = [0, 2, 4, 5, 7, 9, 11]
    let keyRows = 4
    var baseMIDINote = 48
    var notesPressed = Set<MIDINoteNumber>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isMultipleTouchEnabled = true
    }

    override func draw(_ rect: CGRect) {
        let backgroundPath = UIBezierPath(rect: CGRect(x: 0,
                                                       y: 0,
                                                       width: self.frame.width,
                                                       height: self.frame.height))
        UIColor.black.setFill()
        backgroundPath.fill()

        for index in 0..<keyRows {
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
        if notesPressed.contains(MIDINoteNumber(baseMIDINote + (3 - row) * 12 + keyNotes[index])) {
            return pressedKeyColor
        }
        if index == 0 || index == 2 || index == 4 {
            return accentKeyColor
        } else {
            return primaryKeyColor
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
        if noteIndex > 6 {
            return nil
        }

        let octaveIndex = Int(floor(yPosition / keyHeight))

        let octave = 3 - octaveIndex
        let note = keyNotes[noteIndex]

        let noteNumber = baseMIDINote + (octave * 12) + note

        return MIDINoteNumber(noteNumber)
    }

    func addPressedNote(_ note: MIDINoteNumber) {
        if !notesPressed.contains(note) {
            notesPressed.insert(note)
            print("note ON: \(note.description)")
        }
    }

    func removePressedNote(_ note: MIDINoteNumber, touches: Set<UITouch>? = nil) {
        guard notesPressed.contains(note) else { return }
        notesPressed.remove(note)
        print("note OFF: \(note.description)")
    }

    func updatePressedNotes(_ touches: Set<UITouch>?) {
        let notes = getNotesFromTouches(touches ?? Set<UITouch>())
        let disjunct = notesPressed.subtracting(notes)
        if disjunct.isNotEmpty {
            for note in disjunct {
                removePressedNote(note)
            }
        }
    }
}

extension KeyboardView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let notes = getNotesFromTouches(touches)
        for note in notes {
            addPressedNote(note)
        }
        updatePressedNotes(event?.allTouches)
        setNeedsDisplay()
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let note = getNoteFromTouchLocation(touch.location(in: self)),
                note != getNoteFromTouchLocation(touch.previousLocation(in: self)) {
                addPressedNote(note)
                setNeedsDisplay()
            }
        }
        updatePressedNotes(event?.allTouches)
    }

    override open func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        updatePressedNotes(event?.allTouches)
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let note = getNoteFromTouchLocation(touch.location(in: self)) {
                if var otherTouches = event?.allTouches {
                    otherTouches.remove(touch)
                    if !getNotesFromTouches(otherTouches).contains(note) {
                        removePressedNote(note, touches: event?.allTouches)
                    }
                }
            }
        }
        updatePressedNotes(event?.allTouches)
        setNeedsDisplay()
    }
}
