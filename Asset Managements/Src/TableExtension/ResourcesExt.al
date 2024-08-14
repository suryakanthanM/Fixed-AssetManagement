tableextension 55708 ResourcesExt extends Resource
{
    fields
    {
        field(5000; "E-Mail"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}

pageextension 55709 ResourcesExt extends "Resource Card"
{
    layout
    {
        addlast("Personal Data")
        {
            field("E-Mail"; REc."E-Mail")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}