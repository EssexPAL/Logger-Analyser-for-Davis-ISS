unit ATUtils;

interface

uses
  ShareMem,
  System.SysUtils,
  Dialogs;

type
  TFieldSet = record
    Count: Integer;
    Fields: array of String;
  end;

function  CSVToText(Input: String; var Output: TFieldSet; FieldSep: Char; IgnoreEmptyFields: Boolean = True): Integer;
function  Get_File_Size(Filename: String): Integer;

implementation

function Get_File_Size(Filename: String): Integer;
var
  f: file of byte;
  fs: Integer;
begin
  AssignFile(f, FileName);
  Reset(f);
  fs := FileSize(f);
  CloseFile(f);
end;

function CSVToText(Input: String; var Output: TFieldSet; FieldSep: Char; IgnoreEmptyFields: Boolean = True): Integer;
var
  Len, Last, Curr, Idx: Integer;
begin
  SetLength(Output.Fields, 0);
  Output.Count := 0;
  Result := 0;

  Len := Length(Input);

  // If the length of Input is greater than zero then there must be at least one field
  if Len > 0 then
  begin
    Last := 1; // starting point of the current string
    Idx := 0; // array index
    repeat

{$IFDEF VER210}
      Curr := PosEx(FieldSep, Input, Last);
{$ELSE}
      Curr := Pos(FieldSep, Input, Last);
{$ENDIF}
      SetLength(Output.Fields, Idx + 1);
      Output.Fields[Idx] := '';

      if Curr > 0 then
        Output.Fields[Idx] := Trim(Copy(Input, Last, Curr - Last))
      else // last field in string
        Output.Fields[Idx] := Trim(Copy(Input, Last, Len - Last + 1));

      Last := Curr + 1; // skip the delimiter

      // If a field is empty then skip it
      if not IgnoreEmptyFields or (Output.Fields[Idx] <> '') then
        Inc(Idx);

    until Curr = 0;

    Result := Length(Output.Fields);
    Output.Count := Result;
  end;
end;

end.
