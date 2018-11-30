

import UIKit

let colonySize = 20
var colony = Colony(colonySize)
var wrapperswitch = false
class Grid: UIViewController {
    
    var grid = UIView()
    let border: CGFloat = 50

    var cells = [UIView()]
    var tick = 0
    var time: Timer? = nil{
        willSet{
            time?.invalidate()
        }
    }
    
    
   
    
    var interval: Float {
        return speed.minimumValue
    }
    
    var toggle = Set<Coor>()
    @IBOutlet weak var wrapper: UISwitch!
    @IBOutlet weak var speed: UISlider!
    @IBOutlet weak var speedLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colony.s = toggle
        
        let height = (view.frame.height - 2 * border) / CGFloat(colonySize)
        
        for i in 0..<colonySize {
            for j in 0..<colonySize {
                let cellView = UIView()
                cellView.frame = CGRect(x: CGFloat(i) * height, y: CGFloat(j) * height, width: height, height: height)
                cellView.layer.borderWidth = 0.5
                cellView.layer.borderColor = UIColor.black.cgColor
                grid.addSubview(cellView)
                
                cells.append(cellView)
            }
        }
        
        refresh()
        
        view.addSubview(grid)
        grid.translatesAutoresizingMaskIntoConstraints = false
        grid.topAnchor.constraint(equalTo:  self.view.topAnchor, constant: 10).isActive = true
        grid.leftAnchor.constraint(equalTo:  self.view.leftAnchor, constant: border).isActive = true
        grid.rightAnchor.constraint(equalTo:  self.view.rightAnchor, constant: -border).isActive = true
        grid.bottomAnchor.constraint(equalTo:  self.view.bottomAnchor, constant: -2*border).isActive = true
        
        
        grid.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        grid.addGestureRecognizer(CellPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
        
        createTimer()
        speed.minimumValue = 0
        speed.maximumValue = 50
        
        
        
    }
    
    func refresh() {
        for i in cells {
            i.backgroundColor = .white
        }
        for i in colony.s {
           guard i.row < colonySize && i.column < colonySize && 0 <= i.row && 0 <= i.column else {
                break
            }
            cells[i.row * colonySize + i.column + 1].backgroundColor = .black
        }
    }
    
     @objc func handleTap(gesture: UITapGestureRecognizer) {
        let height = grid.frame.height / CGFloat(colonySize)
        
        let location = gesture.location(in: grid)
        let i = Int(location.x / height)
        let j = Int(location.y / height)
        
        let cellView = cells[i * colonySize + j + 1]
        
        if !colony.s.contains(Coor(i, j)) {
            colony.s.insert(Coor(i, j))
            toggle.insert(Coor(i, j))
            cellView.backgroundColor = .black
        }
        else {
            colony.s.remove(Coor(i, j))
            toggle.remove(Coor(i, j))
            cellView.backgroundColor = .white
        }
     }
    
    @objc func handlePan(gesture: CellPanGestureRecognizer) {
        
        let height = grid.frame.height / CGFloat(colonySize)
        
        let si = Int(gesture.initialTouchLocation.x / height)
        let sj = Int(gesture.initialTouchLocation.y / height)
        
        let location = gesture.location(in: grid)
        let i = Int(location.x / height)
        let j = Int(location.y / height)
        
        guard i < colonySize && j < colonySize && 0 <= i && 0 <= j else {
            colony.s = toggle
            return
        }
        
        let cellView = cells[i * colonySize + j + 1]
        
        if !colony.s.contains(Coor(si, sj)) {
            toggle.insert(Coor(i, j))
            cellView.backgroundColor = .black
        }
        else {
            cellView.backgroundColor = .white
            toggle.remove(Coor(i, j))
        }
        
        if gesture.state == .ended {
            colony.s = toggle
        }
    }
    
    @IBAction func play(_ sender: Any) {
        /*
        var tog = 1
        print("TOGGLE")
        for i in toggle {
            print("\(tog)\t(\(i.row), \(i.column))")
            tog += 1
        }
        print("")
        var alv = 1
        print("ALIVE")
        for i in colony.s {
            print("\(alv)\t(\(i.row), \(i.column))")
            alv += 1
        }
        print("")
        */
        for i in colony.s {
            print("\(i.row), \(i.column)")
        }
    }
    
    
    
    func createTimer() {
        if speed.value>0.00{
            if time == nil{
                  print(speed.value)
                  time = Timer.scheduledTimer(withTimeInterval: TimeInterval(4-speed.value), repeats: true, block: {_ in self.timerTick()})
            }
          
        }else{
            time = nil
        }
        
    }
    func timerTick() {
        tick += 1
        if Float(tick) > interval {
            tick = 0
            evolve()
        }
    }
    @objc func evolve() {
        colony.evolve()
        refresh()
        toggle = colony.s
    }
    
    @IBAction func step(_ sender: Any) {
        evolve()
    }
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 1
        return nf
    }()
    @IBAction func switchToggled(_ sender: UISwitch) {
        changeText()
    }
    
    func changeText() {
        if wrapper.isOn {
            wrapperswitch = true
        } else {
            wrapperswitch = false
        }
    }
    @IBAction func speedChanged(_ sender: Any) {
        speedLabel.text = numberFormatter.string(from: NSNumber(value: speed.value))! + "x"
        createTimer()
    }
    //var timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(evolve), userInfo: nil, repeats: true)
}


extension Grid: ColonySelectionDelegate {
    func colonySelected(_ newColony: [Coor]) {
        toggle = Set(newColony)
        colony.s = toggle
        refresh()
    }
}
