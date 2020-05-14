//
//  HomeViewController.swift
//  PandemicNews
//
//  Created by user152439 on 4/24/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit
import Foundation
import CoreData

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate {

    
    //Array de paises
    public var paises = [NSManagedObject]()
    
    
    @IBOutlet weak var barraNavegacion: UINavigationItem!

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidAppear(_ animated: Bool) {
        fetchPaises()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        barraNavegacion.title = "Lista de paises"
        
        borraPaises()
        
        cargaPaises()
        
        
  
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailSegue"){
            let item = sender as? UICollectionViewCell
            let indexPath = collectionView.indexPath(for: item!)
            let detailVC = segue.destination as! PaisIndividualViewController
            
            detailVC.index = indexPath!
            detailVC.paisIndividual = paises[(indexPath?.row)!] 
        }
        
    }
    
    func borraPaises(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            let Paises = results as! [NSManagedObject]
             for pais in Paises{
                managedContext.delete(pais)
             }
             try managedContext.save()
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
    }
    
    func fetchPaises(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Request de paises desacargados de la api
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            paises = results as! [NSManagedObject]
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
        //Request de paises personalizados añadidos por el usuario
        var paisesPersonalizados: [NSManagedObject]!
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonalizedCountries")
        do{
            let results = try managedContext.fetch(fetchRequest2)
            paisesPersonalizados = results as! [NSManagedObject]
            for paisPersonalizado in paisesPersonalizados{
                //Insertamos el pais personalizado en el array de paises que muestra la collection view
                paises.insert(paisPersonalizado, at: 0)
                
                
                
            }
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
        //Request de paises eliminados
        var paisesEliminados: [NSManagedObject]!
        let fetchRequest3 = NSFetchRequest<NSFetchRequestResult>(entityName: "DeletedCountries")
        do{
            let results = try managedContext.fetch(fetchRequest3)
             paisesEliminados = results as! [NSManagedObject]
            
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
        //Eliminamos los paises qu estan en paises eliminados del array que muestra la collection view
        for paisEliminado in paisesEliminados{
            var i = 0
            for pais in paises{
                if(pais.value(forKey: "country") as! String == paisEliminado.value(forKey: "country") as! String){
                    paises.remove(at: i)
                }
                i += 1
            }
        }
        
        
        
        self.collectionView.reloadData()
    }
    
  
    func cargaPaises(){
        
        let urlString = "https://corona-virus-stats.herokuapp.com/api/v1/cases/countries-search?limit=200"
        if let url = URL(string: urlString)
        {
            let task = URLSession.shared.dataTask(with: url) { data,response,error in
                print(response!)
                
                
                if error != nil{
                    print(error!)
                    return
                }
                
                guard let mime = response?.mimeType, mime == "application/json" else {
                    print("Wrong Mine type!")
                    return
                    
                }
                do{
                    
                    if let json  = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        if let vector = json["data"] as? [String: Any]{
                            for (key, value) in vector {
                                if key == "rows"{
                                    if let datos = value as? [Any] {
                                        for dato in datos {
                                            if let pais = dato as? [String: Any] {
                                                
                                                var country = Pais(nombre: "", bandera: "", numeroInfectados: "", casosPorMillPersonas: "", recuperados: "", fallecidos: "")
                                                for (llave, valor) in pais {
                                                    
                                                    if llave == "country" {
                                                        country.country = valor as! String
                                                        
                                                    }
                                                    if llave == "total_cases" {
                                                        country.total_cases = valor as! String
                                                    }
                                                    if llave == "total_deaths" {
                                                        country.total_deaths = valor as! String
                                                    }
                                                    if llave == "total_recovered" {
                                                        country.total_recovered = valor as! String
                                                    }
                                                    if llave == "cases_per_mill_pop" {
                                                        country.cases_per_mill_pop = valor as! String
                                                    }
                                                    if llave == "flag" {
                                                        country.flag = valor as! String
                                                    }
                                                    
                                                }
                                                
                                                DispatchQueue.main.sync {
                                                     self.guardaPais(paisData: country)
                                                }
                                                
                                                
                                               
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                } catch {
                    
                    print("Error during JSON serialization: \(error.localizedDescription)")
                }

            }
            task.resume()
        }
        
        
    }
    
    func guardaPais(paisData: Pais){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity( forEntityName: "Country", in: managedContext)
        let pais = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        pais.setValue(paisData.country, forKey: "country")
        pais.setValue(paisData.total_cases, forKey: "total_cases")
        pais.setValue(paisData.total_recovered, forKey: "total_recovered")
        pais.setValue(paisData.total_deaths, forKey: "total_deaths")
        pais.setValue(paisData.cases_per_mill_pop, forKey: "total_cases_per_mill_pop")
        pais.setValue(paisData.flag, forKey: "flag")
        
       
        
        do{
            try managedContext.save()
            
            
        }catch let error as NSError{
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if(results.count == 200) {
                fetchPaises()
                //muestraAlert()
            }
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "pais"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PaisCollectionViewCell
      
        
        cell.nombrePais.text = paises[indexPath.row].value(forKey: "country") as? String
        cell.numeroInfectados.text = paises[indexPath.row].value(forKey: "total_cases") as? String
        cell.banderaPais.contentMode = .scaleAspectFill
        if(paises[indexPath.row].value(forKey: "flag") != nil){
            cell.banderaPais.downloaded(from: paises[indexPath.row].value(forKey: "flag") as? String ?? "")
        }else{
            if(paises[indexPath.row].value(forKey: "flagImage") != nil){
                cell.banderaPais.image = UIImage(data :paises[indexPath.row].value(forKey: "flagImage") as! Data)
            }
        }
        cell.nombrePais.textAlignment = .center
        cell.numeroInfectados.textAlignment = .center
        
        
        
        return cell
        
    }
    
     func muestraAlert() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //array de paises ya guardados en la entidad CountrySelectedAlert
        var paisGuardado: [NSManagedObject]
        //Peticion
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountrySelectedAlert")
        var nombrePais = ""
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            paisGuardado = results as! [NSManagedObject]
            //Si hay algun pais lo borra puesto que solo debe haber uno
            for paisG in paisGuardado{
                nombrePais = paisG.value(forKey: "country") as! String
            }
            try managedContext.save()
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
        
        let numero = getPaisNumero()
        
        let alertController = UIAlertController(title: "Alerta de casos", message: "El pais \(nombrePais), has superado los \(numero) casos", preferredStyle: .alert)

        
        let saveAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
    
        alertController.addAction(saveAction)
    
        
        
        let Pais = getNombrePais(nombrePais: nombrePais)
        var numeroGuardado = Pais.value(forKey: "total_cases") as! String
        numeroGuardado = numeroGuardado.replacingOccurrences(of: ",", with: "")
        let numeroGuardadoInt = (numeroGuardado as NSString).integerValue
        let numeroGuardadoAlert = (numero as NSString).integerValue
        if(numeroGuardadoInt >= numeroGuardadoAlert) {
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func getPaisNumero() -> String {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //array de paises ya guardados en la entidad CountrySelectedAlert
        var paisGuardado: [NSManagedObject]
        //Peticion
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountryNumberAlert")
        var numeroPais = ""
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            paisGuardado = results as! [NSManagedObject]
            //Si hay algun pais lo borra puesto que solo debe haber uno
            for paisG in paisGuardado{
                numeroPais = paisG.value(forKey: "numero") as! String
            }
            try managedContext.save()
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
        return numeroPais
    }
    
    func getNombrePais(nombrePais: String) -> NSManagedObject{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //array de paises ya guardados en la entidad CountrySelectedAlert
        var paisGuardado: [NSManagedObject]
        //Peticion
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        var Pais: NSManagedObject!
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            paisGuardado = results as! [NSManagedObject]
            //Si hay algun pais lo borra puesto que solo debe haber uno
            for paisG in paisGuardado{
                if(nombrePais == paisG.value(forKey: "country") as! String){
                    Pais = paisG
                    
                }
            }
            try managedContext.save()
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
        return Pais
    }
    
    
    
    
        
    
}

