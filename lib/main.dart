import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'coin_details.dart';


void main() {
  runApp(coins_display());
}

//this is the class that describes the main model 
class Coin_model {
  num price;
  final String id, symbol, name, logo_url;

  Coin_model({
    this.id,
    this.symbol,
    this.name,
    this.logo_url,
    this.price,
  });

  factory Coin_model.fromJson(Map<String, dynamic> jsonData) {
    return Coin_model(
      id: jsonData['id'],
      name: jsonData['name'],
      symbol: jsonData['symbol'],
      logo_url: jsonData['image'],
      price: jsonData['current_price'],
    );
  }
}


// this is the customlistview obtained from the future Json data
class CustomListView extends StatefulWidget {
  final List<Coin_model>  value;
  CustomListView({Key key, this.value}) : super(key: key);

  @override
  _CustomListViewState createState() => _CustomListViewState(value);
}

class _CustomListViewState extends State<CustomListView> {
  final List<Coin_model> coinInfo;
  _CustomListViewState(this.coinInfo);

  Color the_White = Colors.white;
  Color balance_below = Colors.amber[800];
  Color blue_below = Colors.blue[800];
  int clicked = -1;
  
  @override
  void initState() {
    //symbol();
    super.initState();
  }
  Widget build(context) {
    return 
      ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: coinInfo.length,
        itemBuilder: (context, int currentIndex) {
          return List_home(currentIndex, coinInfo[currentIndex], context);
        },
      );
  }

  Widget List_home (int number, Coin_model coins__, BuildContext context) {
    var currencySymbol = "USD";
    double amountCurrency = double.parse(coins__.price.toStringAsFixed(3));
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
      amount: amountCurrency, 
      settings: MoneyFormatterSettings(
        symbol: currencySymbol,
      )
    );
    String theAmount = ( coins__.price.toString().length > 10 == true ) ? fmf.output.symbolOnLeft : fmf.output.compactSymbolOnLeft;


    
    return InkWell(
      hoverColor: Colors.orange,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>  moreOnCoin(value: coins__) )
          );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: the_White,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.network(coins__.logo_url, height: 60, width: 60,),
                    Text(coins__.name, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18,),),
                  ],
                ),
              
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  theAmount, 
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),),
              )
            ]
          )
        ),
      )
    );
  }

}




class coins_display extends StatefulWidget {
  coins_display({Key key,}) : super(key: key);

  coins_display_State createState() => coins_display_State();
}

class coins_display_State extends State<coins_display> {

   // This is optional. This is not requred always
  GlobalKey<ScaffoldState> _scaffold2Key;

  // This method will run once widget is loaded
  // i.e when widget is mounting
  @override
  void initState() {
    _scaffold2Key = GlobalKey();
    super.initState();
  }

  @override
  void dispose() {
    // disposing states
    _scaffold2Key?.currentState?.dispose();
    super.dispose();
  }

  List<Coin_model> coins;


  //Future is n object representing a delayed computation.
Future<List<Coin_model>> getCoinsJson() async {
  String flatNote = "USD";
  //print(flatNote);
  String jsonEndpoint = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=USD&order=market_cap_desc&per_page=10&page=1&sparkline=false";
  print("entered here");
  http.Response response = await http.get(jsonEndpoint);

  if (response.statusCode == 200) {
      String theBody =
       response.body;
      List crypto_coins = jsonDecode(theBody);
      print(theBody);
      //print(theBody);
      return crypto_coins
          .map((crypto_coins) => new Coin_model.fromJson(crypto_coins))
          .toList();
  } else{
    print("here o entered b");
    print(jsonDecode(response.body));
    throw Exception('We were not able to successfully download the json data.');
  }
}


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Color(0xFFDBECF1),
      ),
      home: new Scaffold(
        key: _scaffold2Key,
        appBar: AppBar(
          title: Center(child: Text("Coins List")),
          backgroundColor: Colors.blue[800],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color.fromRGBO(126, 215, 252, 1), Color.fromRGBO(45, 93, 250, 1) ]
            ),
          ),
          child: RefreshIndicator(
            backgroundColor: Colors.green[800],
            color: Colors.white,
            strokeWidth: 3,
            onRefresh: () {
              return Future.delayed(
                Duration(seconds: 3), () async {
                  var contentCoin = await getCoinsJson();
                  setState(() {
                    coins  = contentCoin;
                  });

                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Page Refreshed'),
                    ),
                  );

                }
              );
            },
            child: FutureBuilder<List<Coin_model>> (
              future: getCoinsJson(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  coins = snapshot.data;
                  return CustomListView(value: coins);
                } else if (snapshot.hasError) {
                  print(snapshot.data);
                  return new Container(
                    color: Colors.white,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
                        child: Text("Looks Like you do not have an active Internet Connection",
                        textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    )
                  );
                }
                //return  a circular progress indicator.
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator( strokeWidth: 10, backgroundColor: Colors.green[800],),)
                    ),
                  ]
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
//end
