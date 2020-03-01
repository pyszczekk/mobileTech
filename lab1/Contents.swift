import UIKit
//zad1
var str = "Hello, playground"
print(str)
var calkowita = 13
var rzeczywista = 1.45
print(calkowita, rzeczywista)
//zad2
let stala : String = "Stala"
let stala2 : Int = 5
let stala3 :Float = 2.5
print(stala,stala2,stala3)
//zad3
let znakowa  = str + " "+String(rzeczywista)
let znakowa2 = str+" \(rzeczywista)"
print(znakowa, znakowa2)
//zad4
var tablica = [1,2,3,4,5];
var slownik = [1: "ala", 2:"ma", 3:"kota"]
print(tablica, slownik)
//zad5
tablica.append(6);
slownik.updateValue("i psa", forKey: 4)
print(tablica,slownik)
//zad6
var daty = ["29-11-14","27-11-14","25-11-14","23-11-14"]
var liczby = [[4,5,21,30,31,49],[1,2,3,4,5,6],[7,8,9,10,11,12],[1,34,5,23,16,42]]

let slownik2 = Dictionary(zip(daty, liczby), uniquingKeysWith: { (first, _) in first })
print(slownik2)
//zad7
var slownik3 = [Int:String]()
//zad8
var slownik4 = [String:Int]()

var literki = ["A","B","C","D","E","F","G","H","I","J"]
for i in 1...10{
    
    slownik4.updateValue(i,forKey:literki[i-1])
}
print(slownik4)
//zad9
for i in slownik2{
    print(i.key)
    for j in i.value{
        print("-",j)
    }
}
//zad10
func NWD(first: Int, second:Int)->Int{
    var a = first
    var b = second
    repeat
    {
        if (a>b) {a = a-b}
        if (b>a) {b = b-a}
        
    }
        while (a != b)
    
    return a
}
print(NWD(first:5,second:100), NWD(first:12,second:36), NWD(first:32,second:24))

//zad11
func NWD2(first: Int, second:Int)->(result: Int, firstDivided:Int,secondDivided:Int){
    var a = first
    var b = second
    repeat
    {
        if (a>b) {a = a-b}
        if (b>a) {b = b-a}
        
    }
        while (a != b)
    
    return (a, first/a,second/a)
}
print(NWD2(first:5,second:100), NWD2(first:12,second:36), NWD2(first:32,second:24))

//zad12
func change(c:Character)->Character{
    var r:Character
    switch c{
    case "G":
        r="A"
    case "A":
        r="G"
    case "D":
        r="E"
    case "E":
        r="D"
    case "R":
        r="Y"
    case "Y":
        r="R"
    case "P":
        r="O"
    case "O":
        r="P"
    case "L":
        r="U"
    case "U":
        r="L"
    case "K":
        r="I"
    case "I":
        r="K"
    default:
        r=c
    }
    return r
}
func cipher(s:String,f:(Character)->Character)->String{
    
    var newS=""
    for i in s.uppercased(){
        newS=newS+String(f(i))
    }
    return newS
}
print(cipher(s:"ala ma kota",f:change),cipher(s:"ag,de,ry,po,lu,ki", f:change))
//zad13

for i in slownik2{
    print(i.key)
    print(i.value.map({$0%2}))
}

//zad 14
class NamedObject{
    var Name = "";
    
    func describe()->String{
        return "Object called "+Name
    }
    class Sphere : NamedObject{
        var radius:Double;
        init(n : String, r : Double){
            self.radius = r
            super.init()
            self.Name=n;
        }
        func other(v: Double)->Double{
            radius = pow((3*v/(4*Double.pi)),(1/3))
            return v
        }
        func other()->Double{
            return(4.0/3.0 * Double.pi*pow(radius, 3))
        }
        
        override func describe() -> String {
            return "Object called "+Name+" having radius: "+String(radius)+" and V = "+String(round(self.other()))
        }
        
        
    }
    
}
var test = NamedObject();
test.Name="jestem obiektem";
print(test.describe())

var test2 = NamedObject.Sphere(n:"kula",r:3.0);
print(test2.describe())

test2.other(v:14)
print(test2.describe())
