//
//  AsyncImageView.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 09/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class AsyncImageView: UIImageView {
  
  //Creamos una propiedad para asignar un Id único
  var lastMark : UUID? = nil
  
  // Método que se encarga de asignar la imagen al UIImageView
  func fillWithURL(_ url: URL, placeholder: String?) {
    self.image = placeholder != nil ? UIImage(named: placeholder!) : nil
    
    lastMark = UUID()
    let mark = lastMark
    
    ImageCache.shared.imageWithURL(url) {
      [weak self] (image) in
      
      // Verificamos que el lastMark sea igual para evitar que una imagen se asigne en lugar equivocado
      guard self?.lastMark == mark else {
        return
      }
      
      // Hacemos un unwrap de la variable para aegurar que no sea nil
      guard let unWrappedImage = image else {
        return
      }
      
      // Si estamos en el main thread hacemos la asignación de inmediato
      if Thread.isMainThread {
        self?.image = unWrappedImage
      }
      else {
        // Si no estamos en el main thread, cambiamos al main queque y luego hacemos la asignación
        DispatchQueue.main.async {
          self?.image = unWrappedImage
        }
      }
    }
  }
}
