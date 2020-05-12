//
//  ConfiguracionViewController.swift
//  PandemicNews
//
//  Created by user152439 on 4/23/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit
import CoreData


class ConfiguracionViewController: UIViewController, UIAlertViewDelegate {

    
    @IBOutlet var RecibirBoton: UIButton!
    @IBOutlet var navBar: UINavigationItem!
    @IBAction func addButtonCliked(sender: AnyObject) {
       
       let alertController = UIAlertController(title: "Número de casos para alerta", message: "introduzca con cuantos casos desea recibir alerta de esta app", preferredStyle: .alert)
        alertController.addTextField{(textField: UITextField!) -> Void in
            textField.placeholder = "introduce el número..."
        }
        let saveAction = UIAlertAction(title: "Aceptar", style: .default, handler: {alert -> Void in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            //array de paises ya guardados en la entidad CountrySelectedAlert
            var paisGuardado: [NSManagedObject]
            //Peticion
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountryNumberAlert")
            do{
                let results = try managedContext.fetch(fetchRequest)
                paisGuardado = results as! [NSManagedObject]
                //Si hay algun pais lo borra puesto que solo debe haber uno
                for paisG in paisGuardado{
                    managedContext.delete(paisG)
                }
                try managedContext.save()
                
            }catch let error as NSError{
                print("No ha sido posible cargar \(error), \(error.userInfo)")
                
            }
            //instanciamos la entidad para guardar el pais
            let entity = NSEntityDescription.entity( forEntityName: "CountryNumberAlert", in: managedContext)
            let pais = NSManagedObject(entity: entity!, insertInto: managedContext)
            
            
            //guardamos el pais
            pais.setValue(alertController.textFields?[0].text, forKey: "numero")
            
            do{
                try managedContext.save()
                
            }catch let error as NSError{
                print("No ha sido posible guardar \(error), \(error.userInfo)")
            }
            
            
            
           
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: {alert -> Void in
            
        })
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        navBar.title = "Configuración"
    }
    
    
    
   
    
}
