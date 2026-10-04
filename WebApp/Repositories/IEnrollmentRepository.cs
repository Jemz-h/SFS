using System.Collections.Generic;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public interface IEnrollmentRepository
    {
        IEnumerable<StudentEnrollmentDto> GetByStudentId(int studentId);
        StudentEnrollmentDto GetById(int enrollmentId, int studentId);
        Enrollment GetByIdOnly(int enrollmentId);
        int CreateEnrollmentsForSectionStudent(int studentId, int sectionId);
        int CreateEnrollmentsForOffering(int offeringId, int sectionId);
        void MarkAsRated(int enrollmentId);
        int CountByStudent(int studentId);
        int CountPendingByStudent(int studentId);
        int CountCompletedByStudent(int studentId);
    }
}
