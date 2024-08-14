table 55714 "Model Table"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Model Page";

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(21; Name; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Brand Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Brand Table";
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}





page 55714 "Model Page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = true;
    DeleteAllowed = true;
    Editable = true;
    SourceTable = "Model Table";

    layout
    {
        area(Content)
        {
            repeater("Model Details")
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Brand Code"; Rec."Brand Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}