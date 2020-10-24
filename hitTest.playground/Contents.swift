//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

final class HitTestView: UIView {
    
    private let name: String
    private lazy var label = UILabel(frame: CGRect(x: 8, y: 8, width: 20, height: 20))
    
    init(frame: CGRect, name: String, color: UIColor) {
        self.name = name
        super.init(frame: frame)
        backgroundColor = color
        label.text = name
        addSubview(label)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tap() {
        print("👇 tap at: \(name)")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        print("🔘 call pointInside in view: \(name) at point: \(point): \(super.point(inside: point, with: event))")
        return super.point(inside: point, with: event)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("🔲 call hitTest in view: \(name) at point: \(point)")
        return super.hitTest(point, with: event)
    }
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        
        let viewA = HitTestView(frame: CGRect(x: 8, y: 32, width: 360, height: 220), name: "A", color: .gray)
        let viewB = HitTestView(frame: CGRect(x: 8, y: 32, width: 140, height: 120), name: "B", color: .red)
        let viewC = HitTestView(frame: CGRect(x: 8+140+16, y: 32, width: 140, height: 120), name: "C", color: .blue)
        let viewD = HitTestView(frame: CGRect(x: 8, y: 32, width: 120, height: 60), name: "D", color: .yellow)
        let viewE = HitTestView(frame: CGRect(x: 8, y: 32, width: 120, height: 120), name: "E", color: .green)
        
        view.addSubview(viewA)
        viewA.addSubview(viewB)
        viewA.addSubview(viewC)
        viewB.addSubview(viewD)
        viewC.addSubview(viewE)
        
        let viewZ = HitTestView(frame: CGRect(x: 8, y: 220 + 32 + 32, width: 360, height: 120), name: "Z", color: .gray)
        
        view.addSubview(viewZ)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
