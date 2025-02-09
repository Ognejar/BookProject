unit ArrayUtilsTests;

interface

uses
  DUnitX.TestFramework, ArrayUtils, System.SysUtils, System.Generics.Collections;

type
  [TestFixture]
  TArrayUtilsTests = class
  public
    [Test]
    procedure TestFindMax;

    [Test]
    procedure TestFindMin;

    [Test]
    procedure TestSortArray;

    [Test]
    procedure TestContains;

    [Test]
    procedure TestRemoveValue;

    [Test]
    procedure TestFindMax_EmptyArray;

    [Test]
    procedure TestFindMin_EmptyArray;
  end;

implementation

procedure TArrayUtilsTests.TestFindMax;
var
  Arr: array of Integer;
begin
  Arr := [1, 5, 3, 9, 2];
  Assert.AreEqual(9, FindMax(Arr));
end;

procedure TArrayUtilsTests.TestFindMin;
var
  Arr: array of Integer;
begin
  Arr := [1, 5, 3, 9, 2];
  Assert.AreEqual(1, FindMin(Arr));
end;

procedure TArrayUtilsTests.TestSortArray;
var
  Arr: array of Integer;
begin
  Arr := [5, 2, 8, 1, 3];
  SortArray(Arr);
  Assert.AreEqual(1, Arr[0]);
  Assert.AreEqual(2, Arr[1]);
  Assert.AreEqual(3, Arr[2]);
  Assert.AreEqual(5, Arr[3]);
  Assert.AreEqual(8, Arr[4]);
end;

procedure TArrayUtilsTests.TestContains;
var
  Arr: array of Integer;
begin
  Arr := [1, 2, 3, 4, 5];
  Assert.IsTrue(Contains(Arr, 3));
  Assert.IsFalse(Contains(Arr, 6));
end;

procedure TArrayUtilsTests.TestRemoveValue;
var
  Arr, ResultArr: TArray<Integer>;
begin
  Arr := [1, 2, 3, 2, 4, 2, 5];
  ResultArr := RemoveValue(Arr, 2);
  Assert.AreEqual(4, Length(ResultArr));
  Assert.AreEqual(1, ResultArr[0]);
  Assert.AreEqual(3, ResultArr[1]);
  Assert.AreEqual(4, ResultArr[2]);
  Assert.AreEqual(5, ResultArr[3]);
end;

procedure TArrayUtilsTests.TestFindMax_EmptyArray;
var
  Arr: array of Integer;
begin
  Arr := [];
  Assert.WillRaise(
    procedure
    begin
      FindMax(Arr);
    end, Exception);
end;

procedure TArrayUtilsTests.TestFindMin_EmptyArray;
var
  Arr: array of Integer;
begin
  Arr := [];
  Assert.WillRaise(
    procedure
    begin
      FindMin(Arr);
    end, Exception);
end;

initialization
  TDUnitX.RegisterTestFixture(TArrayUtilsTests);

end.
