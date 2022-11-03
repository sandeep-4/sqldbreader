page 50711 Student
{
    ApplicationArea = All;
    Caption = 'Student';
    PageType = List;
    SourceTable = Student;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.';
                }
            }
        }


    }
    actions
    {
        area(Processing)
        {
            action(Sycn)
            {
                ApplicationArea = All;
                Promoted = true;
                Image = OutlookSyncFields;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    SQLReader: Codeunit SQLReader;
                begin
                    SQLReader.syncStudents();
                    Message('Done');
                end;
            }
        }
    }

}
