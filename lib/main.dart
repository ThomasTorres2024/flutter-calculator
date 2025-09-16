import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart'; // External package for expression evaluationer
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class ArithmeticNode{
  double? val1;
  double? val2; 
  String op;

  

  ArithmeticNode(this.op);
}


class CalculatorData{

  //keep track of the vals and ops the user gave us 
  List<double> vals=[];
  List<String> op=[];

  CalculatorData();

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thomas Torres Basic Calculator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String calculatorEntries="";
  bool readIntoNextSlot = true; 
  CalculatorData calculatorInfoFields = CalculatorData();
  Set<String> validOperations = {"^","*","/","+","-"};
  Map<String, double Function(double, double)> arithmeticFunction = {
    "^": (double v1, double v2)=>(pow(v1,v2)).toDouble() ,
    "*": (double v1, double v2)=>v1*v2,
    "/": (double v1, double v2)=>v1/v2,
    "-": (double v1, double v2)=>v1-v2,
    "+": (double v1, double v2)=>v1+v2,};
                                                            

  void ModifyCalculatorStringRebuild(String char){
    if(readIntoNextSlot){

      //error occurs here, we can't have a stray operand it needs to be next to a number, we only do 
      //read into next slot when we are expecting a number 
      if(validOperations.contains(char)){
        return;
      }
      calculatorInfoFields.vals.add(double.parse(char));  
      readIntoNextSlot=false;
    }
    //last entry was a number, since the only time we have operands is when readIntoNextSlot is true, which is false
    //which is why we are executing here, so we can add operands 
    else if(validOperations.contains(char)){
      calculatorInfoFields.op.add(char); 
      readIntoNextSlot=true;
    }
    //character must be a digit then 
    else
    {
      calculatorInfoFields.vals.last = calculatorInfoFields.vals.last*10+double.parse(char);
    }

    calculatorEntries+=char;
    setState(() {});
  }

  /**
   * Evaluates arithmetic expression entered by user if valid
   */
  void evaluateExpression(String char){

    List<double> vals = calculatorInfoFields.vals; 
    List<String> ops = calculatorInfoFields.op;
    
    validOperations.forEach((element) {
      int i = 0; 
      while(i < ops.length){
        //if our operation is of the same precedence 
        try{
           if(ops[i]==element){

            if(element == "/" && vals[i+1]==0){
              calculatorEntries+="\nERROR. \nDivision by Zero error. \nHit clear.";
              setState(() {});
            }
          
          vals[i+1]=arithmeticFunction[element]!(vals[i],vals[i+1]);
          
          //take away elements we computed from expression
          vals.removeAt(i);
          ops.removeAt(i);

        }
        //continue looping otherwise 
        else
        {
          i++;
        }
        
      }
      catch (e){
        print("ERROR. Unable to parse the arithmetic expression");
        print(vals);
        print(ops);
        print(i);
        print("************************");
        break;
      }
         }
    });
    print(vals[0]);

    calculatorEntries+="=";
    calculatorEntries+=vals[0].toString();
    setState(() {});
  }

  //Reset everything 
  void clearFields(String char){
    readIntoNextSlot=true;
    calculatorEntries="";
    calculatorInfoFields = CalculatorData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(              
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,   // start point
            end: Alignment.bottomRight, // end point
            colors: [
              Colors.blue,
              Colors.purple,
            ],
          ),
        ),
        child:  Container(
          width: 500.0,
          height: 350.0,
          decoration: BoxDecoration(
            color: Colors.white,
                boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 2),
            )
          ],
            borderRadius: BorderRadius.circular(10),
          ),
            
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Thomas Torres Calculator CSC 305",
              style:TextStyle(fontSize: 24,fontFamily: 'Courrier New')),
              Padding(padding: EdgeInsets.only(bottom: 10.0)),
              Container(
                height: 80,
                width: 400,
                alignment: Alignment.center,  
                decoration: BoxDecoration(
                  color: Colors.black,
                  
                ),


                
                child: 
                
                SingleChildScrollView(
                  child: 
                    Text(calculatorEntries,
                    style:TextStyle(
                    color: Colors.white,
                    fontFamily: 'Courier New',
                    fontSize: 24,

                )),
                )
              
              ),
              Padding(padding: EdgeInsets.only(bottom: 10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,         
                children: [
                  getCaculatorButton(calculatorInfoFields, "1",ModifyCalculatorStringRebuild),
                  getCaculatorButton(calculatorInfoFields, "2",ModifyCalculatorStringRebuild),
                  getCaculatorButton(calculatorInfoFields, "3",ModifyCalculatorStringRebuild),
                  getCaculatorButton(calculatorInfoFields, "+",ModifyCalculatorStringRebuild)
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,         
                children: [
                  getCaculatorButton(calculatorInfoFields, "4",ModifyCalculatorStringRebuild),
                  getCaculatorButton(calculatorInfoFields, "5",ModifyCalculatorStringRebuild),
                  getCaculatorButton(calculatorInfoFields, "6",ModifyCalculatorStringRebuild),
                  getCaculatorButton(calculatorInfoFields, "-",ModifyCalculatorStringRebuild)
                ],),
              Padding(padding: EdgeInsets.only(bottom: 10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,         
                children: [
                  getCaculatorButton(calculatorInfoFields, "7",ModifyCalculatorStringRebuild),
                  getCaculatorButton(calculatorInfoFields, "8",ModifyCalculatorStringRebuild),
                  getCaculatorButton(calculatorInfoFields, "9",ModifyCalculatorStringRebuild),
                  getCaculatorButton(calculatorInfoFields, "*",ModifyCalculatorStringRebuild)
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 10.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,         
                children: [
                  getCaculatorButton(calculatorInfoFields, "0",ModifyCalculatorStringRebuild),
                  getCaculatorButton(calculatorInfoFields, "C",clearFields),
                  getCaculatorButton(calculatorInfoFields, "=",evaluateExpression),
                  getCaculatorButton(calculatorInfoFields, "/",ModifyCalculatorStringRebuild)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,         
                children: [
                  getCaculatorButton(calculatorInfoFields, "^",ModifyCalculatorStringRebuild),
                ],
              )
                ],
          ),  
)
        )

      

    );
  }
}



ElevatedButton getCaculatorButton(CalculatorData calculatorInfoFields, String displayChar, Function(String) onPressedAction ){
  return ElevatedButton(
    child: Text(displayChar),
    onPressed: ()=>{
      onPressedAction(displayChar)
      },
    );
}

