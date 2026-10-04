using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;
using StudentFeedbackSystem.DataAccess;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public class CourseRepository : ICourseRepository
    {
        private const CommandType Proc = CommandType.StoredProcedure;

        public IEnumerable<Course> GetAll(bool includeInactive = false)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<Course>("dbo.usp_Course_GetAll", new { IncludeInactive = includeInactive }, commandType: Proc).ToList();
            }
        }

        public Course GetById(int courseId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.QuerySingleOrDefault<Course>("dbo.usp_Course_GetById", new { CourseId = courseId }, commandType: Proc);
            }
        }

        public int Insert(Course course)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.ExecuteScalar<int>("dbo.usp_Course_Insert",
                    new { course.CourseCode, course.CourseTitle, course.Units }, commandType: Proc);
            }
        }

        public void Update(Course course)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Course_Update",
                    new { course.CourseId, course.CourseCode, course.CourseTitle, course.Units }, commandType: Proc);
            }
        }

        public void SetActive(int courseId, bool isActive)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Course_SetActive", new { CourseId = courseId, IsActive = isActive }, commandType: Proc);
            }
        }
    }
}
