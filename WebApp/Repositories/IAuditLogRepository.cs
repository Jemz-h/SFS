using System.Collections.Generic;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public interface IAuditLogRepository
    {
        void Log(int? adminId, string action, string targetType, int targetId, string details);
        IEnumerable<AuditLogEntry> GetAll(int limit = 500, string action = null, string targetType = null, string searchTerm = null);
        IEnumerable<string> GetDistinctActions();
        IEnumerable<string> GetDistinctTargetTypes();
    }
}
