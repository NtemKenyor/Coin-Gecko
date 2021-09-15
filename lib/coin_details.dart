import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:charts_flutter/flutter.dart' as charts;

class moreOnCoin extends StatefulWidget {
  final value;

  moreOnCoin({Key key, this.value}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState(value);
}

class _SecondScreenState extends State<moreOnCoin> {

  final coin_s;
  _SecondScreenState(this.coin_s);


  Color blu_one = Color.fromRGBO(126, 215, 252, 1);
  Color blue_er = Colors.blue[800];

  TextEditingController flat_note = TextEditingController();
  TextEditingController crypto_equ = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool visiblePass = true;
  bool checksValue = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(coin_s.name)),
      body: new Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color.fromRGBO(126, 220, 252, 1), Color.fromRGBO(45, 93, 250, 1) ]
            ),
          ),
        child: ListView(

          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 240,
                decoration: BoxDecoration(
                  //color: Colors.green,
                  image: DecorationImage(
                      image: NetworkImage(coin_s.logo_url), fit: BoxFit.contain
                  )
                ),
              ),
            ),


            Form(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                  padding: const EdgeInsets.fromLTRB(12, 23, 12, 23),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: flat_note,
                      keyboardType: TextInputType.text,
                      enableSuggestions: true,
                      decoration: InputDecoration(   
                        prefixIcon: Icon(Icons.attach_money, color: blue_er,),
                        hintText: "Please Enter an Amount",
                        hintStyle: TextStyle(color: blue_er),
                        suffix: Text("USD"),
                        border:OutlineInputBorder(
                          //gapPadding: 0,
                          borderSide: const BorderSide(color: Colors. white, width: 0),
                          borderRadius: BorderRadius. circular(15.0),
                        ),
                      ),

                      onChanged: (priceAmount){
                        //var equ = double.parse(priceAmount) / coin_s.price ;
                        double equ = 0.0;
                        if(cryptoAmount == null or cryptoAmount == ""){
                          equ = 0.0;
                        }else{
                          equ = double.parse(cryptoAmount) / coin_s.price ;
                        }
                        setState(() {
                          crypto_equ.text = equ.toString();
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'USD - Flatnotes';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 23, 12, 23),
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: crypto_equ,
                        keyboardType: TextInputType.text,
                        enableSuggestions: true,
                        decoration: InputDecoration(   
                          prefixIcon: Icon(Icons.money, color: blue_er,),
                          hintText: "Crypto Price Equivalent",
                          hintStyle: TextStyle(color: blue_er),
                          suffix: Text(coin_s.symbol),
                          border:OutlineInputBorder(
                            //gapPadding: 0,
                            borderSide: const BorderSide(color: Colors. white, width: 0),
                            borderRadius: BorderRadius. circular(15.0),
                          ),
                        ),

                        onChanged: (cryptoAmount){
                          double equ = 0.0;
                          if(cryptoAmount == null or cryptoAmount == ""){
                            equ = 0.0;
                          }else{
                            equ = double.parse(cryptoAmount) * coin_s.price ;
                          }
                          
                          setState(() {
                            flat_note.text = equ.toString();
                          });
                        },
                        
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'USD - Flatnotes';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

             
          ],
        ),
      ),
    );
  }
}


/// Timeseries chart example
