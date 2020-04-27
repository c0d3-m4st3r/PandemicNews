//
//  NoticiasViewController.swift
//  PandemicNews
//
//  Created by user152439 on 4/24/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit

class NoticiasViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var noticias = [Noticia]()
    var paisCategoria = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cargaNoticias()
    }
    
    private func cargaNoticias() {
        let fotoEsp1 = UIImage(named: "Esp1")
        let fotoEsp2 = UIImage(named: "Esp2")
        let fotoEsp3 = UIImage(named: "Esp3")
        let fotoUK1 = UIImage(named: "UK1")
        let fotoUK2 = UIImage(named: "UK2")
        let fotoUK3 = UIImage(named: "UK3")
        let fotoEEUU1 = UIImage(named: "EEUU1")
        let fotoEEUU2 = UIImage(named: "EEUU2")
        let fotoEEUU3 = UIImage(named: "EEUU3")
        let fotoIta1 = UIImage(named: "Ita1")
        let fotoIta2 = UIImage(named: "Ita2")
        let fotoIta3 = UIImage(named: "Ita3")
        let fotoCh1 = UIImage(named: "Ch1")
        let fotoCh2 = UIImage(named: "Ch2")
        let fotoCh3 = UIImage(named: "Ch3")
        let fotoAle1 = UIImage(named: "Ale1")
        let fotoAle2 = UIImage(named: "Ale2")
        let fotoAle3 = UIImage(named: "Ale3")

        let Esp1 = Noticia(imagen: fotoEsp1, titular: "Problemas en el metro", pais: "España")
        let Esp2 = Noticia(imagen: fotoEsp2, titular: "Médicos en apuros", pais: "España")
        let Esp3 = Noticia(imagen: fotoEsp3, titular: "Comparecencia del presidente", pais: "España")
        let UK1 = Noticia(imagen: fotoUK1, titular: "Primer ministro infectado", pais: "Reino Unido")
        let UK2 = Noticia(imagen: fotoUK2, titular: "Ambulancias infectadas", pais: "Reino Unido")
        let UK3 = Noticia(imagen: fotoUK3, titular: "Subida de la curva", pais: "Reino Unido")
        let EEUU1 = Noticia(imagen: fotoEEUU1, titular: "Colas de paro kilométricas", pais: "Estados Unidos")
        let EEUU2 = Noticia(imagen: fotoEEUU2, titular: "Calles vacias en Nueva York", pais: "Estados Unidos")
        let EEUU3 = Noticia(imagen: fotoEEUU3, titular: "Donal Trump dice que no hay problemas", pais: "Estados Unidos")
        let Ita1 = Noticia(imagen: fotoIta1, titular: "Registros aleatorios", pais: "Italia")
        let Ita2 = Noticia(imagen: fotoIta2, titular: "Agua contaminada", pais: "Italia")
        let Ita3 = Noticia(imagen: fotoIta3, titular: "Desabastecimiento leve", pais: "Italia")
        let Ch1 = Noticia(imagen: fotoCh1, titular: "Registros policiales por el virus", pais: "China")
        let Ch2 = Noticia(imagen: fotoCh2, titular: "Personas desmovilizadas", pais: "China")
        let Ch3 = Noticia(imagen: fotoCh3, titular: "Cientificos pueden dar con la cura", pais: "China")
        let Ale1 = Noticia(imagen: fotoAle1, titular: "Alemania, la mejor gestión del virus", pais: "Alemania")
        let Ale2 = Noticia(imagen: fotoAle2, titular: "Angela Merkel decreta el confinamiento", pais: "Alemania")
        let Ale3 = Noticia(imagen: fotoAle3, titular: "Los hospitales alemanes no se saturan", pais: "Alemania")

        noticias = [Esp1, Esp2, Esp3, UK1, UK2, UK3, EEUU1, EEUU2, EEUU3, Ita1, Ita2, Ita3, Ch1, Ch2, Ch3, Ale1, Ale2, Ale3]
        
        var count: Int
        for noticia in noticias{
            count = 0
            for pais in paisCategoria{
                if noticia.pais == pais{
                    count += 1
                }
            }
            if count == 0{
                paisCategoria.append(noticia.pais)
            }
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return paisCategoria.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var noticiasPais = [Noticia]()
        
        for noticia in noticias{
            if noticia.pais == paisCategoria[indexPath.section]{
                noticiasPais.append(noticia)
            }
        }
        
        let identifier = "noticia"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! NoticiasCollectionViewCell
        cell.titularNoticia.text = noticiasPais[indexPath.row].titular
        cell.imagenNoticia.image = noticiasPais[indexPath.row].imagen
        
        cell.titularNoticia.textAlignment = .center
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "seccionPais", for: indexPath) as! SectionHeaderCollectionReusableView
        
        let seccion = paisCategoria[indexPath.section]
        sectionHeaderView.tituloHeader.text = seccion
        
        return sectionHeaderView
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
