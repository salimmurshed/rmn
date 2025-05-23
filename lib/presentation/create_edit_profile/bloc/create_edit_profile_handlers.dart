import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_places_autocomplete_text_field/model/place_details.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../imports/common.dart';
import 'create_edit_profile_bloc.dart';

class CreateProfileHandlers {
  static void emitInitialState(
      {required Emitter<CreateEditProfileWithInitialState> emit,
      required CreateEditProfileWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: false,
        message: AppStrings.global_empty_string));
  }

  static void emitWithLoader(
      {required Emitter<CreateEditProfileWithInitialState> emit,
      required CreateEditProfileWithInitialState state}) {
    emit(state.copyWith(
        isRefreshRequired: true,
        isFailure: false,
        isLoading: true,
        message: AppStrings.global_empty_string));
  }

  static Future<File?> cameraHandler({required bool isFromCamera}) async {
    File? file;
    XFile? imageXFile = await ImagePicker().pickImage(
        source: isFromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 1000.w,
        maxHeight: 1000.h

    );
    if (imageXFile != null) {
      String imageUrl = imageXFile.path;
      file = File(imageUrl);
    }
    return file;
  }

  static String cityNameHandler(
      {required List<AddressComponents> addressComponents}) {
    String cityName = AppStrings.global_empty_string;
    for (AddressComponents component in addressComponents) {
      if (component.types!.contains('locality')) {
        cityName = component.longName ?? AppStrings.global_empty_string;
        break;
      } else {
        if (component.types!.contains('administrative_area_level_2')) {
          cityName = component.longName ?? AppStrings.global_empty_string;
          break;
        } else {
          cityName = AppStrings.global_empty_string;
        }
      }
    }

    return cityName;
  }

  static String stateNameHandler(
      {required List<AddressComponents> addressComponents}) {
    String state = AppStrings.global_empty_string;
    for (var component in addressComponents) {
      if (component.types!.contains('administrative_area_level_1')) {
        state = component.longName ?? AppStrings.global_empty_string;
        break;
      }
    }

    return state;
  }

  static String zipCodeHandler(
      {required List<AddressComponents> addressComponents}) {
    String zipCode = AppStrings.global_empty_string;
    for (var component in addressComponents) {
      if (component.types!.contains('postal_code')) {
        zipCode = component.longName ?? AppStrings.global_empty_string;
      }
    }
    return zipCode;
  }
}
