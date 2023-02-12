unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Controls.Blinker,unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    Shape1: TShape;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    private

  public

  end;

var
  Form1: TForm1;
  meu : TPanelEstacaoMotor;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);


begin
     meu:=TPanelEstacaoMotor.Create(form1);
     meu.Parent:=form1;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

end.

