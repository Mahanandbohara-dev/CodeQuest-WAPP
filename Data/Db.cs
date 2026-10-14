using Microsoft.Data.SqlClient;

namespace CodeQuest.Data;

public static class Db
{
    public static SqlConnection Open(string? connectionString)
    {
        var connection = Create(connectionString);
        connection.Open();
        return connection;
    }

    public static async Task<SqlConnection> OpenAsync(
        string? connectionString,
        CancellationToken cancellationToken = default)
    {
        var connection = Create(connectionString);
        await connection.OpenAsync(cancellationToken);
        return connection;
    }

    private static SqlConnection Create(string? connectionString)
    {
        if (string.IsNullOrWhiteSpace(connectionString))
            throw new InvalidOperationException("The DefaultConnection connection string is not configured.");

        return new SqlConnection(connectionString);
    }
}
