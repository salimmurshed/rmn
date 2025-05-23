import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../imports/common.dart';

class StaffProductsNRegistrationsView extends StatefulWidget {
  const StaffProductsNRegistrationsView({super.key});

  @override
  State<StaffProductsNRegistrationsView> createState() =>
      _StaffProductsNRegistrationsViewState();
}
String image = 'https://unsplash.com/photos/man-in-black-nike-pullover-hoodie-sMhOBWWoaJQ';
List<ProductsType> productTypes = [
  ProductsType(name: 'Floor Pass', products: [
    Products(
        title: 'T-Shirt',
        imageUrl: image,
        price: '20',
        variant: ['Black', 'White', 'Red'],
        size: ['M', 'L', 'XL'],
        description: 'This is a black T-Shirt'),
    Products(
        title: 'T-Shirt',
        imageUrl: image,
        price: '20',
        variant: ['Black', 'White', 'Red'],
        size: ['M', 'L', 'XL'],
        description: 'This is a black T-Shirt'),
    Products(
        title: 'T-Shirt',
        imageUrl: image,
        price: '20',
        variant: ['Black', 'White', 'Red'],
        size: ['M', 'L', 'XL'],
        description: 'This is a black T-Shirt'),
  ]),
  ProductsType(name: 'Other Products', products: [
    Products(
        title: 'T-Shirt',
        imageUrl: image,
        price: '20',
        variant: ['Black', 'White', 'Red'],
        size: ['M', 'L', 'XL'],
        description: 'This is a black T-Shirt'),
    Products(
        title: 'T-Shirt',
        imageUrl: image,
        price: '20',
        variant: ['Black', 'White', 'Red'],
        size: ['M', 'L', 'XL'],
        description: 'This is a black T-Shirt'),
    Products(
        title: 'T-Shirt',
        imageUrl: image,
        price: '20',
        variant: ['Black', 'White', 'Red'],
        size: ['M', 'L', 'XL'],
        description: 'This is a black T-Shirt'),
  ]),
  ProductsType(name: 'Merchandise', products: [
    Products(
        title: 'T-Shirt',
        imageUrl: image,
        price: '20',
        variant: ['Black', 'White', 'Red'],
        size: ['M', 'L', 'XL'],
        description: 'This is a black T-Shirt'),
    Products(
        title: 'T-Shirt',
        imageUrl: image,
        price: '20',
        variant: ['Black', 'White', 'Red'],
        size: ['M', 'L', 'XL'],
        description: 'This is a black T-Shirt'),
    Products(
        title: 'T-Shirt',
        imageUrl: image,
        price: '20',
        variant: ['Black', 'White', 'Red'],
        size: ['M', 'L', 'XL'],
        description: 'This is a black T-Shirt'),
  ]),
  ProductsType(name: 'Admission Pass', products: [
    Products(
        title: 'T-Shirt',
        imageUrl: image,
        price: '20',
        variant: ['Black', 'White', 'Red'],
        size: ['M', 'L', 'XL'],
        description: 'This is a black T-Shirt'),
    Products(
        title: 'T-Shirt',
        imageUrl: image,
        price: '20',
        variant: ['Black', 'White', 'Red'],
        size: ['M', 'L', 'XL'],
        description: 'This is a black T-Shirt'),
    Products(
        title: 'T-Shirt',
        imageUrl: image,
        price: '20',
        variant: ['Black', 'White', 'Red'],
        size: ['M', 'L', 'XL'],
        description: 'This is a black T-Shirt'),
  ]),

];
int isSelected = 0;

class _StaffProductsNRegistrationsViewState
    extends State<StaffProductsNRegistrationsView> {
  @override
  Widget build(BuildContext context) {
    return customScaffold(
        hasForm: false,
        formOrColumnInsideSingleChildScrollView: null,
        customAppBar: CustomAppBar(title: 'Event Name', isLeadingPresent: true),
        anyWidgetWithoutSingleChildScrollView: Column(
          children: [
            buildCustomTabBar(isScrollRequired: false, tabElements: [
              TabElements(title: 'Products', onTap: (){}, isSelected: true),
              TabElements(title: 'Registrations', onTap: (){}, isSelected: false),
            ]),
            SizedBox(
              height: 25.h,
              width: double.infinity,
              child: ListView.separated(
                  padding: EdgeInsets.only(left: 3.w),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {
                    return IntrinsicWidth(
                      child: GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                              color: isSelected == i
                                  ? AppColors.colorSecondaryAccent
                                  : AppColors.colorPrimary,
                              borderRadius: BorderRadius.circular(5.r,),

                              border: Border.all(
                                  width: 1.w,
                                  color: AppColors.colorPrimaryNeutral),
                          ),
                          child: Center(
                            child: Text(
                              productTypes[i].name,
                              style: AppTextStyles.normalPrimary(isOutfit: false),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, i) {
                    return SizedBox(
                      width: 10.h,
                    );
                  },
                  itemCount: productTypes.length),
            ),
          ],
        ));
  }
}
class ProductsType {
  String name;
  List<Products> products;

  ProductsType({required this.name, required this.products});
}

class Products {
  String title;
  String imageUrl;
  String price;
  List<String> variant;
  List<String> size;
  String description;

  Products({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.variant,
    required this.size,
    required this.description,
  });
}