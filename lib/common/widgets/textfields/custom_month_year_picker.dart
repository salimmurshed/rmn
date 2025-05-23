import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';



class SimpleMonthYearPicker {
  /// list of Months
  static final List<MonthModel> _monthModelList = [
    MonthModel(index: 1, name: 'Jan'),
    MonthModel(index: 2, name: 'Feb'),
    MonthModel(index: 3, name: 'Mar'),
    MonthModel(index: 4, name: 'Apr'),
    MonthModel(index: 5, name: 'May'),
    MonthModel(index: 6, name: 'Jun'),
    MonthModel(index: 7, name: 'Jul'),
    MonthModel(index: 8, name: 'Aug'),
    MonthModel(index: 9, name: 'Sep'),
    MonthModel(index: 10, name: 'Oct'),
    MonthModel(index: 11, name: 'Nov'),
    MonthModel(index: 12, name: 'Dec'),
  ];



  static Future<DateTime> showMonthYearPickerDialog({
    required BuildContext context,
    TextStyle? titleTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? monthTextStyle,
    Color? backgroundColor,
    Color? selectionColor,
    bool? barrierDismissible,
    bool? disableFuture,
  })
  async {
    final ThemeData theme = Theme.of(context);
    var primaryColor = selectionColor ?? theme.primaryColor;
    var bgColor = backgroundColor ?? theme.scaffoldBackgroundColor;
    // var textTheme = theme.textTheme;

    /// to get current year
    int selectedYear = DateTime.now().year;

    /// to get index corresponding to current month (1- Jan, 2- Feb,..)
    var selectedMonth = DateTime.now().month;

    // Get current date
    final currentDate = DateTime.now();
    final currentYear = currentDate.year;
    final currentMonth = currentDate.month;
    await showDialog<DateTime>(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (_) {
        return StatefulBuilder(builder: (context, setState) {
          return CustomDialog(
            child: Stack(
              children: [
                Container(
                  height: 210,
                  width: 370,
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: Border.all(
                      color: primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          'Select Expiration Date ',
                          style: titleTextStyle ??
                              const TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, top: 10),
                        child: SizedBox(
                          height: 100,
                          width: 300,
                          child: GridView.builder(
                            itemCount: _monthModelList.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                            ),
                            itemBuilder: (_, index) {
                              var monthModel = _monthModelList[index];
                              final isDisabled = selectedYear == currentYear && index + 1 < currentMonth;
                              return InkWell(
                                onTap:isDisabled ? (){}: () {

                                  setState(() {
                                    selectedMonth = index + 1;
                                  });
                                },
                                onHover: (val) {},
                                child: MonthContainer(
                                  textStyle: monthTextStyle,
                                  month: monthModel.name,
                                  fillColor: index + 1 == selectedMonth
                                      ? primaryColor
                                      : bgColor,
                                  borderColor: index + 1 == selectedMonth
                                      ? primaryColor
                                      : bgColor,
                                    textColor: isDisabled ? AppColors.colorDisabled : (index + 1 != selectedMonth ? AppColors.colorPrimaryInverseText : Colors.white)
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                color: bgColor,
                                border: Border.all(
                                  color: primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: AppColors.colorPrimaryInverseText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              String selectedMonthString = selectedMonth < 10
                                  ? "0$selectedMonth"
                                  : "$selectedMonth";
                              var selectedDate = DateTime.parse(
                                  '$selectedYear-$selectedMonthString-01');

                              Navigator.pop(context, selectedDate);
                            },
                            child: Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                color: AppColors.colorSecondaryAccent,
                                border: Border.all(
                                  color: AppColors.colorSecondaryAccent,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  'Select',
                                  style: TextStyle(
                                    color: AppColors.colorPrimaryInverseText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned.fill(
                  top: 30,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            if(selectedYear>DateTime.now().year){
                              setState(() {
                                selectedYear = selectedYear - 1;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 10,
                            color:selectedYear>DateTime.now().year? primaryColor: AppColors.colorDisabled,
                          ),
                        ),
                        Text(
                          selectedYear.toString(),
                          style: yearTextStyle ??
                              const TextStyle(
                                fontSize: 20,
                                fontFamily: 'Rajdhani',
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (!(disableFuture == true &&
                            selectedYear == DateTime.now().year))
                          IconButton(
                            onPressed: () {
                              // DOC: Give user option to disable future years.
                              if (disableFuture == true &&
                                  selectedYear == DateTime.now().year) {
                                null;
                              } else {
                                setState(() {
                                  selectedYear = selectedYear + 1;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 10,
                              color: primaryColor,
                            ),
                          )
                        else
                          const SizedBox(
                            width: 50,
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
      },
    );
    String selectedMonthString =
    selectedMonth < 10 ? "0$selectedMonth" : "$selectedMonth";
    return DateTime.parse('$selectedYear-$selectedMonthString-01');
  }
}
class MonthModel {
  int index;
  String name;
  MonthModel({
    required this.index,
    required this.name,
  });
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removeViewInsets(
      removeLeft: true,
      removeTop: true,
      removeRight: true,
      removeBottom: true,
      context: context,
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 70.0),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            child: child,
          ),
        ),
      ),
    );
  }
}
class MonthContainer extends StatelessWidget {
  const MonthContainer({
    super.key,
    required this.month,
    required this.fillColor,
    required this.borderColor,
    required this.textColor,
    required this.textStyle,
  });

  final String month;
  final Color fillColor;
  final Color borderColor;
  final Color textColor;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
        color: fillColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          month,
          style:
              TextStyle(
                color: textColor,
              ),
        ),
      ),
    );
  }
}