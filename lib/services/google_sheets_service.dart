import 'package:gsheets/gsheets.dart';

class GoogleSheetsService {
  static const _credentials = r'''
    {
      "type": "service_account",
      "project_id": "prime-haven-297509",
      "private_key_id": "68bd7e3d0c5ac6049893a982e8a5bd63b6118ffe",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCOFavm5SOaISB9\nMUHYC18lbIbpzjnZXsIEsaxsrQ9ExCfLQKnpSlRotJCDBWvaWv5oHExZpkDD0i4q\nJWVAtwJwfB/5ec8LLh0O/oYgkE5/jqhqLLhR9bL8z3QWKtpXRW+LV21VxDXo5BBX\nOuMsnmEqsSBholfrQ4qxYGP0WXdlEXlXNUIRlMRwwYdZ+5sGqrO+HO5ObqMd7rYu\n88gY+cWxiU/Cxt0004lw8UbyiYekOO6OPxBsZf5mW25RPEWwIQNybAF8QFVFOak4\nwwgc2uHkvdGFPqEaMWgucRzwto+eLDYNz01XuQ6UowC6Lv3SrAPFBRU55kRqQ4x7\nD9Yqi69PAgMBAAECggEAC815DiESqAcAb+Xbllq7eJxfSKS84XWhoEoyDIUDs66n\nr5abhqmKAXieWIPmxaixYWyYWwoYbyvSceXRV2LcbQOilFKuBDu8ZjZ2ZdYW7zmm\ne8tjNEu4po+FESJWKNG3xldo2asG32Wyhcx6eoZdg/JawkF+FCj0KG/dXbrg1CBT\nxWZhkEwwK1p8IN5dNy3KmNgiAZqhPPuvyXrr+lN7R3if9vdIooqIthptdZPJ4kiL\nm1F8GVAXI9XzjNEQtacW8m1kCVCa4iS8NK5vNlPc20cwKXGdYNNk76Bi8lFFMDAe\nrQqjre6rTD6esarG2mCvoI6WGmHisED4MTwrkjrToQKBgQDEGz5A89qWbFraBzro\nqyeSeuIHvgb807RGtlXbZFbEC70+mD+NcpS0xXLPha5izUZWYYS+UPjbEDJT/PM6\nILDOnCo4X1f89034FVeDtc15eMr16XXTaVr3dY7x4oBOfJ861ozxAXY3V8Cq8o0z\nkqYxJijpVVeTZYIbhnkCFqqM0wKBgQC5erAj+egNr6Hzs7GNCq1eRSu4Bb9bcg+z\ngeT07FbAbV9fny8c4wNtX+tlLfkToBjgmTVdEsPUVtyThYmtwpwxYT6pAlsTJL7Q\ne+O3V0u01Fcjztz8OVwYLLBju9C0jdVDlB4GKWIx85/MdJyv3Lqtgcn9Mv6PD35F\nBnD7pzwWFQKBgQCEWXaMU4ckmgA+wT5qpIhSfYhqfT8uBprWVlxfcrp0GRAhXJMX\nnUrrLY6sq6XjnHJp/eqenvs0rRuqPz7P7hwldJOx8/boDOecFJs5kssXvgQMLwGM\nKsBv3fEZIipBzi2Qghgg10G3XAv10ziko8ZxyTU3NJekLI/Aj+K/HBkCbQKBgQCF\nklEe123BzWW39wQ6KiJH7VBaqejwleewwi58I2cmFJ3GYwCusN1a+uSubLke5QCF\nXlALwuO8GwGmS1inBast9HYHiGbGFoRD57RJ6Ffg1bobU3HZQgWMc0Jj0HGwVSPs\nEtK8ZTkN+ABwYNol27OkF/+6k+q2Y9XvJ4Bd+kVPMQKBgCKuBB56c5vH41LOCn4H\nQjDcQF6ZwxsvxiNrdOj4Kc7dvbnwKYrXtMCbWDCqgd60t3CyPDdbkO2YW52cKcSI\nqepw9u3P4umGuQgNarnifGiY0CYoKFAORkUNDCkCQo8WWCHb8zJifBlwx9TJhGBS\nJNxy+5LTgKfq9KFdmUP/qWYq\n-----END PRIVATE KEY-----\n",
      "client_email": "gsheets@prime-haven-297509.iam.gserviceaccount.com",
      "client_id": "108460864784529575118",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40prime-haven-297509.iam.gserviceaccount.com"
    }
    ''';
  static const _spreadsheetId = "13FAHmtx12f8zy6G9aAI4NOF5c3vWQcOyHhh8lXWl6zg";

  GSheets gsheets = GSheets(_credentials);

  Future syncMatchScouts() async {
    Spreadsheet ss = await gsheets.spreadsheet(_spreadsheetId);
    Worksheet sheet = ss.worksheetByTitle("match_scouting");
  }
}
