//: Playground - noun: a place where people can play

import UIKit
import GIGLibrary

let label = UILabel(frame: CGRectMake(0, 0, 400, 100))

label.textColor = UIColor.whiteColor()
label.font = UIFont(name: "ChalkboardSE-Light", size: 15)
label.numberOfLines = 2

// MARK: Styled String Example

// MARK: Example 1

label.styledString = "Este es mi texto "
                    + "con estilo ".style(.Bold,
                                          .Underline,
                                          .UnderlineColor(UIColor.yellowColor()))
                    + "rojo \n".style(.Color(.redColor()),
                                      .Bold)
                    + "mola".style(.BackgroundColor(UIColor.redColor()))

label

// MARK: Example 2

label.styledString = "fuente 1 " + "fuente 2".style(.FontName("ArialMT"))

// MARK: Example 2

let textView = UITextView(frame: CGRectMake(0, 0, 400, 100))

let url = NSURL(string: "www.google.es")!
textView.attributedText = ("Pincha en este " + "link".style(.Link(url))).toAttributedString(defaultFont: label.font)

// MARK: Example 2
var font = UIFont(name: "ArialMT", size: 15)!
label.font = font
label.styledString = "numero: " + "10".style(.Size(50), .Bold) + ".22".style(.Size(20), .Italic)

label.styledString = "Acepta los"
                    + " terminos y condiciones".style(.Italic)
                    + " antes de recibir los"
                    + " 22".style(.Size(20), .Color(UIColor.redColor()))
                    + ".35".style(.Size(10), .Color(UIColor.redColor()))
                    + " Euros"

label

// MARK: HTML Example

// MARK: Example 1

label.html = "texto <b>importante</b>"

// MARK: Example 2

label.html = "texto <b style=\"color:red;\">importante</b>"
