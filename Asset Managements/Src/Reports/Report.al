report 55709 "FA Report"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'FA Report';
    ApplicationArea = All;
    ExcelLayout = 'FA Report.xlsx';
    DefaultLayout = Excel;


    dataset
    {
        dataitem("Fixed Asset Movement"; "Fixed Asset Movement")
        {
            column(Fixed_Asset; "Fixed Asset") { }
            column(From_Job_No_; "From Job No.") { }
            column(To_Job_No_; "To Job No.") { }
            Column(Person_Responsible_ID; "Person Responsible ID") { }
            Column(Assgined_By; "Assgined By") { }
            column(From_Date_Time; "From Date Time") { }
            column(To_Date_Time; "To Date Time") { }
            column(E_Mail_Triggered; "E-Mail Triggered") { }
        }
    }
}



// pageextension 55708 ReportEmail extends "Customer Card"
// {
//     layout
//     {

//     }

//     actions
//     {
//         addafter(History)
//         {
//             action("Report for Email")
//             {
//                 Caption = 'Report For Email';
//                 ApplicationArea = All;
//                 trigger OnAction()
//                 var
//                     Email: Codeunit "Email";
//                     EmailMessage: Codeunit "Email Message";
//                     EmailSetup: Record "Email Account";
//                     ToAddress: Text;
//                     Subject: Text;
//                     instream: InStream;
//                     outstream: OutStream;
//                     blob: Codeunit "Temp Blob";
//                     recref: RecordRef;
//                     Cust: Record Customer;
//                     Resrc: Record Resource;
//                 begin
//                     ToAddress := 'solohero300@gmail.com';
//                     Subject := ' Report';
//                     Emailmessage.Create(ToAddress, subject, '');
//                     recref.GetTable(Cust);
//                     blob.CreateOutStream(outstream);
//                     Report.SaveAs(Report::"FA Report", '', ReportFormat::Pdf, outstream);
//                     blob.CreateInStream(instream);
//                     Emailmessage.AddAttachment('Fixed Asset Report.pdf', ' ', instream);
//                     email.Send(Emailmessage);
//                 end;
//             }
//         }
//     }
// }