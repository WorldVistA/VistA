unit uComponentNexus;

interface

uses
  System.Classes;

{
   The word Nexus means "a connection or series of connections linking two or
   more things".  This class allows objects that are not descendant from
   TComponent to receive free notifications for other components.  Set the
   OnFreeNotification property to the method you want called when a component
   is destroyed.  Then call NotifyOnFree for every component for which you want
   free notification.
}

type
  TComponentNexusEvent = procedure(Sender: TObject; AComponent: TComponent) of object;
  TComponentNexus = class(TComponent)
  private
    FOnFreeNotification: TComponentNexusEvent;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    procedure NotifyOnFree(AComponent: TComponent);
    property OnFreeNotification: TComponentNexusEvent read FOnFreeNotification
      write FOnFreeNotification;
  end;

implementation

{ TComponentNexus }

procedure TComponentNexus.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (Operation = opRemove) and Assigned(FOnFreeNotification) then
    FOnFreeNotification(Self, AComponent);
  inherited Notification(AComponent, Operation);
end;

procedure TComponentNexus.NotifyOnFree(AComponent: TComponent);
begin
  AComponent.FreeNotification(Self);
end;

end.
