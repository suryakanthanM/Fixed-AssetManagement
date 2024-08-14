tableextension 55700 FixedAssetExt extends "Fixed Asset"
{
    fields
    {

        field(50001; "Project No."; code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;
            // trigger OnValidate()
            // var
            //     job: Record job;
            // begin
            //     job.Get(Rec."Project No");
            //     Rec."Project Name" := job.Description;
            // end;
        }
        field(50002; "Project_Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            // Editable = false;
        }
        field(50003; " Location"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(50004; "Responsible Empolyee 2"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

        }
        field(50005; "Project Age"; Duration)
        {
            DataClassification = ToBeClassified;
        }

        field(50006; "Total Amount"; Decimal)
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = sum(FixedAssetSubTable.Cost where("Fixed Asset No." = field("No.")));
        }

        field(50007; Brand; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Brand Table";
            trigger OnValidate()
            var
                ModelT: Record "Model Table";
            begin
                if Brand <> '' then begin
                    ModelT.SetRange("Brand Code", Brand);
                    Model := '';
                end;
            end;
        }

        field(50008; Model; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Model Table".Code WHERE("Brand Code" = FIELD(Brand)); // Filter Model Table based on selected Brand
            trigger OnValidate()
            var
                ModelT: Record "Model Table";
            begin
                if Brand <> '' then begin
                    if ModelT.Get(Model) then begin
                        if ModelT."Brand Code" <> Brand then
                            Error('Invalid model for the selected brand');
                    end;
                end;
            end;
        }


    }
}

pageextension 55700 FixedAssetPageExt extends "Fixed Asset Card"
{

    layout
    {

        addlast(general)
        {
            field("Total Amount"; Rec."Total Amount")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Serial No.")
        {
            field("Project No"; Rec."Project No.")
            {
                Caption = 'Project No.';
                ApplicationArea = all;
                trigger OnValidate()
                var
                    FAmove: Record "Fixed Asset Movement";
                    LastFAmove: Record "Fixed Asset Movement";
                    Employee: Record Employee;
                    job: Record job;
                begin
                    if job.Get(Rec."Project No.") then begin
                        Rec."Project_Name" := job.Description;
                        // if Rec.Get(Rec."No.") then begin

                        FAmove.Init();
                        FAmove.Validate("Fixed Asset", Rec."No.");
                        FAmove.Validate("Assgined By", UserId);
                        FAmove.Validate("Person Responsible ID", Job."Person Responsible");


                        LastFAmove.SetRange("Fixed Asset", Rec."No.");
                        if LastFAmove.FindLast() then begin

                            FAmove."From Job No." := LastFAmove."To Job No.";
                            FAmove."From Date Time" := CurrentDateTime;
                            LastFAmove."To Date Time" := FAmove."From Date Time";
                            LastFAmove.Age := LastFAmove."To Date Time" - LastFAmove."From Date Time";
                            LastFAmove.Modify();
                            FAmove."To Job No." := Rec."Project No.";

                        end else begin
                            FAmove."From Job No." := '';
                            FAmove."From Date Time" := CurrentDateTime;
                            FAmove."To Job No." := Rec."Project No.";

                        end;
                        FAmove.Validate("E-Mail Triggered", "Send Email"(Job));
                        FAmove.Insert();
                        message('Data moved');
                    end;
                end;
            }
            field("Project Name"; Rec."Project_Name")
            {
                ApplicationArea = all;
            }
            field(Location; Rec." Location")
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field(Brand; Rec.Brand)
            {
                ApplicationArea = All;
            }
            field(Model; Rec.Model)
            {
                ApplicationArea = All;
            }
        }
        addafter("Responsible Employee")
        {
            group("ResponsibleEmployeeGroup")
            {
                ShowCaption = false;
                Visible = Bool;


                field("Resposible Empolyee 2"; Rec."Responsible Empolyee 2")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        if Rec."Responsible Empolyee 2" <> '' then
                            SendEmailToEmployee(Rec."Responsible Empolyee 2");
                        Message('E-Mail has been send to %1', Rec."Responsible Empolyee 2");
                    end;
                }
            }
        }
        addafter(general)
        {
            group("Asset Finance")
            {
                ShowCaption = false;
                part(Subpage; Subpage)
                {
                    Caption = 'Expenses Details';
                    SubPageLink = "Fixed Asset No." = field("No.");
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                }
            }
        }
    }
    Actions
    {
        addafter("FA Book Value")
        {
            action("FA Report")
            {
                Caption = 'FA Report';
                Image = Report;
                ApplicationArea = All;
                trigger OnAction()
                var
                    Resource: Record Resource;
                    Email: Codeunit Email;
                    EmailMessage: Codeunit "Email Message";
                    instream: InStream;
                    outstream: OutStream;
                    blob: Codeunit "Temp Blob";
                    recref: RecordRef;
                    Resrc: Record Resource;
                    Job: Record Job;
                begin
                    Job.Get(Rec."Project No.");
                    Resource.Get(Job."Person Responsible");
                    Resource.TestField("E-Mail");
                    recref.GetTable(Rec);
                    blob.CreateOutStream(outstream);
                    EmailMessage.Create(Resource."E-Mail", 'Fixed Asset Report', '');
                    Report.SaveAs(Report::"FA Report", '', ReportFormat::Excel, outstream);
                    blob.CreateInStream(instream);
                    Emailmessage.AddAttachment('Fixed Asset Report.xlsx', ' ', instream);
                    Email.Send(EmailMessage);
                    Dialog.Message('Email was sent to the responsible person :' + Resource.Name);
                end;

            }
        }
        addafter("C&opy Fixed Asset")
        {
            action("FA Movement")
            {
                Caption = 'FA Movement';
                Image = MovementWorksheet;
                promoted = true;
                PromotedCategory = process;
                ApplicationArea = All;
                tooltip = 'By clicking here you can move on to the Fixed Asset Movement List Page';
                trigger OnAction()
                var
                    FAmove: Record "Fixed Asset Movement";
                begin
                    FAmove.SetRange("Fixed Asset", Rec."No.");
                    Page.Run(55701, FAmove);
                end;
            }

        }
        addafter("C&opy Fixed Asset")
        {
            action("Monthly Expenses")
            {
                Caption = 'Monthly Expenses';
                Image = Report;
                Promoted = true;
                PromotedCategory = process;
                ApplicationArea = All;
                tooltip = 'By clicking here you can see the Total Expenses With in the range';
                trigger OnAction()

                begin
                    Report.Run(55711);
                end;
            }
        }
    }

    procedure "Send Email"(Job: Record Job): Boolean
    var
        Resource: Record Resource;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
    begin
        Resource.Get(Job."Person Responsible");
        Resource.TestField("E-Mail");
        EmailMessage.Create(Resource."E-Mail", 'Hello', '');
        Exit(Email.Send(EmailMessage));
    end;

    procedure "SendEmailToEmployee"(EmployeeCode: Code[10])
    var
        Employee: Record Employee;
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
    begin
        Employee.Get(EmployeeCode);
        Employee.TestField("E-Mail");
        EmailMessage.Create(Employee."E-Mail", 'Fixed Asset Movement', 'Fixed asset movement notification');
        Email.Send(EmailMessage);
    end;

    var
        Bool: Boolean;

    trigger OnAfterGetRecord()
    begin
        Bool := Rec."Responsible Employee" <> '';
        CurrPage.Update();
    end;
}

pageextension 55701 FixedAssetL extends "Fixed Asset List"
{
    layout
    {
        addafter(Description)
        {
            field(Location; Rec." Location")
            {
                ApplicationArea = All;
            }
            field("Project Age"; Rec."Project Age")
            {
                ApplicationArea = All;
            }
        }
    }
}




