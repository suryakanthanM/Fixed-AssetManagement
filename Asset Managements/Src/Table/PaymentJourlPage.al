pageextension 55706 MyExtension extends "Payment Journal"
{
    layout
    {

    }

    actions
    {

    }
    var
        s: Codeunit "Gen. Jnl.-Post Line";

}

tableextension 55706 MyExtension extends "Gen. Journal Line"
{
    fields
    {
    }

    keys
    {
    }



}



codeunit 55706 PostActionSubscribe
{
    // [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterAccountNoOnValidateGetFABalAccount', '', false, false)]
    // local procedure OnAfterAccountNoOnValidateGetFABalAccount(var GenJournalLine: Record "Gen. Journal Line"; var FixedAsset: Record "Fixed Asset")

    // begin
    //     FixedAsset.FindLast();
    //     FixedAsset.Validate(Description, GenJournalLine.Description);
    //     FixedAsse.Modify();

    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostGenJnlLine', '', false, false)]
    local procedure OnBeforePostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    Var
        TempFASub: Record FixedAssetSubTable;
        Expenses: Record "Expenses Request";
        LineNo: Integer;

    begin
        if Expenses.Get(GenJournalLine."Expense Record ID") then begin

            if Expenses."FANo." <> '' then begin
                TempFAsub.SetRange("Fixed Asset No.", Expenses."FANo.");

                if TempFASub.FindLast() then
                    LineNo := TempFASub."Line No." + 10000
                else
                    LineNo := 10000;
                TempFASub.Init();
                TempFASub.Validate("Line No.", LineNo);
                TempFASub.Validate("Fixed Asset No.", Expenses."FANo.");
                TempFASub.Validate(Cost, Expenses."Requested Amount");

                TempFASub.Validate(Period, Today);
                TempFASub.Insert(true);
            end;
        end;

    end;



    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostGenJnlLine', '', false, false)]
    // local procedure OnBeforePostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    // Var
    //     TempFASub: Record FixedAssetSubTable;
    //     Expenses: Record "Expenses Request";
    //     LineNo: Integer;

    // begin
    //     Expenses.Get(GenJournalLine."Expense Record ID");

    //     if Expenses."FA No." <> '' then begin
    //         TempFAsub.SetRange("Fixed Asset No.", Expenses."FA No.");
    //         TempFASub.Init();
    //         if TempFASub.FindLast() then
    //             LineNo := TempFASub."Line No." + 10000
    //         else
    //             LineNo := 10000;
    //         TempFASub.Validate("Line No.", LineNo);
    //         TempFASub.Validate("Fixed Asset No.", Expenses."FA No.");

    //         TempFASub.Validate(Period, Today);
    //         TempFASub.Insert(true);
    //     end;

    // end;
}