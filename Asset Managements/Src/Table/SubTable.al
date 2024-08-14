table 55702 FixedAssetSubTable
{
    DataClassification = ToBeClassified;
    Caption = 'Fixed Asset SubTable';

    fields
    {
        field(1; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            //  AutoIncrement=true;
        }
        field(2; "Vehicle Number"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Fixed Asset No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(22; Period; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; Model; Text[20])
        {
            DataClassification = ToBeClassified;

        }
        field(24; "Project Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers="","O&M","Project";            
        }
        field(25; "Client No."; Text[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            trigger OnValidate()
            var
                CustL: Record Customer;
            begin
                if CustL.Get("Client No.") then begin
                    Rec."Client Name" := CustL.Name;
                end;

            end;
        }

        field(26; Remarks; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(27; Cost; Decimal)
        {
            
             DataClassification = ToBeClassified;
           

        }
        field(28; "Total Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Payment Type"; option)
        {
            OptionMembers = " ","Cash","NEFT",UPI,RTGS;
        }
        field(30; "Account Holder Name"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Account No/Mobile No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "IFSC Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(33; Category; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(34; Name; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Client Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(36; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
            trigger OnValidate()
            var
                GLAcc: Record "G/L Account";
            begin
                if GLAcc.Get("No.") then begin
                    Rec.Category := GLAcc.Name;
                end;

            end;
        }
        field(37; "Document No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Approved Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }



    }
    keys
    {
        key(Key1; "Fixed Asset No.", "Line No.")
        {
            Clustered = true;
        }
    }
}

page 55702 Subpage
{
    ApplicationArea = All;
    Caption = 'Finance Details';
    PageType = ListPart;
    SourceTable = FixedAssetSubTable;
    AutoSplitKey = true;
    DeleteAllowed = true;
    InsertAllowed = true;
    LinksAllowed = true;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Visible = false;

                }
                field(Period; Rec.Period)
                {
                    ToolTip = 'Specifies the value of the Period field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Project Type"; Rec."Project Type")
                {
                    ToolTip = 'Specifies the value of the Project Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Client No."; Rec."Client No.")
                {
                    ToolTip = 'Specifies the value of the Client field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Client Name"; Rec."Client Name")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Category; Rec.Category)
                {
                    ToolTip = 'Specifies the value of the Category field.', Comment = '%';
                    ApplicationArea = All;
                }

                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Cost; Rec.Cost)
                {
                    ToolTip = 'Specifies the value of the Cost field.', Comment = '%';
                    ApplicationArea = All;
                }

                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ToolTip = 'Specifies the value of the Payment Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Account Holder Name"; Rec."Account Holder Name")
                {
                    ToolTip = 'Specifies the value of the Account Holder Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Acc.No/Mob.No"; Rec."Account No/Mobile No")
                {
                    ToolTip = 'Specifies the value of the Account No/Mobile No field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("IFSC Code"; Rec."IFSC Code")
                {
                    ToolTip = 'Specifies the value of the IFSC Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ToolTip = 'Specifies the value of the Approved Amount field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("Sent for Approval")
            {
                Caption = 'Sent for Approval';
               // Promoted = true;
                ApplicationArea = All;
               // PromotedCategory = Process;
                Image = SendApprovalRequest;
                trigger OnAction()
                var
                    FixedAssetHeader: Record "Fixed Asset";
                    FixedAssetSub: Record FixedAssetSubTable;
                    GenJournalL: Record "Gen. Journal Line";
                    GenLS: Record "General Ledger Setup";
                    FAsetUp: Record "FA Setup";
                    NoSeries: Codeunit "No. Series";
                    DocNo: Code[10];
                    lineno: Integer;
                    TotalAmount: Decimal;
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    PaymentJournal: Page "Payment Journal";
                begin
                    CurrPage.SetSelectionFilter(FixedAssetSub);
                    GenLS.Get();
                    FAsetUp.Get();
                    if GenJournalL.FindLast() then
                        lineno := GenJournalL."Line No." + 10000
                    else
                        lineno := 10000;

                    // DocNo := NoSeries.GetNextNo(FAsetUp."Document No.", Today);

                    if FixedAssetSub.Findset() then begin

                        repeat

                            FixedAssetHeader.Get(FixedAssetSub."Fixed Asset No.");

                            GenJournalL.Init();
                            GenJournalL.SetRange("Line No.", GenJournalL."Line No.");
                            GenJournalL.Validate("Journal Template Name", GenLS."Payment Journal Template");
                            GenJournalL.Validate("Journal Batch Name", GenLS."Payment Journal Batch");
                            GenJournalL.Validate("Account Type", GenJournalL."Account Type"::"G/L Account");
                            // GenJournalL.Validate("PO No.", 'Veh-' + FixedAssetHeader."Registration No.");
                            GenJournalL.Validate("Line No.", lineno);
                            GenJournalL.Insert(true);
                            GenJournalL."Posting Date" := Today;
                            GenJournalL.Validate("Expense Record ID", FixedAssetSub.RecordId);
                            GenJournalL.Validate(Description, FixedAssetSub.Category);
                            GenJournalL.Validate("Account No.", FixedAssetSub."No.");
                            GenJournalL.Validate("Document Type", GenJournalL."Document Type"::Payment);
                            GenJournalL.Validate("Remarks", FixedAssetSub.Remarks);
                            GenJournalL.Validate("Document No.", DocNo);
                            GenJournalL.Validate(Amount, FixedAssetSub.Cost);
                            GenJournalL.Modify(true);


                            lineno += 10000;
                            TotalAmount += GenJournalL.Amount;
                        until FixedAssetSub.Next() = 0;
                    end;

                    GenJournalL.Init();
                    GenJournalL.SetRange("Line No.", GenJournalL."Line No.");
                    GenJournalL.Validate("Journal Template Name", GenLS."Payment Journal Template");
                    GenJournalL.Validate("Journal Batch Name", GenLS."Payment Journal Batch");
                    GenJournalL.Validate("Account Type", GenJournalL."Account Type"::"Bank Account");
                    GenJournalL.Validate("Line No.", lineno);
                    GenJournalL.Insert(true);
                    GenJournalL."Posting Date" := Today;
                    GenJournalL.Validate(Description, 'Total Amount');
                    GenJournalL.Validate("Document Type", GenJournalL."Document Type"::Payment);
                    GenJournalL.Validate("Document No.", DocNo);
                    GenJournalL.Validate("Account No.", GenLS."Payment Journal Bank");
                    GenJournalL.Validate(Amount, -TotalAmount);
                    GenJournalL.Modify(true);

                    message('Approval sent');


                    ApprovalsMgmt.TrySendJournalBatchApprovalRequest(GenJournalL);
                    PaymentJournal.SetControlAppearanceFromBatch();
                    SetControlAppearance();

                    message('Approval posted');

                end;

            }
        }
    }
    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
        CanRequestFlowApprovalForLine: Boolean;

    begin
        OpenApprovalEntriesExistForCurrUser :=
            OpenApprovalEntriesExistForCurrUserBatch or ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);

        OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist or OpenApprovalEntriesOnJnlLineExist;

        CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestFlowApprovalForLine, CanCancelFlowApprovalForLine);
        CanRequestFlowApprovalForBatchAndCurrentLine := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForLine;
    end;

    local procedure CheckOpenApprovalEntries(BatchRecordId: RecordID; GenJournalL: Record "Gen. Journal Line")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";

    begin
        OpenApprovalEntriesExistForCurrUserBatch := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(BatchRecordId);

        OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(BatchRecordId);

        OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
          OpenApprovalEntriesOnJnlBatchExist or
          ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries(GenJournalL."Journal Template Name", GenJournalL."Journal Batch Name");
    end;

    var
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExistForCurrUserBatch: Boolean;
        OpenApprovalEntriesOnJnlBatchExist: Boolean;
        OpenApprovalEntriesOnJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrAnyJnlLineExist: Boolean;
        CanCancelApprovalForJnlLine: Boolean;
        CanRequestFlowApprovalForBatchAndCurrentLine: Boolean;
        CanRequestFlowApprovalForBatch: Boolean;
        CanCancelFlowApprovalForLine: Boolean;
}
