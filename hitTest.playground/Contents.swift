//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

// 1 Implement your onw UIView.hitTest and UIView.pointInside
// 2 Update point(inseide) to handle tap outside parent view (in clipped zone)
// 3 Find Common Paent of two views


final class HitTestView: UIView {
    
    var tapMargin: CGFloat = 0 // 20.0
    let name: String
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
        print("👇 Geture Recognizer tap at: \(name)\n\n")
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("👇 touchesBegan tap at: \(name)\n\n")
//        super.touchesBegan(touches, with: event)
//    }
    
    // просто проверить, как работает
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        print("🔘 pointInside in view: \(name) at point: \(point): \(super.point(inside: point, with: event))")
//                return super.point(inside: point, with: event)
//    }
    // просто проверить, как работает
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        print("🔲 hitTest in view: \(name) at point: \(point)")
//        return super.hitTest(point, with: event)
//    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return myPoint2(inside: point, with: event)
    }
    
    func myPoint2(inside point: CGPoint, with event: UIEvent?) -> Bool {
         print("🔘🔘🔘 myPointInside2 in view: \(name)")
        let inside = super.point(inside: point, with: event)
        if !inside {
            for subview in subviews {
                let pointInSubview = subview.convert(point, from: self)
//                let pointInSubview2 = convert(point, to: subview)
//                print("!!! \(pointInSubview) == \(pointInSubview2): \(pointInSubview == pointInSubview2) ")
                if subview.point(inside: pointInSubview, with: event) {
                    return true
                }
            }
        }
        return inside
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        return super.hitTest(point, with: event)
        return myHitTest(point, with: event)
    }
    
    func myHitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("🔲🔲 myHitTest in view: \(name) at point: \(point)")
        
        guard self.point(inside: point, with: event) else { return nil }
        guard alpha > 0.01 else { return nil }
        guard isUserInteractionEnabled else { return nil }
        guard !isHidden else { return nil }
        
        guard !subviews.isEmpty else { return self }
        
        for child in subviews {
            if let hitTedtedChild = child.hitTest(convert(point, to: child), with: event) {
                return hitTedtedChild
            }
        }
        return self
    }
}

extension HitTestView {
    override var description: String {
        return "\(name)"
    }
}

class ButtonWithTouchSize: UIButton {
    var touchAreaPadding: UIEdgeInsets?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let insets = touchAreaPadding else {
            return super.point(inside: point, with: event)
        }
        let rect = bounds.inset(by: insets.inverted())
        print("rect: \(rect), bounds: bounrd")
        return rect.contains(point)
    }
}

class TouchPassesView: UIView {
        
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view === self { return nil }
        return view
    }
}

private extension UIEdgeInsets {
    func inverted() -> UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
}

class MyViewController: UIViewController {
    
    var viewA: HitTestView!
    var viewB: HitTestView!
    var viewC: HitTestView!
    var viewD: HitTestView!
    var viewE: HitTestView!
    var viewF: HitTestView!
    var viewZ: HitTestView!
    var viewX = UIView()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
        setupViews()
        test(of: viewD, and: viewF)
        test(of: viewD, and: viewB)
        test(of: viewD, and: viewX)
        test(of: viewA, and: viewZ)
    }
    
    func test(of view1: UIView, and view2: UIView) {
        if let parent = findNearestParent(of: view1, and: view2) {
            print("Common parent of \(view1), \(view2) => \(parent)")
        } else {
            print("Common parent of \(view1), \(view2) => NOT FOUND")
        }
    }
    
    private func setupViews() {
        viewA = HitTestView(frame: CGRect(x: 8, y: 32, width: 360, height: 220), name: "A", color: .gray)
        viewB = HitTestView(frame: CGRect(x: 8, y: 32, width: 140, height: 120), name: "B", color: .red)
        viewC = HitTestView(frame: CGRect(x: 8+140+16, y: 32, width: 140, height: 120), name: "C", color: .blue)
        viewD = HitTestView(frame: CGRect(x: 8, y: 32, width: 120, height: 60), name: "D", color: .yellow)
        viewE = HitTestView(frame: CGRect(x: 8, y: 32, width: 120, height: 120), name: "E", color: .green)
        viewF = HitTestView(frame: CGRect(x: 8, y: 32, width: 80, height: 120), name: "F", color: .magenta)
        
        view.addSubview(viewA)
        viewA.addSubview(viewB)
        viewA.addSubview(viewC)
        viewB.addSubview(viewD)
        viewC.addSubview(viewE)
        viewE.addSubview(viewF)
        
        viewZ = HitTestView(frame: CGRect(x: 8, y: 220 + 32 + 32, width: 360, height: 120), name: "Z", color: .gray)
        view.addSubview(viewZ)
        let button = ButtonWithTouchSize(frame: CGRect(x: 8, y: 60 , width: 120, height: 40))
        button.setTitle("Button", for: .normal)
        button.backgroundColor = .systemBlue
        button.touchAreaPadding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.addTarget(self, action: #selector(buttonTap(_:)), for: .touchUpInside)
        viewZ.addSubview(button)
    }
    
    @objc func buttonTap(_ sender: AnyObject) {
        print("Button did tap!")
    }
}

extension MyViewController {
    
    func findNearestParent(of view1: UIView, and view2: UIView) -> UIView? {
        
        guard view1 !== view2 else { return view1 }
        var path1 = pathToRoot(for: view1)
        var path2 = pathToRoot(for: view2)
        // both views have no superViews
        guard !path1.isEmpty || !path2.isEmpty else { return nil }
        // check they both have common root view
        guard path1.last == path2.last else { return nil }
        
        // case1: [D, B, A, root], [F, E, C, A], root
        // case2: [D, B, A, root], [B, A, root]
        var commonParent = path1.last ?? path2.last
        while !path1.isEmpty || !path2.isEmpty, path1.last === path2.last {
            commonParent = path1.removeLast()
            path2.removeLast()
        }
        return commonParent
    }
    // case 1: !==, have commont parent
    func pathToRoot(for view: UIView) -> [UIView] {
        var current = view
        var result = [current]
        
        while let parent = current.superview {
            current = parent
            result.append(current)
        }
        
        return result
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
