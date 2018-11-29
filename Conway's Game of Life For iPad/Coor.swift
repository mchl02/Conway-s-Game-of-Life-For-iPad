

import Foundation

class Coor: Hashable {
    let row: Int
    let column: Int
    
    init(_ x_coor: Int, _ y_coor: Int) {
        self.row = x_coor
        self.column = y_coor
    }
    
    var hashValue: Int {
        return(pair(row, column))
    }
    func pair(_ row: Int, _ column: Int) -> Int {
        return ((row + column) * (row + column + 1) / 2) + column
    }
    static func == (lhs: Coor, rhs: Coor) -> Bool {
        return (lhs.row == rhs.row) && (lhs.column == rhs.column)
    }
}
