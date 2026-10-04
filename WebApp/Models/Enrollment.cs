using System;
using System.Collections.Generic;

namespace StudentFeedbackSystem.Models
{
    public class Enrollment
    {
        public int EnrollmentId { get; set; }
        public int StudentId { get; set; }
        public int OfferingId { get; set; }
        public string Status { get; set; }         // Ongoing | Completed | Dropped
        public bool HasRated { get; set; }
        public DateTime EnrolledAt { get; set; }

        // Joined display fields (not DB columns)
        public string CourseCode { get; set; }
        public string CourseTitle { get; set; }
        public string ProfessorName { get; set; }
        public string SchoolYear { get; set; }
        public string Term { get; set; }
    }

    public class Criterion
    {
        public int CriterionId { get; set; }
        public string CriterionName { get; set; }
        public decimal Weight { get; set; }
        public int DisplayOrder { get; set; }
        public bool IsActive { get; set; }
    }

    public class Feedback
    {
        public int FeedbackId { get; set; }
        public int EnrollmentId { get; set; }
        public int StudentId { get; set; }
        public int ProfessorId { get; set; }
        public int CourseId { get; set; }
        public string SchoolYear { get; set; }
        public string Term { get; set; }
        public decimal AverageScore { get; set; }
        public string Comments { get; set; }
        public bool IsAnonymous { get; set; }
        public DateTime SubmittedAt { get; set; }
        public string CourseCode { get; set; }
        public string CourseTitle { get; set; }
        public string ProfessorName { get; set; }
        public List<FeedbackDetail> Details { get; set; } = new List<FeedbackDetail>();
    }

    public class FeedbackDetail
    {
        public int FeedbackDetailId { get; set; }
        public int FeedbackId { get; set; }
        public int CriterionId { get; set; }
        public int Score { get; set; }
    }

    public class AuditLogEntry
    {
        public int AuditId { get; set; }
        public int? AdminId { get; set; }
        public string AdminUsername { get; set; }
        public string AdminFullName { get; set; }
        public string Action { get; set; }
        public string TargetType { get; set; }
        public int TargetId { get; set; }
        public string Details { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
