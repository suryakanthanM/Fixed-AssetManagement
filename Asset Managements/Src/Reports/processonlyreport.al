report 55711 "Monthly Expenses"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Expenses Request"; "Expenses Request")
        {
            column(Approved_Amount; "Approved Amount")
            {
            }

            trigger OnPreDataItem()
            begin

                SetFilter("Requested Date", '%1..%2', StartDate, EndDate);
            end;

            trigger OnAfterGetRecord()
            begin

                TotalApprovedAmount := TotalApprovedAmount + "Approved Amount";
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Set Date to filter")
                {
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                    }
                }
            }
        }
    }
    trigger OnPostReport()
    begin
        // Display the total approved amount as a message
        Message('Total approved amount between %1 and %2 is: %3', StartDate, EndDate, TotalApprovedAmount);
    end;

    var
        StartDate: Date;
        EndDate: Date;
        TotalApprovedAmount: Decimal;
}
