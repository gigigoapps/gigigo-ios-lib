//: Playground - noun: a place where people can play

import UIKit
import GIGLibrary

let label = UILabel(frame: CGRectMake(0, 0, 400, 100))

label.textColor = UIColor.whiteColor()
label.font = UIFont(name: "ChalkboardSE-Light", size: 15)
label.numberOfLines = 2

// MARK: Styled String Example

label.styledString = "Este es mi texto "
                    + "con estilo ".style(.Bold,
                                          .Underline,
                                          .UnderlineDouble,
                                          .UnderlineColor(UIColor.yellowColor()))
                    + "rojo \n".style(.Color(.redColor()),
                                      .Bold)
                    + "mola".style(.BackgroundColor(UIColor.redColor()))

label

// MARK: HTML Example

label.html = "texto <b>importante</b>"

label.html = "texto <b style=\"color:red;\">importante</b>"
