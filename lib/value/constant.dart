import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widget/app_style_text.dart';

hiddenKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

getSheetError(String title) {
  return Get.snackbar(
    '',
    '',
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.info,
          color: Colors.red,
        ),
        SizedBox(
          width: ScreenUtil().setWidth(10),
        ),
        Flexible(
          child: AppTextStyle(
            name: title,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.red,
          ),
        ),
      ],
    ),
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
  );
}

getSheetSucsses(String title) {
  return Get.snackbar(
    '',
    '',
    messageText: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppTextStyle(
          name: title,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.green,
        ),
        SizedBox(
          width: ScreenUtil().setWidth(10),
        ),
        const Icon(
          Icons.check,
          color: Colors.green,
        ),
      ],
    ),
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
  );
}

// ============ baseUrl ================

String baseUrl = 'https://medi_pal_compa.site/api/';
String baseUrl2 = 'https://medi_pal_compa.site/';

//=============Auth User Url =================

String getCountryUrl = 'get_countries.php';
String getAllCategoryUrl = 'get_all_cats.php';
String getMainItemUrl = 'featured_categories.php';
String getMainCatsUrl = 'get_main_cats.php';
String getSubCatsUrl = 'get_sub_cats.php';
String getVendorsUrl = 'get_vendors.php';
String getBrandsUrl = 'get_brands.php';
String getMainProductUrl = 'get_country_maincategory_products.php';
String getSub2ProductUrl = 'get_country_subcategory_products.php';
String getSubSubItemUrl = 'get_country_sub_subcategory_products.php';
String getProductDetailsUrl = 'get_prod_data.php';
String getBrandProductUrl = 'get_brand_products.php';
String getVendorProductUrl = 'get_vendor_products.php';

String loginUserUrl = 'login.php';
String registrationUserUrl = 'registration.php';
String getCustomersUserUrl = 'getcustomers.php';
String addCustomersUserUrl = 'addcustomers.php';
String getAllInvoicesUserUrl = 'getAllInvoices.php';
String getInvoicesDetailsUserUrl = 'getInvoiceDetails.php';
String getItemsUserUrl = 'getItems.php';
String saveInvoiceUserUrl = 'insertInvoice.php';
