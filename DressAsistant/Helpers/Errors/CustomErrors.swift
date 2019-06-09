//
//  CustomErrors.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 09/06/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation

enum CustomError: Error {
  case generic
  case usersNotSignedIn
  case emptyField(fieldName: String)
}
