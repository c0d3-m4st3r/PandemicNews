//
//  RecibirDeViewController.swift
//  PandemicNews
//
//  Created by user152439 on 5/11/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit
import CoreData

class RecibirDeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //Array de paises totales
    public var paises = [NSManagedObject]()
    //Instacianmos el pickerView
    @IBOutlet var picker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Connectando los datos
        self.picker.delegate = self
        self.picker.dataSource = self
        
        //Cargamos los datos
        getRequest()
        
        
        
    }
    //Cargamos todos los países de la api
    func getRequest(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //Petición a la entidad country
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            //Guardamos los paises en el array paises
            paises = results as! [NSManagedObject]
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
    }
    
    //Número de columnas del carrousel
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    //Numero de filas del carrousel
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return paises.count
    }
    
    //La respuesta del picker view por cada componente que se le pasa
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return paises[row].value(forKey: "Country") as! String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    //Acción disparada por el botón que coge el elemento elegido en el picker y lo guarda en la entidad CountrySelectedAlert
    @IBAction func DoneButton(_ sender: Any){
        //Elemento del array elegido(int)
        let elegido = picker.selectedRow(inComponent: 0)
        //Instanciamos a la bbdd
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //array de paises ya guardados en la entidad CountrySelectedAlert
        var paisGuardado: [NSManagedObject]
        //Peticion
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountrySelectedAlert")
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
        let entity = NSEntityDescription.entity( forEntityName: "CountrySelectedAlert", in: managedContext)
        let pais = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        let paisElegido = paises[elegido].value(forKey: "country") as! String
        //guardamos el pais
        pais.setValue(paisElegido, forKey: "country")
        
        do{
            try managedContext.save()
            
        }catch let error as NSError{
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        
     
    }
    

}
