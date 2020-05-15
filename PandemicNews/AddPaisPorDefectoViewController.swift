//
//  AddPaisPorDefectoViewController.swift
//  PandemicNews
//
//  Created by user152439 on 5/14/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit
import CoreData

class AddPaisPorDefectoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    public var paises = [NSManagedObject]()
    
    @IBOutlet var picker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Connectando los datos
        self.picker.delegate = self
        self.picker.dataSource = self
        
        //Cargamos los datos
        getRequest()
        
        
        // Do any additional setup after loading the view.
    }
    //Cargamos todos los países de la entidad paises eliminados
    func getRequest(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //Petición a la entidad DeletedCountries
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DeletedCountries")
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            //Guardamos los paises eliminados en paises que será el array del que el picker view coja los datos
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
        return paises[row].value(forKey: "country") as! String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    //Acción disparada por el botón y elimina el seleccionado del picker de la entidad deleted countries
    @IBAction func DoneButton(_ sender: Any){
        //Elemento del array elegido(int)
        let elegido = picker.selectedRow(inComponent: 0)
        //Instanciamos a la bbdd
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //array de paises ya guardados en la entidad CountrySelectedAlert
        var paisGuardado: [NSManagedObject]
        //Peticion
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DeletedCountries")
        do{
            let results = try managedContext.fetch(fetchRequest)
            paisGuardado = results as! [NSManagedObject]
            //Si el nombre del elemento elegido y el de la bbdd coinciden lo borra de la bbdd
            for paisG in paisGuardado{
                if(paisG.value(forKey: "country") as! String == paises[elegido].value(forKey: "country") as! String){
                    managedContext.delete(paisG)
                }
            }
            try managedContext.save()
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
    }

}
