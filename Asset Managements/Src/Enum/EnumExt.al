enumextension 55711 ScenarioExt extends "Email Scenario"
{
    value(50000; "Fixed Asset")
    {

    }
}


codeunit 55711 "Email Scenario Setup"
{
    trigger OnRun()

    begin
        Page.Run(Page::"Fixed Asset Card");
    end;
}



