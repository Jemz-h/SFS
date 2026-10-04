using System;
using System.Data;
using Dapper;
using StudentFeedbackSystem.DataAccess;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public class AdminRepository : IAdminRepository
    {
        private const CommandType Proc = CommandType.StoredProcedure;

        public Admin GetById(int adminId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.QuerySingleOrDefault<Admin>("dbo.usp_Admin_GetById", new { AdminId = adminId }, commandType: Proc);
            }
        }

        public Admin GetByUsername(string username)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.QuerySingleOrDefault<Admin>("dbo.usp_Admin_GetByUsername", new { Username = username }, commandType: Proc);
            }
        }

        public void RecordFailedLogin(int adminId, int failedCount, DateTime? lockoutUntil)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Admin_RecordFailedLogin",
                    new { AdminId = adminId, FailedCount = failedCount, LockoutUntil = lockoutUntil }, commandType: Proc);
            }
        }

        public void ResetFailedLogin(int adminId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Admin_ResetFailedLogin", new { AdminId = adminId }, commandType: Proc);
            }
        }
    }
}
