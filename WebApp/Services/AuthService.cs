using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Security;
using StudentFeedbackSystem.Models;
using StudentFeedbackSystem.Repositories;
using StudentFeedbackSystem.Security;

namespace StudentFeedbackSystem.Services
{
    public enum LoginResult
    {
        Success,
        InvalidCredentials,
        AccountLockedOut,
        AccountPending,
        AccountRejected,
        AccountSuspended
    }

    public class AuthService
    {
        private static readonly int MaxFailedAttempts = ReadPositiveInteger("MaxLoginAttempts", 5);
        private static readonly int ConfiguredLockoutMinutesValue = ReadPositiveInteger("LockoutMinutes", 15);
        private static readonly TimeSpan LockoutDuration = TimeSpan.FromMinutes(ConfiguredLockoutMinutesValue);

        public static int ConfiguredLockoutMinutes => ConfiguredLockoutMinutesValue;
        private static readonly HashSet<string> AllowedPrograms = new HashSet<string>(StringComparer.Ordinal)
        {
            "Bachelor of Science in Information Technology",
            "Bachelor of Science in Computer Science",
            "Bachelor of Science in Information System",
            "Bachelor of Science in Entrepreneurship",
            "Bachelor of Science in Business Administration",
            "Bachelor of Science in Accountancy",
            "Bachelor of Science in Industrial Engineering",
            "Bachelor of Science in Electrical Computer Engineering",
            "Bachelor of Science in Computer Engineering",
            "Bachelor of Science in Early Childhood Education"
        };

        private readonly IStudentRepository _studentRepo;
        private readonly IAdminRepository _adminRepo;

        public AuthService() : this(new StudentRepository(), new AdminRepository()) { }

        public AuthService(IStudentRepository studentRepo, IAdminRepository adminRepo)
        {
            _studentRepo = studentRepo;
            _adminRepo = adminRepo;
        }

        /// <summary>
        /// Registers a new student account in Pending status. Caller (Register.aspx.cs)
        /// is responsible for validating field formats before calling this.
        /// </summary>
        public (bool Success, string Error) RegisterStudent(string studentNumber, string schoolEmail,
            string plainPassword, string firstName, string middleName, string lastName, string program,
            int yearLevel, DateTime birthDate)
        {
            studentNumber = (studentNumber ?? string.Empty).Trim();
            schoolEmail = (schoolEmail ?? string.Empty).Trim();
            if (!Regex.IsMatch(studentNumber, "^[0-9]{2}-[0-9]{4}$"))
            {
                return (false, "Student number must use the format YY-NNNN.");
            }

            if (!IsValidEmail(schoolEmail))
            {
                return (false, "Enter a valid school email address.");
            }

            if (string.IsNullOrWhiteSpace(firstName) || string.IsNullOrWhiteSpace(lastName)
                || firstName.Trim().Length > 100 || lastName.Trim().Length > 100
                || (middleName != null && middleName.Trim().Length > 100))
            {
                return (false, "Enter valid first and last names (maximum 100 characters each).");
            }

            if (yearLevel < 1 || yearLevel > 8)
            {
                return (false, "Select a valid year level.");
            }

            if (!AllowedPrograms.Contains(program))
            {
                return (false, "Select a valid program.");
            }

            if (!Regex.IsMatch(plainPassword ?? string.Empty, "^(?=.*[A-Za-z])(?=.*[0-9]).{8,}$"))
            {
                return (false, "Password must have at least 8 characters, including a letter and a number.");
            }

            if (_studentRepo.EmailOrNumberExists(schoolEmail, studentNumber))
            {
                return (false, "A student with this email or student number is already registered.");
            }

            var student = new Student
            {
                StudentNumber = studentNumber,
                SchoolEmail = schoolEmail.ToLowerInvariant(),
                PasswordHash = PasswordHasher.Hash(plainPassword),
                FirstName = firstName,
                MiddleName = middleName,
                LastName = lastName,
                BirthDate = birthDate,
                Program = program,
                YearLevel = yearLevel
            };

            _studentRepo.Insert(student);
            return (true, null);
        }

        private static int ReadPositiveInteger(string settingName, int defaultValue)
        {
            int value;
            return int.TryParse(ConfigurationManager.AppSettings[settingName], out value) && value > 0 && value <= 1440
                ? value
                : defaultValue;
        }

        private static bool IsValidEmail(string value)
        {
            if (string.IsNullOrWhiteSpace(value) || value.Length > 254)
            {
                return false;
            }

            try
            {
                var address = new MailAddress(value);
                return string.Equals(address.Address, value, StringComparison.OrdinalIgnoreCase);
            }
            catch (FormatException)
            {
                return false;
            }
        }

        /// <summary>
        /// Attempts student login. On success, issues a Forms Authentication cookie
        /// carrying role + StudentId + SectionId in the encrypted ticket UserData,
        /// so pages can authorize/filter without re-querying identity every time.
        /// </summary>
        public LoginResult LoginStudent(string schoolEmail, string plainPassword, bool persistCookie)
        {
            var student = _studentRepo.GetBySchoolEmail(schoolEmail);
            if (student == null)
            {
                return LoginResult.InvalidCredentials;
            }

            if (student.LockoutUntil.HasValue && student.LockoutUntil.Value > DateTime.UtcNow)
            {
                return LoginResult.AccountLockedOut;
            }

            if (!PasswordHasher.Verify(plainPassword, student.PasswordHash))
            {
                RegisterFailedStudentLogin(student);
                return LoginResult.InvalidCredentials;
            }

            _studentRepo.ResetFailedLogin(student.StudentId);

            switch (student.Status)
            {
                case "Pending":
                    return LoginResult.AccountPending;
                case "Rejected":
                    return LoginResult.AccountRejected;
                case "Suspended":
                    return LoginResult.AccountSuspended;
                case "Verified":
                    IssueTicket(
                        userName: student.SchoolEmail,
                        role: "Student",
                        entityId: student.StudentId,
                        sectionId: student.SectionId,
                        persistCookie: persistCookie);
                    return LoginResult.Success;
                default:
                    return LoginResult.InvalidCredentials;
            }
        }

        public LoginResult LoginAdmin(string username, string plainPassword, bool persistCookie)
        {
            var admin = _adminRepo.GetByUsername(username);
            if (admin == null)
            {
                return LoginResult.InvalidCredentials;
            }

            if (admin.LockoutUntil.HasValue && admin.LockoutUntil.Value > DateTime.UtcNow)
            {
                return LoginResult.AccountLockedOut;
            }

            if (!PasswordHasher.Verify(plainPassword, admin.PasswordHash))
            {
                RegisterFailedAdminLogin(admin);
                return LoginResult.InvalidCredentials;
            }

            _adminRepo.ResetFailedLogin(admin.AdminId);

            IssueTicket(
                userName: admin.Username,
                role: admin.Role,          // "Admin" or "SuperAdmin"
                entityId: admin.AdminId,
                sectionId: null,
                persistCookie: persistCookie);

            return LoginResult.Success;
        }

        public void SignOut()
        {
            FormsAuthentication.SignOut();
            HttpContext.Current.Session?.Clear();
        }

        private void RegisterFailedStudentLogin(Student student)
        {
            var count = student.FailedLoginCount + 1;
            DateTime? lockout = count >= MaxFailedAttempts ? DateTime.UtcNow.Add(LockoutDuration) : (DateTime?)null;
            _studentRepo.RecordFailedLogin(student.StudentId, count, lockout);
        }

        private void RegisterFailedAdminLogin(Admin admin)
        {
            var count = admin.FailedLoginCount + 1;
            DateTime? lockout = count >= MaxFailedAttempts ? DateTime.UtcNow.Add(LockoutDuration) : (DateTime?)null;
            _adminRepo.RecordFailedLogin(admin.AdminId, count, lockout);
        }

        /// <summary>
        /// UserData format: "Role|EntityId|SectionId" (SectionId may be empty).
        /// Read this back with SessionClaims (see below) instead of re-querying the DB per page.
        /// </summary>
        private void IssueTicket(string userName, string role, int entityId, int? sectionId, bool persistCookie)
        {
            var userData = $"{role}|{entityId}|{sectionId}";

            var ticket = new FormsAuthenticationTicket(
                version: 1,
                name: userName,
                issueDate: DateTime.Now,
                expiration: DateTime.Now.AddMinutes(persistCookie ? 60 * 24 * 7 : 30),
                isPersistent: persistCookie,
                userData: userData,
                cookiePath: FormsAuthentication.FormsCookiePath);

            var encryptedTicket = FormsAuthentication.Encrypt(ticket);
            var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket)
            {
                HttpOnly = true,
                Secure = FormsAuthentication.RequireSSL,
                Path = FormsAuthentication.FormsCookiePath
            };
            if (ticket.IsPersistent)
            {
                cookie.Expires = ticket.Expiration;
            }

            HttpContext.Current.Response.Cookies.Add(cookie);
        }
    }
}
