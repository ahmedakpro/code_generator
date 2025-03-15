import 'package:flutter/material.dart';
import 'package:code_generator/constants/colors.dart';
import 'package:code_generator/db/storage_helper.dart';
import 'package:code_generator/widgets/modeIcon.dart';
import '../widgets/myText.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                txt: 'عن التطبيق',
                size: 18,
                family: boldFont,
              ),
              ModeIcon()
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildSectionTitle('ماذا يفعل code_generator ؟'),
                _buildParagraph(
                    'code_generator هو تطبيق مبتكر لإنشاء وإدارة الرموز المشفرة للمنتجات التي تحتاج رمز مشفر عليها، لتعريفها لقارئ الباركود، أو تخزين بيانات نصية في رمزاستجابة. وبهذه المميزات:'
                    '\n- تخزين المنتجات قي قاعدة بيانات محلية.'
                    '\n- العمل دون الحاجة الى إتصال بالإنترنت.'
                    '\n-اختيار نوع الرمز Barcode أو QR code'
                    '\n- حفظ الرمز المشفر مع اسم المنتج كملف مفرد او متعدد pdf.'
                    '\n- حفظ نسخة إحتياطية لقاعدة البيانات على الجهاز.'
                    '\n- خيار البحث عن الاصناف المحفوظة.'
                    '\n- امكانية قراءة باركود لمنتج سابق واضافتة الى قاعدة البيانات لتجديده.'
                    '\n- اختصار الروابط والنصوص الى رمز QR'),
                const Divider(height: 40),
                _buildSectionTitle('اتصل بنا:'),
                _buildContactItem('📧', 'ahmed2002.agc@gmail.com'),
                _buildContactItem('📱', '+967-776646961'),
                _buildContactItem(
                    '👨‍💻', 'المطور: أحمد الخليدي \n Flutter Developer'),
                const SizedBox(height: 30),
                _buildTagLine(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'نسخ إحتياطي',
                      onPressed: () =>
                          ItemStorage.createPersistentBackup(context),
                      icon: const Icon(Icons.backup),
                    ),
                    const SizedBox(width: 25),
                    IconButton(
                      tooltip: 'إستعادة النسخة الاحتياطية',
                      onPressed: () =>
                          ItemStorage.restorePersistentBackup(context),
                      icon: const Icon(Icons.restore),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: MyText(
        txt: text,
        family: boldFont,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return MyText(
      txt: text,
      maxLine: 15,
    );
  }

  Widget _buildContactItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          MyText(txt: icon, size: 20),
          const SizedBox(width: 12),
          MyText(
            txt: text,
          ),
        ],
      ),
    );
  }

  Widget _buildTagLine() {
    return const Column(
      children: [
        MyText(
          txt: 'code_generator: رفيقك الذكي في عالم رموز QR!',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        MyText(
          txt: '"من المبتكرين إلى المبتكرين"',
        ),
      ],
    );
  }
}
