import 'dart:io';


class AdMobService {


  String getAdMobAppId(){
    if(Platform.isAndroid){
      return "ca-app-pub-6899690535865894~6996903672";
    }else if(Platform.isIOS){
      return "ca-app-pub-8097359634602961~4709873451";
    }
    return null;
  }


  String getRewardedVidoAdId(){
    if(Platform.isAndroid){
      return "ca-app-pub-6899690535865894/1740174739";
    }else if(Platform.isIOS){
      return "ca-app-pub-8097359634602961/2083710119";
    }
    return null;
  }

  String getVipBannerAdId(){
    if(Platform.isAndroid){
      return "ca-app-pub-8097359634602961/4773500363";
    }else if(Platform.isIOS){
      return "ca-app-pub-8097359634602961/6477356479";
    }
    return null;
  }

  String getVipPlayListBannerAdId(){
    if(Platform.isAndroid){
      return "ca-app-pub-8097359634602961/9834255354";
    }else if(Platform.isIOS){
      return "ca-app-pub-8097359634602961/1033458101";
    }
    return null;
  }

  String getVideoPageBannerAdId(){
    if(Platform.isAndroid){
      return "ca-app-pub-8097359634602961/2338908714";
    }else if(Platform.isIOS){
      return "ca-app-pub-8097359634602961/7598866459";
    }
    return null;
  }


}
