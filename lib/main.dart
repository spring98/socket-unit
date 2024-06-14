// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

void main() {
  runApp(
    const GetMaterialApp(
      home: SocketUnit(),
    ),
  );
}

class SocketUnit extends StatefulWidget {
  const SocketUnit({Key? key}) : super(key: key);

  @override
  _SocketUnitState createState() => _SocketUnitState();
}

class _SocketUnitState extends State<SocketUnit> {
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (socket.connected) {
                    print('이미 연결되어 있습니다.');
                  } else {
                    initSocket();
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  color: Colors.lightBlueAccent,
                  child: const Text('소켓 연결하기'),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (socket.connected) {
                    sendMessage();
                  } else {
                    print('연결되어 있지 않습니다.');
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  color: Colors.yellow,
                  child: const Text('메세지 보내기'),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  socketDispose();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  color: Colors.orange,
                  child: const Text('나가기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initSocket() {
    // Dart client
    socket = IO.io('ws://222.100.24.97:3002', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    socket.onConnect((_) {
      print('connection establish!');
      print(
          'id : ${socket.id}, connected : ${socket.connected}, disconnected : ${socket.disconnected}');

      String answer =
          jsonEncode({"uid": "14e49a51-11b7-4785-b266-505c007404f2"});

      socket.emit('uid', answer);

      socket.emit('joinRoom', [0, answer]);
    });

    socket.on('message', (data) {
      print('서버에서 보낸 메세지 : $data');
    });

    socket.onDisconnect((_) {
      print('연결이 끊어졌습니다.');
    });
  }

  void sendMessage() {
    String uid = jsonEncode({"uid": "14e49a51-11b7-4785-b266-505c007404f2"});

    String send = jsonEncode({
      "uid": "9f956a6f-0342-4246-886b-c59eb04905cc",
      "lat": "37449446",
      "lng": "126656448"
    });
    socket.emit('message', [0, uid, send]);
  }

  void socketDispose() {
    socket.disconnect();
    socket.dispose();
  }
}
