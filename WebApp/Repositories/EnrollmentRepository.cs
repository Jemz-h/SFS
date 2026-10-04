using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;
using StudentFeedbackSystem.DataAccess;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public class EnrollmentRepository : IEnrollmentRepository
    {
        private const CommandType Proc = CommandType.StoredProcedure;

        public IEnumerable<StudentEnrollmentDto> GetByStudentId(int studentId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<StudentEnrollmentDto>("dbo.usp_Enrollment_GetByStudentId", new { StudentId = studentId }, commandType: Proc).ToList();
            }
        }

        public StudentEnrollmentDto GetById(int enrollmentId, int studentId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.QuerySingleOrDefault<StudentEnrollmentDto>("dbo.usp_Enrollment_GetById",
                    new { EnrollmentId = enrollmentId, StudentId = studentId }, commandType: Proc);
            }
        }

        public Enrollment GetByIdOnly(int enrollmentId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.QuerySingleOrDefault<Enrollment>("dbo.usp_Enrollment_GetByIdOnly", new { EnrollmentId = enrollmentId }, commandType: Proc);
            }
        }

        // The procedure returns the number of rows it inserted, so it is read with ExecuteScalar.
        public int CreateEnrollmentsForSectionStudent(int studentId, int sectionId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.ExecuteScalar<int>("dbo.usp_Enrollment_CreateEnrollmentsForSectionStudent",
                    new { StudentId = studentId, SectionId = sectionId }, commandType: Proc);
            }
        }

        public int CreateEnrollmentsForOffering(int offeringId, int sectionId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.ExecuteScalar<int>("dbo.usp_Enrollment_CreateEnrollmentsForOffering",
                    new { OfferingId = offeringId, SectionId = sectionId }, commandType: Proc);
            }
        }

        public void MarkAsRated(int enrollmentId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Enrollment_MarkAsRated", new { EnrollmentId = enrollmentId }, commandType: Proc);
            }
        }

        public int CountByStudent(int studentId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.ExecuteScalar<int>("dbo.usp_Enrollment_CountByStudent", new { StudentId = studentId }, commandType: Proc);
            }
        }

        public int CountPendingByStudent(int studentId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.ExecuteScalar<int>("dbo.usp_Enrollment_CountPendingByStudent", new { StudentId = studentId }, commandType: Proc);
            }
        }

        public int CountCompletedByStudent(int studentId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.ExecuteScalar<int>("dbo.usp_Enrollment_CountCompletedByStudent", new { StudentId = studentId }, commandType: Proc);
            }
        }
    }
}
