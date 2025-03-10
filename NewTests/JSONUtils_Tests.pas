unit JSONUtils_Tests;

interface

uses
  DUnitX.TestFramework,
  JSONUtils,
  System.SysUtils,
  System.JSON;

type
  [TestFixture]
  TJSONUtilsTests = class
  public
    [Test]
    procedure TestSortJSONFields_SimpleObject;
    [Test]
    procedure TestSortJSONFields_NestedObject;
    [Test]
    procedure TestSortJSONFields_ArrayOfObjects;
    [Test]
    procedure TestSortJSONFields_SimpleArray;
    [Test]
    procedure TestSortJSONFields_InvalidJSON;
  end;

implementation

{ TJSONUtilsTests }

procedure TJSONUtilsTests.TestSortJSONFields_SimpleObject;
var
  InputJSON, ExpectedJSON, SortedJSON: string;
begin
  InputJSON := '{"b":2,"a":1,"c":3}';
  ExpectedJSON := '{"a":1,"b":2,"c":3}';
  SortedJSON := SortJSONFields(InputJSON);
  Assert.AreEqual(ExpectedJSON, SortedJSON, 'Simple JSON object sorting failed');
end;

procedure TJSONUtilsTests.TestSortJSONFields_NestedObject;
var
  InputJSON, ExpectedJSON, SortedJSON: string;
begin
  InputJSON := '{"b":{"d":4,"c":3},"a":1}';
  ExpectedJSON := '{"a":1,"b":{"c":3,"d":4}}';
  SortedJSON := SortJSONFields(InputJSON);
  Assert.AreEqual(ExpectedJSON, SortedJSON, 'Nested JSON object sorting failed');
end;

procedure TJSONUtilsTests.TestSortJSONFields_ArrayOfObjects;
var
  InputJSON, ExpectedJSON, SortedJSON: string;
begin
  InputJSON := '[{"b":2,"a":1},{"d":4,"c":3}]';
  ExpectedJSON := '[{"a":1,"b":2},{"c":3,"d":4}]';
  SortedJSON := SortJSONFields(InputJSON);
  Assert.AreEqual(ExpectedJSON, SortedJSON, 'Array of JSON objects sorting failed');
end;

procedure TJSONUtilsTests.TestSortJSONFields_SimpleArray;
var
  InputJSON, ExpectedJSON, SortedJSON: string;
begin
  InputJSON := '[3,1,2]';
  ExpectedJSON := '[3,1,2]'; // ������� ���������� �� �����������
  SortedJSON := SortJSONFields(InputJSON);
  Assert.AreEqual(ExpectedJSON, SortedJSON, 'Simple array sorting failed');
end;

procedure TJSONUtilsTests.TestSortJSONFields_InvalidJSON;
var
  InputJSON, SortedJSON: string;
begin
  InputJSON := 'invalid json';
  SortedJSON := SortJSONFields(InputJSON);
  Assert.AreEqual(InputJSON, SortedJSON, 'Invalid JSON handling failed');
end;

initialization
//  TDUnitX.RegisterTestFixture(TJSONUtilsTests);

end.
