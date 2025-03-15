import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:code_generator/widgets/my_icon_btn.dart';
import 'package:code_generator/widgets/note_textField.dart';
import 'package:flutter/material.dart';
import 'package:code_generator/constants/colors.dart';
import 'package:code_generator/services/save_item.dart';
import 'package:code_generator/widgets/MyCustomBtn.dart';
import 'package:code_generator/widgets/my_textField.dart';
import '../db/storage_helper.dart';
import '../models/qr_code.dart';
import '../widgets/modeIcon.dart';
import '../widgets/myText.dart';
import '../widgets/my_dialogs.dart';

class AddItem extends StatefulWidget {
  final Items? item;
  final bool? qrGenerate;
  const AddItem({super.key, this.item, this.qrGenerate});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _qrNumberController;
  late bool isEditing;

  @override
  void didUpdateWidget(covariant AddItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.qrGenerate != widget.qrGenerate ||
        oldWidget.item != widget.item) {
      _resetControllers();
    }
  }

  @override
  void initState() {
    super.initState();
    isEditing = widget.item != null;
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _typeController = TextEditingController(text: widget.item?.type ?? '');
    _qrNumberController = TextEditingController(
      text: widget.item?.number.toString() ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isQr = widget.qrGenerate == true;
    final GlobalKey repaintKey = GlobalKey();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: isEditing
              ? const MyText(
                  txt: 'تعديل عنصر',
                  family: boldFont,
                  size: 18,
                  textAlign: TextAlign.center,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      txt: isQr ? 'توليد رمز QR' : 'إضافة عنصر',
                      size: 18,
                      family: boldFont,
                    ),
                    !isQr
                        ? MyIconButton(
                            onPressed: _scanBarcode,
                            tooltip: 'تجديد منتج',
                            iconData: const Icon(Icons.qr_code_scanner_outlined,
                                size: 30),
                          )
                        : const SizedBox(),
                    const ModeIcon(),
                  ],
                ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MyTextField(
                  controller: _nameController,
                  txt: isQr ? 'عنوان الرمز' : 'أسم الصنف',
                ),
                NoteTextfield(
                  controller: _typeController,
                  txt: isQr ? 'النص' : 'نوع الصنف',
                  hintText: isQr
                      ? 'النصوص المراد تحويلها الى QR'
                      : 'حبوب، امبول، شراب ....',
                  height: isQr ? 150 : 60,
                ),
                !isQr
                    ? MyTextField(
                        controller: _qrNumberController,
                        txt: isQr ? '' : 'الباركود',
                        hintText: isQr
                            ? 'اضغط الايقونة لمسح الباركود'
                            : 'اضغط الايقونة لتوليد باركود',
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.barcode_reader, size: 30),
                          onPressed: generateBarcodeNumber,
                          padding: const EdgeInsets.only(bottom: 15),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(height: 15),
                MyCustomBtn(
                  onTap: () {
                    if (isQr) {
                      MyDialogs.saveDailog(
                        cnx: context,
                        globalKey: repaintKey,
                        itemName: _nameController.text,
                        itemType: _typeController.text,
                        itemNum: 0,
                        isQr: true,
                      );
                    } else {
                      SaveItem().saveItem(
                        itemType: _typeController.text,
                        itemName: _nameController.text,
                        isEditing: isEditing,
                        qrName: _qrNumberController.text,
                        itemId: widget.item?.id,
                        cnx: context,
                      );
                      emptyField();
                    }
                  },
                  btnText: isQr ? 'إنشاء QR' : (isEditing ? 'تحديث' : 'حفظ'),
                  width: MediaQuery.sizeOf(context).width / 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetControllers() {
    isEditing = widget.item != null;
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _typeController = TextEditingController(text: widget.item?.type ?? '');
    _qrNumberController = TextEditingController(
      text: widget.item?.number.toString() ?? '',
    );
  }

  void emptyField() {
    setState(() {
      _qrNumberController.clear();
      _nameController.clear();
      _typeController.clear();
    });
  }

  Future<void> _scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        setState(() {
          _qrNumberController.text = result.rawContent;
        });
      }
    } catch (e) {
      print('error:$e');
    }
  }

  Future<void> generateBarcodeNumber() async {
    try {
      final items = await ItemStorage.getItems();
      int newNumber;
      do {
        newNumber = DateTime.now().millisecondsSinceEpoch % 10000000000;
      } while (items.any((item) => item.number == newNumber));
      _qrNumberController.text = newNumber.toString();
    } catch (e) {
      print('Error$e');
    }
  }
}
