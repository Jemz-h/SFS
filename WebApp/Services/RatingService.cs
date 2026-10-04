using System;
using System.Collections.Generic;
using System.Linq;
using StudentFeedbackSystem.Models;
using StudentFeedbackSystem.Repositories;

namespace StudentFeedbackSystem.Services
{
    public class RatingService
    {
        private readonly IEnrollmentRepository _enrollmentRepo;
        private readonly ICriterionRepository _criterionRepo;
        private readonly IFeedbackRepository _feedbackRepo;

        public RatingService()
            : this(new EnrollmentRepository(), new CriterionRepository(), new FeedbackRepository()) { }

        public RatingService(
            IEnrollmentRepository enrollmentRepo,
            ICriterionRepository criterionRepo,
            IFeedbackRepository feedbackRepo)
        {
            _enrollmentRepo = enrollmentRepo;
            _criterionRepo = criterionRepo;
            _feedbackRepo = feedbackRepo;
        }

        public IEnumerable<StudentEnrollmentDto> GetStudentEnrollments(int studentId)
        {
            return _enrollmentRepo.GetByStudentId(studentId);
        }

        public StudentEnrollmentDto GetEnrollmentForRating(int enrollmentId, int studentId)
        {
            var enrollment = _enrollmentRepo.GetById(enrollmentId, studentId);
            if (enrollment == null)
            {
                return null;
            }

            if (enrollment.HasRated || string.Equals(enrollment.Status, "Dropped", StringComparison.OrdinalIgnoreCase))
            {
                return null;
            }

            return enrollment;
        }

        public IEnumerable<Criterion> GetActiveCriteria()
        {
            return _criterionRepo.GetAll(includeInactive: false);
        }

        public int SubmitRating(
            int studentId,
            int enrollmentId,
            IDictionary<int, int> criterionScores,
            string comments,
            bool isAnonymous)
        {
            if (criterionScores == null)
            {
                throw new ArgumentNullException(nameof(criterionScores));
            }

            if (comments != null && comments.Length > 2000)
            {
                throw new ArgumentException("Comments cannot exceed 2,000 characters.", nameof(comments));
            }

            var enrollment = _enrollmentRepo.GetById(enrollmentId, studentId);
            if (enrollment == null)
            {
                throw new UnauthorizedAccessException("The specified enrollment does not belong to the authenticated student.");
            }

            if (enrollment.HasRated)
            {
                throw new InvalidOperationException("You have already submitted an evaluation for this course.");
            }

            if (string.Equals(enrollment.Status, "Dropped", StringComparison.OrdinalIgnoreCase))
            {
                throw new InvalidOperationException("Ratings cannot be submitted for dropped courses.");
            }

            var activeCriteria = _criterionRepo.GetAll(includeInactive: false).ToList();
            if (!activeCriteria.Any())
            {
                throw new InvalidOperationException("No active rating criteria found in the system.");
            }

            decimal totalWeightedScore = 0m;
            decimal totalWeight = 0m;
            var details = new List<FeedbackDetail>();

            foreach (var criterion in activeCriteria)
            {
                if (criterion.Weight <= 0)
                {
                    throw new InvalidOperationException($"The configured weight for '{criterion.CriterionName}' must be positive.");
                }

                if (!criterionScores.TryGetValue(criterion.CriterionId, out var score) || score < 1 || score > 5)
                {
                    throw new ArgumentException($"Please provide a valid rating (1 to 5) for '{criterion.CriterionName}'.");
                }

                totalWeightedScore += score * criterion.Weight;
                totalWeight += criterion.Weight;

                details.Add(new FeedbackDetail
                {
                    CriterionId = criterion.CriterionId,
                    Score = score
                });
            }

            var averageScore = totalWeight > 0
                ? Math.Round(totalWeightedScore / totalWeight, 2)
                : 0m;

            var feedback = new Feedback
            {
                EnrollmentId = enrollment.EnrollmentId,
                StudentId = studentId,
                ProfessorId = enrollment.ProfessorId,
                CourseId = enrollment.CourseId,
                SchoolYear = enrollment.SchoolYear,
                Term = enrollment.Term,
                AverageScore = averageScore,
                Comments = string.IsNullOrWhiteSpace(comments) ? null : comments.Trim(),
                IsAnonymous = isAnonymous,
                Details = details
            };

            return _feedbackRepo.InsertFeedback(feedback, details);
        }

        public IEnumerable<Feedback> GetStudentRatingHistory(int studentId)
        {
            return _feedbackRepo.GetByStudentId(studentId);
        }

        public Feedback GetFeedbackDetails(int feedbackId, int studentId)
        {
            var feedback = _feedbackRepo.GetById(feedbackId);
            if (feedback == null || feedback.StudentId != studentId)
            {
                return null;
            }

            feedback.Details = _feedbackRepo.GetDetailsByFeedbackId(feedbackId).ToList();
            return feedback;
        }

        public (int TotalCourses, int PendingRatings, int CompletedRatings) GetStudentDashboardCounts(int studentId)
        {
            var total = _enrollmentRepo.CountByStudent(studentId);
            var pending = _enrollmentRepo.CountPendingByStudent(studentId);
            var completed = _enrollmentRepo.CountCompletedByStudent(studentId);
            return (total, pending, completed);
        }
    }
}
