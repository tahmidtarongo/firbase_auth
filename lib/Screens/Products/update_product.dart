import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/model/product_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../Home/home_screen.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({Key? key, required this.productModel, required this.productNameList, required this.productCodeList}) : super(key: key);

  final ProductModel productModel;
  final List<String> productNameList;
  final List<String> productCodeList;

  @override
  UpdateProductState createState() => UpdateProductState();
}

class UpdateProductState extends State<UpdateProduct> {
  late String productKey;
  late ProductModel updatedProductModel;
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  File imageFile = File('No File');
  String imagePath = 'No Data';

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);
    try {
      EasyLoading.show(
        status: 'Uploading... ',
        dismissOnTap: false,
      );
      var snapshot = await FirebaseStorage.instance.ref('Product Picture/${DateTime.now().millisecondsSinceEpoch}').putFile(file);
      var url = await snapshot.ref.getDownloadURL();
      setState(() {
        updatedProductModel.productPicture = url.toString();
      });
    } on firebase_core.FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }

  void getProductKey(String code) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    // ignore: unused_local_variable
    List<ProductModel> productList = [];
    final ref = FirebaseDatabase.instance.ref(userId).child('Products');
    ref.keepSynced(true);
    ref.orderByKey().get().then((value) {
      for (var element in value.children) {
        var data = jsonDecode(jsonEncode(element.value));
        if (data['productCode'].toString() == code) {
          productKey = element.key.toString();
        }
      }
    });
  }

  TextEditingController productNameController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController mrpController = TextEditingController();
  TextEditingController wholeSaleController = TextEditingController();
  TextEditingController dealerPriceController = TextEditingController();
  TextEditingController manufacturerController = TextEditingController();

  @override
  void initState() {
    getProductKey(widget.productModel.productCode);
    updatedProductModel = widget.productModel;
    super.initState();

    ///________set_previous_data_________________________
    productNameController.value = TextEditingValue(text: widget.productModel.productName);
    sizeController.value = TextEditingValue(text: widget.productModel.size);
    colorController.value = TextEditingValue(text: widget.productModel.color);
    weightController.value = TextEditingValue(text: widget.productModel.weight);
    capacityController.value = TextEditingValue(text: widget.productModel.capacity);
    typeController.value = TextEditingValue(text: widget.productModel.type);
    purchasePriceController.value = TextEditingValue(text: widget.productModel.productPurchasePrice);
    mrpController.value = TextEditingValue(text: widget.productModel.productSalePrice);
    wholeSaleController.value = TextEditingValue(text: widget.productModel.productWholeSalePrice);
    dealerPriceController.value = TextEditingValue(text: widget.productModel.productDealerPrice);
    manufacturerController.value = TextEditingValue(text: widget.productModel.productManufacturer);
  }

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kMainColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Update Product',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer(builder: (context, ref, __) {
        return Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: Form(
                key: globalKey,
                child: Column(
                  children: [
                    ///________Name__________________________________________
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: productNameController,
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(),
                          labelText: 'Product Name',
                          hintText: 'Enter Product Name.',
                        ),
                        validator: (value) {
                          if (value.isEmptyOrNull) {
                            return 'Product name is required.';
                          } else if (widget.productNameList.contains(value?.toLowerCase().removeAllWhiteSpace()) && value != widget.productModel.productName) {
                            return 'Product name is already added.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          updatedProductModel.productName = value!;
                        },
                      ),
                    ),

                    ///______category___________________________
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: widget.productModel.productCategory,
                          labelText: 'Category',
                          border: const OutlineInputBorder(),
                          suffixIcon: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                    ),

                    ///_____SIZE & Color__________________________
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: sizeController,
                              onSaved: (value) {
                                updatedProductModel.size = value!;
                              },
                              decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: 'Size',
                                hintText: 'Enter Size.',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ).visible(widget.productModel.size.isNotEmpty),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: colorController,
                              onSaved: (value) {
                                updatedProductModel.color = value!;
                              },
                              decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: 'Color',
                                hintText: 'Enter Color.',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ).visible(widget.productModel.color.isNotEmpty),
                      ],
                    ),

                    ///_______Weight & Capacity & Type_____________________________
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: weightController,
                              onSaved: (value) {
                                updatedProductModel.weight = value!;
                              },
                              decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: 'Weight',
                                hintText: 'Enter Weight.',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ).visible(widget.productModel.weight.isNotEmpty),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: capacityController,
                              onSaved: (value) {
                                updatedProductModel.capacity = value!;
                              },
                              decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: 'Capacity',
                                hintText: 'Enter Capacity.',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ).visible(widget.productModel.capacity.isNotEmpty),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: typeController,
                        onSaved: (value) {
                          updatedProductModel.type = value!;
                        },
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Type',
                          hintText: 'Usb C',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ).visible(widget.productModel.type.isNotEmpty),

                    ///___________Brand___________________________________
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: widget.productModel.brandName,
                          labelText: 'Brand',
                          border: const OutlineInputBorder(),
                          suffixIcon: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                    ),

                    ///_________product_code_______________________________
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                hintText: widget.productModel.productCode,
                                labelText: 'Product Code',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GestureDetector(
                              child: Container(
                                height: 60.0,
                                width: 100.0,
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: kGreyTextColor),
                                ),
                                child: const Image(
                                  image: AssetImage('images/barcode.png'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    ///_______stock & unit______________________
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: 'Stock',
                                hintText: widget.productModel.productStock,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                hintText: widget.productModel.productUnit,
                                labelText: 'Units',
                                border: const OutlineInputBorder(),
                                suffixIcon: const Icon(Icons.keyboard_arrow_down),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    ///__________purchase & sale price_______________________________
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              readOnly: true,
                              keyboardType: TextInputType.number,
                              controller: purchasePriceController,
                              decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: 'Purchase Price',
                                hintText: 'Enter Purchase Price.',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              readOnly: true,
                              controller: mrpController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: 'MRP',
                                hintText: 'Enter MRP.',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    ///___________wholeSale_DealerPrice____________________________
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: wholeSaleController,
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                updatedProductModel.productWholeSalePrice = value!;
                              },
                              decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: 'WholeSale Price',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: dealerPriceController,
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                updatedProductModel.productDealerPrice = value!;
                              },
                              decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: 'Dealer price',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Discount',
                              hintText: 'Enter Discount.',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )).visible(false),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              controller: manufacturerController,
                              onSaved: (value) {
                                updatedProductModel.productManufacturer = value!;
                              },
                              decoration: const InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                labelText: 'Manufacturer',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                // ignore: sized_box_for_whitespace
                                child: Container(
                                  height: 200.0,
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                                            setState(() {
                                              imageFile = File(pickedImage!.path);
                                              imagePath = pickedImage!.path;
                                            });
                                            Future.delayed(const Duration(milliseconds: 100), () {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.photo_library_rounded,
                                                size: 60.0,
                                                color: kMainColor,
                                              ),
                                              Text(
                                                'Gallery',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 20.0,
                                                  color: kMainColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 40.0,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            pickedImage = await _picker.pickImage(source: ImageSource.camera);
                                            setState(() {
                                              imageFile = File(pickedImage!.path);
                                              imagePath = pickedImage!.path;
                                            });
                                            Future.delayed(const Duration(milliseconds: 100), () {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.camera,
                                                size: 60.0,
                                                color: kGreyTextColor,
                                              ),
                                              Text(
                                                'Camera',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 20.0,
                                                  color: kGreyTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54, width: 1),
                              borderRadius: const BorderRadius.all(Radius.circular(120)),
                              image: imagePath == 'No Data'
                                  ? DecorationImage(
                                      image: NetworkImage(widget.productModel.productPicture),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: FileImage(imageFile),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 2),
                                borderRadius: const BorderRadius.all(Radius.circular(120)),
                                color: kMainColor,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ButtonGlobalWithoutIcon(
                      buttontext: 'Save and Publish',
                      buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
                      onPressed: () async {
                        if (validateAndSave()) {
                          try {
                            bool result = await InternetConnectionChecker().hasConnection;

                             result ? imagePath == 'No Data' ? null : await uploadFile(imagePath) : null;
                            EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                            DatabaseReference ref = FirebaseDatabase.instance.ref("${FirebaseAuth.instance.currentUser!.uid}/Products/$productKey");
                            ref.keepSynced(true);
                            ref.update({
                              'productName': updatedProductModel.productName,
                              'productCategory': updatedProductModel.productCategory,
                              'size': updatedProductModel.size,
                              'color': updatedProductModel.color,
                              'weight': updatedProductModel.weight,
                              'capacity': updatedProductModel.capacity,
                              'type': updatedProductModel.type,
                              'brandName': updatedProductModel.brandName,
                              'productCode': updatedProductModel.productCode,
                              'productStock': updatedProductModel.productStock,
                              'productUnit': updatedProductModel.productUnit,
                              'productSalePrice': updatedProductModel.productSalePrice,
                              'productPurchasePrice': updatedProductModel.productPurchasePrice,
                              'productDiscount': updatedProductModel.productDiscount,
                              'productWholeSalePrice': updatedProductModel.productWholeSalePrice,
                              'productDealerPrice': updatedProductModel.productDealerPrice,
                              'productManufacturer': updatedProductModel.productManufacturer,
                              'productPicture': updatedProductModel.productPicture,
                            });
                            EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 500));
                            //ref.refresh(productProvider);
                            Future.delayed(const Duration(milliseconds: 100), () {
                              const HomeScreen().launch(context, isNewTask: true);
                            });
                          } catch (e) {
                            EasyLoading.dismiss();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        }
                      },
                      buttonTextColor: Colors.white,
                    ),
                    // Column(
                    //   children: [
                    //     const SizedBox(height: 10),
                    //     GestureDetector(
                    //       onTap: () {
                    //         showDialog(
                    //             context: context,
                    //             builder: (BuildContext context) {
                    //               return Dialog(
                    //                 shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(12.0),
                    //                 ),
                    //                 // ignore: sized_box_for_whitespace
                    //                 child: Container(
                    //                   height: 200.0,
                    //                   width: MediaQuery.of(context).size.width - 80,
                    //                   child: Center(
                    //                     child: Row(
                    //                       mainAxisAlignment: MainAxisAlignment.center,
                    //                       children: [
                    //                         GestureDetector(
                    //                           onTap: () async {
                    //                             pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                    //
                    //                             setState(() {
                    //                               imageFile = File(pickedImage!.path);
                    //                               imagePath = pickedImage!.path;
                    //                             });
                    //
                    //                             Future.delayed(const Duration(milliseconds: 100), () {
                    //                               Navigator.pop(context);
                    //                             });
                    //                           },
                    //                           child: Column(
                    //                             mainAxisAlignment: MainAxisAlignment.center,
                    //                             children: [
                    //                               const Icon(
                    //                                 Icons.photo_library_rounded,
                    //                                 size: 60.0,
                    //                                 color: kMainColor,
                    //                               ),
                    //                               Text(
                    //                                 'Gallery',
                    //                                 style: GoogleFonts.poppins(
                    //                                   fontSize: 20.0,
                    //                                   color: kMainColor,
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                         const SizedBox(
                    //                           width: 40.0,
                    //                         ),
                    //                         GestureDetector(
                    //                           onTap: () async {
                    //                             pickedImage = await _picker.pickImage(source: ImageSource.camera);
                    //                             setState(() {
                    //                               imageFile = File(pickedImage!.path);
                    //                               imagePath = pickedImage!.path;
                    //                             });
                    //                             Future.delayed(const Duration(milliseconds: 100), () {
                    //                               Navigator.pop(context);
                    //                             });
                    //                           },
                    //                           child: Column(
                    //                             mainAxisAlignment: MainAxisAlignment.center,
                    //                             children: [
                    //                               const Icon(
                    //                                 Icons.camera,
                    //                                 size: 60.0,
                    //                                 color: kGreyTextColor,
                    //                               ),
                    //                               Text(
                    //                                 'Camera',
                    //                                 style: GoogleFonts.poppins(
                    //                                   fontSize: 20.0,
                    //                                   color: kGreyTextColor,
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //               );
                    //             });
                    //       },
                    //       child: Stack(
                    //         children: [
                    //           Container(
                    //             height: 120,
                    //             width: 120,
                    //             decoration: BoxDecoration(
                    //               border: Border.all(color: Colors.black54, width: 1),
                    //               borderRadius: const BorderRadius.all(Radius.circular(120)),
                    //               image: imagePath == 'No Data'
                    //                   ? DecorationImage(
                    //                       image: NetworkImage(productPicture),
                    //                       fit: BoxFit.cover,
                    //                     )
                    //                   : DecorationImage(
                    //                       image: FileImage(imageFile),
                    //                       fit: BoxFit.cover,
                    //                     ),
                    //             ),
                    //           ),
                    //           Container(
                    //             height: 120,
                    //             width: 120,
                    //             decoration: BoxDecoration(
                    //               border: Border.all(color: Colors.black54, width: 1),
                    //               borderRadius: const BorderRadius.all(Radius.circular(120)),
                    //               image: DecorationImage(
                    //                 image: FileImage(imageFile),
                    //                 fit: BoxFit.cover,
                    //               ),
                    //             ),
                    //             // child: imageFile.path == 'No File' ? null : Image.file(imageFile),
                    //           ),
                    //           Positioned(
                    //             bottom: 0,
                    //             right: 0,
                    //             child: Container(
                    //               height: 35,
                    //               width: 35,
                    //               decoration: BoxDecoration(
                    //                 border: Border.all(color: Colors.white, width: 2),
                    //                 borderRadius: const BorderRadius.all(Radius.circular(120)),
                    //                 color: kMainColor,
                    //               ),
                    //               child: const Icon(
                    //                 Icons.camera_alt_outlined,
                    //                 size: 20,
                    //                 color: Colors.white,
                    //               ),
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //     const SizedBox(height: 10),
                    //   ],
                    // ),
                    // ButtonGlobalWithoutIcon(
                    //   buttontext: 'Save and Publish',
                    //   buttonDecoration: kButtonDecoration.copyWith(color: kMainColor, borderRadius: const BorderRadius.all(Radius.circular(30))),
                    //   onPressed: () async {
                    //     if (validateAndSave()) {
                    //       try {
                    //         EasyLoading.show(status: 'Loading...', dismissOnTap: false);
                    //
                    //         imagePath == 'No Data' ? null : await uploadFile(imagePath);
                    //         // ignore: no_leading_underscores_for_local_identifiers
                    //         final DatabaseReference _productInformationRef = FirebaseDatabase.instance
                    //             // ignore: deprecated_member_use
                    //             .reference()
                    //             .child(FirebaseAuth.instance.currentUser!.uid)
                    //             .child('Products');
                    //         ProductModel productModel = ProductModel(
                    //           productName,
                    //           productCategory,
                    //           size,
                    //           color,
                    //           weight,
                    //           capacity,
                    //           type,
                    //           brandName,
                    //           productCode,
                    //           productStock,
                    //           productUnit,
                    //           productSalePrice,
                    //           productPurchasePrice,
                    //           productDiscount,
                    //           productWholeSalePrice,
                    //           productDealerPrice,
                    //           productManufacturer,
                    //           productPicture,
                    //         );
                    //         await _productInformationRef.push().set(productModel.toJson());
                    //         Subscription.decreaseSubscriptionLimits(itemType: 'products', context: context);
                    //         EasyLoading.showSuccess('Added Successfully', duration: const Duration(milliseconds: 500));
                    //         ref.refresh(productProvider);
                    //         Future.delayed(const Duration(milliseconds: 100), () {
                    //           const Home().launch(context, isNewTask: true);
                    //         });
                    //       } catch (e) {
                    //         EasyLoading.dismiss();
                    //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    //       }
                    //     }
                    //   },
                    //   buttonTextColor: Colors.white,
                    // ),
                    // const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
