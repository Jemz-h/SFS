using System.Collections.Generic;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public interface IFeedbackRepository
    {
        bool HasStudentRated(int studentId, int enrollmentId);
        int InsertFeedback(Feedback feedback, IEnumerable<FeedbackDetail> details);
        IEnumerable<Feedback> GetByStudentId(int studentId);
        Feedback GetById(int feedbackId);
        IEnumerable<FeedbackDetail> GetDetailsByFeedbackId(int feedbackId);
        IEnumerable<ProfessorRatingSummaryDto> GetProfessorRatingSummaries(string schoolYear = null, string term = null, string department = null);
        IEnumerable<CriterionScoreDto> GetProfessorCriterionBreakdown(int professorId, string schoolYear = null, string term = null);
        IEnumerable<string> GetProfessorComments(int professorId, string schoolYear = null, string term = null);
        IEnumerable<string> GetProfessorCoursesTaught(int professorId, string schoolYear = null, string term = null);
        OverallRatingMetricsDto GetOverallMetrics(string schoolYear = null, string term = null, string department = null);
    }
}
