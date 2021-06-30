import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';

class ListenLocationWidget extends StatefulWidget {
  const ListenLocationWidget({Key? key}) : super(key: key);

  @override
  _ListenLocationState createState() => _ListenLocationState();
}

class _ListenLocationState extends State<ListenLocationWidget> {
  final Location location = Location();

  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;

  Future<void> _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      if (err is PlatformException) {
        setState(() {
          _error = err.code;
        });
      }
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((LocationData currentLocation) {
          Fluttertoast.showToast(
              msg: 'latitude:${currentLocation.latitude} , latitude:${currentLocation.latitude}',
              backgroundColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER);
          // final snackBar = SnackBar(
          //   content: Text('latitude:${currentLocation.latitude} , latitude:${currentLocation.latitude}'),
          //   action: SnackBarAction(
          //     label: 'Undo',
          //     onPressed: () {
          //       // Some code to undo the change.
          //     },
          //   ),
          // );
          //
          // // Find the ScaffoldMessenger in the widget tree
          // // and use it to show a SnackBar.
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        _error = null;

        _location = currentLocation;
      });
    });
    setState(() {});
  }

  Future<void> _stopListen() async {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Listen location: ' + (_error ?? '${_location ?? "unknown"}'));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Listen location: ' + (_error ?? '${_location ?? "unknown"}'),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 42),
              child: ElevatedButton(
                child: const Text('Listen'),
                onPressed:
                    _locationSubscription == null ? _listenLocation : null,
              ),
            ),
            ElevatedButton(
              child: const Text('Stop'),
              onPressed: _locationSubscription != null ? _stopListen : null,
            )
          ],
        ),
      ],
    );
  }
}
