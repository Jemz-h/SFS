using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;
using StudentFeedbackSystem.DataAccess;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public class AuditLogRepository : IAuditLogRepository
    {
        private const CommandType Proc = CommandType.StoredProcedure;

        public void Log(int? adminId, string action, string targetType, int targetId, string details)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_AuditLog_Log",
                    new { AdminId = adminId, Action = action, TargetType = targetType, TargetId = targetId, Details = details },
                    commandType: Proc);
            }
        }

        public IEnumerable<AuditLogEntry> GetAll(int limit = 500, string action = null, string targetType = null, string searchTerm = null)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                // The procedure adds the % wildcards, so the raw search term is passed through.
                return conn.Query<AuditLogEntry>("dbo.usp_AuditLog_GetAll", new
                {
                    Limit = limit,
                    Action = string.IsNullOrWhiteSpace(action) ? null : action,
                    TargetType = string.IsNullOrWhiteSpace(targetType) ? null : targetType,
                    SearchTerm = string.IsNullOrWhiteSpace(searchTerm) ? null : searchTerm
                }, commandType: Proc).ToList();
            }
        }

        public IEnumerable<string> GetDistinctActions()
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<string>("dbo.usp_AuditLog_GetDistinctActions", commandType: Proc).ToList();
            }
        }

        public IEnumerable<string> GetDistinctTargetTypes()
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<string>("dbo.usp_AuditLog_GetDistinctTargetTypes", commandType: Proc).ToList();
            }
        }
    }
}
