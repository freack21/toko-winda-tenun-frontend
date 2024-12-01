import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget header() {
      return AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: whiteColor,
        ),
        scrolledUnderElevation: 0.0,
        title: Text(
          "Ketentuan & Kebijakan",
          style: whiteTextStyle.copyWith(
            fontWeight: medium,
            fontSize: 18,
          ),
        ),
        toolbarHeight: 64,
      );
    }

    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: header(),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: defaultMargin,
          horizontal: defaultMargin,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          color: whiteColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat datang di aplikasi Toko Winda Tenun. Dengan menggunakan aplikasi ini, Anda setuju untuk mematuhi ketentuan dan kebijakan yang telah ditetapkan berikut:",
                style: primaryTextStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "1. Pengumpulan dan Penggunaan Data Pribadi",
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Untuk menggunakan layanan kami, Anda akan diminta untuk memberikan beberapa data pribadi, seperti: Nama Lengkap, Email Nomor, Telepon, Lokasi Pengantaran Paket. Data tersebut digunakan untuk keperluan pendaftaran, mempermudah proses komunikasi, dan pengiriman produk. Kami berkomitmen untuk menjaga kerahasiaan data pribadi Anda dan hanya akan menggunakannya untuk keperluan yang berkaitan dengan layanan aplikasi ini.",
                style: primaryTextStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "2. Pendaftaran Akun",
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Untuk mengakses fitur-fitur dalam aplikasi, Anda diwajibkan untuk mendaftar menggunakan email yang valid, nomor telepon yang aktif, dan nama lengkap. Setiap informasi yang Anda berikan harus akurat dan terkini.",
                style: primaryTextStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "3. Informasi Produk",
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Aplikasi ini menampilkan berbagai produk tenun songket yang diproduksi oleh Winda Tenun Songket. Informasi produk, harga, dan stok dapat berubah sewaktu-waktu tanpa pemberitahuan sebelumnya. Anda dapat menghubungi kami melalui fitur chat yang tersedia dalam aplikasi untuk bertanya lebih lanjut tentang produk.",
                style: primaryTextStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "4. Fitur Chat",
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Fitur chat disediakan untuk memudahkan komunikasi antara pelanggan dan tim kami terkait produk yang ditawarkan. Kami berhak untuk memoderasi konten komunikasi dan menindak tegas jika ditemukan adanya penyalahgunaan fitur.",
                style: primaryTextStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "5. Proses Pemesanan dan Pengiriman",
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Setelah Anda memilih produk yang diinginkan, Anda dapat melakukan checkout melalui aplikasi. Pastikan sebelum melakukan checkout, Anda telah mengirim chat ke admin, agar admin dapat melakukan tracking pada pesanan anda. Anda diharuskan mencantumkan lokasi pengantaran yang tepat dan jelas. Biaya pengiriman akan dihitung berdasarkan lokasi Anda.",
                style: primaryTextStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "6. Keamanan Data",
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Kami menggunakan metode yang wajar dan sesuai standar industri untuk melindungi data pribadi Anda. Namun, kami tidak bertanggung jawab atas kerugian yang mungkin terjadi akibat akses tidak sah ke akun Anda yang disebabkan oleh kelalaian dalam menjaga kerahasiaan informasi login.",
                style: primaryTextStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "7. Perubahan Ketentuan",
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Kami berhak untuk mengubah ketentuan dan kebijakan ini sewaktu-waktu. Setiap perubahan akan diinformasikan melalui aplikasi atau media komunikasi yang relevan.",
                style: primaryTextStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Dengan menggunakan aplikasi Toko Winda Tenun, Anda menyatakan bahwa Anda telah membaca, memahami, dan setuju dengan seluruh ketentuan dan kebijakan yang berlaku.",
                style: primaryTextStyle,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
