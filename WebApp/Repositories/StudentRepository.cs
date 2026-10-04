using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;
using StudentFeedbackSystem.DataAccess;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public class StudentRepository : IStudentRepository
    {
        private const CommandType Proc = CommandType.StoredProcedure;

        public Student GetById(int studentId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.QuerySingleOrDefault<Student>("dbo.usp_Student_GetById", new { StudentId = studentId }, commandType: Proc);
            }
        }

        public Student GetBySchoolEmail(string schoolEmail)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.QuerySingleOrDefault<Student>("dbo.usp_Student_GetBySchoolEmail", new { SchoolEmail = schoolEmail }, commandType: Proc);
            }
        }

        public Student GetByStudentNumber(string studentNumber)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.QuerySingleOrDefault<Student>("dbo.usp_Student_GetByStudentNumber", new { StudentNumber = studentNumber }, commandType: Proc);
            }
        }

        public bool EmailOrNumberExists(string schoolEmail, string studentNumber)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.ExecuteScalar<int>("dbo.usp_Student_EmailOrNumberExists",
                    new { SchoolEmail = schoolEmail, StudentNumber = studentNumber }, commandType: Proc) > 0;
            }
        }

        public int Insert(Student student)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.ExecuteScalar<int>("dbo.usp_Student_Insert", new
                {
                    student.StudentNumber,
                    student.SchoolEmail,
                    student.PasswordHash,
                    student.FirstName,
                    student.MiddleName,
                    student.LastName,
                    student.BirthDate,
                    student.Program,
                    student.YearLevel
                }, commandType: Proc);
            }
        }

        public void UpdateStatus(int studentId, string status, string rejectionReason, int? verifiedByAdminId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Student_UpdateStatus",
                    new { StudentId = studentId, Status = status, RejectionReason = rejectionReason, VerifiedByAdminId = verifiedByAdminId },
                    commandType: Proc);
            }
        }

        public void UpdateSection(int studentId, int? sectionId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Student_UpdateSection", new { StudentId = studentId, SectionId = sectionId }, commandType: Proc);
            }
        }

        public void RecordFailedLogin(int studentId, int failedCount, DateTime? lockoutUntil)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Student_RecordFailedLogin",
                    new { StudentId = studentId, FailedCount = failedCount, LockoutUntil = lockoutUntil }, commandType: Proc);
            }
        }

        public void ResetFailedLogin(int studentId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Student_ResetFailedLogin", new { StudentId = studentId }, commandType: Proc);
            }
        }

        public IEnumerable<Student> GetByStatus(string status)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<Student>("dbo.usp_Student_GetByStatus", new { Status = status }, commandType: Proc).ToList();
            }
        }

        // The procedure adds the % wildcards, so the raw term is passed through.
        public IEnumerable<Student> Search(string term)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<Student>("dbo.usp_Student_Search", new { Term = term }, commandType: Proc).ToList();
            }
        }
    }
}
