//
//  ConfiguracionViewController.swift
//  PandemicNews
//
//  Created by user152439 on 4/23/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit

class ConfiguracionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //@IBOutlet weak var tableView: UITableView!
    var opciones = [String] ()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        cargaOpciones()
        //tableView.delegate = self
        //tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    private func cargaOpciones(){
        let opcion1 = "Recibir notificación de"
        let opcion2 = "Números de casos para alerta"
        
        opciones += [opcion1,opcion2]
    }
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "opcion")
        cell.textLabel?.text = opciones[indexPath.row]
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
