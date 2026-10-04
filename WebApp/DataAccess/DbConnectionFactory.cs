using System.Configuration;
using System.Data.SqlClient;

namespace StudentFeedbackSystem.DataAccess
{
    public static class DbConnectionFactory
    {
        private static readonly string ConnectionString =
            ConfigurationManager.ConnectionStrings["StudentFeedbackDb"].ConnectionString;

        public static SqlConnection CreateOpenConnection()
        {
            var connection = new SqlConnection(ConnectionString);
            connection.Open();
            return connection;
        }
    }
}
