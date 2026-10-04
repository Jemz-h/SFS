using System;

namespace StudentFeedbackSystem.Models
{
    public class Admin
    {
        public int AdminId { get; set; }
        public string Username { get; set; }
        public string PasswordHash { get; set; }
        public string FullName { get; set; }
        public string Role { get; set; }          // "Admin" | "SuperAdmin"
        public bool IsActive { get; set; }
        public int FailedLoginCount { get; set; }
        public DateTime? LockoutUntil { get; set; }
        public DateTime CreatedAt { get; set; }

        public bool IsSuperAdmin => string.Equals(Role, "SuperAdmin", StringComparison.OrdinalIgnoreCase);
    }
}
