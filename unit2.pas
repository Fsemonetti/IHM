 unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,extctrls,StdCtrls,Graphics;
       type

        { TPanelEstacaoMotor }

        TPanelEstacaoMotor = Class(TPanel)
          private
            Bdesliga : Tbutton;
            BLiga    : Tbutton;
            LDesligado:Tshape;
            LLigado   :Tshape;
            LFalha    :Tshape;
            Pisca     : Ttimer;
            Nome      : Tlabel;

          public
            constructor Create(TheOwner: TComponent); override;
            destructor Destroy; override;
            procedure Paint; override;

        end;

implementation

{ TPanelEstacaoMotor }

constructor TPanelEstacaoMotor.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Caption:='';
  Color:=Clgray;
  Width:=200;
  Height:=100;
  Top:=50;;
  Left:=50;

  Bdesliga  := Tbutton.Create(nil);
  Bdesliga.parent:=self;
  Bdesliga.Color:=8;
  Bdesliga.Width:=20;
  Bdesliga.Height:=20;
  Bdesliga.Top:=50;;
  Bdesliga.Left:=0;

  BLiga     := Tbutton.Create(nil);
  BLiga.parent:=self;
  BLiga.Color:=8;
  BLiga.Width:=20;
  BLiga.Height:=20;
  BLiga.Top:=50;;
  BLiga.Left:=30;

  LLigado   :=Tshape.create(nil);
  LLigado.parent:=self;
  LLigado.Color:=8;
  LLigado.Width:=20;
  LLigado.Height:=20;
  LLigado.Top:=50;;
  LLigado.Left:=60;
  LLigado.Brush.Color:=Clred;

  LDesligado:=Tshape.create(nil);
  LDesligado.parent:=self;
  LDesligado.Color:=8;
  LDesligado.Width:=20;
  LDesligado.Height:=20;
  LDesligado.Top:=50;;
  LDesligado.Left:=90;
  LDesligado.Brush.Color:=Clred;

  LFalha    :=Tshape.create(nil);
  LFalha.parent:=self;
  LFalha.Color:=8;
  LFalha.Width:=20;
  LFalha.Height:=20;
  LFalha.Top:=50;;
  LFalha.Left:=120;
  LFalha.Brush.Color:=Clred;

  Nome:= Tlabel.Create(nil);
  Nome.Parent:=self;
  Nome.Caption:='Motor';
  Pisca     :=Ttimer.create(nil);

end;

destructor TPanelEstacaoMotor.Destroy;
begin
  inherited Destroy;
  Bdesliga.Destroy;
  BLiga.Destroy;
  LLigado.Destroy;
  LDesligado.Destroy;
  LFalha.Destroy;
  Pisca.Destroy;

end;

procedure TPanelEstacaoMotor.Paint;
begin
  inherited Paint;
end;

end.

