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
    
    func getRequest(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DeletedCountries")
        
        do{
            let results = try managedContext.fetch(fetchRequest)
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
            //Si hay algun pais lo borra puesto que solo debe haber uno
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
