var FindSubject = "signal alert";
function getMail(){

  //指定した件名のスレッドを検索して取得
  var myThreads = GmailApp.search(FindSubject, 0, 10);
  //スレッドからメールを取得し二次元配列に格納
  var myMessages = GmailApp.getMessagesForThreads(myThreads);

  var folder_id = ""; //  スクリーンショットが入っているフォルダーのID
  var folder_id2= ""; // 日足レベルの画像が入っているフォルダーのID

  var onlyFirstMail = 1;
// ここからメール内容をラインに送信
  for(var i in myMessages){
    for(var j in myMessages[i]){

      //スターがないメッセージのみ処理
      if(!myMessages[i][j].isStarred()){
        //処理済みのメッセージをスターをつける
        myMessages[i][j].star();
        if(!(onlyFirstMail))
        {
          //メールの1個目以外は何もしない
        }else if (onlyFirstMail) {
          onlyFirstMail = 0;
          var strDate　=　myMessages[i][j].getDate();
          var strSubject　=　myMessages[i][j].getSubject();
          var strMessage　=　myMessages[i][j].getPlainBody().slice(0,200);

          strDate += "\n\n";
          strSubject += "\n";
          var splitMess = strMessage.split("/");
          var joinMess = splitMess.join("\n");
          Logger.log(joinMess);
          mes = joinMess.slice(0, -1);
          //LINEにメッセージを送信
          sendLine("",strSubject, mes);

          // ここから画像送信============================================
          const files = DriveApp.getFolderById(folder_id).getFiles();

          var imageArray = [];
          var k = 0;
          var imageArray2 = [];
          while (files.hasNext()) {

            const file = files.next();
            file.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW);
            const filename = file.getName();

            const imageUrl = file.getUrl();
            const imageId = file.getId();
            const blob = file.getBlob()

            if(k == 0) {
              sendImage(filename, blob);
              k++;
            } else {
              sendImage(filename, blob);
            }

            // 1Dフォルダの画像を送信する処理
            const files2 = DriveApp.getFolderById(folder_id2).getFiles();
            while ( files2.hasNext()) {

              const file2 = files2.next();
              const filename2 = file2.getName();
              if (filename2.includes('W1')){
                if (filename.slice(0,6) === filename2.slice(0,6)) {
                    file2.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW);
                    const blob2 = file2.getBlob();
                    sendImage(filename2, blob2);
                    console.log("sOK")
                }
              }
            }
          }
        }
      }
    }
  }
}

//ラインメッセージを送るもの
function sendLine(strDate,strSubject,strMessage){
  strMessage.rstri

  var strToken = "";//Lineに送信するためのトークン
  var options =
   {
     "method"  : "post",
     "payload" : "message=" + strDate + strSubject + strMessage,
     "headers" : {"Authorization" : "Bearer "+ strToken}

   };

   UrlFetchApp.fetch("https://notify-api.line.me/api/notify",options);
}
//画像をラインに送る
function sendImage(name, image){

  //Lineに送信するためのトークン
  var strToken = "";
  var payload = {
   'message' : name,
   'imageFile' : image
  }

  var options =
   {
     "type"  : "post",
     "payload" : payload,
     "headers" : {"Authorization" : "Bearer "+ strToken}
   };

   UrlFetchApp.fetch("https://notify-api.line.me/api/notify",options);
}

//通知せずに画像を送る
function sendImage2(name, image){

  //Lineに送信するためのトークン
  var strToken = "";
  var payload = {
   'message' : name,
   'imageFile' : image
  }

  var options =
   {
     "type"  : "post",
     "payload" : payload,
     "notificationDisabled" : true,
     "headers" : {"Authorization" : "Bearer "+ strToken}
   };

   UrlFetchApp.fetch("https://notify-api.line.me/api/notify",options);
}
