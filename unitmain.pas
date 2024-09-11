unit unitmain;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LCLType, Menus,LMessages, ExtCtrls, unitabout;

type

  { TFormMain }

  TFormMain = class(TForm)
    ColorDialog: TColorDialog;
    LabelSize: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuColorBorder: TMenuItem;
    MEnuColorBackground: TMenuItem;
    MenuItem5: TMenuItem;
    MenuIncreaseBorder: TMenuItem;
    MenuDecreaseBorder: TMenuItem;
    N3: TMenuItem;
    MenuShowSize: TMenuItem;
    N2: TMenuItem;
    N1: TMenuItem;
    MenuOpacity50: TMenuItem;
    MenuOpacity80: TMenuItem;
    MenuOpacity100: TMenuItem;
    PopupMenu1: TPopupMenu;
    Shape: TShape;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure LabelSizeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MenuDecreaseBorderClick(Sender: TObject);
    procedure MenuIncreaseBorderClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuColorBorderClick(Sender: TObject);
    procedure MenuColorBackgroundClick(Sender: TObject);
    procedure MenuOpacity100Click(Sender: TObject);
    procedure MenuOpacity50Click(Sender: TObject);
    procedure MenuOpacity80Click(Sender: TObject);
    procedure MenuShowSizeClick(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private

  public

  end;

var
  FormMain: TFormMain;

implementation /////////////////////////////////////////////////////////////////

{$R *.lfm}

{ TFormMain }
var
  PrevWndProc: WNDPROC;

function WndCallback(Ahwnd: HWND; uMsg: UINT; wParam: WParam; lParam: LParam): LRESULT; stdcall;
const
  Margin = 5;
var
  Rect: TRect;
  MouseX, MouseY: LongInt;
begin
  if uMsg = WM_NCHITTEST then
  begin
    Result := Windows.DefWindowProc(Ahwnd, uMsg, wParam, lParam);
    MouseX := GET_X_LPARAM(lParam);
    MouseY := GET_Y_LPARAM(lParam);
    with Rect do
    begin
      Left := MouseX - FormMain.BoundsRect.Left;
      Right := FormMain.BoundsRect.Right - MouseX;
      Top := MouseY - FormMain.BoundsRect.Top;
      Bottom := FormMain.BoundsRect.Bottom - MouseY;
      if (Top < Margin) and (Left < Margin) then
        Result := windows.HTTOPLEFT
      else if (Top < Margin) and (Right < Margin) then
        Result := windows.HTTOPRIGHT
      else if (Bottom < Margin) and (Left < Margin) then
        Result := windows.HTBOTTOMLEFT
      else if (Bottom < Margin) and (Right < Margin) then
        Result := windows.HTBOTTOMRIGHT
      else if (Top < Margin) then
        Result := windows.HTTOP
      else if (Left < Margin) then
        Result := windows.HTLEFT
      else if (Bottom < Margin) then
        Result := windows.HTBOTTOM
      else if (Right < Margin) then
        Result := windows.HTRIGHT;
    end;
    Exit;
  end;
  Result := CallWindowProc(PrevWndProc,Ahwnd, uMsg, WParam, LParam);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  PrevWndProc := Windows.WNDPROC(SetWindowLongPtr(Self.Handle, GWL_WNDPROC, PtrInt(@WndCallback)));
  FormMain.DoubleBuffered:=True;

  FormMain.AlphaBlend:=True;
  FormMain.AlphaBlendValue:=255;
end;

procedure TFormMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //showmessage(inttostr(key));
  if (key=37) and (Shift=[]) then FormMain.Left:=FormMain.Left-1;
  if (key=39) and (Shift=[]) then FormMain.Left:=FormMain.Left+1;
  if (key=38) and (Shift=[]) then FormMain.Top:=FormMain.Top-1;
  if (key=40) and (Shift=[]) then FormMain.Top:=FormMain.Top+1;

  if (key=37) and (Shift=[ssShift]) then FormMain.Width:=FormMain.Width-1;
  if (key=39) and (Shift=[ssShift]) then FormMain.Width:=FormMain.Width+1;
  if (key=38) and (Shift=[ssShift]) then FormMain.Height:=FormMain.Height-1;
  if (key=40) and (Shift=[ssShift]) then FormMain.Height:=FormMain.Height+1;
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  LabelSize.Caption:=IntToStr(FormMain.Width)+' x '+IntToStr(FormMain.Height);
  LabelSize.Hint:=LabelSize.Caption;
end;

procedure TFormMain.LabelSizeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    SendMessage(FormMain.Handle, LM_SYSCOMMAND, 61458, 0);
  end;
end;

procedure TFormMain.MenuDecreaseBorderClick(Sender: TObject);
begin
  if Shape.Pen.Width>1 then Shape.Pen.Width:=Shape.Pen.Width-1;
end;

procedure TFormMain.MenuIncreaseBorderClick(Sender: TObject);
begin
  Shape.Pen.Width:=Shape.Pen.Width+1;
end;

procedure TFormMain.MenuItem1Click(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.MenuItem3Click(Sender: TObject);
begin
  FormCredits:=TFormCredits.Create(Application);
  FormCredits.ShowModal;
  FreeAndNil(FormCredits);
end;

procedure TFormMain.MenuColorBorderClick(Sender: TObject);
begin
  if ColorDialog.Execute then
  begin
    Shape.Pen.Color:=ColorDialog.Color;
  end;
end;

procedure TFormMain.MenuColorBackgroundClick(Sender: TObject);
begin
  if ColorDialog.Execute then
  begin
    Shape.Brush.Color:=ColorDialog.Color;
  end;
end;

procedure TFormMain.MenuOpacity100Click(Sender: TObject);
begin
  MenuOpacity100.Checked:=True;
  MenuOpacity80.Checked:=False;
  MenuOpacity50.Checked:=False;
  FormMain.AlphaBlendValue:=255;
end;

procedure TFormMain.MenuOpacity80Click(Sender: TObject);
begin
  MenuOpacity100.Checked:=False;
  MenuOpacity80.Checked:=True;
  MenuOpacity50.Checked:=False;
  FormMain.AlphaBlendValue:=Round(255/100*80);
end;

procedure TFormMain.MenuShowSizeClick(Sender: TObject);
begin
  ShowMessage('Current size: '+IntToStr(FormMain.Width)+' x '+IntToStr(FormMain.Height));
end;

procedure TFormMain.MenuOpacity50Click(Sender: TObject);
begin
  MenuOpacity100.Checked:=False;
  MenuOpacity80.Checked:=False;
  MenuOpacity50.Checked:=True;
  FormMain.AlphaBlendValue:=Round(255/100*50);
end;

procedure TFormMain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Self.BorderStyle:=bsNone;
end;

end.

