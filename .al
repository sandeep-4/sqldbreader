dotnet
{
    assembly(System.Data)
    {
        type(System.Data.SqlClient.SqlConnection; SQLConnection) { }
        type(System.Data.SqlClient.SqlCommand; SQLCommand) { }
        type(System.Data.SqlClient.SqlParameter; SQLParam) { }
        type(System.Data.SqlClient.SqlDataReader; SQLDataReader) { }
    }
}