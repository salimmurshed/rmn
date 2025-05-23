import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:rmnevents/data/repository/qr_repository.dart';
import 'package:rmnevents/data/repository/sales_repository.dart';
import 'package:rmnevents/presentation/qr_scan_view/widgets/staff_popup.dart';
import 'package:rmnevents/presentation/qr_scan_view/bloc/qr_scan_handler.dart';
import 'package:rmnevents/root_app.dart';
import 'package:rmnevents/services/shared_preferences_services/history_cached_data.dart';

import '../../../data/models/response_models/history_response_model.dart';
import '../../../data/models/response_models/sales_transaction_response_model.dart';
import '../../../data/repository/history_repository.dart';
import '../../../di/di.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';

part 'qr_scan_event.dart';

part 'qr_scan_state.dart';

part 'qr_scan_bloc.freezed.dart';

class QrScanBloc extends Bloc<QrScanEvent, QrScanState> {
  StreamSubscription? _scanSubscription;

  QrScanBloc() : super(QrScanState.initial()) {
    on<TriggerCreationOfQRView>(_onTriggerCreationOfQRView);
    on<TriggerQRScanUpload>(_onTriggerQRScanUpload);
    on<TriggerStoreQRScannedData>(_onTriggerStoreQRScannedData);
    on<TriggerFetchHistory>(_onTriggerFetchHistory);
    on<TriggerReloadHistory>(_onTriggerReloadHistory);
    on<TriggerQRScanResume>(_onTriggerQRSanResume);
    on<TriggerScanQrCode>(_onTriggerScanQrCode);
    on<TriggerQRCameraReassemble>(_onTriggerQRCameraReassemble);
    on<TriggerFetchSales>(_onTriggerFetchSales);
    on<TriggerStartDownload>(_onTriggerStartDownload);
    on<TriggerSwitchTabs>(_onTriggerSwitchTabs);
    on<TriggerStopDownload>(_onTriggerStopDownload);

    on<TriggerScrollSales>(_onTriggerScrollSales);
    on<TriggerHistoryTabEvents>(_onTriggerHistoryTabEvents);
  }

  FutureOr<void> _onTriggerCreationOfQRView(TriggerCreationOfQRView event,
      Emitter<QrScanState> emit) {
    QRViewController controller = event.controller;
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isLoading: false,
        isFailure: false,
        isRefreshedRequired: true,
        qrViewController: controller,
        isCameraResumed: true));
    add(TriggerScanQrCode());
  }


  FutureOr<void> _onTriggerScanQrCode(TriggerScanQrCode event,
      Emitter<QrScanState> emit) async {
    String qrItemId = AppStrings.global_empty_string;
    // await state.qrViewController!.resumeCamera();
    Barcode? barcode;

    // Cancel the previous subscription if it exists
    await _scanSubscription?.cancel();

    _scanSubscription =
        state.qrViewController!.scannedDataStream.listen((scanData) async {
          barcode = scanData;
          qrItemId = QRScanHandler.extractQRID(code: barcode!.code!);

          if (qrItemId.isNotEmpty) {
            await _scanSubscription?.cancel();
            if (Platform.isAndroid) {
              await state.qrViewController!.stopCamera();
            } else if (Platform.isIOS) {
              await state.qrViewController!.pauseCamera();
            }
            //add(TriggerQRScanUpload(id: qrItemId));
            add(TriggerStoreQRScannedData(id: qrItemId, isSuccessful: true));
            qrItemId = AppStrings.global_empty_string;
          }
        });
  }

  FutureOr<void> _onTriggerQRScanUpload(TriggerQRScanUpload event,
      Emitter<QrScanState> emit) async {
    QRScanHandler.emitRefreshState(state: state, emit: emit);
    emit(state.copyWith(
        isScannedButtonActive: false,
        isCameraResumed: true,
        scanLoading: true));
    bool isSuccessful = false;
    try {
      final response =
      await QRRepository.postOrGetQRID(id: event.id, isPost: true);
      response.fold((failure) {
        isSuccessful = false;
        emit(state.copyWith(
          isRefreshedRequired: false,
          isFailure: true,
          isCameraResumed: false,
          message: failure.message,
        ));
      }, (success) {
        isSuccessful = true;
        emit(state.copyWith(
            isCameraResumed: false,
            isScannedButtonActive: true,
            message:
            success.responseData?.message ?? 'Code Scanned Successfully',
            isFailure: false));
        QrData qrData = success.responseData!.data!;
        String assetUrl = success.responseData!.assetsUrl!;
        qrData.isSuccessful = true;
        if (qrData.product != null) {
          qrData.product!.image = StringManipulation.combineStings(
              prefix: assetUrl, suffix: qrData.product!.image!);
        }
        if (qrData.athlete != null) {
          qrData.athlete!.profileImage = StringManipulation.combineStings(
              prefix: assetUrl, suffix: qrData.athlete!.profileImage!);
        }
        final storedHistory = instance<HistoryCachedData>().getHistory() ?? [];
        final newElement = jsonEncode(qrData).toString();
        final updatedList = [...storedHistory, newElement];
        instance<HistoryCachedData>().setHistory(updatedList);
      });
      emit(state.copyWith(
          isCameraResumed: false,
          isFailure: false,
          scanLoading: false,
          isRefreshedRequired: false));
      add(TriggerQRScanResume());
      Navigator.pop(navigatorKey.currentContext!);
    } catch (e) {
      emit(state.copyWith(
          message: e.toString(),
          isFailure: true,
          isLoading: false,
          isCameraResumed: false,
          isRefreshedRequired: false));
      add(TriggerQRScanResume());
    }
  }

  FutureOr<void> _onTriggerStoreQRScannedData(TriggerStoreQRScannedData event,
      Emitter<QrScanState> emit) async {
    QRScanHandler.emitRefreshState(state: state, emit: emit);
    emit(state.copyWith(isLoading: true));
    //add(TriggerQRScanResume());
    try {
      DataBaseUser user = await GlobalHandlers.extractUserHandler();
      final response =
      await QRRepository.postOrGetQRID(id: event.id, isPost: false);
      response.fold(
              (failure) =>
              emit(state.copyWith(
                isRefreshedRequired: false,
                isFailure: true,
                isCameraResumed: false,
                message: failure.message,
                isLoading: false
              )), (success) {
        String message = success.responseData?.data?.scanDetails != null
            ? success.responseData?.message ?? AppStrings.global_empty_string
            : AppStrings.global_empty_string;
        bool isFailure =
        success.responseData?.data?.scanDetails != null ? true : false;
        emit(state.copyWith(
            isCameraResumed: false, message: message, isFailure: isFailure, isLoading: false));

        String imageUrl = AppStrings.global_empty_string;
        if (success.responseData!.qrType.toString().toLowerCase() ==
            'product') {
          imageUrl = StringManipulation.combineStings(
              prefix: success.responseData!.assetsUrl!,
              suffix: success.responseData!.data!.product!.image!);
        } else {
          imageUrl = success.responseData!.data!.athlete!.profileImage != null
              ? StringManipulation.combineStings(
              prefix: success.responseData!.assetsUrl!,
              suffix: success.responseData!.data!.athlete!.profileImage!)
              : StringManipulation.combineStings(
              prefix: success.responseData!.assetsUrl!,
              suffix: success.responseData!.data!.athlete!.profile!);
        }
        add(TriggerQRScanResume());
        showDialog(
            context: navigatorKey.currentContext!,
            builder: (context) {
              return StaffPopup(
                  isFailure: isFailure,
                  scanType: success.responseData!.qrType.toString()
                      .toLowerCase() == 'product'
                      ? ScanType.purchase
                      : ScanType.registration,
                  title: success.responseData!.data!.event!.title!,
                  imageUrl: imageUrl,
                  productTitle: success.responseData!.qrType.toString()
                      .toLowerCase() == 'product'
                      ? success.responseData!.data!.product!.qrProductTitle!
                      : StringManipulation.combineFirstNameWithLastName(
                      firstName:
                      success.responseData!.data!.athlete!.firstName!,
                      lastName:
                      success.responseData!.data!.athlete!.lastName!),
                  metric1: success.responseData!.qrType.toString()
                      .toLowerCase() == 'product'
                      ? (success.responseData?.data?.purchasedVariant ??
                      AppStrings.global_empty_string)
                      : success.responseData!.data!.division!,
                  metric2: success.responseData!.qrType.toString()
                      .toLowerCase() == 'product'
                      ? (AppStrings.global_empty_string)
                      : StringManipulation.capitalizeFirstLetterOfEachWord(
                      value: success.responseData!.data!.style!),
                  metric3: success.responseData!.qrType.toString()
                      .toLowerCase() ==
                      'product'
                      ? (AppStrings.global_empty_string)
                      : 'WC ${success.responseData!.data!.weightClass!}',
                  buyerName: success.responseData?.data?.user != null
                      ? StringManipulation.combineFirstNameWithLastName(
                    firstName: success.responseData!.data!.user!.firstName!.contains('=')?
                    GlobalHandlers.dataDecryptionHandler(
                        value:
                        success.responseData!.data!.user!.firstName!):success.responseData!.data!.user!.firstName!
                    ,
                    lastName: success.responseData!.data!.user!.lastName!.contains('=')?
                    GlobalHandlers.dataDecryptionHandler(
                        value:
                        success.responseData!.data!.user!.lastName!):success.responseData!.data!.user!.lastName!,
                  )
                      : AppStrings.global_empty_string,
                  buyerDate: GlobalHandlers.mmDDYYDateFormatHandler(
                      dateTime: DateTime.parse(
                          success.responseData!.data!.createdAt!)),
                  scannerName: success.responseData?.data?.scanDetails
                      ?.scannedByUser ??
                      StringManipulation.combineFirstNameWithLastName(
                          firstName: user.firstName!, lastName: user.lastName!),
                  scannerDate: success.responseData?.data?.scanDetails
                      ?.scannedAt != null
                      ? GlobalHandlers.mmDDYYDateFormatHandler(
                      dateTime: DateTime.parse(
                          success.responseData!.data!.scanDetails!.scannedAt!))
                      : GlobalHandlers.mmDDYYDateFormatHandler(
                      dateTime: DateTime.now()),
                  decline: () {
                   // add(TriggerQRScanResume());
                    Navigator.pop(context);

                  },
                  confirm: () {
                    add(TriggerQRScanUpload(id: event.id));
                  },
                  scanAgain: () {
                   // add(TriggerQRScanResume());
                    Navigator.pop(context);
                  });
            });

        if (isFailure) {
          QrData qrData = success.responseData!.data!;
          String assetUrl = success.responseData!.assetsUrl!;
          qrData.isSuccessful = false;
          if (qrData.product != null) {
            qrData.product!.image = StringManipulation.combineStings(
                prefix: assetUrl, suffix: qrData.product!.image!);
          }
          if (qrData.athlete != null) {
            qrData.athlete!.profileImage = StringManipulation.combineStings(
                prefix: assetUrl, suffix: qrData.athlete!.profileImage!);
          }
          final storedHistory =
              instance<HistoryCachedData>().getHistory() ?? [];
          final newElement = jsonEncode(qrData).toString();
          final updatedList = [...storedHistory, newElement];
          instance<HistoryCachedData>().setHistory(updatedList);
        }
      });
    } catch (e) {
      emit(state.copyWith(
          message: e.toString(),
          isFailure: true,
          isLoading: false,
          isCameraResumed: false,
          isRefreshedRequired: false));
    }
  }

  Future<void> _onTriggerFetchHistory(TriggerFetchHistory event,
      Emitter<QrScanState> emit) async {
    List<QrData> qrData = [];
    emit(state.copyWith(isLoading: true));
    try {
      List<String> response = instance<HistoryCachedData>().getHistory() ?? [];
      if (response.isNotEmpty) {
        for (var i = 0; i < response.length; i++) {
          qrData.add(QrData.fromJson(jsonDecode(response[i])));
        }
      }
      for (QrData qr in qrData) {
        qr.user!.firstName = qr.user!.firstName!.contains('=')?
            GlobalHandlers.dataDecryptionHandler(value: qr.user!.firstName!):
        qr.user!.firstName!
        ;
        qr.user!.lastName =
        qr.user!.lastName!.contains('=')?
            GlobalHandlers.dataDecryptionHandler(value: qr.user!.lastName!):
        qr.user!.lastName!;
      }

      // List<QrData> qrDataC = [
      //   QrData(
      //     teamId: '1',
      //     id: '2',
      //     divisionType: 'Girls',createdAt: '2021-09-01T00:00:00.000Z',
      //     price: 200,style: 'Freestyle',
      //     isSuccessful: true,ageGroup: '8 and Under',division: 'Hello',weightClass: '100',
      //     athlete: Athlete(
      //       id: '1',
      //       firstName: 'Athlete 1',
      //       lastName: 'Athlete 1',
      //       profileImage: 'https://www.google.com',
      //     ),
      //
      //     user: DataBaseUser(
      //       id: '1',
      //       firstName: 'User 1',
      //       lastName: 'User 1',
      //     ),
      //     scanDetails: ScanDetails(
      //       scannedByUser: 'User 1',
      //       scannedAt: '2021-09-01T00:00:00.000Z',
      //       scannedBy: 'User 1',
      //
      //     ),
      //     age: 9,team: Team(id: '1', name: 'Team 1', ),
      //   )
      // ];
      emit(state.copyWith(qrData: qrData, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
          message: e.toString(),
          isFailure: true,
          isLoading: false,
          isRefreshedRequired: false));
    }
  }

  Future<void> _onTriggerQRSanResume(TriggerQRScanResume event,
      Emitter<QrScanState> emit) async {
    QRScanHandler.emitRefreshState(state: state, emit: emit);
    await state.qrViewController!.pauseCamera();
    state.qrViewController!.resumeCamera();
    emit(state.copyWith(
        isCameraResumed: true, isRefreshedRequired: false, qrKey: GlobalKey()));
  }

  Future<void> _onTriggerQRCameraReassemble(TriggerQRCameraReassemble event,
      Emitter<QrScanState> emit) async {
    QRScanHandler.emitRefreshState(state: state, emit: emit);
    if (Platform.isAndroid) {
      state.qrViewController!.pauseCamera();
    } else if (Platform.isIOS) {
      await state.qrViewController!.pauseCamera();
      state.qrViewController!.resumeCamera();
    }
    emit(state.copyWith(isCameraResumed: true, isRefreshedRequired: false));
  }

  @override
  Future<void> close() {
    _scanSubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onTriggerReloadHistory(TriggerReloadHistory event,
      Emitter<QrScanState> emit) {
    emit(QrScanState.initial());
    Navigator.pop(navigatorKey.currentContext!);
  }



  FutureOr<void> _onTriggerStartDownload(TriggerStartDownload event,
      Emitter<QrScanState> emit) {
    List<HistoryData> historyData = state.selectedIndex == 0
        ? List.from(state.historyData)
        : List.from(state.salesData);
    historyData[event.index].isDownloaded = false;
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        index: event.index,
        historyData: historyData,
        isFailure: false,
        isRefreshedRequired: true));
  }

  FutureOr<void> _onTriggerStopDownload(TriggerStopDownload event,
      Emitter<QrScanState> emit) {
    List<HistoryData> historyData =  List.from(state.historyData);
      List<SalesData> sales = List.from(state.salesData);
      if(state.selectedIndex == 0){
        historyData[event.index].isDownloaded = true;}else{
        sales[event.index].isDownloaded = true;
      }

    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isLoading: false,
        index: event.index,
        salesData: sales,
        historyData: historyData,
        isFailure: false,
        isRefreshedRequired: false));
    buildCustomToast(msg: event.message, isFailure: event.isFailure);
  }

  FutureOr<void> _onTriggerFetchSales(TriggerFetchSales event,
      Emitter<QrScanState> emit) async {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isLoading: event.isFirstTime ? true : false,
        isFailure: false,
        isRefreshedRequired: true));
    if (event.isFirstTime) {
      try {
        final response = await SalesRepository.getSales(
            page: event.isFirstTime ? 1 :
            state.salesPage);
        response.fold((failure) {
          emit(state.copyWith(
              message: failure.message,
              isLoading: false,
              isFailure: true,
              isRefreshedRequired: false));
        }, (success) {
          List<SalesData> history = success.responseData!.data!;

          for (var i = 0; i < history.length; i++) {
            history[i].isDownloaded = true;
          }
          num totalPage = success.responseData!.totalPage!;
          num page = success.responseData!.page!;
          emit(state.copyWith(
              salesData: [...state.salesData, ...history],
              isLoading: false,
              isFailure: false,
              totalSalesPage: totalPage.toInt(),
              salesPage: page.toInt(),
              isRefreshedRequired: false));
        });
      } catch (e) {
        debugPrint('Error: $e');
        emit(state.copyWith(
            message: e.toString(),
            isLoading: false,
            isFailure: true,
            isRefreshedRequired: false));
      }
    } else {
      emit(state.copyWith(
          message: AppStrings.global_empty_string,
          isLoading: false,
          isFailure: false,
          isRefreshedRequired: false));
    }
  }

  FutureOr<void> _onTriggerSwitchTabs(TriggerSwitchTabs event,
      Emitter<QrScanState> emit) {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        selectedIndex: event.index,
        isFailure: false,
        isRefreshedRequired: true));
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        selectedIndex: event.index,
        isFailure: false,
        isRefreshedRequired: false));
  }



  FutureOr<void> _onTriggerScrollSales(TriggerScrollSales event,
      Emitter<QrScanState> emit) async {
    emit(state.copyWith(
        message: AppStrings.global_empty_string,
        isLoading: false,
        isFailure: false,
        isLoadingMore: true,
        isFetchingSales: true,
        isRefreshedRequired: true));

    debugPrint('------Another Page-----');
    try {
      final response = await SalesRepository.getSales(page:
      state.salesPage + 1);
      response.fold((failure) {
        emit(state.copyWith(
            message: failure.message,
            isLoading: false,
            isFailure: true,
            isFetchingSales: false,
            isRefreshedRequired: false));
      }, (success) {
        List<SalesData> history = success.responseData!.data!;

        for (var i = 0; i < history.length; i++) {
          history[i].isDownloaded = true;
        }
        num totalPage = success.responseData!.totalPage!;
        num page = success.responseData!.page!;
        emit(state.copyWith(
            salesData: [...state.salesData, ...history],
            isLoading: false,
            isFailure: false,
            isFetchingSales: false,
            totalSalesPage: totalPage.toInt(),
            salesPage: page.toInt(),
            isRefreshedRequired: false));
      });
    } catch (e) {
      debugPrint('Error: $e');
      emit(state.copyWith(
          message: e.toString(),
          isLoading: false,
          isFailure: true,
          isFetchingSales: false,
          isRefreshedRequired: false));
    }
  }

  FutureOr<void> _onTriggerHistoryTabEvents(TriggerHistoryTabEvents event,
      Emitter<QrScanState> emit)
  async {
    List<HistoryData> history = [];
    switch (event.historyTabEvents) {
      case HistoryTabEvents.all:
        await _fetchHistoryData(
          emit: emit,
          page: 1,
          type: HistoryTabEvents.all.name,
          isScroll: false,
        );
        break;
      case HistoryTabEvents.products:
        await _fetchHistoryData(
          emit: emit,
          page: 1,
          type: HistoryTabEvents.products.name,
          isScroll: false,
        );
        break;
      case HistoryTabEvents.registrations:
        await _fetchHistoryData(
          emit: emit,
          page: 1,
          type: HistoryTabEvents.registrations.name,
          isScroll: false,
        );
        break;
      case HistoryTabEvents.productScroll:
        await _fetchHistoryData(
          emit: emit,
          page: state.historyPage + 1,
          type: HistoryTabEvents.products.name,
          isScroll: true,
        );
        break;
      case HistoryTabEvents.registrationScroll:
        await _fetchHistoryData(
          emit: emit,
          page: state.historyPage + 1,
          type: HistoryTabEvents.registrations.name,
          isScroll: true,
        );
        break;
      case HistoryTabEvents.allScroll:
        await _fetchHistoryData(
          emit: emit,
          page: state.allPage + 1,
          type: HistoryTabEvents.all.name,
          isScroll: true,
        );
        break;
      case HistoryTabEvents.none:
        break;
    }
  }

  Future<void> _fetchHistoryData({
    required Emitter<QrScanState> emit,
    required int page,
    required String type,
    required bool isScroll,
  })
  async {

    emit(state.copyWith(
      message: AppStrings.global_empty_string,
      isLoading: !isScroll,
      isLoadingMore: isScroll,
      isFailure: false,
      isFetchingHistory: true,
      isRefreshedRequired: true,
      isCameraResumed: true,
    ));
    emit(state.copyWith(
      filterIndex: type == HistoryTabEvents.all.name ? -1 : (
          (type == HistoryTabEvents.products.name) ? 0 : 1
      ),
    ));

    try {
      final response = await HistoryRepository.getHistory(page: page, type: type);

      response.fold((failure) {
        emit(state.copyWith(
          message: failure.message,
          isLoading: false,
          isLoadingMore: false,
          isFailure: true,
          isFetchingHistory: false,
          isRefreshedRequired: false,
        ));
      }, (success) {
        List<HistoryData> history = formatHistoryList(success);
        emit(state.copyWith(
          historyData:  !isScroll ? history :
          [...state.historyData, ...history],
          isLoading: false,
          isLoadingMore: false,
          isFetchingHistory: false,
          isFailure: false,
          isRefreshedRequired: false,
        ));
        debugPrint('------${success.responseData!.page!}-----');
        debugPrint('------${success.responseData!.totalPage!}-----');
        if(type == HistoryTabEvents.all.name){
          emit(state.copyWith(
            allPage: success.responseData!.page!.toInt(),
            totalAllPage: success.responseData!.totalPage!.toInt(),
          ));
        }else{
          emit(state.copyWith(
            totalHistoryPage: success.responseData!.totalPage!.toInt(),
            historyPage: success.responseData!.page!.toInt(),
          ));
        }

        if (page == 1 && type == 'all') {
          add(const TriggerFetchSales(isFirstTime: true));
        }

      });
    } catch (e) {
      debugPrint('Error: $e');
      emit(state.copyWith(
        message: e.toString(),
        isLoading: false,
        isFetchingHistory: false,
        isLoadingMore: false,
        isFailure: true,
        isRefreshedRequired: false,
      ));
    }

  }

  List<HistoryData> formatHistoryList(HistoryResponseModel success) {
    List<HistoryData> history = success.responseData!.data!;
    for (var i = 0; i < history.length; i++) {
      if (history[i].athlete != null) {
        history[i].athlete!.profileImage =
            StringManipulation.combineStings(
                prefix: success.responseData!.assetsUrl!,
                suffix: history[i].athlete!.profileImage!);
      }
      if (history[i].product != null) {
        history[i].product!.image = StringManipulation.combineStings(
            prefix: success.responseData!.assetsUrl!,
            suffix: history[i].product!.image!);
      }
      history[i].isDownloaded = true;
      history[i].user!.firstName = history[i].user!.firstName!.contains('=')?
          GlobalHandlers.dataDecryptionHandler(
          value: history[i].user!.firstName!):history[i].user!.firstName!;

      history[i].user!.lastName =  history[i].user!.lastName!.contains('=')?
          GlobalHandlers.dataDecryptionHandler(
          value: history[i].user!.lastName!):history[i].user!.lastName!;

    }
    return history;
  }
}
