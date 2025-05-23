import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmnevents/presentation/pos_settings/bloc/pos_settings_bloc.dart';
import 'package:rmnevents/presentation/register_and_sell/bloc/register_and_sell_bloc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../app_configurations/app_environments.dart';
import '../../imports/common.dart';
import '../../imports/data.dart';
import '../../presentation/home/staff_home_bloc/staff_home_bloc.dart';
import '../../root_app.dart';
import '../models/response_models/purchase_socket_response_model.dart';

class SocketDataSource {
  static IO.Socket? socket;

  static Future connectWithSocket() async {
    DataBaseUser user = await GlobalHandlers.extractUserHandler();

    debugPrint(
        'Connecting to socket ${"${AppEnvironments.socketUrl}?token=${user.token}"}');
    socket = IO.io(
        "${AppEnvironments.socketUrl}?token=${user.token}", <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket?.connect();
    socket?.onConnect((_) {
      debugPrint('Connection established');
    }); //

    socket?.emit('joinRoom', {"room_id": "onsite-purchase"});

    socket?.on("purchaseSuccess", (data) {
      debugPrint('Received data: $data');
      PurchaseSocketResponseModel purchaseResponse =
          PurchaseSocketResponseModel.fromJson(data);
      debugPrint('Parsed response: ${purchaseResponse.toJson()}');
      String? receiverId = purchaseResponse.readerId;
      String storedId = navigatorKey.currentContext!.read<StaffHomeBloc>().state.readerData!.id!;
      debugPrint('Receiver id: $receiverId, Stored id: $storedId');
      if(receiverId != storedId) {
        // BlocProvider.of<RegisterAndSellBloc>(navigatorKey.currentContext!)
        //     .add(TriggerPurchaseFail());
      }else{
        BlocProvider.of<RegisterAndSellBloc>(navigatorKey.currentContext!)
            .add(TriggerSuccessDialog(purchaseResponse: purchaseResponse));
      }

    });
    socket?.on("purchaseFail", (data) {
      debugPrint('Received data: $data');
      BlocProvider.of<RegisterAndSellBloc>(navigatorKey.currentContext!)
          .add(TriggerPurchaseFail());
    });

    socket?.on("connectReader", (data) {
      debugPrint('connected data: $data');
    });
    socket?.on("readerDisconnected", (data) {
      debugPrint('disconnected data: $data');
      String readerId = data['messageData']['readerId'];
      buildCustomToast(
          msg: data['messageData']['message'],
          isFailure: true);
      List storedId = navigatorKey.currentContext!.read<PosSettingsBloc>().state.readers;
      int index = storedId.indexWhere((reader) => reader.id == readerId);
      BlocProvider.of<PosSettingsBloc>(navigatorKey.currentContext!).add(TriggerConnectToAReader(deviceIndex: index, isConnect: false));
      BlocProvider.of<PosSettingsBloc>(navigatorKey.currentContext!).add(TriggerRefreshPosSettings());
      BlocProvider.of<StaffHomeBloc>(navigatorKey.currentContext!)
          .add(TriggerCheckIfReaderIsExisting());
    });

    socket?.on('connect_error', (data) => debugPrint('-------$data'));
    socket?.onDisconnect((_) => debugPrint('Connection Disconnection'));
    socket?.onConnectError((err) => debugPrint('error in  connection $err'));
    socket?.onError((err) => debugPrint(
        'error in  $err')
    );
    socket?.onPing((d) => debugPrint('show $d'));
  }

  static void disconnectSocket() {
    socket?.disconnect();
    debugPrint('Socket disconnected');
  }

  static void emitConnectReader({required String readerId}) {
    socket?.emit("connectReader", {"reader_id":readerId});
    debugPrint('Emitting connect reader');
  }

  static void emitDisconnectReader() {
    socket?.emit("disconnectReader", {});
    debugPrint('Emitting connect reader');
  }
  static void emitPurchaseSuccess() {
    //  socket?.emit('joinRoom', {"room_id": "onsite-purchase"});
  }


}
