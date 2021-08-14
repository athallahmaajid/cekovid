class IndonesiaData {
  final int jumlahPositif;
  final int jumlahDirawat;
  final int jumlahSembuh;
  final int jumlahMeninggal;

  Map<String, dynamic> toMap() {
    return {
      'Positif': jumlahPositif,
      'Dirawat': jumlahDirawat,
      'Sembuh': jumlahSembuh,
      'Meninggal': jumlahMeninggal
    };
  }

  IndonesiaData({
    required this.jumlahPositif,
    required this.jumlahDirawat,
    required this.jumlahSembuh,
    required this.jumlahMeninggal,
  });

  factory IndonesiaData.fromJson(Map<String, dynamic> json) {
    return IndonesiaData(
      jumlahPositif: json['jumlah_positif'],
      jumlahDirawat: json['jumlah_dirawat'],
      jumlahSembuh: json['jumlah_sembuh'],
      jumlahMeninggal: json['jumlah_meninggal'],
    );
  }
}

class ProvinceData {
  final int jumlahPositif;
  final int jumlahDirawat;
  final int jumlahSembuh;
  final int jumlahMeninggal;

  ProvinceData({
    required this.jumlahPositif,
    required this.jumlahDirawat,
    required this.jumlahSembuh,
    required this.jumlahMeninggal,
  });

  factory ProvinceData.fromJson(Map<String, dynamic> json) {
    return ProvinceData(
      jumlahPositif: json['jumlah_positif'],
      jumlahDirawat: json['jumlah_dirawat'],
      jumlahSembuh: json['jumlah_sembuh'],
      jumlahMeninggal: json['jumlah_meninggal'],
    );
  }
}
