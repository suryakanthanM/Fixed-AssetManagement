// codeunit 55705 "ExpenseManagement"
// {
 
//     procedure CreateBatchTemplate(var ExpensesRequestP: Record "ExpensesRequest")
//     var
//         GenLedgerSetupL: Record "General Ledger Setup";
//         GenBatchTemp: Record "Gen. Journal Batch";
//         SalesReceiSetup: Record "Sales & Receivables Setup";
 
//     begin
//         ExpensesRequestP.FindSet();
//         GenLedgerSetupL.Get();
//         SalesReceiSetup.Get();
//         if not GenBatchTemp.Get(GenLedgerSetupL."Payment Journal Template", ExpensesRequestP.Job)
//         then begin
//             GenBatchTemp.Init();
//             GenBatchTemp.Validate("Journal Template Name", GenLedgerSetupL."Payment Journal Template");
//             GenBatchTemp.Validate(Name, ExpensesRequestP.Job);
//             GenBatchTemp.Insert(true);
//             GenBatchTemp.Validate(Description, ExpensesRequestP.Description);
//             GenBatchTemp.Validate("Bal. Account Type", GenBatchTemp."Bal. Account Type"::"G/L Account");
//             GenBatchTemp.Validate("Bal. Account No.", '2910');
//             GenBatchTemp."No. Series" := SalesReceiSetup."Expense Request Nos";
//             GenBatchTemp."Copy VAT Setup to Jnl. Lines" := true;
//             GenBatchTemp.Modify();
//         end;
 
 
 
//     end;
 
//     procedure SendForApproval(var ExpensesRequestP: Record "ExpensesRequest")
//     var
//         GenJnlLineL: Record "Gen. Journal Line";
//         GenJnlLine2L: Record "Gen. Journal Line";
//         GenLedgerSetupL: Record "General Ledger Setup";
//         BankAccountL: Record "Bank Account";
//         SalesReceiSetup: Record "Sales & Receivables Setup";
//         NoSeries: Codeunit "No. Series";
//         ApprovalsMgmt: Codeunit "Approvals Mgmt.";
//         DocumentNoL: Code[20];
//         AccountNoL: Text[30];
//         LineNoL: Integer;
//         TotalAmountL: Integer;
//         AlreadysendError: Label 'Nothing to Send for Approval';
//         RecordinPaymentJnl: Label 'Selected Records already sent for Approval';
//     begin
//         DocumentNoL := '';
//         LineNoL := 0;
//         GenLedgerSetupL.Get();
//         SalesReceiSetup.Get();
//         GenLedgerSetupL.TestField("Payment Journal Template");
//         GenLedgerSetupL.TestField("Payment Journal Batch");
//         GenLedgerSetupL.TestField("Payment Journal Bank");
//         SalesReceiSetup.TestField("Expense Request Nos");
 
//         DocumentNoL := NoSeries.GetNextNo(SalesReceiSetup."Expense Request Nos", Today);
 
//         GenJnlLineL.Reset();
//         GenJnlLineL.SetRange("Journal Template Name", GenLedgerSetupL."Payment Journal Template");
//         GenJnlLineL.SetRange("Journal Batch Name", ExpensesRequestP.Job);
//         if GenJnlLineL.FindLast() then
//             LineNoL := GenJnlLineL."Line No." + 10000
//         else
//             LineNoL := 10000;
 
//         ExpensesRequestP.SetFilter("Remaining Amount", '>%1', 0);
//         if ExpensesRequestP.FindSet() then
//             repeat
//                 if not ExpensesRequestP.Rejected then begin
//                     if not AlreadySentForApproval(ExpensesRequestP) then begin
//                         GenJnlLineL.Init();
//                         GenJnlLineL.Validate("Journal Template Name", GenLedgerSetupL."Payment Journal Template");
//                         GenJnlLineL.Validate("Journal Batch Name", ExpensesRequestP.Job);
 
//                         GenJnlLineL."Line No." := LineNoL;
//                         GenJnlLineL.Validate("Document Type", GenJnlLineL."Document Type"::Payment);
//                         GenJnlLineL.Validate("Document No.", DocumentNoL);
//                         if ExpensesRequestP.Type = ExpensesRequestP.Type::"G/L Account" then
//                             GenJnlLineL.Validate("Account Type", GenJnlLineL."Account Type"::"G/L Account")
//                         else
//                             GenJnlLineL.Validate("Account Type", GenJnlLineL."Account Type"::Vendor);
//                         GenJnlLineL.Validate("PO No.", ExpensesRequestP."Job Task");// >> Upgrade <<
//                         GenJnlLineL.Validate("Account No.", ExpensesRequestP."No.");
//                         GenJnlLineL.Validate(Description, ExpensesRequestP.Description);
//                         GenJnlLineL.Validate(Remarks, ExpensesRequestP.Remarks);
//                         GenJnlLineL.Validate("Posting Date", Today);
//                         GenJnlLineL.Validate(Amount, ExpensesRequestP."Remaining Amount");
//                         TotalAmountL += ExpensesRequestP."Remaining Amount";
//                         GenJnlLineL."Expense Record ID" := ExpensesRequestP.RecordId;
//                         GenJnlLineL.Insert(true);
//                         LineNoL += 10000;
//                     end;
//                 end
//                 else
//                     Error('Selected Record is Already Rejected');
 
 
//             until ExpensesRequestP.Next() = 0
//         else
//             Error(AlreadySendError);
 
//         if TotalAmountL > 0 then begin
//             BankAccountL.Get(GenLedgerSetupL."Payment Journal Bank");
//             GenJnlLineL.Init();
//             GenJnlLineL.Validate("Journal Template Name", GenLedgerSetupL."Payment Journal Template");
//             GenJnlLineL.Validate("Journal Batch Name", ExpensesRequestP.Job);
//             GenJnlLineL.Validate("Line No.", LineNoL);
//             GenJnlLineL.Validate("Document Type", GenJnlLineL."Document Type"::Payment);
//             GenJnlLineL.Validate("Document No.", DocumentNoL);
//             GenJnlLineL.Validate("Account Type", GenJnlLineL."Account Type"::"Bank Account");
//             GenJnlLineL.Validate("Account No.", GenLedgerSetupL."Payment Journal Bank");
//             GenJnlLineL.Validate(Description, BankAccountL.Name);
//             GenJnlLineL.Validate("Posting Date", Today);
//             GenJnlLineL.Validate(Amount, -TotalAmountL);
//             GenJnlLineL.Insert(true);
 
//             // -- Request for Approval
//             GenJnlLine2L.SetRange("Journal Template Name", GenLedgerSetupL."Payment Journal Template");
//             GenJnlLine2L.SetRange("Journal Batch Name", ExpensesRequestP.Job);
//             GenJnlLine2L.FindSet();
//             ApprovalsMgmt.TrySendJournalBatchApprovalRequest(GenJnlLine2L);
//             SetControlAppearanceFromBatch(GenJnlLine2L);
//             SetControlAppearance(GenJnlLine2L);
//             Message(CompletionMsgG);
//             // -- Request for Approval
//         end else
//             Message(RecordinPaymentJnl);
//     end;
 
//     procedure AlreadySentForApproval(var ExpenseRequestP: Record "ExpensesRequest"): Boolean
//     var
//         GenJnlLineL: Record "Gen. Journal Line";
//     begin
//         GenJnlLineL.SetRange("Expense Record ID", ExpenseRequestP.RecordId);
//         if GenJnlLineL.IsEmpty() then
//             exit(false);
//         exit(true);
//     end;
 
//     var
//         CompletionMsgG: Label 'Selected Records are Send for Approval';
//         ClientTypeManagement: Codeunit "Client Type Management";
//         BackgroundErrorHandlingMgt: Codeunit "Background Error Handling Mgt.";
//         JournalErrorsMgt: Codeunit "Journal Errors Mgt.";
//         OpenApprovalEntriesExistForCurrUserBatch: Boolean;
//         OpenApprovalEntriesOnJnlBatchExist: Boolean;
//         OpenApprovalEntriesOnBatchOrAnyJnlLineExist: Boolean;
//         CanCancelApprovalForJnlBatch: Boolean;
//         CanRequestFlowApprovalForBatch: Boolean;
//         CanCancelFlowApprovalForBatch: Boolean;
//         CanRequestFlowApprovalForBatchAndAllLines: Boolean;
//         ApprovalEntriesExistSentByCurrentUser: Boolean;
//         EnabledGenJnlLineWorkflowsExist: Boolean;
//         EnabledGenJnlBatchWorkflowsExist: Boolean;
//         BackgroundErrorCheck: Boolean;
//         OpenApprovalEntriesExistForCurrUser: Boolean;
//         ShowAllLinesEnabled: Boolean;
//         OpenApprovalEntriesOnBatchOrCurrJnlLineExist: Boolean;
//         OpenApprovalEntriesOnJnlLineExist: Boolean;
//         CanCancelApprovalForJnlLine: Boolean;
//         CanRequestFlowApprovalForBatchAndCurrentLine: Boolean;
//         CanCancelFlowApprovalForLine: Boolean;
 
//     procedure SetControlAppearanceFromBatch(GenJnlLineP: Record "Gen. Journal Line")
//     begin
//         SetApprovalStateForBatch(GenJnlLineP);
//         BackgroundErrorCheck := BackgroundErrorHandlingMgt.BackgroundValidationFeatureEnabled();
//         ShowAllLinesEnabled := true;
//         GenJnlLineP.SwitchLinesWithErrorsFilter(ShowAllLinesEnabled);
//         JournalErrorsMgt.SetFullBatchCheck(true);
//     end;
 
//     procedure SetApprovalStateForBatch(GenJnlLineP: Record "Gen. Journal Line")
//     var
//         GenJournalBatch: Record "Gen. Journal Batch";
//         ApprovalsMgmt: Codeunit "Approvals Mgmt.";
//         WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
//         WorkflowManagement: Codeunit "Workflow Management";
//         WorkflowEventHandling: Codeunit "Workflow Event Handling";
//         CurrentJnlTemplateName: Code[15];
//         CurrentJnlBatchName: Code[10];
//         CanRequestFlowApprovalForAllLines: Boolean;
 
//     begin
//         if ClientTypeManagement.GetCurrentClientType() = CLIENTTYPE::ODataV4 then
//             exit;
//         CurrentJnlTemplateName := GenJnlLineP."Journal Template Name";
//         CurrentJnlBatchName := GenJnlLineP."Journal Batch Name";
//         if not GenJournalBatch.Get(CurrentJnlTemplateName, CurrentJnlBatchName) then
//             exit;
 
//         CheckOpenApprovalEntries(GenJournalBatch.RecordId, GenJnlLineP);
 
//         CanCancelApprovalForJnlBatch := ApprovalsMgmt.CanCancelApprovalForRecord(GenJournalBatch.RecordId);
 
//         WorkflowWebhookManagement.GetCanRequestAndCanCancelJournalBatch(
//           GenJournalBatch, CanRequestFlowApprovalForBatch, CanCancelFlowApprovalForBatch, CanRequestFlowApprovalForAllLines);
//         CanRequestFlowApprovalForBatchAndAllLines := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForAllLines;
//         ApprovalEntriesExistSentByCurrentUser := ApprovalsMgmt.HasApprovalEntriesSentByCurrentUser(GenJournalBatch.RecordId) or ApprovalsMgmt.HasApprovalEntriesSentByCurrentUser(GenJnlLineP.RecordId);
 
//         EnabledGenJnlLineWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::"Gen. Journal Line", WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode());
//         EnabledGenJnlBatchWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::"Gen. Journal Batch", WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode());
 
//     end;
 
//     procedure CheckOpenApprovalEntries(BatchRecordId: RecordID; GenJnlLineP: Record "Gen. Journal Line")
//     var
//         ApprovalsMgmt: Codeunit "Approvals Mgmt.";
//     begin
//         OpenApprovalEntriesExistForCurrUserBatch := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(BatchRecordId);
 
//         OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(BatchRecordId);
 
//         OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
//           OpenApprovalEntriesOnJnlBatchExist or
//           ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries(GenJnlLineP."Journal Template Name", GenJnlLineP."Journal Batch Name");
//     end;
 
//     local procedure SetControlAppearance(GenJnlLineP: Record "Gen. Journal Line")
//     var
//         ApprovalsMgmt: Codeunit "Approvals Mgmt.";
//         WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
//         CanRequestFlowApprovalForLine: Boolean;
//     begin
//         OpenApprovalEntriesExistForCurrUser :=
//           OpenApprovalEntriesExistForCurrUserBatch or ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(GenJnlLineP.RecordId);
 
//         OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(GenJnlLineP.RecordId);
//         OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist or OpenApprovalEntriesOnJnlLineExist;
 
//         CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(GenJnlLineP.RecordId);
 
//         WorkflowWebhookManagement.GetCanRequestAndCanCancel(GenJnlLineP.RecordId, CanRequestFlowApprovalForLine, CanCancelFlowApprovalForLine);
//         CanRequestFlowApprovalForBatchAndCurrentLine := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForLine;
//     end;
 
 
 
// }