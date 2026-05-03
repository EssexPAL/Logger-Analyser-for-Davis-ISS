unit Tables;

interface

uses
  Sharemem,
  Vcl.StdCtrls, Vcl.CheckLst, Vcl.ComCtrls, Vcl.Forms, Vcl.Graphics,
  System.Classes, System.SysUtils, Data.DB, dbisamtb, Winapi.Windows,
  System.Types, Defs, VirtualTrees,
  Average, Vcl.Dialogs;

const
  BP_LOWEST_EVER = 870;
  FIELDNAMES: array [0..9] of String = ('wsDate',     'wsTime',     'wsWindDir',
                                        'wsWindAvr',  'wsWindPk',   'wsTemp',
                                        'wsHumidity', 'wsRainDay',  'wsRainHour',
                                        'wsPressure');
//{$define USEDLL}
//{$ifdef USEDLL}
{
function  GetHighestDate(DBName: String; TableName: String): Integer; stdcall;
function  LoadData(DBName, TableName: String;  Qd: pQd; var Ax: TAxes; Log: TStrings = nil): Integer; stdcall;
procedure CheckTable(DBName: String; TableName: String); stdcall;
procedure EmptyTable(DBName, TableName: String); stdcall;
function  OldImportData(DBName, TableName, FileName: String): String; stdcall;
function  ImportData(DBName, TableName: String; Data: TWsDataList): String; stdcall;
function  LoadMaxMinData(DBName, TableName: String; var Ax: Taxes; var PlotBuffer: TDualPlotBuffer): Integer; stdcall;
function  LoadRainData(DBName, TableName: String; Qd: pQd; var Ax: Taxes): Integer; stdcall;
function  LoadRainDataHourly(DBName, TableName: String; Qd: pQd; var Ax: Taxes): Integer; stdcall;
function  LoadLastDataPeriod(DBName, TableName: String; Qd: pQd; var Ax: Taxes; InfoBuffer: TStringList): Integer; stdcall;
function  LoadPolarData(DBName, TableName: String; Ax: TAxes; var Pi: TPolarInfo): Integer; stdcall;
function  LoadWindData(DBName, TableName: String; Ax: TAxes; var Si: TSegmentInfo; InfoBuffer: TStringList): Integer; stdcall;
procedure AddTableData(DBName, TableName: String; Date: Word; STime, ETime: DWord; List: TVirtualStringTree; Order: Integer = -1); stdcall;
function  GetDataCount(DBName, TableName: String): Integer; stdcall;
function  GetHighestTime(DBName: String; TableName: String; TheDate: Integer): Integer; stdcall;
function  GetRecordCountForDay(DBName: String; TableName: String; TheDate: Integer): Integer; stdcall;
}
//{$else}
function  GetHighestDate(DBName: String; TableName: String): Integer; stdcall; external 'WsIsam.dll';
function  LoadData(DBName, TableName: String;  Qd: pQd; var Ax: TAxes; Log: TStrings = nil): Integer; stdcall;  external 'WsIsam.dll';
procedure CheckTable(DBName: String; TableName: String); stdcall;  external 'WsIsam.dll';
procedure EmptyTable(DBName, TableName: String); stdcall;  external 'WsIsam.dll';
function  ImportData(DBName, TableName: String; Data: TWsDataList): String; stdcall; external 'WsIsam.dll';
function  LoadMaxMinData(DBName, TableName: String; var Ax: Taxes; var PlotBuffer: TDualPlotBuffer): Integer; stdcall;  external 'WsIsam.dll';
function  LoadRainData(DBName, TableName: String; Qd: pQd; var Ax: Taxes): Integer; stdcall;  external 'WsIsam.dll';
function  LoadRainDataHourly(DBName, TableName: String; Qd: pQd; var Ax: Taxes): Integer; stdcall;  external 'WsIsam.dll';
function  LoadLastDataPeriod(DBName, TableName: String; Qd: pQd; var Ax: Taxes; InfoBuffer: TStringList): Integer; stdcall;  external 'WsIsam.dll';
function  LoadPolarData(DBName, TableName: String; Ax: TAxes; var Pi: TPolarInfo): Integer; stdcall;  external 'WsIsam.dll';
function  LoadWindData(DBName, TableName: String; Ax: TAxes; var Si: TSegmentInfo; InfoBuffer: TStringList): Integer; stdcall; external 'WsIsam.dll';
procedure AddTableData(DBName, TableName: String; Date: Word; STime, ETime: DWord; List: TVirtualStringTree; Order: Integer = -1); stdcall;  external 'WsIsam.dll';
function  GetDataCount(DBName, TableName: String): Integer; stdcall;  external 'WsIsam.dll';
function  GetDLLVer: Integer ; stdcall;  external 'WsIsam.dll';

//  {$endif}

implementation

  uses LoggerLib;

end.

