table 55712 "Brand Table"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Brand Page";
    DrillDownPageId="Brand Page";

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
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}


page 55712 "Brand Page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    Editable = true;
    InsertAllowed = true;
    DeleteAllowed = true;

    SourceTable = "Brand Table";

    layout
    {
        area(Content)
        {
            repeater("Brand Details")
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}