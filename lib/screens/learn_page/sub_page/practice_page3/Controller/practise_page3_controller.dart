import 'package:camera/camera.dart';
import 'package:how_to_use_provider/models/data_models/data_learn_model.dart';
import 'package:how_to_use_provider/services/api_services.dart';

class PractisePage3Controller {

  Future<bool?> checkAnswer(XFile image, DataLearnModel data) async{
    final apiService = ApiServices();
    String? answer = await apiService.postCapturedImage(image);

    if (answer != null){
      if(answer.toLowerCase() == data.word.word.toLowerCase()){
        return true; 
      }else{
        return false; 
      }
    }else{
      return null; 
    }
  }
  
}