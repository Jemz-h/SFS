using System;

namespace StudentFeedbackSystem.Models
{
    public enum StudentStatus
    {
        Pending,
        Verified,
        Rejected,
        Suspended
    }

    public class Student
    {
        public int StudentId { get; set; }
        public string StudentNumber { get; set; }
        public string SchoolEmail { get; set; }
        public string PasswordHash { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public DateTime? BirthDate { get; set; }
        public string Program { get; set; }
        public int YearLevel { get; set; }
        public string Status { get; set; }              // matches DB varchar: Pending/Verified/Rejected/Suspended
        public string RejectionReason { get; set; }
        public int? SectionId { get; set; }
        public DateTime DateRegistered { get; set; }
        public DateTime? DateVerified { get; set; }
        public int? VerifiedBy { get; set; }
        public int FailedLoginCount { get; set; }
        public DateTime? LockoutUntil { get; set; }

        public string FullName => string.IsNullOrWhiteSpace(MiddleName)
            ? $"{FirstName} {LastName}"
            : $"{FirstName} {MiddleName} {LastName}";

        public bool IsVerified => string.Equals(Status, "Verified", StringComparison.OrdinalIgnoreCase);
    }
}
