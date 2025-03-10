unit StringUtils_tests;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils, System.Classes, JSONUtils, StringUtils, System.JSON,
  System.Generics.Collections,
  DUnitX.DUnitCompatibility;

type

  [TestFixture]
  TStringUtilsTests = class(TTestCase)
  private
    FTestCases: TDictionary<string, string>;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestSortJSONFields;

    [Test]
    procedure TestSortJSONFields_Nested;

    [Test]
    procedure TestTrimString;

    [Test]
    procedure TestToUpperCaseString;

    [Test]
    procedure TestToLowerCaseString;

    [Test]
    procedure TestIsNumeric;

    [Test]
    procedure TestIsAlpha;

    [Test]
    procedure TestIsAlphaNumeric;

    [Test]
    procedure TestReplaceSubstring;
  end;

implementation

procedure TStringUtilsTests.Setup;
begin
  FTestCases := TDictionary<string, string>.Create;
  // ��������� �������� ������ ��� SortJSONFields
  FTestCases.Add('{"b":2, "a":1, "c":3, "a":4}', '{"a":4,"b":2,"c":3}');
  FTestCases.Add('{"a":1, "b":2, "c":3}', '{"a":1,"b":2,"c":3}');
  FTestCases.Add('{"c":3, "b":2, "a":1}', '{"a":1,"b":2,"c":3}');
  FTestCases.Add('{"a":1, "a":2, "a":3}', '{"a":3}');
  FTestCases.Add('{"z":26, "a":1, "m":13}', '{"a":1,"m":13,"z":26}');
  FTestCases.Add('{"nested": {"b":2, "a":1}, "c":3}',
    '{"c":3,"nested":{"a":1,"b":2}}');
  FTestCases.Add('{"array": [ {"b":2, "a":1}, {"c":3, "d":4} ]}',
    '{"array":[{"a":1,"b":2},{"c":3,"d":4}]}');
end;

procedure TStringUtilsTests.TearDown;
begin
  FTestCases.Free;
end;

procedure TStringUtilsTests.TestSortJSONFields;
var
  OriginalJSON, ExpectedSortedJSON, ActualSortedJSON: string;
begin
  for OriginalJSON in FTestCases.Keys do
  begin
    ExpectedSortedJSON := FTestCases[OriginalJSON];
    try
      ActualSortedJSON := SortJSONFields(ExpectedSortedJSON);
      Assert.AreEqual(ExpectedSortedJSON, ActualSortedJSON,
        'Failed to sort JSON fields correctly.');
    finally
    end;
  end;
end;

procedure TStringUtilsTests.TestSortJSONFields_Nested;
var
  OriginalJSON, ExpectedSortedJSON, ActualSortedJSON: string;
begin
  OriginalJSON := '{"nested": {"b":2, "a":1}, "c":3}';
  ExpectedSortedJSON := '{"c":3,"nested":{"a":1,"b":2}}';
  try
    ActualSortedJSON := SortJSONFields(OriginalJSON);
    Assert.AreEqual(ExpectedSortedJSON, ActualSortedJSON,
      'Failed to sort nested JSON fields correctly.');
  finally
  end;
end;

procedure TStringUtilsTests.TestTrimString;
begin
  Assert.AreEqual('Test', TrimString('  Test  '), 'TrimString failed.');
  Assert.AreEqual('', TrimString('    '), 'TrimString failed on empty string.');
  Assert.AreEqual('����', TrimString('  ����  '),
    'TrimString failed with Cyrillic characters.');
end;

procedure TStringUtilsTests.TestToUpperCaseString;
begin
  Assert.AreEqual('TEST', ToUpperCaseString('Test'),
    'ToUpperCaseString failed.');
  Assert.AreEqual('����', ToUpperCaseString('����'),
    'ToUpperCaseString failed with Cyrillic characters.');
end;

procedure TStringUtilsTests.TestToLowerCaseString;
begin
  Assert.AreEqual('test', ToLowerCaseString('Test'),
    'ToLowerCaseString failed.');
  Assert.AreEqual('����', ToLowerCaseString('����'),
    'ToLowerCaseString failed with Cyrillic characters.');
end;

procedure TStringUtilsTests.TestIsNumeric;
begin
  Assert.IsTrue(IsNumeric('123'), 'IsNumeric failed for "123".');
  Assert.IsTrue(IsNumeric('123.45'), 'IsNumeric failed for "123.45".');
  Assert.IsFalse(IsNumeric('123a'), 'IsNumeric failed for "123a".');
  Assert.IsFalse(IsNumeric('abc'), 'IsNumeric failed for "abc".');
end;

procedure TStringUtilsTests.TestIsAlpha;
begin
  Assert.IsTrue(IsAlpha('Test'), 'IsAlpha failed for "Test".');
  Assert.IsTrue(IsAlpha('����'), 'IsAlpha failed for "����".');
  Assert.IsFalse(IsAlpha('Test1'), 'IsAlpha failed for "Test1".');
  Assert.IsFalse(IsAlpha('123'), 'IsAlpha failed for "123".');
end;

procedure TStringUtilsTests.TestIsAlphaNumeric;
begin
  Assert.IsTrue(IsAlphaNumeric('Test123'),
    'IsAlphaNumeric failed for "Test123".');
  Assert.IsTrue(IsAlphaNumeric('����123'),
    'IsAlphaNumeric failed for "����123".');
  Assert.IsFalse(IsAlphaNumeric('Test 123'),
    'IsAlphaNumeric failed for "Test 123".');
  Assert.IsFalse(IsAlphaNumeric('123!'), 'IsAlphaNumeric failed for "123!".');
end;

procedure TStringUtilsTests.TestReplaceSubstring;
begin
  Assert.AreEqual('This is a test.', ReplaceSubstring('This is a sample.',
    'sample', 'test'), 'ReplaceSubstring failed.');
  Assert.AreEqual('Cyrillic ����.', ReplaceSubstring('Cyrillic sample.',
    'sample', '����'), 'ReplaceSubstring failed with Cyrillic characters.');
end;

initialization

TDUnitX.RegisterTestFixture(TStringUtilsTests);

end.
