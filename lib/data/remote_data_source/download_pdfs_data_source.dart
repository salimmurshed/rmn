import 'package:http/http.dart' as http;

class DownloadPdfsDataSource{
 static Future downloadAndSavePdf({required String url, required String fileName})async {
   try{
     print("------ $url");
     var response = await http.get(Uri.parse(url));
    print("**********");
     print(response);
     return response;
   }catch(e){
     print(e);
   }

  }
}