//
//  AddPaisViewController.swift
//  PandemicNews
//
//  Created by user152439 on 5/8/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class AddPaisViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //Variables de clase
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var botnAñadir: UIButton!
    @IBOutlet weak var deaths: UITextField?
    @IBOutlet weak var recovered: UITextField?
    @IBOutlet weak var country: UITextField?
    @IBOutlet weak var casesPerMil: UITextField?
    @IBOutlet weak var totalCases: UITextField?
    
    
    //Instancia del imagePicker controller que nos servirá para seleccionar una imagen de la galería
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegates de los textField y del image Picker
        deaths?.delegate = self
        recovered?.delegate = self
        country?.delegate = self
        casesPerMil?.delegate = self
        totalCases?.delegate = self
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
      
    }
    
    //Método para que el teclado se esconda cuando pulsemos en aceptar del teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Acción programada para cuando se pulse en el botón añadir imagen de la galería y llama al imagePicker
    @IBAction func addFoto(_ sender: Any){
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Acción programada para cuando tengamos todos los datos introducidos y queramos guardar el pais
    @IBAction func addPais(_ sender: Any){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //Guardamos estos países en otra entidad llamada paises personalizados
        let entity = NSEntityDescription.entity( forEntityName: "PersonalizedCountries", in: managedContext)
        let pais = NSManagedObject(entity: entity!, insertInto: managedContext)
        //Seteamos los datos
        pais.setValue(country?.text as! String, forKey: "country")
        pais.setValue(totalCases?.text as! String, forKey: "total_cases")
        pais.setValue(recovered?.text as! String, forKey: "total_recovered")
        pais.setValue(deaths?.text as! String, forKey: "total_deaths")
        pais.setValue(casesPerMil?.text as! String, forKey: "total_cases_per_mill_pop")
        var imagenCodificada = (flag.image)!.pngData()
        pais.setValue(imagenCodificada, forKey: "flagImage")
        //Guardamos datos
        do{
            try managedContext.save()
            
            
        }catch let error as NSError{
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        //Volvemos a la vista anterior
        self.navigationController?.popViewController(animated: true)
 
    }
    //Metodo delegate del imagePicker, cuando se haya terminado de escoger.....
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Guardamos la imagen seleccionada en la imagen flag
        flag.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        //Cambiamos el modo del contenido a rellenar todo
        flag.contentMode = .scaleAspectFill
        //Quitamos el imagePicker controller
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}
