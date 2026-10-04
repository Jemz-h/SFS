using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using Dapper;
using StudentFeedbackSystem.DataAccess;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public class FeedbackRepository : IFeedbackRepository
    {
        private const CommandType Proc = CommandType.StoredProcedure;

        // usp_Feedback_InsertFeedback raises SQL error 50001 with this text when the enrollment
        // is already rated or dropped.
        private const string NotEligibleMessage = "This enrollment is not eligible for another rating.";

        public bool HasStudentRated(int studentId, int enrollmentId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.ExecuteScalar<int>("dbo.usp_Feedback_HasStudentRated",
                    new { StudentId = studentId, EnrollmentId = enrollmentId }, commandType: Proc) > 0;
            }
        }

        public int InsertFeedback(Feedback feedback, IEnumerable<FeedbackDetail> details)
        {
            // Matches dbo.FeedbackDetailType (CriterionId INT, Score TINYINT).
            var detailTable = new DataTable();
            detailTable.Columns.Add("CriterionId", typeof(int));
            detailTable.Columns.Add("Score", typeof(byte));
            if (details != null)
            {
                foreach (var detail in details)
                {
                    detailTable.Rows.Add(detail.CriterionId, Convert.ToByte(detail.Score));
                }
            }

            try
            {
                using (var conn = DbConnectionFactory.CreateOpenConnection())
                {
                    // The procedure claims the enrollment and inserts the feedback and its details in one transaction.
                    return conn.ExecuteScalar<int>("dbo.usp_Feedback_InsertFeedback", new
                    {
                        feedback.EnrollmentId,
                        feedback.StudentId,
                        feedback.ProfessorId,
                        feedback.CourseId,
                        feedback.SchoolYear,
                        feedback.Term,
                        feedback.AverageScore,
                        feedback.Comments,
                        feedback.IsAnonymous,
                        Details = detailTable.AsTableValuedParameter("dbo.FeedbackDetailType")
                    }, commandType: Proc);
                }
            }
            catch (DbException ex) when (ex.Message.IndexOf(NotEligibleMessage, StringComparison.OrdinalIgnoreCase) >= 0)
            {
                // Keeps the exception type the callers already handle.
                throw new InvalidOperationException(NotEligibleMessage, ex);
            }
        }

        public IEnumerable<Feedback> GetByStudentId(int studentId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<Feedback>("dbo.usp_Feedback_GetByStudentId", new { StudentId = studentId }, commandType: Proc).ToList();
            }
        }

        public Feedback GetById(int feedbackId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.QuerySingleOrDefault<Feedback>("dbo.usp_Feedback_GetById", new { FeedbackId = feedbackId }, commandType: Proc);
            }
        }

        public IEnumerable<FeedbackDetail> GetDetailsByFeedbackId(int feedbackId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<FeedbackDetail>("dbo.usp_Feedback_GetDetailsByFeedbackId", new { FeedbackId = feedbackId }, commandType: Proc).ToList();
            }
        }

        // Classification and CoursesTaught now come straight from the procedure.
        public IEnumerable<ProfessorRatingSummaryDto> GetProfessorRatingSummaries(string schoolYear = null, string term = null, string department = null)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<ProfessorRatingSummaryDto>("dbo.usp_Feedback_GetProfessorRatingSummaries", new
                {
                    SchoolYear = string.IsNullOrWhiteSpace(schoolYear) ? null : schoolYear,
                    Term = string.IsNullOrWhiteSpace(term) ? null : term,
                    Department = string.IsNullOrWhiteSpace(department) ? null : department
                }, commandType: Proc).ToList();
            }
        }

        public IEnumerable<string> GetProfessorCoursesTaught(int professorId, string schoolYear = null, string term = null)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<string>("dbo.usp_Feedback_GetProfessorCoursesTaught", new
                {
                    ProfessorId = professorId,
                    SchoolYear = string.IsNullOrWhiteSpace(schoolYear) ? null : schoolYear,
                    Term = string.IsNullOrWhiteSpace(term) ? null : term
                }, commandType: Proc).ToList();
            }
        }

        public IEnumerable<CriterionScoreDto> GetProfessorCriterionBreakdown(int professorId, string schoolYear = null, string term = null)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<CriterionScoreDto>("dbo.usp_Feedback_GetProfessorCriterionBreakdown", new
                {
                    ProfessorId = professorId,
                    SchoolYear = string.IsNullOrWhiteSpace(schoolYear) ? null : schoolYear,
                    Term = string.IsNullOrWhiteSpace(term) ? null : term
                }, commandType: Proc).ToList();
            }
        }

        public IEnumerable<string> GetProfessorComments(int professorId, string schoolYear = null, string term = null)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<string>("dbo.usp_Feedback_GetProfessorComments", new
                {
                    ProfessorId = professorId,
                    SchoolYear = string.IsNullOrWhiteSpace(schoolYear) ? null : schoolYear,
                    Term = string.IsNullOrWhiteSpace(term) ? null : term
                }, commandType: Proc).ToList();
            }
        }

        // Totals are computed in SQL now; the procedure always returns exactly one row.
        public OverallRatingMetricsDto GetOverallMetrics(string schoolYear = null, string term = null, string department = null)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.QuerySingle<OverallRatingMetricsDto>("dbo.usp_Feedback_GetOverallMetrics", new
                {
                    SchoolYear = string.IsNullOrWhiteSpace(schoolYear) ? null : schoolYear,
                    Term = string.IsNullOrWhiteSpace(term) ? null : term,
                    Department = string.IsNullOrWhiteSpace(department) ? null : department
                }, commandType: Proc);
            }
        }

        // The SQL procedures use the same thresholds, so change both places together.
        public static string MapClassification(decimal averageScore)
        {
            if (averageScore >= 4.20m) return "Very Satisfactory";
            if (averageScore >= 3.40m) return "Satisfactory";
            return "Below Satisfactory";
        }
    }
}
