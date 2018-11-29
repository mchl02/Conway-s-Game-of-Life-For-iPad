

import UIKit

protocol ColonySelectionDelegate: class {
    func colonySelected(_ newColony: [Coor])
}


class Templates: UITableViewController {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem
    }
 
    var templates = ["Blank", "Basic", "Gider Gun"]
    var cellsAlive: [[Coor]] = [[], [Coor(1, 1)], [Coor(5, 3), Coor(5, 4), Coor(5, 5), Coor(4, 5), Coor(3, 4)]]
    
    weak var delegate: ColonySelectionDelegate?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = templates[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedColony = cellsAlive[indexPath.row]
        delegate?.colonySelected(selectedColony)
    }
}
