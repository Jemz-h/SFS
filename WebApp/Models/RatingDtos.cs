using System;
using System.Collections.Generic;

namespace StudentFeedbackSystem.Models
{
    public class ProfessorRatingSummaryDto
    {
        public int ProfessorId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FullName => $"{FirstName} {LastName}".Trim();
        public string Department { get; set; }
        public int ResponseCount { get; set; }
        public decimal AverageScore { get; set; }
        public string Classification { get; set; } // Very Satisfactory | Satisfactory | Below Satisfactory
        public string CoursesTaught { get; set; }
    }

    public class CriterionScoreDto
    {
        public int CriterionId { get; set; }
        public string CriterionName { get; set; }
        public decimal Weight { get; set; }
        public decimal AverageScore { get; set; }
        public int ResponseCount { get; set; }
    }

    public class ProfessorDrillDownDto
    {
        public int ProfessorId { get; set; }
        public string FullName { get; set; }
        public string Department { get; set; }
        public decimal OverallAverage { get; set; }
        public int TotalResponses { get; set; }
        public string Classification { get; set; }
        public List<CriterionScoreDto> CriterionScores { get; set; } = new List<CriterionScoreDto>();
        public List<string> Comments { get; set; } = new List<string>();
        public List<string> CoursesTaught { get; set; } = new List<string>();
    }

    public class StudentEnrollmentDto
    {
        public int EnrollmentId { get; set; }
        public int StudentId { get; set; }
        public int OfferingId { get; set; }
        public int CourseId { get; set; }
        public string CourseCode { get; set; }
        public string CourseTitle { get; set; }
        public int Units { get; set; }
        public int ProfessorId { get; set; }
        public string ProfessorName { get; set; }
        public string Department { get; set; }
        public int SectionId { get; set; }
        public string SectionName { get; set; }
        public string SchoolYear { get; set; }
        public string Term { get; set; }
        public string Status { get; set; }
        public bool HasRated { get; set; }
        public DateTime? SubmittedAt { get; set; }
        public decimal? AverageScore { get; set; }
    }

    public class OverallRatingMetricsDto
    {
        public int TotalSubmissions { get; set; }
        public decimal InstitutionalAverage { get; set; }
        public int VerySatisfactoryCount { get; set; }
        public int SatisfactoryCount { get; set; }
        public int BelowSatisfactoryCount { get; set; }
        public int TotalProfessorsEvaluated { get; set; }
    }
}
