unit KR_PRoGBAR;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, extctrls,
  dsgnIntf;

type
  KrAbout=class;

  KrGradFillProp1=record
    Top:integer;
    Bottom:integer;
    Left:integer;
    Right:integer;
    TopLeft:TColor;
    TopRight:TColor;
    BottomLeft:TColor;
    BottomRight:TColor;
  end;

  KrBorder=(boNone, bo3dUp, bo3dDown, boLine);

  KrProgBar = class(TPaintBox)
  private
    _About:KrAbout;
    _Border:KrBorder;
    _Transparent:boolean;
    _ColorLine:TColor;
    _ColorUp:TColor;
    _ColorDown:TColor;
    _ColorBackGround:TColor;
    _ColorLeft:TColor;
    _ColorRight:TColor;
    _Marge:integer;
    _Min:integer;
    _Max:integer;
    _Pos:integer;
    _Caption:string;

    _BeforePaint:TNotifyEvent;

    procedure SetBorder(value:KrBorder);
    procedure SetColorLine(value:TColor);
    procedure SetColorUp(value:TColor);
    procedure SetColorDown(value:TColor);
    procedure SetColorBackGround(value:TColor);
    procedure SetTransparent(value:boolean);
    procedure SetColorLeft(value:TColor);
    procedure SetColorRight(value:TColor);
    procedure SetMarge(value:integer);
    procedure SetMin(value:integer);
    procedure SetMax(value:integer);
    procedure SetPos(value:integer);
    procedure SetCaption(value:string);
  protected
    procedure Paint; override;
    procedure Update; override;

  public
    OldPos:integer;

    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;

  published
    property About:KrAbout read _About write _About;
    property Border:KrBorder read _Border write SetBorder default bo3dDown;
    property ColorLine:TColor read _ColorLine write SetColorLine default clBlack;
    property ColorUp:TColor read _ColorUp write SetColorUp default clWhite;
    property ColorDown:TColor read _ColorDown write SetColorDown default clGray;
    property ColorBackGround:TColor read _ColorBackGround write SetColorBackGround default clSilver;
    property Transparenty:boolean read _Transparent write SetTransparent default False;
    property ColorLeft:TColor read _ColorLeft write SetColorLeft default clBlue;
    property ColorRight:TColor read _ColorRight write SetColorRight default clRed;
    property Marge:integer read _Marge write SetMarge default 1;
    property Min:integer read _Min write SetMin default 0;
    property Max:integer read _Max write SetMax default 100;
    property Pos:integer read _Pos write SetPos default 0;
    property Caption:string read _Caption write SetCaption;

    property Align;
    property ParentShowHint;
    property ShowHint;
    property Hint;
    property Font;
    property Tag;
    property Enabled;

    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;

    property BeforePaint:TNotifyEvent read _BeforePaint write _BeforePaint;
  end;

  KrAbout=class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;

  procedure Register;
  function GradientFill1(DC: HDC; p2:pointer; p3: ULONG; p4: Pointer; p5, p6: ULONG): BOOL; stdcall;
  procedure FillGradient(DC:HDC; Prop:KrGradFillProp1);
implementation

///////////////////////////////////////////////////////////////////////////////
  function GradientFill1; external msimg32 name 'GradientFill';

  procedure FillGradient(DC:HDC; Prop:KrGradFillProp1);
  type
    TRGB=record
      r:integer;
      g:integer;
      b:integer;
    end;

    KrTrivertex=packed record
      x:integer;
      y:integer;
      Red:word;
      Green:word;
      Blue:word;
      Alpha:word;
    end;
  var
    vert:array[0..3] of KRTRIVERTEX;
    gtri:array[0..1] of GRADIENT_TRIANGLE;
    RGB_TopLeft:TRGB;
    RGB_TopRight:TRGB;
    RGB_BottomLeft:TRGB;
    RGB_BottomRight:TRGB;

    function GetRgb(color:TColor):TRGB;
    begin
      result.r:=(color and $000000ff)*$ff;
      result.g:=((color shr 8) and $000000ff)*$ff;
      result.b:=((color shr 16) and $000000ff)*$ff;
    end;

  begin
    with Prop do begin
      RGB_TopRight:=GetRgb(TopRight);
      RGB_TopLeft:=GetRgb(TopLeft);
      RGB_BottomLeft:=GetRGB(BottomLeft);
      RGB_BottomRight:=GetRgb(BottomRight);

      vert[0].x:=prop.Left; vert[0].y:=prop.Top;
      vert[0].Red:=RGB_TopLeft.r; vert[0].Green:=RGB_TopLeft.g; vert[0].Blue:=RGB_TopLeft.b; vert[0].Alpha:=$0000;

      vert[1].x:=prop.Right; vert[1].y:=prop.Top;
      vert[1].Red:=RGB_TopRight.r; vert[1].Green:=RGB_TopRight.g; vert[1].Blue:=RGB_TopRight.b; vert[1].Alpha:=$0000;

      vert[2].x:=prop.Right; vert[2].y:=prop.Bottom;
      vert[2].Red:=RGB_BottomRight.r; vert[2].Green:=RGB_BottomRight.g; vert[2].Blue:=RGB_BottomRight.b; vert[2].Alpha:=$0000;

      vert[3].x:=prop.Left; vert[3].y:=prop.Bottom;
      vert[3].Red:=RGB_BottomLeft.r; vert[3].Green:=RGB_BottomLeft.g; vert[3].Blue:=RGB_BottomLeft.b; vert[3].Alpha:=$0000;
    end;

    gTRi[0].Vertex1:=0; gTRi[0].Vertex2:=1; gTRi[0].Vertex3:=2;
    gTRi[1].Vertex1:=0; gTRi[1].Vertex2:=2; gTRi[1].Vertex3:=3;
    GradientFill1(dc, @vert, 4, @gTri, 1, GRADIENT_FILL_TRIANGLE);

    with prop do begin
      vert[0].x:=prop.Left; vert[0].y:=prop.Top;
      vert[0].Red:=RGB_TopLeft.r; vert[0].Green:=RGB_TopLeft.g; vert[0].Blue:=RGB_TopLeft.b; vert[0].Alpha:=$0000;

      vert[1].x:=prop.Left; vert[1].y:=prop.Bottom;
      vert[1].Red:=RGB_BottomLeft.r; vert[1].Green:=RGB_BottomLeft.g; vert[1].Blue:=RGB_BottomLeft.b; vert[1].Alpha:=$0000;

      vert[2].x:=prop.Right; vert[2].y:=prop.Bottom;
      vert[2].Red:=RGB_BottomRight.r; vert[2].Green:=RGB_BottomRight.g; vert[2].Blue:=RGB_BottomRight.b; vert[2].Alpha:=$0000;

      vert[3].x:=prop.Right; vert[3].y:=prop.Top;
      vert[3].Red:=RGB_TopRight.r; vert[3].Green:=RGB_TopRight.g; vert[3].Blue:=RGB_TopRight.b; vert[3].Alpha:=$0000;
    end;

    gTRi[0].Vertex1:=0; gTRi[0].Vertex2:=1; gTRi[0].Vertex3:=2;
    gTRi[1].Vertex1:=0; gTRi[1].Vertex2:=1; gTRi[1].Vertex3:=2;
    GradientFill1(dc, @vert, 4, @gTri, 1, GRADIENT_FILL_TRIANGLE);
  end;

  procedure Register;
  begin
    RegisterComponents('Kr...', [KrProgBar]);
    RegisterPropertyEditor(TypeInfo(KrAbout), KrProgBar, 'About', KrAbout);
  end;

  constructor KrProgBar.Create(AOwner:TComponent);
  begin
    inherited Create(AOwner);

    OldPos:=-1;
    _Border:=bo3dDown;
    _ColorLine:=clBlack;
    _ColorUp:=clWhite;
    _ColorDown:=clGray;
    _ColorBackGround:=clSilver;
    _Transparent:=False;
    _ColorLeft:=clBlue;
    _ColorRight:=clRed;
    _Marge:=1;
    _Min:=0;
    _Max:=100;
    _Pos:=0;
  end;

  destructor KrProgBar.Destroy;
  begin

    inherited Destroy;
  end;

  procedure KrProgBar.Paint;
  begin
    Update;
  end;

  procedure KrProgBar.Update;
  var
    BarRect:TRect;
    r, r1:TRect;
    GF:KrGradFillProp1;
    Image:TImage;
    position:integer;
    bw:integer;
  begin
    r:=ClientRect;
    inc(r.Left, _Marge);
    inc(r.Top, _Marge);
    dec(r.Right, _Marge);
    dec(r.Bottom, _Marge);
    position:=(_Pos*(BarRect.Right-BarRect.Left)) div (_max-_min)+BarRect.Left;
    if OldPos=Position then exit;

    OldPos:=position;
    BarRect:=ClientRect;
    Image:=TImage.Create(Self);
    Image.Left:=0;
    Image.Top:=0;
    Image.Width:=ClientRect.Right;
    Image.Height:=ClientRect.Bottom;

    case _Border of
      boLine: begin
          if _TransParent=True then begin
            Image.Canvas.Brush.Color:=_ColorLine;
            Image.Canvas.FrameRect(BarRect);
          end else begin
            Image.Canvas.Pen.Color:=_ColorLine;
            Image.Canvas.Brush.Color:=_ColorBackGround;
            Image.Canvas.Rectangle(BarRect);
          end;
        end;
      bo3dUp: begin
          if _TransParent=False then begin
            Image.Canvas.Pen.Color:=_ColorBackGround;
            Image.Canvas.Brush.Color:=_ColorBackGround;
            Image.Canvas.Rectangle(BarRect);
          end;
          Image.Canvas.Pen.Color:=_ColorUp;
          Image.Canvas.MoveTo(BarRect.Left, BarRect.Bottom);
          Image.Canvas.LineTo(BarRect.Left, BarRect.Top);
          Image.Canvas.LineTo(BarRect.Right-1, BarRect.Top);
          Image.Canvas.Pen.Color:=_ColorDown;
          Image.Canvas.LineTo(BarRect.Right-1, BarRect.Bottom-1);
          Image.Canvas.LineTo(BarRect.Left, BarRect.Bottom-1);
        end;
      bo3dDown: begin
          if _TransParent=False then begin
            Image.Canvas.Pen.Color:=_ColorBackGround;
            Image.Canvas.Brush.Color:=_ColorBackGround;
            Image.Canvas.Rectangle(BarRect);
          end;
          Image.Canvas.Pen.Color:=_ColorDown;
          Image.Canvas.MoveTo(BarRect.Left, BarRect.Bottom);
          Image.Canvas.LineTo(BarRect.Left, BarRect.Top);
          Image.Canvas.LineTo(BarRect.Right-1, BarRect.Top);
          Image.Canvas.Pen.Color:=_ColorUp;
          Image.Canvas.LineTo(BarRect.Right-1, BarRect.Bottom-1);
          Image.Canvas.LineTo(BarRect.Left, BarRect.Bottom-1);
        end;
      boNone: begin
          if _TransParent=False then begin
            Image.Canvas.Pen.Color:=_ColorBackGround;
            Image.Canvas.Brush.Color:=_ColorBackGround;
            Image.Canvas.Rectangle(BarRect);
          end;
        end;
    end;

    BarRect:=ClientRect;
    inc(BarRect.Left, _Marge);
    inc(BarRect.Top, _Marge);
    dec(BarRect.Right, _Marge);
    dec(BarRect.Bottom, _Marge);
    r1:=BarRect;

    position:=(_Pos*(BarRect.Right-BarRect.Left)) div (_max-_min)+BarRect.Left;

    Image.Canvas.Pen.Color:=_ColorRight;
    Image.Canvas.Brush.Color:=_ColorRight;
    Image.Canvas.Rectangle(BarRect);
    r:=BarRect;
    Image.Canvas.Pen.Color:=_ColorLeft;
    Image.Canvas.Brush.Color:=_ColorLeft;
    r.Right:=position;
    Image.Canvas.Rectangle(r);

    gf.Top:=BarRect.Top;
    gf.Bottom:=BarRect.Bottom;

    bw:=(BarRect.Right-BarRect.Left) div 2;
    BarRect.Left:=BarRect.Left-(bw div 2);
    BarRect.Right:=BarRect.Right+(bw div 2);
    gf.Left:=(_Pos*(BarRect.Right-BarRect.Left)) div (_max-_min)+BarRect.Left;
    gf.Left:=gf.Left-bw div 2;
    gf.Right:=gf.Left+bw;

    gf.TopLeft:=_ColorLeft;
    gf.TopRight:=_ColorRight;
    gf.BottomLeft:=_ColorLeft;
    gf.BottomRight:=_ColorRight;
    FillGradient(Image.Canvas.Handle, gf);

    if Assigned(_BeforePaint) then _BeforePaint(Self);
    Image.Canvas.Font:=Font;
    SetBkMode(Image.Canvas.Handle, TRANSPARENT);
    Image.Canvas.TextOut(((r1.Right-r1.Left)-Image.Canvas.TextWidth(_Caption)) div 2,
                         ((r1.Bottom-r1.Top)-Image.Canvas.TextHeight(_Caption)) div 2,
                         _Caption);

    Canvas.CopyRect(ClientRect, Image.Canvas, ClientRect);
    Image.Free;
  end;

  procedure KrProgBar.SetColorLeft(value:TColor);
  begin
    if value=_ColorLeft then exit;
    _ColorLeft:=value;
    Update;
  end;

  procedure KrProgBar.SetColorRight(value:TColor);
  begin
    if value=_ColorRight then exit;
    _ColorRight:=value;
    Update;
  end;

  procedure KrProgBar.SetMarge(value:integer);
  begin
    if value=_Marge then exit;
    _Marge:=value;
    Update;
  end;

  procedure KrProgBar.SetCaption(value:string);
  begin
    if value=_Caption then exit;
    _Caption:=value;
    Update;
  end;

  procedure KrProgBar.SetMin(value:integer);
  begin
    if value=_Min then exit;
    _Min:=value;
    Update;
  end;

  procedure KrProgBar.SetMax(value:integer);
  begin
    if value=_Max then exit;
    _Max:=value;
    Update;
  end;

  procedure KrProgBar.SetPos(value:integer);
  begin
    if value=_Pos then exit;
    _Pos:=value;
    Update;
  end;

  procedure KrProgBar.SetBorder(value:KrBorder);
  begin
    if value=_Border then exit;
    _Border:=value;
    Update;
  end;

  procedure KrProgBar.SetColorLine(value:TColor);
  begin
    if value=_ColorLine then exit;
    _ColorLine:=value;
    Update;
  end;

  procedure KrProgBar.SetColorUp(value:TColor);
  begin
    if value=_ColorUp then exit;
    _ColorUp:=value;
    Update;
  end;

  procedure KrProgBar.SetColorDown(value:TColor);
  begin
    if value=_ColorDown then exit;
    _ColorDown:=value;
    Update;
  end;

  procedure KrProgBar.SetColorBackGround(value:TColor);
  begin
    if value=_ColorBackGround then exit;
    _ColorBackGround:=value;
    Update;
  end;

  procedure KrProgBar.SetTransparent(value:boolean);
  begin
    if value=_Transparent then exit;
    _Transparent:=value;
    Update;
  end;

  procedure KrAbout.Edit;
  begin
    MessageDlg('KrProgBar'+#13+#13+'Version 1.0, 2000'+#13+
               'Minimal Windows 2000 or higher of Windows 98 or higher'+#13+#13+
               'www.iaehv.nl/users/kray/index.html'+#13+
               'kray@iaehv.nl',
                mtInformation, [mbOK], 0);
  end;

  function KrAbout.GetAttributes: TPropertyAttributes;
  begin
    Result := [paMultiSelect, paDialog, paReadOnly];
  end;

  function KrAbout.GetValue: string;
  begin
    Result := '(about)';
  end;
end.
