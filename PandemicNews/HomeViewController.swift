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


//Extension de UIImageView que nos permite descargar imagenes de url pasandole una URL como parámetro
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
//Clase HomeViewController

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, UISearchBarDelegate {
    //--------------------Declaración de atributos del HomeViewController-------------------------
    //Array de paises
    public var paises = [NSManagedObject]()
    //Barra de navegación
    @IBOutlet weak var barraNavegacion: UINavigationItem!
    //ColectionView de paises
    @IBOutlet weak var collectionView: UICollectionView!
    //Barra de búsqueda
    @IBOutlet weak var searchBar: UISearchBar!
    //Array de paises para el filtrado de la búsqueda
    var paisesFiltrado: [NSManagedObject]!
    //Booleano que nos dice si la búsqueda está activa o no
    var searchBarActive: Bool = false
    
    
    //Cada vez que aparezca la vista
    override func viewDidAppear(_ animated: Bool) {
        //Se llama a la request de la base de datos Core Data  para refrescar la Collection View
        fetchPaises()
        
    }
    
    //Cuando la vista carga por primera vez...
    override func viewDidLoad() {
        super.viewDidLoad()
        //Delegate de la barra de búsqueda
        self.searchBar.delegate = self
        //Cambiamos el título de la vista
        barraNavegacion.title = "Lista de paises"
        //Borramos todos los países
        borraPaises()
        //Los volvemos a cargar
        cargaPaises()
    }
    
    
    
    //Preparamos la segue de la collection view a pais individual para pasarle infomación
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailSegue"){
            let item = sender as? UICollectionViewCell
            let indexPath = collectionView.indexPath(for: item!)
            let detailVC = segue.destination as! PaisIndividualViewController
            //Le pasamos a la vista de pais individual el indice en el que se encuentra el país y el país en concreto sobre el que pulsamos
            detailVC.index = indexPath!
            detailVC.paisIndividual = paises[(indexPath?.row)!] 
        }
        
    }
    
    //Borra todos los países de la tabla Country y la deja vacía
    func borraPaises(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //Creamos la request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            let Paises = results as! [NSManagedObject]
             for pais in Paises{
                //Eliminamos cada país que esté en la tabla
                managedContext.delete(pais)
             }
            //Guardamos
             try managedContext.save()
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
    }
    
    //Request a la base de datos para sacar todos los países que necesitamos mostrar en la CollectionView
    func fetchPaises(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Request de paises desacargados de la api
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            //Guardamos el resultado en el array paises
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
        //Igualamos el array de filtrado al de paises en general
        paisesFiltrado = paises
        //Refrescamos la CollectionView
        self.collectionView.reloadData()
    }
    
    //Realiza la descarga de datos de una api JSON
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
                    //Si no ha habido errores en la descarga de datos, procedemos a decodificarlos
                    if let json  = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        //Dentro del vector data
                        if let vector = json["data"] as? [String: Any]{
                            for (key, value) in vector {
                                //Si nos encontramos con el elemento rows entramos
                                if key == "rows"{
                                    //Obtenemos un array con todos los paises
                                    if let datos = value as? [Any] {
                                        for dato in datos {
                                            if let pais = dato as? [String: Any] {
                                                //Vamos de manera individual guardando cada pais en un  objeto temporal llamado country
                                                var country = Pais(nombre: "", bandera: "", numeroInfectados: "", casosPorMillPersonas: "", recuperados: "", fallecidos: "")
                                                //Por cada pais...
                                                for (llave, valor) in pais {
                                                    //Comprobamos que campo estamos tratando y si coincide con el que queremos guardamos el dato en el objeto country
                                                    
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
                                                //De manera asíncrona llamamos a la función que guarda el país en core data
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
        //Decimos en que entidad queremos guardar los datos
        let entity = NSEntityDescription.entity( forEntityName: "Country", in: managedContext)
        //Creamos un objeto de esa entidad
        let pais = NSManagedObject(entity: entity!, insertInto: managedContext)
        //Le proporcionamos los valores que vienen por parámetro
        pais.setValue(paisData.country, forKey: "country")
        pais.setValue(paisData.total_cases, forKey: "total_cases")
        pais.setValue(paisData.total_recovered, forKey: "total_recovered")
        pais.setValue(paisData.total_deaths, forKey: "total_deaths")
        pais.setValue(paisData.cases_per_mill_pop, forKey: "total_cases_per_mill_pop")
        pais.setValue(paisData.flag, forKey: "flag")

        do{
            //Guardamos
            try managedContext.save()
            
            
        }catch let error as NSError{
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        //Realizamos una fetch request de todoss los paises guardados
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        //LLamamos a fecthPaises solo cuando tenemos 200 paises guardados en la BBDD, debido a que queremos que actualice sólo cuando esten todos descargados
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
    //Número de elementos en la collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Si la barra de busqueda esta activa solo se muestran los elementos que cpoinciden con la misma
        if self.searchBarActive {
            return self.paisesFiltrado!.count;
        }
        //Si no estaá activa se muestran todos
        return self.paises.count
    }
    //Construcción de cada celda de manera individual
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "pais"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PaisCollectionViewCell
        //Si la búsqueda está activa se cogen los datos de paisesFiltrado
        if(searchBarActive){
            cell.nombrePais.text = paisesFiltrado[indexPath.row].value(forKey: "country") as? String
            cell.numeroInfectados.text = paisesFiltrado[indexPath.row].value(forKey: "total_cases") as? String
            cell.banderaPais.contentMode = .scaleAspectFill
            if(paises[indexPath.row].value(forKey: "flag") != nil){
                cell.banderaPais.downloaded(from: paisesFiltrado[indexPath.row].value(forKey: "flag") as? String ?? "")
            }else{
                if(paises[indexPath.row].value(forKey: "flagImage") != nil){
                    cell.banderaPais.image = UIImage(data :paisesFiltrado[indexPath.row].value(forKey: "flagImage") as! Data)
                }
            }
        }//Si no está activa coge los datos de paises
        else{
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
        }
        cell.nombrePais.textAlignment = .center
        cell.numeroInfectados.textAlignment = .center
        
        
        
        return cell
        
    }
    //Muestra alerta cuando un determinado pais alcanza un determinado número de casos
     func muestraAlert() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //array de paises ya guardados en la entidad CountrySelectedAlert
        var paisGuardado: [NSManagedObject]
        //Peticion para saber cual es el pais que tenemos seleccionado para que nos muestre la alerta
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CountrySelectedAlert")
        var nombrePais = ""
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            paisGuardado = results as! [NSManagedObject]
            //Averiguamos cual es el pais guardado(solo debe haber uno)
            for paisG in paisGuardado{
                nombrePais = paisG.value(forKey: "country") as! String
            }
            try managedContext.save()
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
        //Lamamos a getPaisNumero que nos devuelve el numero de casos para alerta
        let numero = getPaisNumero()
        //Creamos la alerta
        let alertController = UIAlertController(title: "Alerta de casos", message: "El pais \(nombrePais), has superado los \(numero) casos", preferredStyle: .alert)

        //Creamos la acción aceptar
        let saveAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        //Añadimos la acción aceptar al alert controller
        alertController.addAction(saveAction)
    
        
        //Comprobamos si el pais tiene más casos de los que el usuario quiere que se le notifique
        let Pais = getNombrePais(nombrePais: nombrePais)
        var numeroGuardado = Pais.value(forKey: "total_cases") as! String
        numeroGuardado = numeroGuardado.replacingOccurrences(of: ",", with: "")
        let numeroGuardadoInt = (numeroGuardado as NSString).integerValue
        let numeroGuardadoAlert = (numero as NSString).integerValue
        //Si es asi se muestra la alerta, en caso contrario no
        if(numeroGuardadoInt >= numeroGuardadoAlert) {
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    //Obtiene el número de casos para alerta que guardo el usuario
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
            
            for paisG in paisGuardado{
                numeroPais = paisG.value(forKey: "numero") as! String
            }
            try managedContext.save()
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
        return numeroPais
    }
    //Obtiene el país segun el nombre que se le pasa por parámetro
    func getNombrePais(nombrePais: String) -> NSManagedObject{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //array de paises ya guardados en la entidad
        var paisGuardado: [NSManagedObject]
        //Peticion
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        var Pais: NSManagedObject!
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            paisGuardado = results as! [NSManagedObject]

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
    
    // MARK: Search
    func filterContentForSearchText(searchText:String){
        self.paisesFiltrado = self.paises.filter({ (object: NSManagedObject) -> Bool in
            let cadena = object.value(forKey: "country") as! String
            return cadena.lowercased().contains(searchText.lowercased())
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // si el usuario escribe algo lo buscamos 
        if searchText.count > 0 {
            // search and reload data source
            self.searchBarActive    = true
            self.filterContentForSearchText(searchText: searchText)
            self.collectionView?.reloadData()
        }else{
            // if text lenght == 0
            // we will consider the searchbar is not active
            self.searchBarActive = false
            self.collectionView?.reloadData()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.cancelSearching()
        self.collectionView?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarActive = true
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // we used here to set self.searchBarActive = YES
        // but we'll not do that any more... it made problems
        // it's better to set self.searchBarActive = YES when user typed something
        self.searchBar!.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // this method is being called when search btn in the keyboard tapped
        // we set searchBarActive = NO
        // but no need to reloadCollectionView
        self.searchBarActive = false
        self.searchBar!.setShowsCancelButton(false, animated: false)
    }
    func cancelSearching(){
        self.searchBarActive = false
        self.searchBar!.resignFirstResponder()
        self.searchBar!.text = ""
    }
    
    
    
    
        
    
}

