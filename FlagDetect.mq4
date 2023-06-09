#property strict
//
//  ４ｈなどの水平ラインを消す、4h,1d,1wの時間軸の名前を消す
//
#property description "[DLLの使用を許可する]にチェックを入れてください。"

#property indicator_chart_window
#property strict

extern bool SoundON=true;
extern bool EmailON=true;

#include <Arrays\Array.mqh>
#include <Arrays\ArrayInt.mqh>
#include <Arrays\ArrayString.mqh>

#import "user32.dll"
   int GetWindowRect(int hWnd, int& rect[4]); 
#import "kernel32.dll"
   bool MoveFileW(string lpExistingFileName, string lpNewFileName);
#import "kernel32.dll"
   bool CopyFileW(string lpExistingFileName, string lpNewFileName, bool bFailIfExists);
#import


input ENUM_BASE_CORNER Corner = CORNER_RIGHT_LOWER;  //表示位置
input int InpX = 0; //横軸
input int InpY = 0; //縦軸
input int InpFontSize = 20;   //大きさ
input color InpColor = clrGray;  //色

extern int SMA1 = 100;
extern int SMA2 = 200;
extern int SMA3 = 10;
extern int SMA4 = 20;

extern color  LineColor = White;

extern int visible_time = OBJ_PERIOD_D1;

extern int scope = 250; // 水平ラインを引くために調べる範囲
extern int scope_4h = 10;


input string Pair1 = "USDJPY";   //通貨ペア1
input string Pair2 = "EURJPY";   //通貨ペア2
input string Pair3 = "GBPJPY";   //通貨ペア3
input string Pair4 = "AUDJPY";   //通貨ペア4
input string Pair5 = "CADJPY";   //通貨ペア5
input string Pair6 = "CHFJPY";   //通貨ペア6
input string Pair7 = "EURUSD";   //通貨ペア7
input string Pair8 = "GBPUSD";   //通貨ペア8
input string Pair9 = "AUDUSD";   //通貨ペア9
input string Pair10 = "USDCAD";  //通貨ペア10
input string Pair11 = "USDCHF";  //通貨ペア11
input string Pair12 = "SGDJPY";        //通貨ペア12
input string Pair13 = "NZDJPY";        //通貨ペア13
input string Pair14 = "EURAUD";        //通貨ペア14
input string Pair15 = "CADCHF";        //通貨ペア15
input string Pair16 = "EURGBP";        //通貨ペア16
input string Pair17 = "EURCAD";        //通貨ペア17
input string Pair18 = "EURCHF";        //通貨ペア18
input string Pair19 = "NZDUSD";        //通貨ペア19
input string Pair20 = "AUDCAD";        //通貨ペア20
input string Pair21 = "AUDCHF";        //通貨ペア21
input string Pair22 = "GBPAUD";        //通貨ペア22
input string Pair23 = "";        //通貨ペア23
input string Pair24 = "";        //通貨ペア24
input string Pair25 = "";        //通貨ペア25
input string Pair26 = "";        //通貨ペア26
input string Pair27 = "";        //通貨ペア27
input string Pair28 = "";        //通貨ペア28
input string Pair29 = "";        //通貨ペア29


input bool M1 = true;      //1分足
input bool M5 = true;      //5分足
input bool M15 = true;     //15分足
input bool M30 = true;     //30分足
input bool H1 = true;      //1時間足
input bool H4 = true;      //4時間足
input bool D1 = true;      //日足
input bool W1 = true;      //週足
input bool MN = true;      //月足


CArrayInt *arrayTime = new CArrayInt;
CArrayString *arrayPair = new CArrayString;


long	id = ChartFirst(); //最初のChartID
input string detect_txt_name = "mt4.txt";


enum extension{
   png,   //.gif
   gif   //.png
};
input extension exName = gif;   //拡張子



const string pipeName = "TestPipe";     // パイプ名。外部プログラムで作成した名前に合わせる。
int pipe = INVALID_HANDLE;

int init()
{
   LabelCreate("ScreenShot_Button", Corner, InpX, InpY, InpFontSize, InpColor);
   // 名前付きパイプを開く（接続する）。
   pipe = FileOpen("\\\\.\\pipe\\" + pipeName, FILE_WRITE | FILE_BIN | FILE_ANSI);
   if (pipe == INVALID_HANDLE) {
      Alert("Can't open pipe");
   }else{
      Alert("Okay open pipe");
   }
   
   
   if(M1) arrayTime.Add(PERIOD_M1);
   if(M5) arrayTime.Add(PERIOD_M5);
   if(M15) arrayTime.Add(PERIOD_M15);
   if(M30) arrayTime.Add(PERIOD_M30);
   if(H1) arrayTime.Add(PERIOD_H1);
   if(H4) arrayTime.Add(PERIOD_H4);
   if(D1) arrayTime.Add(PERIOD_D1);
   if(W1) arrayTime.Add(PERIOD_W1);
   if(MN) arrayTime.Add(PERIOD_MN1);
   if(!M1 && !M5 && !M15 && !M30 && !H1 && !H4 && !D1 && !W1 && !W1 && !MN) arrayTime.Add(0);

   arrayTime.Sort();

   if(SymbolSelect(Pair1, true)) arrayPair.Add(Pair1);
   if(SymbolSelect(Pair2, true)) arrayPair.Add(Pair2);
   if(SymbolSelect(Pair3, true)) arrayPair.Add(Pair3);
   if(SymbolSelect(Pair4, true)) arrayPair.Add(Pair4);
   if(SymbolSelect(Pair5, true)) arrayPair.Add(Pair5);
   if(SymbolSelect(Pair6, true)) arrayPair.Add(Pair6);
   if(SymbolSelect(Pair7, true)) arrayPair.Add(Pair7);
   if(SymbolSelect(Pair8, true)) arrayPair.Add(Pair8);
   if(SymbolSelect(Pair9, true)) arrayPair.Add(Pair9);
   if(SymbolSelect(Pair10, true)) arrayPair.Add(Pair10);
   if(SymbolSelect(Pair11, true)) arrayPair.Add(Pair11);
   if(SymbolSelect(Pair12, true)) arrayPair.Add(Pair12);
   if(SymbolSelect(Pair13, true)) arrayPair.Add(Pair13);
   if(SymbolSelect(Pair14, true)) arrayPair.Add(Pair14);
   if(SymbolSelect(Pair15, true)) arrayPair.Add(Pair15);
   if(SymbolSelect(Pair16, true)) arrayPair.Add(Pair16);
   if(SymbolSelect(Pair17, true)) arrayPair.Add(Pair17);
   if(SymbolSelect(Pair18, true)) arrayPair.Add(Pair18);
   if(SymbolSelect(Pair19, true)) arrayPair.Add(Pair19);
   if(SymbolSelect(Pair20, true)) arrayPair.Add(Pair20);
   if(SymbolSelect(Pair21, true)) arrayPair.Add(Pair21);
   if(SymbolSelect(Pair22, true)) arrayPair.Add(Pair22);
   if(SymbolSelect(Pair23, true)) arrayPair.Add(Pair23);
   if(SymbolSelect(Pair24, true)) arrayPair.Add(Pair24);
   if(SymbolSelect(Pair25, true)) arrayPair.Add(Pair25);
   if(SymbolSelect(Pair26, true)) arrayPair.Add(Pair26);
   if(SymbolSelect(Pair27, true)) arrayPair.Add(Pair27);
   if(SymbolSelect(Pair28, true)) arrayPair.Add(Pair28);
   if(SymbolSelect(Pair29, true)) arrayPair.Add(Pair29);


   if(id == ChartID()){
      id = ChartNext(id);
   }

   return(INIT_SUCCEEDED);
}

void deinit(const int reason)
{
   // パイプを閉じる。
   FileClose(pipe);
}


inline string ReadLine(int file)
{
   string s;
   printf("start ReadLine");
   while (1)
   {
      //printf("start FileRead");
      string c = FileReadString(file, 1);
      s += c;
      if (c == "\n") break;
   } 
   
   return s;
}

int gVolumeBak = 0;
int Periods = 1; // バーが生成されてスクショコードへと実行が進むたびにインクリメントされる。目的としては5分足は30分に一回、15分足は1時間に一回、30分足は2時間に一回スクショをとって検出すればいいとおもったから。
bool onlySet = True;
int start()
{
  if ((Volume[0] < gVolumeBak) || onlySet) {
   //バーの始まりで1回だけ処理したい内容をここに記載する
     Alert("hoge");
     printf(onlySet);
     onlySet = False;
     //=====================================================================================
     int total = arrayPair.Total();
     if(total <= 0) return(0);

     int nowIndex = -1;
     int i, j;               
     double tmp=0;
     double sma1, sma2, sma3, sma4; //******************************************************            
                 
     double price;
     int    supportCnt=0; // いくつのポイントがラインを支えているか。始点を除く
     string obj_name = "HHL";
     string obj_name2 = "LHL";                
     int    chart_id = 0;
     int    tlCnt=1;    // 初めにTLを作るときに使用したりするカウント（仮のカウント
     int    tlCnt2=1;   // TLの名前を変えるの時に使用する数のカウント                  
      
     for(int i=0; i<total; i++){
       if(arrayPair.At(i) == ChartSymbol(id)){
          nowIndex = i;
          break;
       }
     }
      static datetime ssTime;
      if(ssTime == TimeLocal()){
         ObjectSetInteger(0, "ScreenShot_Button", OBJPROP_SELECTED, true);
         return(0);
      }
      else ssTime = TimeLocal();
      
      int x = (int)ObjectGet("ScreenShot_Button", OBJPROP_XDISTANCE);
      int y = (int)ObjectGet("ScreenShot_Button", OBJPROP_YDISTANCE);
      
      ObjectDelete("ScreenShot_Button");
      
      int hWnd = WindowHandle(id, 0);
      
      int rect[4];
      GetWindowRect(hWnd, rect);
      
      int width = rect[2] - rect[0];
      int height = rect[3] - rect[1];

      
      string date = TimeToStr(TimeLocal(), TIME_DATE);
      string hour = StringSubstr(TimeToStr(TimeLocal(), TIME_SECONDS), 0, 2);
      string min = StringSubstr(TimeToStr(TimeLocal(), TIME_SECONDS), 3, 2);
      string sec = StringSubstr(TimeToStr(TimeLocal(), TIME_SECONDS), 6, 2);
      
      string suffix;
      switch(exName){
         case 0: suffix = ".gif"; break;
         case 1: suffix = ".png"; break;
         default: suffix = ".gif"; break;
      }
      
      string TimeFrameName;
      int nextPeriod;
      
      for (int i=0; i<4; i++) {
                
         switch(i){
            case 0: ChartSetSymbolPeriod(id, ChartSymbol(id), PERIOD_M5);nextPeriod = PERIOD_M5; break;
            case 1: ChartSetSymbolPeriod(id, ChartSymbol(id), PERIOD_M15);nextPeriod = PERIOD_M15; break;
            case 2: ChartSetSymbolPeriod(id, ChartSymbol(id), PERIOD_M30);nextPeriod = PERIOD_M30;break; 
            case 3: ChartSetSymbolPeriod(id, ChartSymbol(id), PERIOD_H4);nextPeriod = PERIOD_H4;break; 
            default: TimeFrameName = "("+IntegerToString(Period())+")"; break;
         }
        
         for (int k = 0; k < total; k++){
            ChartSetInteger(id, CHART_MODE, CHART_LINE);
            
            printf("PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");
            switch(ChartPeriod(id)){
            case 1: TimeFrameName = "(M1)"; break;
            case 5: TimeFrameName = "(M5)"; break;
            case 15: TimeFrameName = "(M15)"; break;
            case 30: TimeFrameName = "(M30)"; break;
            case 60: TimeFrameName = "(H1)"; break;
            case 240: TimeFrameName = "(aH4)"; break;
            case 1440: TimeFrameName = "(D1)"; break;
            case 10080: TimeFrameName = "(W1)"; break;
            case 43200: TimeFrameName = "(MN1)"; break;     
            default: TimeFrameName = "("+IntegerToString(Period())+")"; break;
           }
            string fileName = ChartSymbol(id)+TimeFrameName +suffix;
            string chartSymbol = ChartSymbol(id)+TimeFrameName;
   
            printf("fileName:" + fileName);
            
            int chartVisibleBars = (int)ChartGetInteger(id,CHART_VISIBLE_BARS, 0); 
            int chartFirstVisibleBar = (int)ChartGetInteger(id, CHART_FIRST_VISIBLE_BAR, 0);
            
            
            //===================================================================================================
            //======= ここからスクショする
            //====================================================================================================
            
            int total = arrayPair.Total();
            if(total <= 0) return(0);
      
            int nowIndex = -1;              
      
            for(int m=0; m<total; m++){
               if(arrayPair.At(m) == ChartSymbol(id)){
                  nowIndex = m;
                  break;
               }
            }               
            string dataPath = TerminalInfoString(TERMINAL_DATA_PATH);
            string filePath = dataPath+"\\MQL4\\Files\\";
            bool ssFlag;
            string desktopPath = StringSubstr(dataPath, 0, StringFind(dataPath, "AppData"))+"スクリーンショット保存フォルダ名";
            
            if (i == 3 ){
               desktopPath = StringSubstr(dataPath, 0, StringFind(dataPath, "AppData"))+"日足のスクリーンショット保存フォルダ名";
            }
            
            bool CreateFlag;
            ////////////////////////////////
            //   テキスト表示処理
            ///////////////////////////////         
            if(chartVisibleBars > chartFirstVisibleBar) ssFlag=ChartScreenShot(id, fileName, 1700, 600, ALIGN_RIGHT);
            else ssFlag = ChartScreenShot(id, fileName, 1700, 600, ALIGN_LEFT);               
                                  
            CopyFileW(filePath + fileName, desktopPath + fileName, False);                        

            CreateFlag = MoveFileW(filePath + fileName, desktopPath + fileName);         
            if (!(CreateFlag)) {
               string tmpPath = StringSubstr(dataPath, 0, StringFind(dataPath, "AppData"))+"スクリーンショット保存フォルダ名";               
               MoveFileW(filePath + date, tmpPath + date);
               CopyFileW(filePath + fileName, desktopPath + fileName, False);
            }
            LabelCreate("ScreenShot_Button", Corner, x, y, InpFontSize, InpColor);      


            ObjDelete(id, "a");
            
            int nextTF;
            switch(ChartPeriod(id)){
            case 5: nextTF=PERIOD_M15; break;
            case 15: nextTF=PERIOD_M30; break;
            case 30: nextTF=PERIOD_H4; break;               
            case 60: nextTF=PERIOD_H4; break;
            case 240: nextTF=1440; break;
            case 1440: nextTF=10080; break;
            case 10080: nextTF=43200; break;   
            default: nextTF=nextPeriod;; break;
           }
            
            sma1 = iMA(ChartSymbol(id), nextTF, SMA1, 0, MODE_SMA, PRICE_CLOSE, 0);
            sma2 = iMA(ChartSymbol(id), nextTF, SMA2, 0, MODE_SMA, PRICE_CLOSE, 0);
            sma3 = iMA(ChartSymbol(id), nextTF, SMA3, 0, MODE_SMA, PRICE_CLOSE, 0);
            sma4 = iMA(ChartSymbol(id), nextTF, SMA4, 0, MODE_SMA, PRICE_CLOSE, 0);
             
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////           １Dと１Wのスクショ処理
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            

            ChartSetInteger(id, CHART_MODE, CHART_CANDLES); //============================= line => candle
            ChartSetSymbolPeriod(id, ChartSymbol(id), PERIOD_D1);
            TimeFrameName = "(D1)";
            fileName = ChartSymbol(id)+TimeFrameName+suffix;
            chartSymbol = ChartSymbol(id)+TimeFrameName;

            chartVisibleBars = (int)ChartGetInteger(0,CHART_VISIBLE_BARS, 0);
            chartFirstVisibleBar = (int)ChartGetInteger(0, CHART_FIRST_VISIBLE_BAR, 0);
            if(chartVisibleBars > chartFirstVisibleBar) ssFlag = ChartScreenShot(id, fileName, 1700, 600, ALIGN_LEFT); 
            else ssFlag = ChartScreenShot(id, fileName, 1700, 600, ALIGN_LEFT);                                        

            printf(ssFlag);
            
            desktopPath = StringSubstr(dataPath, 0, StringFind(dataPath, "AppData"))+"日足のスクリーンショット保存フォルダ名";
            CopyFileW(filePath + fileName, desktopPath + fileName, False);
            ObjDelete(id, "a");          
                      
            //=========================================================================================================================================
            ChartSetSymbolPeriod(id, ChartSymbol(id), PERIOD_W1);
            TimeFrameName = "(W1)";
            fileName = ChartSymbol(id)+TimeFrameName+suffix;
            chartSymbol = ChartSymbol(id)+TimeFrameName;

            chartVisibleBars = (int)ChartGetInteger(0,CHART_VISIBLE_BARS, 0);
            chartFirstVisibleBar = (int)ChartGetInteger(0, CHART_FIRST_VISIBLE_BAR, 0);
            if(chartVisibleBars > chartFirstVisibleBar) ssFlag = ChartScreenShot(id, fileName, 1700, 600, ALIGN_LEFT);
            else ssFlag = ChartScreenShot(id, fileName, 1700, 600, ALIGN_LEFT);

            printf(ssFlag);
            
            desktopPath = StringSubstr(dataPath, 0, StringFind(dataPath, "AppData"))+"日足のスクリーンショット保存フォルダ名";
            CopyFileW(filePath + fileName, desktopPath + fileName, False);
            
            //=========================================================================================================================================
            
            ObjDelete(id, "a");

            HLDelete(id, obj_name, obj_name2);
         
            if(nowIndex == -1 || nowIndex == 0) ChartSetSymbolPeriod(id, arrayPair.At(total-1), nextPeriod);
            else ChartSetSymbolPeriod(id, arrayPair.At(nowIndex-1), nextPeriod);
         }
      }

      
         
     //=========================================================================================
     // ここからPython実行するための準備処理
     //=========================================================================================
      // 文字列をパイプに書き込む。      
      FileWriteString(pipe, "1" + "\r\n");           
  
      int file = INVALID_HANDLE;
      file  = FileOpen(detect_txt_name, FILE_READ | FILE_WRITE | FILE_BIN);
      
      if (file == INVALID_HANDLE) {
         printf("Can't open pipe");
      }
      string s;
      string c;         
      c = FileReadString(file, 1);
      if (c == "1") {
         printf(c);
         string pair;
         while (1)
         {            
            c = FileReadString(file, 1);
            s += c;
            if (c == "\n") break;
         }
         printf(s);
         if (SoundON) Alert("signal at Ask=",Ask,"\n Bid=",Bid,"\n Date=",TimeToStr(CurTime(),TIME_DATE)," ",TimeHour(CurTime()),":",TimeMinute(CurTime()),"\n Symbol=",Symbol()," Period=",Period());
         if (EmailON) SendMail("signal alert",s);
         FileWrite(file,"0");
      }
      FileClose(file);   
   //初期化
     gVolumeBak = 0;
  } else {
   //今のVolume[0]をセット
     gVolumeBak = Volume[0];
  }
  return (0);
}


void LabelCreate(string Label_name, int pos_corner, int pos_x, int pos_y, int font_size, color text_color){

   if(ObjectFind(Label_name) != 0){
      ObjectCreate(Label_name, OBJ_LABEL, 0, 0, 0);
      ObjectSetText(Label_name, "<", font_size, "Wingdings", text_color);
      ObjectSet(Label_name, OBJPROP_CORNER, pos_corner);
      ObjectSet(Label_name, OBJPROP_XDISTANCE, pos_x);
      ObjectSet(Label_name, OBJPROP_YDISTANCE, pos_y);
   }
   else{
      ObjectSet(Label_name, OBJPROP_CORNER, pos_corner);
      ObjectSet(Label_name, OBJPROP_XDISTANCE, pos_x);
      ObjectSet(Label_name, OBJPROP_YDISTANCE, pos_y);
   }
   
   WindowRedraw();
   
}



void createHoriLine(long chart_id, string obj_name, string obj_name2, double max_high, double max_low, int visible_time, color LineColor)
{
    ObjectCreate(chart_id, obj_name,                                          // オブジェクト作成
                       OBJ_HLINE,                                             // オブジェクトタイプ
                       0,                                                     // サブウインドウ番号
                       0,                                                     // 1番目の時間のアンカーポイント
                       max_high                                               // 1番目の価格のアンカーポイント
    );
          
    ObjectSetInteger(chart_id,obj_name,OBJPROP_COLOR,LineColor);  // ラインの色設定
    ObjectSetInteger(chart_id,obj_name,OBJPROP_STYLE,STYLE_SOLID);// ラインのスタイル設定
    ObjectSetInteger(chart_id,obj_name,OBJPROP_WIDTH,1);          // ラインの幅設定
    ObjectSetInteger(chart_id,obj_name,OBJPROP_BACK,false);       // オブジェクトの背景表示設定
    ObjectSetInteger(chart_id,obj_name,OBJPROP_SELECTABLE,true);  // オブジェクトの選択可否設定
    ObjectSetInteger(chart_id,obj_name,OBJPROP_SELECTED,false);   // オブジェクトの選択状態
    ObjectSetInteger(chart_id,obj_name,OBJPROP_HIDDEN,false);     // オブジェクトリスト表示設定
    ObjectSetInteger(chart_id,obj_name,OBJPROP_ZORDER,0);         // オブジェクトのチャートクリックイベント優先順位         
    ObjectSetInteger(chart_id,obj_name,OBJPROP_RAY_RIGHT,true);   // ラインの延長線(右)
    ObjectSetInteger(chart_id,obj_name , OBJPROP_TIMEFRAMES , visible_time);
    
   
   
    ObjectCreate(chart_id ,obj_name2,                                         // オブジェクト作成
                       OBJ_HLINE,                                             // オブジェクトタイプ
                       0,                                                     // サブウインドウ番号
                       0,                                                     // 1番目の時間のアンカーポイント
                       max_low                                                // 1番目の価格のアンカーポイント
    );
          
    ObjectSetInteger(chart_id,obj_name2,OBJPROP_COLOR,LineColor);  // ラインの色設定
    ObjectSetInteger(chart_id,obj_name2,OBJPROP_STYLE,STYLE_SOLID);// ラインのスタイル設定
    ObjectSetInteger(chart_id,obj_name2,OBJPROP_WIDTH,1);          // ラインの幅設定
    ObjectSetInteger(chart_id,obj_name2,OBJPROP_BACK,false);       // オブジェクトの背景表示設定
    ObjectSetInteger(chart_id,obj_name2,OBJPROP_SELECTABLE,true);  // オブジェクトの選択可否設定
    ObjectSetInteger(chart_id,obj_name2,OBJPROP_SELECTED,false);   // オブジェクトの選択状態
    ObjectSetInteger(chart_id,obj_name2,OBJPROP_HIDDEN,false);     // オブジェクトリスト表示設定
    ObjectSetInteger(chart_id,obj_name2,OBJPROP_ZORDER,0);         // オブジェクトのチャートクリックイベント優先順位         
    ObjectSetInteger(chart_id,obj_name2,OBJPROP_RAY_RIGHT,true);   // ラインの延長線(右)
    ObjectSetInteger(chart_id,obj_name , OBJPROP_TIMEFRAMES , visible_time);
}


void HLDelete(long   chart_ID,   // chart's ID
              string obj_name, // line name
              string obj_name2)
{
//--- delete a horizontal line
   ObjectDelete(chart_ID,obj_name);
   ObjectDelete(chart_ID,obj_name2);
}

void ObjCreate(long chart_id, string obj_name, string dip_text){
   ObjectCreate(chart_id,obj_name,                                     // オブジェクト作成
                 OBJ_LABEL,                                             // オブジェクトタイプ
                 0,                                                       // サブウインドウ番号
                 0,                                                       // 1番目の時間のアンカーポイント
                 0                                                        // 1番目の価格のアンカーポイント
                 );
    
    ObjectSetInteger(chart_id,obj_name,OBJPROP_COLOR,clrYellow);    // 色設定

    ObjectSetInteger(chart_id,obj_name,OBJPROP_BACK,false);           // オブジェクトの背景表示設定
    ObjectSetInteger(chart_id,obj_name,OBJPROP_SELECTABLE,true);     // オブジェクトの選択可否設定
    ObjectSetInteger(chart_id,obj_name,OBJPROP_SELECTED,true);      // オブジェクトの選択状態
    ObjectSetInteger(chart_id,obj_name,OBJPROP_HIDDEN,true);         // オブジェクトリスト表示設定
    ObjectSetInteger(chart_id,obj_name,OBJPROP_ZORDER,0);     // オブジェクトのチャートクリックイベント優先順位


    ObjectSetDouble(chart_id,obj_name,OBJPROP_ANGLE,0);               // 角度

    ObjectSetString(chart_id,obj_name,OBJPROP_TEXT,dip_text);    // 表示するテキスト
    ObjectSetString(chart_id,obj_name,OBJPROP_FONT,"ＭＳ　ゴシック");  // フォント

    ObjectSetInteger(chart_id,obj_name,OBJPROP_FONTSIZE,16);                   // フォントサイズ
    ObjectSetInteger(chart_id,obj_name,OBJPROP_CORNER,CORNER_RIGHT_LOWER);  // コーナーアンカー設定
    ObjectSetInteger(chart_id,obj_name,OBJPROP_XDISTANCE,200);                // X座標
    ObjectSetInteger(chart_id,obj_name,OBJPROP_YDISTANCE,0);                 // Y座標

    // オブジェクトバインディングのアンカーポイント設定
    ObjectSetInteger(chart_id,obj_name,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);  

}

void ObjDelete(long   chart_ID,   // chart's ID
              string obj_name) // line name)
{
//--- delete a horizontal line
   ObjectDelete(chart_ID,obj_name);
}