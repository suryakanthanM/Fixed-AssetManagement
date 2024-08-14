pageextension 55705 ProjectPExt extends "Job Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(CompleteProject)
        {
            action("Assigned TMI")
            {
                ApplicationArea = all;
                Image = FixedAssets;
                Promoted = true;
                PromotedCategory = process;
                tooltip = 'By clicking here you can move to the Fixed Asset List page';
                trigger OnAction()
                var
                    FA: Record "Fixed Asset";
                    FAmove: Record "Fixed Asset Movement";
                    ProjectAge: Duration;
                begin
                    FAmove.SetRange("To Job No.", Rec."No.");
                    if FAmove.FindSet() then
                        repeat
                            ProjectAge := CurrentDateTime - FAmove."From Date Time";
                            if FA.Get(FAmove."Fixed Asset") then begin
                                FA."Project Age" := ProjectAge;
                                FA.Modify(true); // use Modify(true) to commit the changes
                            end else
                                Error('Fixed Asset %1 not found', FAmove."Fixed Asset");
                        until FAmove.Next() = 0;
                    Message('Project Age %1 ', ProjectAge);
                    // Message('No Fixed Asset Movement found for Project No.: %1', Rec."No.");
                    Page.Run(Page::"Fixed Asset List");
                end;
            }
        }
    }
}
