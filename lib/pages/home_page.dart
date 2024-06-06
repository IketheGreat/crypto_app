import 'dart:convert';

import 'package:coincap_app/pages/details_page.dart';
import 'package:coincap_app/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  String _selectedCoin = "Bitcoin";

  HTTPService? _http;

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _selectedCoinDropDown(),
              _dataWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedCoinDropDown() {
    List<String> _coins = [
      "Bitcoin",
      "Ethereum",
      "Tether",
      "Cardano",
      "Ripple"
    ];

    List<DropdownMenuItem<String>> _items = _coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();

    return DropdownButton(
      value: _selectedCoin,
      items: _items,
      onChanged: (dynamic _value) {
        setState(() {
          _selectedCoin = _value;
        });
      },
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      iconSize: 30,
      underline: Container(),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
      future: _http?.get("/coins/$_selectedCoin".toLowerCase()),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          Map _data = jsonDecode(
            _snapshot.data.toString(),
          );
          num _usdPrice = _data["market_data"]["current_price"]["usd"];
          num _change24h = _data["market_data"]["price_change_percentage_24h"];
          String _imgUrl = _data["image"]["large"];
          String _description = _data["description"]["en"];
          Map _exchangeRates = _data["market_data"]["current_price"];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: _deviceHeight! * 0.35,
                child: Column(
                  children: [
                    GestureDetector(
                      onDoubleTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext _context) {
                          return DetailsPage(
                            rates: _exchangeRates,
                          );
                        }));
                      },
                      child: _coinImage(_imgUrl),
                    ),
                    _currentPriceWidget(_usdPrice),
                    _percentageChangeWidget(_change24h),
                  ],
                ),
              ),
              _coinDescription(_description),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget _currentPriceWidget(num _rate) {
    return Text(
      "${_rate.toStringAsFixed(2)} USD",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _percentageChangeWidget(num _change) {
    return Text(
      "${_change.toString()} %",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _coinImage(String _imgURL) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.02),
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_imgURL),
        ),
      ),
    );
  }

  Widget _coinDescription(String _description) {
    return Container(
        color: const Color.fromARGB(255, 41, 54, 110),
        width: _deviceWidth! * 0.90,
        height: _deviceHeight! * 0.45,
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth! * 0.05,
          vertical: _deviceHeight! * 0.03,
        ),
        child: ListView(
          children: [
            Text(
              _description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ));
  }
}
