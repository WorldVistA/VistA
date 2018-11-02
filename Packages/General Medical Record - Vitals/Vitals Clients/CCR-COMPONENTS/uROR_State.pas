unit uROR_State;
{$I Components.inc}

interface

uses
  SysUtils, Classes, ovcbase, ovcstate;

type
  TCCRComponentState = class(TOvcComponentState)
  private
    fOnSaveState:    TNotifyEvent;
    fOnRestoreState: TNotifyEvent;

  protected
    procedure RestoreStatePrim; override;
    procedure SaveStatePrim; override;

  public
    { Public declarations }
  published
    property OnSaveState: TNotifyEvent          read  fOnSaveState
                                                write fOnSaveState;

    property OnRestoreState: TNotifyEvent       read  fOnRestoreState
                                                write fOnRestoreState;

  end;

  TCCRFormState = class(TOvcFormState)
  private
    fOnSaveState:    TNotifyEvent;
    fOnRestoreState: TNotifyEvent;

  protected
    procedure RestoreStatePrim; override;
    procedure SaveStatePrim; override;

  public
    { Public declarations }
  published
    property OnSaveState: TNotifyEvent          read  fOnSaveState
                                                write fOnSaveState;

    property OnRestoreState: TNotifyEvent       read  fOnRestoreState
                                                write fOnRestoreState;

  end;

implementation

////////////////////////////// TCCRComponentState \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

procedure TCCRComponentState.RestoreStatePrim;
begin
  if not Assigned(Storage) then Exit;

  try
    Storage.Open;
    try
      inherited;
      if Assigned(OnRestoreState) then OnRestoreState(Self);
    finally
      Storage.Close;
    end;
  except
  end;
end;

procedure TCCRComponentState.SaveStatePrim;
begin
  if not Assigned(Storage) then Exit;

  try
    Storage.Open;
    try
      inherited;
      if Assigned(OnSaveState) then OnSaveState(Self);
    finally
      Storage.Close;
    end;
  except
  end;
end;

///////////////////////////////// TCCRFormState \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

procedure TCCRFormState.RestoreStatePrim;
begin
  if not Assigned(Storage) then Exit;

  try
    Storage.Open;
    try
      inherited;
      if Assigned(OnRestoreState) then OnRestoreState(Self);
    finally
      Storage.Close;
    end;
  except
  end;
end;

procedure TCCRFormState.SaveStatePrim;
begin
  if not Assigned(Storage) then Exit;

  try
    Storage.Open;
    try
      inherited;
      if Assigned(OnSaveState) then OnSaveState(Self);
    finally
      Storage.Close;
    end;
  except
  end;
end;

end.
