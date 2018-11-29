

import Foundation

class Colony: CustomStringConvertible {
    var s = Set<Coor>()
    var colonySize: Int
    var gen = 0
    
    init(_ colonySize: Int) {
        self.colonySize = colonySize
    }
    
    func setCellAlive(xCoor: Int, yCoor: Int) {
        s.insert(Coor(xCoor, yCoor))
    }
    
    func setCellDead(xCoor: Int, yCoor: Int) {
        s.remove(Coor(xCoor, yCoor))
    }
    
    func isCellAlive(xCoor: Int, yCoor: Int) -> Bool {
        return s.contains(Coor(xCoor, yCoor))
    }
    
    func neighboring(xCoor: Int, yCoor: Int) -> Set<Coor> {
        var neighbor = Set<Coor>()
        //checks around
        neighbor.insert(Coor(xCoor-1, yCoor-1))
        neighbor.insert(Coor(xCoor, yCoor-1))
        neighbor.insert(Coor(xCoor+1, yCoor-1))
        neighbor.insert(Coor(xCoor-1, yCoor))
        neighbor.insert(Coor(xCoor+1, yCoor))
        neighbor.insert(Coor(xCoor-1, yCoor+1))
        neighbor.insert(Coor(xCoor, yCoor+1))
        neighbor.insert(Coor(xCoor+1, yCoor+1))
        return neighbor
    }
    
    func neighboringCount(_ x: Int, _ y: Int) -> Int {
        return neighboring(xCoor: x, yCoor: y).filter( {isCellAlive(xCoor: $0.row, yCoor: $0.column)} ).count
    }
    
    func decide(_ row: Int, _ col: Int) -> Bool {
        let count = neighboringCount(row, col)
        if count == 3 {
            return true
        } else if count == 2 && isCellAlive(xCoor: row, yCoor: col) {
            return true
        } else {
            return false
        }
    }
    
    func resetColony(){
        s = Set<Coor>()
        gen = 0
    }
    
    var description: String {
        var result = ""
        result += "Generation #\(gen)\n"
        for row in 0..<colonySize {
            for col in 0..<colonySize {
                result += isCellAlive(xCoor: row, yCoor: col) ? "*" : " "
            }
            result += "\n"
        }
        return result
    }
    
    
    func evolve() {
        var s1 = Set<Coor>()
        s1 = Set( s.map( { neighboring(xCoor: $0.row, yCoor: $0.column) })
            .flatMap({$0}) )
        //filter the set
        s = Set( s1.filter( {decide($0.row, $0.column)} ) )
        gen += 1
        
    }
}
