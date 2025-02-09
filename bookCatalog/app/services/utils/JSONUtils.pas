unit JSONUtils;

{
  ������: JSONUtils
  �����: ������ �.�. (������)
  ������: ���������� ���������
  ��������: Freeware
  ������: 1.6.0
  ���� ��������: 2025-02-16

  ��������:
    ������ JSONUtils ������������� ������� ��� ������ � JSON-�������.
    �������� � ���� ������� ��� ���������� ����� � JSON-��������,
    ����������� ��������� ��������� ��������, � ����� ������ ��������������� ��������.

  ������� ���������:
    [2025-02-08] ������ ������ � �������� ���������� JSON-�����.
    [2025-02-09] ��������� ����������� ��������� ��������� �������� � ��������.
    [2025-02-10] ���������� ������, ��������� � ���������� ���������� ������.
    [2025-02-11] �������� ������������������ ���������� ��� ������� JSON-��������.
    [2025-02-12] ������ 1.3.1: ����������� ������������� ������ � ��������� ���������� ����.
    [2025-02-13] ������ 1.4.0: �������� ��������� ������� SortJSONFields ��� �������� ������.
    [2025-02-14] ������ 1.5.0: �������� ������� SortJSONFields ��� ������ �� ��������.
    [2025-02-15] ������ 1.5.1: ���������� ������ � ���������� � ���������� ������� SortJSONValue.
    [2025-02-16] ������ 1.6.0: ��������� ��������� ���������� �������� � ���������� ������ �����.
}

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections, System.Generics.Defaults;

{ ��������� ���� � JSON-������� � ���������� �������, �������� ��������� �������� ��� ����������.
  ���������� ������������ ��������� ������� � �������.
  ��������� � ���������� JSON � ���� ������. }
function SortJSONFields(const JSONObject: string): string;

{ ��������������� ����������� ������� ��� ���������� }
function SortJSONValue(const Value: TJSONValue): TJSONValue;

{ ��������������� ������� ��� ���������� �������� }
function SortJSONArray(const ArrayValue: TJSONArray): TJSONArray;

implementation

function SortJSONValue(const Value: TJSONValue): TJSONValue;
var
  Obj: TJSONObject;
  Arr: TJSONArray;
  Pair: TJSONPair;
  Element: TJSONValue;
  SortedObj: TJSONObject;
  SortedArr: TJSONArray;
  KeyMap: TDictionary<string, TJSONValue>;
  SortedKeys: TArray<string>;
begin
  if Value is TJSONObject then
  begin
    Obj := Value as TJSONObject;
    SortedObj := TJSONObject.Create;
    try
      KeyMap := TDictionary<string, TJSONValue>.Create;
      try
        for Pair in Obj do
          KeyMap.AddOrSetValue(Pair.JsonString.Value, SortJSONValue(Pair.JsonValue));

        SortedKeys := KeyMap.Keys.ToArray;
        TArray.Sort<string>(SortedKeys, TComparer<string>.Construct(
          function(const Left, Right: string): Integer
          begin
            Result := CompareText(Left, Right);
          end
        ));

        for var Key in SortedKeys do
          SortedObj.AddPair(Key, KeyMap[Key]);

        Result := SortedObj;
      finally
        KeyMap.Free;
      end;
    except
      SortedObj.Free;
      raise;
    end;
  end
  else if Value is TJSONArray then
  begin
    Arr := Value as TJSONArray;
    SortedArr := TJSONArray.Create;
    try
      for Element in Arr do
      begin
        if Element is TJSONObject then
          SortedArr.AddElement(SortJSONValue(Element))
        else
          SortedArr.AddElement(TJSONValue(Element.Clone));
      end;
      Result := SortedArr;
    except
      SortedArr.Free;
      raise;
    end;
  end
  else
  begin
    Result := TJSONValue(Value.Clone);
  end;
end;

function SortJSONArray(const ArrayValue: TJSONArray): TJSONArray;
var
  SortedArray: TJSONArray;
  Element: TJSONValue;
begin
  SortedArray := TJSONArray.Create;
  try
    for Element in ArrayValue do
    begin
      if Element is TJSONObject then
        SortedArray.AddElement(SortJSONValue(Element))
      else
        SortedArray.AddElement(TJSONValue(Element.Clone)); // ���������� ���������� ����
    end;
    Result := SortedArray;
  except
    SortedArray.Free;
    raise;
  end;
end;

function SortJSONFields(const JSONObject: string): string;
var
  JSONValue: TJSONValue;
begin
  if Assigned(JSONValue) then
  begin
  JSONValue := TJSONObject.ParseJSONValue(JSONObject);
    try
      if JSONValue is TJSONObject then
      begin
        Result := SortJSONValue(JSONValue).ToString;
      end
      else if JSONValue is TJSONArray then
      {
        ����� �� ������ ���������� ����������� ������ ������ � �������.
        ���� �������� ������� �� �������� ���������, �� ������ ���������� ������ ��� ����.
      }
      begin
        Result := SortJSONArray(JSONValue as TJSONArray).ToString;
      end
      else
      {
        ���� ������� ������ �� �������� JSON-�������� ��� ��������, ���������� � ��� ����.
        � ������ ������, ��� ����� ���� ������, �����, ���������� �������� � �.�.
      }
      begin
        Result := JSONObject;
      end;
    finally
      JSONValue.Free;
    end;
  end
  else
  begin
    // ���� ������� �� ������, ���������� ������ ������
    Result := '';
  end;
end;

end.
