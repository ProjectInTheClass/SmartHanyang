

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    @IBOutlet weak var textField: UITextField!
    //MARK: Properties
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        MealDataManager.shared.load()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MealDataManager.shared.meals.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let meal = MealDataManager.shared.meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            MealDataManager.shared.meals.remove(at: indexPath.row)
            MealDataManager.shared.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {

        case "Roulette":
            var texts:[String] = [String]()
            
            for meal in MealDataManager.shared.meals {
                texts.append(meal.name)

            }
            
            //roulette = Roulette(texts: texts, frame: CGRect(x: 0, y: 0, width: smaller, height: smaller))
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    
    //MARK: Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                MealDataManager.shared.meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: MealDataManager.shared.meals.count, section: 0)
                
                MealDataManager.shared.meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals.
            MealDataManager.shared.save()
        }
    }
    
    func insertNew() {
        if let text = textField.text {
            if text.isEmpty{
                return
            }
            if let meal = Meal(name: text, photo: nil, rating: 0){
                MealDataManager.shared.addMeal(aMeal: meal)
            }
        }
        
        let indexPath = IndexPath(row: MealDataManager.shared.meals.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        textField.text = ""
        view.endEditing(true)
    }
    
    //MARK: Actions
    
    
    @IBAction func addAction(_ sender: Any) {
        self.insertNew()
    }
    
    @IBAction func keyboardReturn(_ sender: Any) {
        self.insertNew()
    }
    
    
    
    @IBAction func rouletteAction(_ sender: Any) {
        
    }
    

}
