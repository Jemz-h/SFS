using System.Collections.Generic;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public interface IStudentRepository
    {
        Student GetById(int studentId);
        Student GetBySchoolEmail(string schoolEmail);
        Student GetByStudentNumber(string studentNumber);
        bool EmailOrNumberExists(string schoolEmail, string studentNumber);
        int Insert(Student student);
        void UpdateStatus(int studentId, string status, string rejectionReason, int? verifiedByAdminId);
        void UpdateSection(int studentId, int? sectionId);
        void RecordFailedLogin(int studentId, int failedCount, System.DateTime? lockoutUntil);
        void ResetFailedLogin(int studentId);
        IEnumerable<Student> GetByStatus(string status);
        IEnumerable<Student> Search(string term);
    }
}
