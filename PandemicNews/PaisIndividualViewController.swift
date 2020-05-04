//
//  PaisIndividualViewController.swift
//  PandemicNews
//
//  Created by user152439 on 4/27/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit

class PaisIndividualViewController: UIViewController {
    
    @IBOutlet weak var banderaPais: UIImageView!
    @IBOutlet weak var nombrePais: UILabel!
    @IBOutlet weak var numInfectados: UILabel!
    @IBOutlet weak var numCasosPor1Mill: UILabel!
    @IBOutlet weak var numCurados: UILabel!
    @IBOutlet weak var numFallecidos: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var elimButton: UIButton!
    
    
    var paisIndividual: Pais?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        //cargaPais()
    }
   /* private func cargaPais(){
        navItem.title = "País individual"
        banderaPais.image = paisIndividual?.bandera
        nombrePais.text = paisIndividual?.nombre
        numInfectados.text = paisIndividual?.numeroInfectados.description
        numCasosPor1Mill.text = paisIndividual?.casosPorMillPersonas.description
        numCurados.text = paisIndividual?.recuperados.description
        numFallecidos.text = paisIndividual?.fallecidos.description
    }
*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
