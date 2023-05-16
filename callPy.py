import subprocess
import win32pipe
import win32file

#MT4と名前付きパイプを連携し、何か書き込まれれば別PGM呼び出しするＰＧＭ。

def main():
    try:
        # 名前付きパイプの作成
        pipe = win32pipe.CreateNamedPipe(
            r'\\.\pipe\TestPipe',
            win32pipe.PIPE_ACCESS_DUPLEX,
            win32pipe. PIPE_TYPE_BYTE | win32pipe.PIPE_READMODE_BYTE | win32pipe.PIPE_WAIT,
            1, 256, 256, 0, None)
        # クライアントの接続を待つ
        win32pipe.ConnectNamedPipe(pipe, None)
        # バッファの準備
        s = b''
        # 無限ループ
        while True:
            # パイプから 1 文字読み取って
            hr, c = win32file.ReadFile(pipe, 1)
            # バッファに追加
            s += c
            # 改行文字を読んだら
            if c == b'\n':
                subprocess.run(["python", "./yolov7/detect3.py", "--source", "C:/Users/ryota/Documents/FX/ScreenShot_for_python", "--weights", "./yolov7/best_nnnn300.pt", "--conf", "0.1"], shell=True)
    except:
        print("エラー")

if __name__ == "__main__":
    main()
