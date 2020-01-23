unit Main;

{$mode objfpc}{$H+}
{$warnings off}
{$hints off}

// Created at 23th of January 2020 by Linuxer (https://gitlab.com/psposito), from scratch with Free Pascal

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus, Unix;

type

  { TForm1 }

  TForm1 = class(TForm)
    MenuItem1          : TMenuItem;
    MenuItem2          : TMenuItem;
    MenuItem3          : TMenuItem;
    MenuItem4          : TMenuItem;
    PopupMenu1         : TPopupMenu;
    TrayIcon1          : TTrayIcon;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
  private

  public

  end;

var
  Form1                 : TForm1;
  S                     : LongInt;
  n                     : Integer;
  HasPassword           : Boolean;
  Password              : String;

implementation

{$R *.frm}

{ TForm1 }

procedure CameraOn;
begin
    S := fpsystem(concat('echo ',Password,' | sudo -S modprobe uvcvideo'));
    if (S <> 0) then
       begin
           ShowMessage('Incorrect password');
           HasPassword := false;
       end;
end;

procedure CameraOff;
begin
    S := fpsystem(concat('echo ',Password,' | sudo -S modprobe -r uvcvideo'));
    if (S <> 0) then
       begin
           ShowMessage('Incorrect password');
           HasPassword := false;
       end;
end;

procedure AskPassword;
begin
    Password := PasswordBox('Authorization Needed / User Input','Please Enter Password');
    HasPassword := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    S                           := fpsystem('echo off');
    HasPassword                 := false;
    application.showmainform    := false;
    TrayIcon1.Hint              := 'Camera Switch';
    TrayIcon1.ShowIcon          := True;
    TrayIcon1.Show;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
    if HasPassword then
       begin
           CameraOn;
       end
    else
        begin
          AskPassword;
          CameraOn;
        end;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
    if HasPassword then
       begin
           CameraOff;
       end
    else
        begin
          AskPassword;
          CameraOff;
        end;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
    TrayIcon1.Hide;
    PopupMenu1.Free;
    TrayIcon1.Free;
    Halt (0);
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
    HasPassword := false;
    ShowMessage('Password has been forgotten');
end;

end.

