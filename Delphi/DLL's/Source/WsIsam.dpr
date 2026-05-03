library WsIsam ;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  ShareMem,
  System.SysUtils,
  System.Classes,
  System.Types,
  Math,
  VirtualTrees,
  at_gen_utils,
  Data.DB,
  dbisamtb,
  Vcl.Dialogs,
  Tables,
  Average in  '..\Common\Average.pas',
  Defs in     '..\Common\Defs.pas',
  ATUtils in  '..\Common\ATUtils.pas';

{$R *.res}

(* Get the highest date in the database or return -1 if there are no records *)

exports
  GetHighestDate,
  LoadData,
  CheckTable,
  EmptyTable,
  ImportData,
  LoadMaxMinData,
  LoadRainData,
  LoadLastDataPeriod,
  LoadPolarData,
  LoadWindData,
  AddTableData,
  GetDataCount,
  GetRecordCountForDay,
  GetDLLVer,
  SetRecord;

begin
end.
