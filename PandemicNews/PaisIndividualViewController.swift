//
//  PaisIndividualViewController.swift
//  PandemicNews
//
//  Created by user152439 on 4/27/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit
import CoreData


//View controller de la vista de pais individual(detailVC)
class PaisIndividualViewController: UIViewController {
    
    //Variables de la clase, que son los atributos de dicho pais
    @IBOutlet weak var banderaPais: UIImageView!
    @IBOutlet weak var nombrePais: UILabel!
    @IBOutlet weak var numInfectados: UILabel!
    @IBOutlet weak var numCasosPor1Mill: UILabel!
    @IBOutlet weak var numCurados: UILabel!
    @IBOutlet weak var numFallecidos: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    
    //Objetos que vienen dados por el prepare segue(se pasan de la otra vista)
    var paisIndividual: NSManagedObject?
    var index: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Cargamos los datos del pais para mostrarlo
        cargaPais()
    }
    //Cargamos los datos del pais para mostrarlo
    private func cargaPais(){
        
        navItem.title = "País individual"
        banderaPais.contentMode = .scaleAspectFill
        //Si tiene una url en el campo bandera la descarga
        if(paisIndividual?.value(forKey: "flag") != nil){
            banderaPais.downloaded(from: paisIndividual?.value(forKey: "flag") as! String)
        }else{
            //Si no tiene nada en el campo bandera se mira a ver si lo tiene en el campo flagImage
            if(paisIndividual?.value(forKey: "flagImage") != nil){
                //Si tiene se iguala la bandera a la imagen contenida aquí
                banderaPais.image = UIImage(data :paisIndividual?.value(forKey: "flagImage") as! Data)
            }
            //Si no se cumple ninguna de las dos anteriores condiciones el campo bandera queda vacío
        }
        //Se rellenan el resto de campos
        nombrePais.text = paisIndividual?.value(forKey: "country") as! String
        numInfectados.text = paisIndividual?.value(forKey: "total_cases") as! String
        numCasosPor1Mill.text = paisIndividual?.value(forKey: "total_cases_per_mill_pop") as! String
        numCurados.text = paisIndividual?.value(forKey: "total_recovered") as! String
        numFallecidos.text = paisIndividual?.value(forKey: "total_deaths") as! String
        
 }
    
    //Accion eliminar pais que es activada con el boton eliminar Pais, guarda el pais que esta seleccionado en la entidad de paises eliminados
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
        
        //Cuando se pulse en este botón se vuelve a la vista anterior
        self.navigationController?.popViewController(animated: true)
    
    }

}
