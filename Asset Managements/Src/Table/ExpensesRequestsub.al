tableextension 55707 ExpensesRequest extends "Expenses Request"
{
    fields
    {
        field(50000; "FANo."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset";
            trigger OnValidate()
            var
                FAL: Record "Fixed Asset";
            begin
                if FAL.Get("FANo.") then begin
                    Rec."Serial No." := FAl."Serial No.";
                end;
            end;
        }
        field(50001; "Serial No."; Text[100])
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
pageextension 55707 ExpensesRequestP extends "ExpensesRequest"
{
    layout
    {
        addafter("No.")
        {
            field("FA No."; Rec."FANo.")
            {
                ApplicationArea = All;
            }
            field("Serial No."; Rec."Serial No.")
            {
                ApplicationArea = All;
            }
        }
    }
}


// table 55704 "ExpensesRequest"
// {
//     DataClassification = ToBeClassified;
//     Caption = 'Expenses Request';

//     fields
//     {
//         field(1; Job; Code[20])
//         {
//             DataClassification = ToBeClassified;

//         }
//         field(2; "Job Task"; Code[20])
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(3; "Job Planning Line No."; Integer)
//         {
//             DataClassification = ToBeClassified;
//         }

//         field(4; "Line No."; Integer)
//         {
//             DataClassification = ToBeClassified;
//             // AutoIncrement = true;
//         }

//         field(21; "Type"; Enum "TypeField")
//         {
//             DataClassification = ToBeClassified;

//         }
//         field(22; "No."; Code[20])
//         {
//             DataClassification = ToBeClassified;
//             TableRelation = If (Type = const("G/L Account")) "G/L Account"
//             else
//             if (Type = const(Vendor)) Vendor;
//             trigger OnValidate()
//             var
//                 GLAccountL: Record "G/L Account";
//                 VendorL: Record Vendor;
//             begin
//                 if GLAccountL.Get(Rec."No.") then
//                     Rec.Category := GLAccountL.Name
//                 else
//                     if VendorL.Get(Rec."No.") then
//                         Rec.Description := VendorL.Name;

//             end;
//         }
//         field(23; Description; Text[100])
//         {
//             DataClassification = ToBeClassified;
//         }

//         field(26; Remarks; text[250])
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(27; "Requested Date"; Date)
//         {
//             DataClassification = ToBeClassified;
//         }

//         field(29; "Requested Amount"; Integer)
//         {
//             DataClassification = ToBeClassified;
//             trigger OnValidate()
//             begin
//                 Rec."Remaining Amount" := Rec."Requested Amount" - Rec."Approved Amount";
//             end;
//         }
//         field(30; "Approved Amount"; Integer)
//         {
//             DataClassification = ToBeClassified;
//             trigger OnValidate()
//             var
//                 JobPlanningLineL: Record "Job Planning Line";
//                 ApprovalError: Label 'You cannot Approve beyond the Requested Amount %1 for the Record %2';
//             begin
//                 Rec."Remaining Amount" := Rec."Requested Amount" - Rec."Approved Amount";
//                 if Rec."Remaining Amount" < 0 then
//                     Error(StrSubstNo(ApprovalError, Rec."Remaining Amount", Rec.RecordId));
//             end;
//         }
//         field(31; "Remaining Amount"; Integer)
//         {
//             DataClassification = ToBeClassified;

//         }
//         field(32; "Requested By"; Code[30])
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(33; "Approved Date"; Date)
//         {
//             DataClassification = ToBeClassified;
//         }
//         field(34; "Approved By"; Code[30])
//         {
//             DataClassification = ToBeClassified;
//         }



//         field(36; Rejected; Boolean)
//         {
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }
//         field(37; Location; Code[50])
//         {
//             DataClassification = ToBeClassified;
//             TableRelation = Location;
//         }
//         field(38; Category; Text[50])
//         {
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }
//         field(39; Period; Code[20])
//         {
//             Editable = false;
//             FieldClass = FlowField;
//             CalcFormula = lookup("Job Planning Line".Period where("Job No." = field(Job), "Job Task No." = field("Job Task"), "Line No." = field("Job Planning Line No.")));
//         }

//     }

//     keys
//     {
//         key(Key1; Job, "Job Task", "Job Planning Line No.", "Line No.")
//         {
//             Clustered = true;
//         }
//     }
//     trigger OnInsert()
//     var
//         JobPlanningLineL: Record "Job Planning Line";
//         ExpensesRequestL: Record "ExpensesRequest";
//         TotalCostExpenseL: Integer;
//     begin
//         TotalCostExpenseL := 0;
//         JobPlanningLineL.Reset();
//         JobPlanningLineL.SetRange("Job No.", Rec.Job);
//         JobPlanningLineL.SetRange("Job Task No.", Rec."Job Task");
//         JobPlanningLineL.SetRange("Line No.", Rec."Job Planning Line No.");
//         if JobPlanningLineL.FindFirst() then;


//         ExpensesRequestL.Reset();
//         ExpensesRequestL.SetRange(Job, Rec.Job);
//         ExpensesRequestL.SetRange("Job Task", Rec."Job Task");
//         ExpensesRequestL.SetRange("Job Planning Line No.", Rec."Job Planning Line No.");
//         ExpensesRequestL.SetRange(Rejected, false);
//         ExpensesRequestL.CalcSums(ExpensesRequestL."Requested Amount");
//         TotalCostExpenseL := ExpensesRequestL."Requested Amount";

//         TotalCostExpenseL += Rec."Requested Amount";
//         if TotalCostExpenseL > JobPlanningLineL."Allocated Budget" then
//             Error(Text001);


//         JobPlanningLineL.Validate("Total Request Amount", TotalCostExpenseL);
//         JobPlanningLineL.Modify();

//     end;

//     trigger OnModify()
//     var
//         JobPlanningLineL: Record "Job Planning Line";
//         ExpensesRequestL: Record "ExpensesRequest";
//         ExpenseMgmtL: Codeunit "ExpenseManagement";
//         TotalCostExpenseL: Integer;
//     begin
//         TotalCostExpenseL := 0;
//         JobPlanningLineL.Reset();
//         JobPlanningLineL.SetRange("Job No.", Rec.Job);
//         JobPlanningLineL.SetRange("Job Task No.", Rec."Job Task");
//         JobPlanningLineL.SetRange("Line No.", Rec."Job Planning Line No.");
//         if JobPlanningLineL.FindFirst() then;

//         ExpensesRequestL.Reset();
//         ExpensesRequestL.SetRange(Job, Rec.Job);
//         ExpensesRequestL.SetRange("Job Task", Rec."Job Task");
//         ExpensesRequestL.SetRange("Job Planning Line No.", Rec."Job Planning Line No.");
//         ExpensesRequestL.SetRange(Rejected, false);
//         ExpensesRequestL.CalcSums("Requested Amount");
//         TotalCostExpenseL := ExpensesRequestL."Requested Amount";

//         TotalCostExpenseL += Rec."Requested Amount" - xRec."Requested Amount";
//         if TotalCostExpenseL > JobPlanningLineL."Allocated Budget" then
//             Error(Text001);

//         if ExpenseMgmtL.AlreadySentForApproval(Rec) then
//             Error('Record already sent for approval');

//         JobPlanningLineL.Validate("Total Request Amount", TotalCostExpenseL);
//         JobPlanningLineL.Modify();

//     end;

//     trigger OnDelete()
//     var
//         ExpenseMgmtL: Codeunit "ExpenseManagement";
//     begin
//         if ExpenseMgmtL.AlreadySentForApproval(Rec) then
//             Error('Record already sent for approval');
//         if Rec."Approved Amount" <> 0 then
//             Error(Text002);
//     end;

//     var
//         Text001: Label 'Sum of Requested amount in Expenses Request must be equal or less than Allocated Budget in Project Planning Line';
//         Text002: Label 'This Expense Request is already Approved';
// }

// page 55704 ExpenseRequest
// {
//     PageType = ListPart;
//     ApplicationArea = All;
//     SourceTable = "ExpensesRequest";
//     Caption = 'Expenses Request';
//     AutoSplitKey = true;
//     MultipleNewLines = true;
//     DelayedInsert = true;
//     LinksAllowed = true;


//     layout
//     {
//         area(Content)
//         {
//             repeater(Control1)
//             {
//                 ShowCaption = false;
//                 field(Job; Rec.Job)
//                 {
//                     ToolTip = 'Specifies the value of the Job field.';
//                     ApplicationArea = All;
//                     Visible = false;
//                     Editable = false;
//                 }
//                 field("Job Task"; Rec."Job Task")
//                 {
//                     ToolTip = 'Specifies the value of the Job Task field.';
//                     ApplicationArea = All;
//                     Visible = false;
//                     Editable = false;
//                 }
//                 field("Job Planning Line No."; Rec."Job Planning Line No.")
//                 {
//                     ToolTip = 'Specifies the value of the Job Planning Line No. field.';
//                     ApplicationArea = All;
//                     Visible = false;
//                     Editable = false;
//                 }
//                 field("Line No."; Rec."Line No.")
//                 {
//                     ToolTip = 'Specifies the value of the Line No. field.';
//                     ApplicationArea = All;
//                     Visible = false;
//                     Editable = false;

//                 }
//                 field(Period; Rec.Period)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Type"; Rec."Type")
//                 {
//                     ToolTip = 'Specifies the value of the Type field.';
//                     ApplicationArea = All;
//                     Editable = Rec."Approved Amount" = 0;
//                     trigger OnValidate()
//                     begin

//                         Rec.Location := '';
//                         Rec."No." := '';
//                         Rec.Category := '';
//                         Rec.Description := '';
//                         Rec.Remarks := '';
//                         Rec."Requested Amount" := 0;
//                         Rec."Requested By" := '';
//                         Rec."Requested Date" := 0D;
//                         Rec."Remaining Amount" := 0;
//                     end;
//                 }

//                 field(Location; Rec.Location)
//                 {
//                     ApplicationArea = All;
//                     Editable = Rec."Approved Amount" = 0;
//                 }

//                 field("No."; Rec."No.")
//                 {
//                     ToolTip = 'Specifies the value of the No. field.';
//                     ApplicationArea = All;
//                     Editable = Rec."Approved Amount" = 0;
//                 }
//                 field(Category; Rec.Category)
//                 {
//                     ToolTip = 'Specifies the value of the Description field.';
//                     ApplicationArea = All;
//                     Editable = Rec."Approved Amount" = 0;
//                 }
//                 field(Description; Rec.Description)
//                 {
//                     ApplicationArea = All;
//                     Editable = Rec."Approved Amount" = 0;
//                 }


//                 field(Remarks; Rec.Remarks)
//                 {
//                     ToolTip = 'Specifies the value of the Remarks field.';
//                     ApplicationArea = All;
//                     Editable = Rec."Approved Amount" = 0;
//                 }

//                 field("Requested Amount"; Rec."Requested Amount")
//                 {
//                     ToolTip = 'Specifies the value of the Requested Amount field.';
//                     ApplicationArea = All;
//                     Editable = Rec."Approved Amount" = 0;
//                 }
//                 field("Requested By"; Rec."Requested By")
//                 {
//                     ToolTip = 'Specifies the value of the Requested By field.';
//                     ApplicationArea = All;
//                     Editable = false;
//                 }
//                 field("Requested Date"; Rec."Requested Date")
//                 {
//                     ToolTip = 'Specifies the value of the Requested Date field.';
//                     ApplicationArea = All;
//                     Editable = false;
//                 }
//                 field("Approved Amount"; Rec."Approved Amount")
//                 {
//                     ToolTip = 'Specifies the value of the Approved Amount field.';
//                     ApplicationArea = All;
//                     Editable = false;
//                 }

//                 field("Approved By"; Rec."Approved By")
//                 {
//                     ToolTip = 'Specifies the value of the Approved By field.';
//                     ApplicationArea = All;
//                     Editable = false;
//                 }
//                 field("Approved Date"; Rec."Approved Date")
//                 {
//                     ToolTip = 'Specifies the value of the Approved Date field.';
//                     ApplicationArea = All;
//                     Editable = false;
//                 }

//                 field("Remaining Amount"; Rec."Remaining Amount")
//                 {
//                     ToolTip = 'Specifies the value of the Remaining Amount field.';
//                     ApplicationArea = All;
//                     Editable = false;
//                 }
//                 field(Rejected; Rec.Rejected)
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }


//     }
//     actions
//     {
//         area(Processing)
//         {
//             action(ExpensesRequestPage)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Expenses Request Page';
//                 Image = ListPage;
//                 RunObject = page "Expenses Request List";
//             }
//             action("Send for Approvals")
//             {
//                 ApplicationArea = All;
//                 Caption = 'Send for Approvals';
//                 Image = Approvals;
//                 trigger OnAction()
//                 var
//                     ExpensesRequestL: Record "Gen. Journal Line";
//                     ExpenseMgmt: page Subpage;
//                     JobTaskL: Record "Job Task";
//                     EndDate: Date;
//                     EndDateError: Label '%1 cannot Send for Approval after the End Date(%2), Project %3 in Task No. %4';
//                 begin
//                     CurrPage.SetSelectionFilter(ExpensesRequestL);

//                     JobTaskL.SetRange("Job No.", Rec.Job);
//                     JobTaskL.SetRange("Job Task No.", Rec."Job Task");
//                     if JobTaskL.FindFirst() then begin
//                         JobTaskL.CalcFields("End Date");
//                         if JobTaskL."End Date" < Today then
//                             Error(EndDateError, UserId, JobTaskL."End Date", JobTaskL."Job No.", JobTaskL."Job Task No.");
//                     end;

//                     SetControlAppearance();
//                 end;
//             }
//         }
//     }
//     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
//     begin
//         Rec."Requested By" := UserId;
//         Rec."Requested Date" := Today;
//     end;

//     trigger OnModifyRecord(): Boolean
//     begin
//         Rec."Requested By" := UserId;
//         Rec."Requested Date" := Today;

//     end;

//     local procedure SetControlAppearance()
//     var
//         ApprovalsMgmt: Codeunit "Approvals Mgmt.";
//         WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
//         CanRequestFlowApprovalForLine: Boolean;

//     begin
//         OpenApprovalEntriesExistForCurrUser :=
//             OpenApprovalEntriesExistForCurrUserBatch or ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);

//         OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
//         OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist or OpenApprovalEntriesOnJnlLineExist;

//         CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);

//         WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestFlowApprovalForLine, CanCancelFlowApprovalForLine);
//         CanRequestFlowApprovalForBatchAndCurrentLine := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForLine;
//     end;

//     local procedure CheckOpenApprovalEntries(BatchRecordId: RecordID; GenJournalL: Record "Gen. Journal Line")
//     var
//         ApprovalsMgmt: Codeunit "Approvals Mgmt.";

//     begin
//         OpenApprovalEntriesExistForCurrUserBatch := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(BatchRecordId);

//         OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(BatchRecordId);

//         OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
//           OpenApprovalEntriesOnJnlBatchExist or
//           ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries(GenJournalL."Journal Template Name", GenJournalL."Journal Batch Name");
//     end;

//     var
//         OpenApprovalEntriesExistForCurrUser: Boolean;
//         OpenApprovalEntriesExistForCurrUserBatch: Boolean;
//         OpenApprovalEntriesOnJnlBatchExist: Boolean;
//         OpenApprovalEntriesOnJnlLineExist: Boolean;
//         OpenApprovalEntriesOnBatchOrCurrJnlLineExist: Boolean;
//         OpenApprovalEntriesOnBatchOrAnyJnlLineExist: Boolean;
//         CanCancelApprovalForJnlLine: Boolean;
//         CanRequestFlowApprovalForBatchAndCurrentLine: Boolean;
//         CanRequestFlowApprovalForBatch: Boolean;
//         CanCancelFlowApprovalForLine: Boolean;

// }


// pageextension 55705 JObPLine extends "Job Planning Lines"
// {
//     layout
//     {
//         addafter(Control1)
//         {
//             part(ExpenseRequest; ExpenseRequest)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Expense Request';
//                 SubPageLink = Job = field("Job No.");
//                 UpdatePropagation = Both;
//             }
//         }
//     }

//     actions
//     {
//         // Add changes to page actions here
//     }

//     var
//         myInt: Integer;
// }