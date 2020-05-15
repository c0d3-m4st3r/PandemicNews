//
//  MapaMundiViewController.swift
//  PandemicNews
//
//  Created by user152439 on 4/28/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class MapaMundiViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var casosTotales: UILabel!
    @IBOutlet weak var paisesInfectados: UILabel!
    @IBOutlet weak var recuperadosTotales: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
  
    var datos = "World"
    
    
    //Funcion que carga todos los datos del mundo
    private func cargaPais(){
        //Obtenemos un objeto con todos los datos de mundo
        let mundo = getCasosMundo(nombre: datos)
        casosTotales.text = mundo.value(forKey: "total_cases") as! String
        paisesInfectados.text = getPaisesTotales() as! String
        recuperadosTotales.text = mundo.value(forKey: "total_recovered") as! String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cargaPais()
        
        //Url de la webView
        let myURL = URL(string: "https://www.trackcorona.live/map")
        //Petición de la web View
        let myRequest = URLRequest(url: myURL!)
        //Cargamos la petición de la web View
        webView.load(myRequest)
        	

    }
    //Obtiene el número de casos que hay en todo el mundo
    func getCasosMundo(nombre: String) -> NSManagedObject{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //array de paises ya guardados en la entidad Country
        var MundoGuardado: [NSManagedObject]
        //Peticion
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        var Pais: NSManagedObject!
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            MundoGuardado = results as! [NSManagedObject]
            //Buscamos el pais mundo
            for paisG in MundoGuardado{
                if(nombre == paisG.value(forKey: "country") as! String){
                    Pais = paisG
                    
                }
            }
            try managedContext.save()
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
        //Devolvemos los datos del mundo
        return Pais
    }
    
    
    
    //Funcion que cuenta cuantos paises hay guardados en la bbdd de la api
    func getPaisesTotales() -> String{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //array de paises ya guardados en la entidad CountrySelectedAlert
        var paisesGuardados: [NSManagedObject]
        //Peticion
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        var Pais: NSManagedObject!
        var contador = 0
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            paisesGuardados = results as! [NSManagedObject]
            for paisG in paisesGuardados{
                if(paisG != nil){
                    contador += 1
                    
                }
            }
            try managedContext.save()
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
        //Pasamos el número a string para que se pueda mostrar
        let numeroGuardadoInt = (contador as NSInteger).description
        return numeroGuardadoInt
    }
    
}
