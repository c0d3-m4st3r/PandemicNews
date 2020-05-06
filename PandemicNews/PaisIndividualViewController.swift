//
//  PaisIndividualViewController.swift
//  PandemicNews
//
//  Created by user152439 on 4/27/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit

protocol PaisIndividualViewControllerDelegate: class{
    func delete(cell: PaisCollectionViewCell)
}

class PaisIndividualViewController: UIViewController {
    
    @IBOutlet weak var banderaPais: UIImageView!
    @IBOutlet weak var nombrePais: UILabel!
    @IBOutlet weak var numInfectados: UILabel!
    @IBOutlet weak var numCasosPor1Mill: UILabel!
    @IBOutlet weak var numCurados: UILabel!
    @IBOutlet weak var numFallecidos: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var elimButton: UIButton!
    
    weak var delegate: PaisIndividualViewControllerDelegate?
    var paisIndividual: Pais?
    var collectionViewPais: UICollectionView?
    var arrayPaises: [Pais]?
    var index: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        cargaPais()
    }
    private func cargaPais(){
        navItem.title = "País individual"
        banderaPais.contentMode = .scaleAspectFill
        banderaPais.downloaded(from: paisIndividual?.flag ?? "")
        nombrePais.text = paisIndividual?.country
        numInfectados.text = paisIndividual?.total_cases.description
        numCasosPor1Mill.text = paisIndividual?.cases_per_mill_pop
        numCurados.text = paisIndividual?.total_recovered
        numFallecidos.text = paisIndividual?.total_deaths
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! HomeViewController
        detailVC.eliminarPais(item: index!)
    }
    
    @IBAction func eliminarPais(_ sender: UIButton){
        print("Botón presionado")
        
        
        
        
        
        
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
