//
//  Noticia.swift
//  PandemicNews
//
//  Created by user152439 on 4/24/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit

class Noticia {
    
    var imagen: UIImage?
    var titular: String
    var pais: String
    
    init(imagen: UIImage?, titular: String, pais: String) {
        self.imagen = imagen
        self.titular = titular
        self.pais = pais
    }
    
}
