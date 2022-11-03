codeunit 50711 SQLReader
{
    trigger OnRun()
    begin

    end;

    procedure SetupConnectiontoSQL(var SQLConnection: DotNet SQLConnection)
    var
    begin
        SQLConnection := SQLConnection.SqlConnection(GetConnectionString); //completed
        SQLConnection.Open();
    end;

    procedure CloseConnection(var SQLConnection: DotNet SQLConnection)
    var
    begin
        SQLConnection.Close(); //completed
        SQLConnection.Dispose();
    end;

    procedure GetConnectionString() ConnStr: text
    var
        serverName: Text;
        DBName: Text; //completed
    begin
        GETServerInfo(Servername, DbName);
        If (serverName = '') OR (DBName = '') then
            exit('Please enter server name an ddb name');

        if not IsServiceTier then begin
            ConnStr := 'Provider=SQLOLEDB;' +
            'Initial Catalog=' + UpperCase(DBName) +
            ';Data Source=' + UpperCase(serverName) +
            ';User ID=' + SQLUsrId + ';Password=' + SQLPass;
        end else begin
            ConnStr :=
            'Server=' + serverName + ';' +
            'Database="' + DBName + '";' +
            'Uid=' + SQLUsrId + ';' +
            'Pwd=' + SQLPass + ';';
        end;

        exit(ConnStr);
    end;


    procedure GETServerInfo(var SerVName: Text; var DBN: Text)
    var
        myInt: Integer; //completed
    begin
        Clear(SerVName);
        Clear(DBN);
        Clear(SQLUsrId);
        Clear(SQLPass);

        // SerVName := '1.1.1.1';
        // DBN := 'dbbame';
        // SQLUsrId := 'NAVServer\serbernname';
        // SQLPass := 'testpassword';

        SerVName := 'NAV\BC190';
        DBN := 'Student';
        SQLUsrId := 'NAV\agile';
        SQLPass := '';
    end;

    //setup Command
    procedure setupSQLCommand(SQLConnection: DotNet SQLConnection; SQLCommand: DotNet SQLCommand; commandText: Text; SQLcommandType: Option StoreProcedure,TableDirect,TextOpt)
    var
    begin
        SQLCommand := SQLConnection.CreateCommand(); //complete
        SQLCommand.CommandText := commandText;
        SQLCommand.CommandTimeout := 15;
    end;

    procedure readRecords(TableName: Text)
    var
        myInt: Integer;
    begin
        Clear(commandtxt);
        commandtxt := readTextConst + TableName;
        setupSQLCommand(SQLConn, SQLComm, commandtxt, SQLCommType::TextOpt);
        SQLDataReader := SQLComm.ExecuteReader();
    end;

    procedure insertIntoStudent(var Student: Record Student)
    var
    //Student: Record Student;
    begin
        // with SQLDataReader.Read() do begin
        //     Student.Reset();
        //     Student.SetRange("No.",SQLDataReader.GetValue(No));
        // end;

        Clear(commandtxt);
        SetupConnectiontoSQL(SQLConn);
        commandtxt := InsertTxt + Student.TableName + SpaceTxt + '(No,Name,Address)' + ValueTxt + '(@No,@Name,@Address)';
        setupSQLCommand(SQLConn, SQLComm, commandtxt, SQLCommType::TextOpt);

        SQLComm.Parameters.AddWithValue('@No', Format(Student."No."));
        SQLComm.Parameters.AddWithValue('@Name', Format(Student.Name));
        SQLComm.Parameters.AddWithValue('@Address', Format(Student.Address));
        SQLComm.ExecuteNonQuery();
    end;


    procedure updateIntoStudent(var Student: Record Student)
    var
    //Student: Record Student;
    begin
        // with SQLDataReader.Read() do begin
        //     Student.Reset();
        //     Student.SetRange("No.",SQLDataReader.GetValue(No));
        // end;

        Clear(commandtxt);
        SetupConnectiontoSQL(SQLConn);
        commandtxt := UpdateTxt + Student.TableName + SpaceTxt
        + SetTxt +
        // 'No=@No' +
        'Name=@Name' +
        'Address=@Address' + whereTxt +
        'No' + ' = ''' + FORMAT(Student."No.") + '''';
        setupSQLCommand(SQLConn, SQLComm, commandtxt, SQLCommType::TextOpt);

        SQLComm.Parameters.AddWithValue('@No', Format(Student."No."));
        SQLComm.Parameters.AddWithValue('@Name', Format(Student.Name));
        SQLComm.Parameters.AddWithValue('@Address', Format(Student.Address));
        SQLComm.ExecuteNonQuery();
    end;

    procedure syncStudents()
    var
        Student: Record Student;
    begin
        // SetupConnectiontoSQL(SQLConn);
        // readRecords('[' + 'Student' + ']');
        // insertIntoStudent();
        // CloseConnection(SQLConn);
        SetupConnectiontoSQL(SQLConn);
        Student.Reset();
        Student.SetCurrentKey("No.");
        //Student.SetRange("No.");
        if Student.FindSet() then
            repeat
                readStudentFromDB(FORMAT(Student."No."), Student.FieldName("No."));
                if SQLDataReader.HasRows then begin
                    CloseConnection(SQLConn);
                    updateIntoStudent(Student);
                end else begin
                    insertIntoStudent(Student);
                end;

            until Student.Next() = 0;
        CloseConnection(SQLConn);
    end;

    procedure readStudentFromDB(PrimaryCode: Code[20]; FieldName: Text)
    var
        myInt: Integer;
        Student: Record Student;
    begin
        Clear(SQLComm);
        commandtxt := readTextConst + Student.TableName + SpaceTxt + whereTxt + 'No' + ' = ''' + FORMAT(PrimaryCode) + '''';
        setupSQLCommand(SQLConn, SQLComm, commandtxt, SQLCommType::TextOpt);

        SQLDataReader := SQLComm.ExecuteReader();
        SQLDataReader.Read();

    end;


    var
        myInt: Integer;
        SQLUsrId: Text;
        SQLPass: Text;
        commandtxt: Text;

        readTextConst: TextConst ENU = 'select * from';

        whereTxt: Label 'where', Locked = true;

        SetTxt: Label 'set', Locked = true;

        UpdateTxt: Label 'Update', Locked = true;

        InsertTxt: Label 'Insert into', Locked = true;

        SpaceTxt: Label ' ', Locked = true;

        ValueTxt: Label 'values', Locked = true;

        SQLConn: DotNet SQLConnection;

        SQLComm: DotNet SQLCommand;

        SQLCommType: Option StoreProcedure,TableDirect,TextOpt;

        SQLDataReader: DotNet SQLDataReader;

        SQLParam: DotNet SQLParam;
}