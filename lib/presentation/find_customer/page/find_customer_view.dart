import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rmnevents/presentation/selected_customer/bloc/selected_customer_bloc.dart';
import '../../../imports/common.dart';
import '../../../imports/data.dart';
import '../../../root_app.dart';
import '../bloc/find_customer_bloc.dart';

class FindCustomerView extends StatefulWidget {
  const FindCustomerView({super.key});

  @override
  _FindCustomerViewState createState() => _FindCustomerViewState();
}

class _FindCustomerViewState extends State<FindCustomerView> {
  Timer? _debounce;
  @override
  void initState() {
    BlocProvider.of<FindCustomerBloc>(context).add(TriggerRefreshScreen());
    BlocProvider.of<FindCustomerBloc>(context).add(TriggerFetchUsersList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FindCustomerBloc, FindCustomerState>(
      builder: (context, state) {
        return customScaffold(
            hasForm: true,
            formOrColumnInsideSingleChildScrollView: FocusScope(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.findCustomer_title,
                      style: AppTextStyles.regularPrimary()),
                  SizedBox(height: 20.h),
                  Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    color: AppColors.colorSecondary,
                  ),
                    child: Column(
                      children: [
                        Container(
                          height: 50.h,
                          padding: EdgeInsets.only(left: 7.w, right: 7.w),
                          child: TextFormField(
                            onChanged: (v) {
                              _debounce?.cancel(); // Cancel the previous timer if it exists
                              _debounce = Timer(const Duration(milliseconds: 500), () {
                                BlocProvider.of<FindCustomerBloc>(context).add(TriggerSearchForCustomer());
                              });
                            },
                            controller: state.searchController,
                            style: AppTextStyles.textFormFieldELabelStyle(),
                            decoration: InputDecoration(
                              hintText: AppStrings.findCustomer_search_hint,
                              suffixIconConstraints: BoxConstraints(
                                minHeight: 24.h,
                                minWidth: 24.w,
                              ),
                              suffixIcon: GestureDetector(

                                onTap: () {
                                  //onClick();
                                },
                                child: Icon(
                                  state.isOpened
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: AppColors.colorPrimaryInverse,
                                ),
                              ),
                              hintStyle: AppTextStyles.textFormFieldEHintStyle(),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.colorPrimaryDivider,
                                ),
                              ),
                            ),
                          ),
                        ),
                        state.isLoading
                            ? CustomLoader(
                            isForSingleWidget: true,
                            child: buildUserPaginatedDropdown(
                              isLoading: state.isLoading,
                              onClick: () {},
                              onSearch: () {},
                              selectItem: (i) {},
                              page: state.page,
                              isFetching: state.isFetching,
                              isBottomLoading: state.isBottomLoading,
                              totalPage: state.totalPage,
                              isOpened: state.isOpened,
                              users: state.customerList,
                              searchController: state.searchController,
                              controller: state.scrollController,
                            ))
                            : buildUserPaginatedDropdown(
                          isLoading: state.isLoading,
                          onClick: () {
                            BlocProvider.of<FindCustomerBloc>(context)
                                .add(TriggerOpenDropDown());
                          },
                          onSearch: () {
                            _debounce?.cancel(); // Cancel the previous timer if it exists
                            _debounce = Timer(const Duration(milliseconds: 500), () {
                              BlocProvider.of<FindCustomerBloc>(context).add(TriggerSearchForCustomer());
                            });
                          },
                          selectItem: (i) {
                            BlocProvider.of<FindCustomerBloc>(context)
                                .add(TriggerSelectCustomer(index: i));
                          },
                          users: state.customerList,
                          page: state.page,
                          isFetching: state.isFetching,
                          isBottomLoading: state.isBottomLoading,
                          totalPage: state.totalPage,
                          isOpened: state.isOpened,
                          searchController: state.searchController,
                          controller: state.scrollController,
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ),
            customAppBar: CustomAppBar(
                title: AppStrings.findCustomer_title, isLeadingPresent: true),
            anyWidgetWithoutSingleChildScrollView: null);
      },
    );
  }

  Widget buildUserPaginatedDropdown(
      {required TextEditingController searchController,
      required ScrollController controller,
      required List<DataBaseUser> users,
      required bool isOpened,
      required Function() onSearch,
      required Function(int i) selectItem,
      required Function() onClick,
      required int totalPage,
      required int page,
      required bool isFetching,
      required bool isLoading,
      required bool isBottomLoading}) {
    double height = Dimensions.getScreenHeight() * 0.8;
    // height = height > Dimensions.getScreenHeight() * 0.4
    //     ? Dimensions.getScreenHeight() * 0.4
    //     : height;
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: SizedBox(
        height: (isOpened && users.isNotEmpty) ? height : null,
        child: Column(
          children: [
            // Container(
            //   width: Dimensions.getScreenWidth(),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(10.r),
            //       topRight: Radius.circular(10.r),
            //     ),
            //     color: AppColors.colorSecondary,
            //   ),
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 8.w,
            //   ),
            //   child: Row(
            //     children: [
            //       if (!isOpened)
            //         // Expanded(
            //         //   child: Container(
            //         //     padding: EdgeInsets.only(left: 7.w, right: 7.w),
            //         //     child: Row(
            //         //       children: [
            //         //         Container(
            //         //           padding: EdgeInsets.symmetric(
            //         //                vertical: 15.h),
            //         //           decoration: BoxDecoration(
            //         //             borderRadius: BorderRadius.circular(10.r),
            //         //           ),
            //         //           child: Text(
            //         //             AppStrings.findCustomer_search_hint,
            //         //             style: AppTextStyles.textFormFieldEHintStyle(),
            //         //           ),
            //         //         ),
            //         //         const Spacer(),
            //         //         GestureDetector(
            //         //           onTap: () {
            //         //             onClick();
            //         //           },
            //         //           child: Icon(
            //         //             isOpened
            //         //                 ? Icons.keyboard_arrow_up
            //         //                 : Icons.keyboard_arrow_down,
            //         //             color: AppColors.colorPrimaryInverse,
            //         //           ),
            //         //         )
            //         //       ],
            //         //     ),
            //         //   ),
            //         // ),
            //       // if (isOpened)
            //       //   Expanded(
            //       //     child: Container(
            //       //       padding: EdgeInsets.only(left: 7.w, right: 7.w),
            //       //       child: TextFormField(
            //       //         onChanged: (v) {
            //       //           onSearch();
            //       //         },
            //       //         controller: searchController,
            //       //         style: AppTextStyles.textFormFieldELabelStyle(),
            //       //         decoration: InputDecoration(
            //       //           hintText: AppStrings.findCustomer_search_hint,
            //       //           suffixIconConstraints: BoxConstraints(
            //       //             minHeight: 24.h,
            //       //             minWidth: 24.w,
            //       //           ),
            //       //           suffixIcon: GestureDetector(
            //       //
            //       //             onTap: () {
            //       //               onClick();
            //       //             },
            //       //             child: Icon(
            //       //               isOpened
            //       //                   ? Icons.keyboard_arrow_up
            //       //                   : Icons.keyboard_arrow_down,
            //       //               color: AppColors.colorPrimaryInverse,
            //       //             ),
            //       //           ),
            //       //           hintStyle: AppTextStyles.textFormFieldEHintStyle(),
            //       //           focusedBorder: UnderlineInputBorder(
            //       //             borderSide: BorderSide(
            //       //               color: AppColors.colorPrimaryDivider,
            //       //             ),
            //       //           ),
            //       //         ),
            //       //       ),
            //       //     ),
            //       //   ),
         // ]
            //  ),
          //  ),
            if (isOpened && users.isNotEmpty)
              Expanded(
                child: RawScrollbar(
                    padding: EdgeInsets.only(left: 5.w, right: 15.w),
                    thickness: 3,
                    thumbColor: AppColors.colorPrimaryAccent,
                    trackRadius: Radius.circular(4.r),
                    trackVisibility: true,
                    trackColor: AppColors.colorDisabled.withOpacity(
                      0.1,
                    ),
                    thumbVisibility: true,
                    controller: controller,
                    interactive: true,
                    radius: Radius.circular(4.r),
                    child: ListView.separated(
                        shrinkWrap: true,
                        controller: controller,
                        itemBuilder: (context, i) {
                          if (i == users.length - 1 && totalPage > page) {
                            if (!isFetching) {
                              if (totalPage > page) {
                                BlocProvider.of<FindCustomerBloc>(context)
                                    .add(TriggerMoreUserFetch());
                              }
                            }
                            return isBottomLoading
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      color: AppColors.colorPrimaryAccent,
                                    )),
                                  )
                                : const SizedBox.shrink();
                          }
                          return GestureDetector(
                            onTap: () {
                              selectItem(i);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: 6.h,
                                  bottom: 6.h,
                                  left: 20.w,
                                  right: 20.w),
                              decoration: BoxDecoration(
                                color: AppColors.colorSecondary,
                              ),
                              height: isTablet ? 60.h : 50.h,
                              // padding: EdgeInsets.symmetric(
                              //  vertical: 6.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: isTablet ? 55.h : 45.h,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(3.r),
                                    ),
                                    child: users[i].profile!.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(3.r),
                                            child: CachedNetworkImage(
                                              imageUrl: users[i].profile!.contains('https') ? users[i].profile! : UrlPrefixes.baseUrl + users[i].profile!,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, url, error) => SvgPicture.asset(
                                                AppAssets.icProfileAvatar,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(3.r),
                                            child: SvgPicture.asset(
                                              AppAssets.icProfileAvatar,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ),
                                  // CircleAvatar(
                                  //     backgroundImage: NetworkImage(users[i].avatarUrl)),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Container(
                                      // color: AppColors.colorPrimaryAccent,
                                      height: isTablet ? 55.h : 45.h,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Expanded(
                                            child: Text(
                                                StringManipulation
                                                    .combineFirstNameWithLastName(
                                                        firstName:
                                                            users[i].firstName!,
                                                        lastName:
                                                            users[i].lastName!),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTextStyles
                                                    .regularPrimary(
                                                        isOutFit: false,
                                                        isBold: true)),
                                          ),
                                          // const Spacer(),
                                          Expanded(
                                            child: Text(
                                              users[i].email ??
                                                  AppStrings
                                                      .global_empty_string,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyles
                                                  .regularNeutralOrAccented(
                                                      isOutfit: true),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // const Spacer(),
                                  if (users[i].accountType ==
                                      AccountType.facebook.name)
                                    Image.asset(
                                      AppAssets.imgFacebook,
                                      height: 30.h,
                                      width: 30.w,
                                    ),
                                  if (users[i].accountType ==
                                      AccountType.google.name)
                                    Image.asset(
                                      AppAssets.imgGoogle,
                                      height: 30.h,
                                      width: 30.w,
                                    ),
                                  if (users[i].accountType ==
                                      AccountType.apple.name)
                                    Image.asset(
                                      AppAssets.imgApple,
                                      height: 30.h,
                                      width: 30.w,
                                    ),
                                  SizedBox(width: 5.w),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, i) {
                          return Container(
                            margin: EdgeInsets.only(left: 20.w, right: 30.w),
                            height: 1,
                            color: AppColors.colorDisabled.withOpacity(
                              0.1,
                            ),
                          );
                        },
                        itemCount: users.length)),
              ),
            if (isOpened && users.isEmpty)
              Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.r), bottomLeft: Radius.circular(10.r)),
                  color: AppColors.colorSecondary,
                ),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        AppStrings.findCustomer_search_noResults,
                        style: AppTextStyles.smallTitleForEmptyList(),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
