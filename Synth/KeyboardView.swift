import UIKit

@IBDesignable class KeyboardView: UIView {

    let keySpacing: CGFloat = 1.0

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
            UIColor.red.setFill()
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
}
