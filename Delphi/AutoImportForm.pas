unit AutoImportForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Defs, ATUtils, UDPMessages, LoggerLib, Tables,
  Vcl.ExtCtrls;

const
  RETRY_COUNT = 3;

type
  TImportForm = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    ImportLog: TMemo;
    Timer: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    Wx, Wy: Integer;
    AutoClose, SaveRaw: Boolean;
    procedure DownloadNewData();
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImportForm: TImportForm;

procedure AutoImportNewData(X, Y: Integer; AutoClose, SaveRaw: Boolean);

implementation

{$R *.dfm}

procedure TImportForm.TimerTimer(Sender: TObject);
begin
  Close;
end;

procedure AutoImportNewData(X, Y: Integer; AutoClose, SaveRaw: Boolean);
begin
  Application.CreateForm(TImportForm, ImportForm);
  ImportForm.Wx := X;
  ImportForm.Wy := Y;
  ImportForm.AutoClose  := AutoClose;
  ImportForm.SaveRaw    := SaveRaw;

  ImportForm.Position := poDesigned; // Ensures Left/Top are respected

  ImportForm.ShowModal;

  ImportForm.Release;
end;

procedure TImportForm.DownloadNewData();
var
  S, Data, Path: String;
  RemDir, DataFile: TStringList;
  Fs: TFieldSet;
  Idx, FileDate, HashPos, FileRecs, DBRecs, Changes, Count: Integer;
  DataList: TWsDataList;
  OK: Boolean;
begin
  try
    Path := ExtractFilePath(Application.ExeName);
    if not DirectoryExists(Path + 'Raw') then
      CreateDir(Path + 'Raw');
    Path := Path + 'Raw';


    RemDir := TStringList.Create;
    DataFile := TStringList.Create;

//  get remote directory /Data
    Count := RETRY_COUNT;
    repeat
      OK := UDPGetRemDir(RemDir, True);
      Dec(Count);
    until OK or (Count = 0);

    if not OK and (Count = 0) then
    begin
      MessageDlg('Unable to get data directory from the logger!', mtWarning, [mbOK], 0);
      Exit;
    end else
    begin
//    Itterate through the entries from the most recent backwards.  Once
//    the record counts match then stop.
      Idx := RemDir.Count - 1; // most recent file (last in list)
      Changes := 0;

      repeat
        DBRecs := 0;
        DataFile.Clear;

//      get the data file and place in the stringlist
        Count := RETRY_COUNT;
        repeat
          OK := UDPGetFile(Remdir.Strings[Idx], '/Data/', Data, True);
          Dec(Count);
        until OK or (Count = 0);

        if OK and (Count = 0) then
        begin
          MessageDlg('Unable to get data from the logger!', mtWarning, [mbOK], 0);
          Exit;
        end;

        DataFile.Text := Data;
//      save raw data
        if SaveRaw then
          DataFile.SaveToFile(Path + '\' + ChangeFileExt(Remdir.Strings[Idx], '.raw'));

        if RemDir.Count > 0 then
        begin
//        process the file
          if Data.Length > 0 then
          begin
            HashPos := Pos('#', DataFile.Strings[0]);
            if HashPos > 0 then
            begin
//            set datalist length and fill it
              SetLength(DataList, DataFile.Count - 1);
              BuildDataList(DataFile, DataList);

//            get file date and record sizes
              FileDate := StrToInt(Copy(DataFile.Strings[0], HashPos + 1, 99));
//            DB record count for "FileDate"
              DBRecs := GetRecordCountForDay(__Config.DBPath, __Config.TableName, FileDate);
//            File record count for "DataFile"
              FileRecs := DataFile.Count - 1;

//            Import if there is more data in the DataFile than the database
              if FileRecs > DBRecs then
              begin
                ImportLog.Lines.Add(Format('%s - IMPORTING FILE', [DateTimeToStr(Now)]));
                ImportLog.Lines.Add(Format('File: %s  File Date: %d  Data Records: %d', [Remdir.Strings[Idx], FileDate, FileRecs]));

//              Import the data to the database
                S := ImportData(__Config.DBPath, __Config.TableName, DataList);

                ImportLog.Lines.Add(S);
                ImportLog.Lines.Add('-----------------------------------');
                Inc(Changes);
              end;
            end;
          end;
          Dec(Idx);
        end;
      until (FileRecs <= DBRecs) or (Idx < 0);
    end;

    if Changes = 0 then
      ImportLog.Lines.Add('No Import was necessary');

  finally
    ImportLog.Lines.Add('');
    ImportLog.Lines.Add('DONE');

    RemDir.Free;
  end;
end;


procedure TImportForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TImportForm.FormActivate(Sender: TObject);
begin
  ImportLog.Clear;
  Application.ProcessMessages;
//  run the import
  DownloadNewData();
  if AutoClose then
    Timer.Enabled := True;
end;

procedure TImportForm.FormShow(Sender: TObject);
begin
  SetBounds(Wx + 50, Wy + 250, ImportForm.Width, ImportForm.Height);
end;


end.
