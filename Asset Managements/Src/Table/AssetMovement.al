table 55701 "Fixed Asset Movement"
{
    DataClassification = ToBeClassified;
    
 
    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(21; "Fixed Asset"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "From Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "To Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Assgined By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Person Responsible ID"; Code[20])
        {
            DataClassification = ToBeClassified;
 
        }
        field(26; "E-Mail Triggered"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "From Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "To Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(29; Age; Duration)
        {
            DataClassification = ToBeClassified;
        }
 
    }
}

page 55701 "FixedAssetMovements"
{
    ApplicationArea = All;
    Caption = 'Fixed Asset Movements';
    PageType = List;
    SourceTable = "Fixed Asset Movement";
    // AutoSplitKey=true;
    UsageCategory = Lists;
    Editable = false;
 
 
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Fixed Asset"; Rec."Fixed Asset")
                {
                    ToolTip = 'Specifies the value of the Fixed Asset field.', Comment = '%';
                }
                field("From Job No."; Rec."From Job No.")
                {
                    ToolTip = 'Specifies the value of the From Job No. field.', Comment = '%';
                }
                field("To Job No."; Rec."To Job No.")
                {
                    ToolTip = 'Specifies the value of the To Job No. field.', Comment = '%';
                }
                field("Assgined By"; Rec."Assgined By")
                {
                    ToolTip = 'Specifies the value of the Assgined By field.', Comment = '%';
                }
                field("Person Responsible"; Rec."Person Responsible ID")
                {
                    ToolTip = 'Specifies the value of the Person Responsible field.', Comment = '%';
                }
                field("E-Mail"; Rec."E-Mail Triggered")
                {
                    ToolTip = 'Specifies the value of the E-Mail field.', Comment = '%';
                }
                field("From Date Time"; Rec."From Date Time")
                {
                    ToolTip = 'Specifies the value of the From Date Time field.', Comment = '%';
                }
                field("To Date Time"; Rec."To Date Time")
                {
                    ToolTip = 'Specifies the value of the To Date Time field.', Comment = '%';
                }
                field(Age; Rec.Age)
                {
                    ToolTip = 'Specifies the value of the Age field.', Comment = '%';
                }
            }
        }
    }

    var s: Page "Payment Journal";
}