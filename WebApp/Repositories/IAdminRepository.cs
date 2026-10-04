using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public interface IAdminRepository
    {
        Admin GetById(int adminId);
        Admin GetByUsername(string username);
        void RecordFailedLogin(int adminId, int failedCount, System.DateTime? lockoutUntil);
        void ResetFailedLogin(int adminId);
    }
}
