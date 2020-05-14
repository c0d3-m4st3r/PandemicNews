//
//  PaisIndividualViewController.swift
//  PandemicNews
//
//  Created by user152439 on 4/27/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit
import CoreData



class PaisIndividualViewController: UIViewController {
    
    @IBOutlet weak var banderaPais: UIImageView!
    @IBOutlet weak var nombrePais: UILabel!
    @IBOutlet weak var numInfectados: UILabel!
    @IBOutlet weak var numCasosPor1Mill: UILabel!
    @IBOutlet weak var numCurados: UILabel!
    @IBOutlet weak var numFallecidos: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    
    
    var paisIndividual: NSManagedObject?
    var index: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        cargaPais()
    }
    private func cargaPais(){
        navItem.title = "País individual"
        banderaPais.contentMode = .scaleAspectFill
        
        if(paisIndividual?.value(forKey: "flag") != nil){
            banderaPais.downloaded(from: paisIndividual?.value(forKey: "flag") as! String)
        }else{
            if(paisIndividual?.value(forKey: "flagImage") != nil){
                banderaPais.image = UIImage(data :paisIndividual?.value(forKey: "flagImage") as! Data)
            }
        }
        nombrePais.text = paisIndividual?.value(forKey: "country") as! String
        numInfectados.text = paisIndividual?.value(forKey: "total_cases") as! String
        numCasosPor1Mill.text = paisIndividual?.value(forKey: "total_cases_per_mill_pop") as! String
        numCurados.text = paisIndividual?.value(forKey: "total_recovered") as! String
        numFallecidos.text = paisIndividual?.value(forKey: "total_deaths") as! String
        
 }
    
    
    @IBAction func eliminarPais(_ sender: UIButton){
        print("Botón presionado")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //instanciamos la entidad para guardar el pais
        let entity = NSEntityDescription.entity( forEntityName: "DeletedCountries", in: managedContext)
        let pais = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        let paisElegido = paisIndividual?.value(forKey: "country") as! String
        //guardamos el pais
        pais.setValue(paisElegido, forKey: "country")
        
        do{
            try managedContext.save()
            
        }catch let error as NSError{
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        
        self.navigationController?.popViewController(animated: true)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homeView = segue.destination as! HomeViewController
        
        
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
