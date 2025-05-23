import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rmnevents/data/repository/download_pdf_repository.dart';
import 'package:rmnevents/presentation/my_purchases/bloc/my_purchases_handlers.dart';

import '../../../imports/common.dart';
import '../../../imports/data.dart';

part 'my_purchases_event.dart';

part 'my_purchases_state.dart';

part 'my_purchases_bloc.freezed.dart';

class MyPurchasesBloc
    extends Bloc<MyPurchasesEvent, MyPurchasesWithInitialState> {
  MyPurchasesBloc() : super(MyPurchasesWithInitialState.initial()) {
    on<TriggerSeasonsEvent>(_onTriggerSeasonsEvent);
    on<TriggerProductsEvent>(_onTriggerProductsEvent);
    on<TriggerInitialize>(_onTriggerInitialize);
    on<TriggerSelectInvoice>(_onTriggerSelectInvoice);
    on<TriggerSelectSeason>(_onTriggerSelectSeason);
    on<TriggerDownloadSingleInvoice>(_onTriggerDownloadSingleInvoice);
    on<TriggerDropDownExpand>(_onTriggerDropDownExpand);
    on<TriggerOpenBottomSheetForDownload>(_onTriggerOpenBottomSheetForDownload);
  }

  FutureOr<void> _onTriggerSeasonsEvent(TriggerSeasonsEvent event,
      Emitter<MyPurchasesWithInitialState> emit) async {
       if(state.isSeasonsCalledFirstTime){
         emit(MyPurchasesWithInitialState.initial());
         emit(state.copyWith(
           selectTabIndex: event.myPurchases == MyPurchases.seasonPasses ? 0 : 1,
         ));
         if (event.myPurchases == MyPurchases.products) {
           add(TriggerProductsEvent());
         } else {
           try {
             final response = await SeasonRepository.getMyPurchasesSeasonPasses();
             response.fold(
                   (failure) {
                 emit(state.copyWith(
                   seasons: [],
                   isFailure: true,
                   message: failure.message,
                   isLoading: false,
                 ));
               },
                   (success) {
                 List<SeasonData> data =
                 MyPurchasesHandlers.updateSeasonDataParameters(
                     assetsUrl: success.responseData!.assetsUrl!,
                     data: success.responseData?.data ?? []);
                 emit(state.copyWith(
                   seasons: data,
                   isFailure: false,
                   isSeasonsCalledFirstTime: false,
                   message: AppStrings.global_empty_string,
                   isLoading: false,
                 ));
               },
             );
           } catch (e) {
             emit(state.copyWith(
               seasons: [],
               isFailure: true,
               message: e.toString(),
               isLoading: false,
             ));
           }}
       }
       else{
         emit(state.copyWith(
        selectTabIndex: 0,
        isRefreshRequired: true,
           message: AppStrings.global_empty_string,
         ));
         emit(state.copyWith(
           seasons: state.seasons,
           isFailure: false,
           message: AppStrings.global_empty_string,
           isRefreshRequired: false,
         ));
       }
  }

  FutureOr<void> _onTriggerSelectInvoice(
      TriggerSelectInvoice event, Emitter<MyPurchasesWithInitialState> emit) {
    MyPurchasesHandlers.emitRefreshState(emit: emit, state: state);
    String selectedInvoiceOrderNo = event.invoiceOrderNumber;
    List<Memberships> memberships = event.memberships;
    String invoiceUrl = AppStrings.global_empty_string;
    for (Memberships membership in memberships) {
      if (selectedInvoiceOrderNo.contains(membership.orderNo!)) {
        invoiceUrl = membership.invoiceUrl ?? AppStrings.global_empty_string;
        break;
      }
    }
    AppStrings.global_empty_string;
    emit(state.copyWith(
        isRefreshRequired: false,
        isFailure: false,
        isLoading: false,
        selectedValue: selectedInvoiceOrderNo,
        invoiceUrl: invoiceUrl,
        message: AppStrings.global_empty_string));
  }

  FutureOr<void> _onTriggerDownloadSingleInvoice(
      TriggerDownloadSingleInvoice event,
      Emitter<MyPurchasesWithInitialState> emit) async {
    MyPurchasesHandlers.emitForInvoiceDownload(emit: emit, state: state);
    emit(state.copyWith(
        isDownloadingInvoice: event.isIndividualInvoiceDownload ? false : true,
        individualInvoiceIndex: event.individualInvoiceIndex));
    if (event.isIndividualInvoiceDownload) {
      state.seasons[state.indexOfSelectedSeason]
          .memberships![event.individualInvoiceIndex].isDownloading = true;
    }
    try {
      final response = await DownloadPdfRepository.downloadAndSavePdf(
          url: event.invoiceUrl, fileName: event.orderNo);
      response.fold(
        (failure) {
          emit(state.copyWith(
              groupInvoiceIndex: -1,
              individualInvoiceIndex: -1,
              isFailure: true,
              isDownloadingInvoice: false,
              message: failure.message));
          if(event.isIndividualInvoiceDownload) {
            state.seasons[state.indexOfSelectedSeason].memberships![event.individualInvoiceIndex].isDownloading = false;
          }
        },
        (success) {
          emit(state.copyWith(
              groupInvoiceIndex: -1,
              individualInvoiceIndex: -1,
              isFailure: false,
              isDownloadingInvoice: false,
              message: AppStrings.myPurchases_invoiceDownloaded_success_text));
          if (event.isIndividualInvoiceDownload) {
            state
                .seasons[state.indexOfSelectedSeason]
                .memberships![event.individualInvoiceIndex]
                .isDownloading = false;
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
          groupInvoiceIndex: -1,
          individualInvoiceIndex: -1,
          isFailure: true,
          isDownloadingInvoice: false,
          message: e.toString()));
      if (event.isIndividualInvoiceDownload) {
        state.seasons[state.indexOfSelectedSeason]
            .memberships![event.individualInvoiceIndex].isDownloading = false;
      }
    }
  }

  FutureOr<void> _onTriggerOpenBottomSheetForDownload(
      TriggerOpenBottomSheetForDownload event,
      Emitter<MyPurchasesWithInitialState> emit) {
    MyPurchasesHandlers.emitRefreshState(emit: emit, state: state);
    List<String> invoiceUrls =
        MyPurchasesHandlers.extractUrls(data: event.memberships);
    emit(state.copyWith(
        isBottomSheetOpen: true,
        invoiceUrls: invoiceUrls,
        message: AppStrings.global_empty_string));
  }

  FutureOr<void> _onTriggerProductsEvent(TriggerProductsEvent event,
      Emitter<MyPurchasesWithInitialState> emit) async {

     if(state.isProductsCalledFirstTime){
       MyPurchasesHandlers.emitInitialState(emit: emit, state: state);
       emit(state.copyWith(
         selectTabIndex: 1,
       ));

       try {
         final response = await ProductsRepository.getMyPurchasesProducts();
         response.fold(
               (failure) {
             emit(state.copyWith(
               products: [],
               isFailure: true,
               message: failure.message,
               isLoading: false,
             ));
           },
               (success) {
             List<PurchasedProduct> data =
             MyPurchasesHandlers.updateProductsDataParameters(
                 assetsUrl: success.responseData!.assetsUrl!,
                 data: success.responseData?.data ?? []);
             emit(state.copyWith(
               products: data,
               isFailure: false,
               isProductsCalledFirstTime: false,
               message: AppStrings.global_empty_string,
               isLoading: false,
             ));
           },
         );
       } catch (e) {
         emit(state.copyWith(
             isLoading: false, isFailure: true, message: e.toString()));
       }
     }else{
       emit(state.copyWith(
         isRefreshRequired: true,
         selectTabIndex: 1,
         message: AppStrings.global_empty_string,));
       emit(state.copyWith(
         products: state.products,
         isFailure: false,
         message: AppStrings.global_empty_string,
         isRefreshRequired: false,
       ));
     }
  }

  FutureOr<void> _onTriggerDropDownExpand(
      TriggerDropDownExpand event, Emitter<MyPurchasesWithInitialState> emit) {
    emit(state.copyWith(isExpanded: event.isExpanded));
  }

  FutureOr<void> _onTriggerSelectSeason(TriggerSelectSeason event, Emitter<MyPurchasesWithInitialState> emit) {
   MyPurchasesHandlers.emitRefreshState(emit: emit, state: state);
   emit(state.copyWith(
     isRefreshRequired: false,
     indexOfSelectedSeason: event.indexOfSelectedSeason,
   ));
  }

  FutureOr<void> _onTriggerInitialize(TriggerInitialize event, Emitter<MyPurchasesWithInitialState> emit) {
   emit(MyPurchasesWithInitialState.initial());
  }
}
