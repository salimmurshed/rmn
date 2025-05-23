import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rmnevents/presentation/all_events/bloc/all_events_bloc.dart';

import '../../../imports/common.dart';

class AllEventsMapView extends StatefulWidget {
  const AllEventsMapView({super.key});

  @override
  State<AllEventsMapView> createState() => _AllEventsMapViewState();
}

class _AllEventsMapViewState extends State<AllEventsMapView> {
  @override
  void initState() {
    BlocProvider.of<AllEventsBloc>(context).add(TriggerGetUserLocation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AllEventsBloc, AllEventsWithInitialState>(
      listener: (context, state) {
        if (state.message.isNotEmpty) {
          buildCustomToast(msg: state.message, isFailure: state.isFailure);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.colorPrimary,
        body: Stack(children: [
          BlocBuilder<AllEventsBloc, AllEventsWithInitialState>(
            builder: (context, state) {
              return buildCustomGoogleMapMarkerBuilder(
                  customMarkers: state.customMarkers,
                  googleMapDarkStyle: state.googleDarkMapStyle,
                  userLocation: state.userLocation);
            },
          ),
          BlocBuilder<AllEventsBloc, AllEventsWithInitialState>(
            builder: (context, state) {
              return Positioned(
                  top: Dimensions.getScreenHeight() * 0.1,
                  left: 5.w,
                  right: 5.w,
                  child: Column(
                    children: [
                      customBuildSearchAndFilterButton(
                        isFilterAvailable: true,
                        formKey: GlobalKey<FormState>(),
                        searchFunction: () {
                          BlocProvider.of<AllEventsBloc>(context)
                              .add(TriggerSearchEventsOnMap());
                        },
                        eraserFunction: () {
                          BlocProvider.of<AllEventsBloc>(context)
                              .add(TriggerEraseSearchKeywordEvent());
                        },
                        isFilterOn: state.isFilterOn,
                        onChangeSearchFunction: (value) {
                          BlocProvider.of<AllEventsBloc>(context).add(
                              TriggerOnChangeSearchEvent(searchValue: value));
                        },
                        filterOnFunction: () {
                          BlocProvider.of<AllEventsBloc>(context)
                              .add(const TriggerTapOnFilter(isMap: true));
                        },
                        searchController: state.searchController,
                        focusNode: state.focusNode,
                        showEraser: state.showEraser,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Visibility(
                          visible: state.isFilterOn,
                          child: buildCustomTabBar(
                              isScrollRequired: false,
                              tabElements: [
                                TabElements(
                                    title:
                                    AppStrings.allEvents_upcomingTab_title,
                                    onTap: () {
                                      BlocProvider.of<AllEventsBloc>(context)
                                          .add(
                                          const TriggerFetchFilterEventsOnMap(
                                              filterType: FilterType.upcoming));
                                    },
                                    isSelected: state.filterType ==
                                        FilterType.upcoming),
                                TabElements(
                                    title: AppStrings.allEvents_pastTab_title,
                                    onTap: () {
                                      BlocProvider.of<AllEventsBloc>(context)
                                          .add(
                                          const TriggerFetchFilterEventsOnMap(
                                              filterType: FilterType.past));
                                    },
                                    isSelected:
                                    state.filterType == FilterType.past),
                              ])),
                    ],
                  ));
            },
          ),
          BlocBuilder<AllEventsBloc, AllEventsWithInitialState>(
            builder: (context, state) {
              return Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Dimensions.generalRadius)),
                    child: Container(
                        margin: EdgeInsets.only(
                            bottom: 40.h, left: 120.w, right: 120.w),
                        child: buildBtn(
                            onTap: state.isLoading ? () {} : () {
                              Navigator.pushNamed(
                                  context, AppRouteNames.routeAllEvents)
                                  .then((value) {
                                if (context.mounted) {
                                  BlocProvider.of<AllEventsBloc>(context)
                                      .add(TriggerGetUserLocation());
                                }
                              });
                            },
                            btnLabel: AppStrings.clientHome_viewAll_button_text,
                            isColorFilledButton: true,
                            isActive: !state.isLoading)),
                  ));
            },
          )
        ]),
      ),
    );
  }

  CustomGoogleMapMarkerBuilder buildCustomGoogleMapMarkerBuilder(
      {required List<MarkerData> customMarkers,
        required String googleMapDarkStyle,
        required LatLng? userLocation}) {
    return CustomGoogleMapMarkerBuilder(
      customMarkers: customMarkers,
      builder: (context, markers) {
        return BlocBuilder<AllEventsBloc, AllEventsWithInitialState>(
          buildWhen: (previous, current) =>
          previous.isLoading == current.isLoading,
          builder: (context, state) {
            return GoogleMap(
              onTap: (latLang) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              myLocationEnabled: false,
              scrollGesturesEnabled: true,
              style: googleMapDarkStyle,
              onMapCreated: (GoogleMapController controller) async {
                if (customMarkers.length == 1) {
                  controller.animateCamera(CameraUpdate.newLatLngZoom(
                      customMarkers.first.marker.position, 15));
                }
                if (userLocation != null) {
                  controller.animateCamera(
                      CameraUpdate.newLatLngZoom(userLocation, 15));
                }
              },
              markers: markers ?? {},
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition:  const CameraPosition(
                  target: LatLng(43.032114, -105.961448)),
            );
          },
        );
      },
    );
  }
}
