import '../../../imports/common.dart';
import '../../../imports/data.dart';

class FindCustomerHandlers{
  static List<DataBaseUser> getUsers({required List<DataBaseUser> customers, required String assetsUrl}){
    for (int i = 0; i < customers.length; i++) {
      if (customers[i].profile != null) {

        customers[i].profile =  !customers[i].profile!.contains('http') ?
            StringManipulation.combineStings(
            prefix: assetsUrl,
            suffix: customers[i].profile!):customers[i].profile;
      } else {
        customers[i].profile = AppStrings.global_empty_string;
      }
      // customers[i].firstName =
      //     customers[i].firstName ?? AppStrings.global_empty_string;
      // customers[i].lastName =
      //     customers[i].lastName ?? AppStrings.global_empty_string;
      // customers[i].email =
      //     customers[i].email ?? AppStrings.global_empty_string;
    }
    return customers;
  }
}