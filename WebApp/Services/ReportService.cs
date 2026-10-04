using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using StudentFeedbackSystem.Models;
using StudentFeedbackSystem.Repositories;

namespace StudentFeedbackSystem.Services
{
    public class ReportService
    {
        private readonly IFeedbackRepository _feedbackRepo;
        private readonly IProfessorRepository _professorRepo;

        public const decimal ThresholdVerySatisfactory = 4.20m;
        public const decimal ThresholdSatisfactory = 3.40m;

        public ReportService()
            : this(new FeedbackRepository(), new ProfessorRepository()) { }

        public ReportService(IFeedbackRepository feedbackRepo, IProfessorRepository professorRepo)
        {
            _feedbackRepo = feedbackRepo;
            _professorRepo = professorRepo;
        }

        public OverallRatingMetricsDto GetOverallMetrics(string schoolYear = null, string term = null, string department = null)
        {
            return _feedbackRepo.GetOverallMetrics(schoolYear, term, department);
        }

        public IEnumerable<ProfessorRatingSummaryDto> GetProfessorRatings(
            string schoolYear = null,
            string term = null,
            string department = null,
            string searchQuery = null)
        {
            var summaries = _feedbackRepo.GetProfessorRatingSummaries(schoolYear, term, department);

            if (!string.IsNullOrWhiteSpace(searchQuery))
            {
                var query = searchQuery.Trim();
                summaries = summaries.Where(s =>
                    s.FullName.IndexOf(query, StringComparison.OrdinalIgnoreCase) >= 0 ||
                    (!string.IsNullOrEmpty(s.Department) && s.Department.IndexOf(query, StringComparison.OrdinalIgnoreCase) >= 0) ||
                    (!string.IsNullOrEmpty(s.CoursesTaught) && s.CoursesTaught.IndexOf(query, StringComparison.OrdinalIgnoreCase) >= 0)
                );
            }

            return summaries.ToList();
        }

        public ProfessorDrillDownDto GetProfessorDrillDown(int professorId, string schoolYear = null, string term = null)
        {
            var professor = _professorRepo.GetById(professorId);
            if (professor == null) return null;

            var summaries = _feedbackRepo.GetProfessorRatingSummaries(schoolYear, term, null);
            var summary = summaries.FirstOrDefault(s => s.ProfessorId == professorId);

            var criterionScores = _feedbackRepo.GetProfessorCriterionBreakdown(professorId, schoolYear, term).ToList();
            var comments = _feedbackRepo.GetProfessorComments(professorId, schoolYear, term).ToList();
            var courses = _feedbackRepo.GetProfessorCoursesTaught(professorId, schoolYear, term).ToList();

            return new ProfessorDrillDownDto
            {
                ProfessorId = professor.ProfessorId,
                FullName = professor.FullName,
                Department = professor.Department,
                OverallAverage = summary?.AverageScore ?? 0m,
                TotalResponses = summary?.ResponseCount ?? 0,
                Classification = summary?.Classification ?? Classify(0m),
                CriterionScores = criterionScores,
                Comments = comments,
                CoursesTaught = courses
            };
        }

        public static string Classify(decimal score)
        {
            if (score >= ThresholdVerySatisfactory)
            {
                return "Very Satisfactory";
            }
            if (score >= ThresholdSatisfactory)
            {
                return "Satisfactory";
            }
            return "Below Satisfactory";
        }

        public byte[] ExportToCsv(string schoolYear = null, string term = null, string department = null)
        {
            var ratings = GetProfessorRatings(schoolYear, term, department, null).ToList();
            var sb = new StringBuilder();

            sb.AppendLine("Professor ID,Faculty Name,Department,Courses Taught,Total Student Reviews,Average Rating Score,Satisfaction Classification");

            foreach (var r in ratings)
            {
                var escapedName = EscapeCsv(r.FullName);
                var escapedDept = EscapeCsv(r.Department ?? "");
                var escapedCourses = EscapeCsv(r.CoursesTaught ?? "");
                var classification = EscapeCsv(r.Classification);

                sb.AppendLine($"{r.ProfessorId},{escapedName},{escapedDept},{escapedCourses},{r.ResponseCount},{r.AverageScore:0.00},{classification}");
            }

            return Encoding.UTF8.GetBytes(sb.ToString());
        }

        private static string EscapeCsv(string value)
        {
            if (string.IsNullOrEmpty(value)) return "\"\"";
            if (value[0] == '=' || value[0] == '+' || value[0] == '-' || value[0] == '@')
            {
                value = "'" + value;
            }
            if (value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r"))
            {
                return $"\"{value.Replace("\"", "\"\"")}\"";
            }
            return value;
        }
    }
}
