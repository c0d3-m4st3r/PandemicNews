//
//  Pais.swift
//  PandemicNews
//
//  Created by user152439 on 4/24/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit

class Pais {
    
    //Aributos de Pais
    var nombre: String
    var bandera: UIImage?
    var numeroInfectados: Int
    var casosPorMillPersonas: Float
    var recuperados: Int
    var fallecidos: Int
    
    init(nombre: String, bandera: UIImage?, numeroInfectados: Int, casosPorMillPersonas: Float, recuperados: Int, fallecidos: Int){
        
        
        //Dando valor a atributos
        self.nombre = nombre
        self.bandera = bandera
        self.numeroInfectados = numeroInfectados
        self.casosPorMillPersonas = casosPorMillPersonas
        self.recuperados = recuperados
        self.fallecidos = fallecidos
    }
    
    
    
    
}
