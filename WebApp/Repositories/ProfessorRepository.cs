using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;
using StudentFeedbackSystem.DataAccess;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public class ProfessorRepository : IProfessorRepository
    {
        private const CommandType Proc = CommandType.StoredProcedure;

        public IEnumerable<Professor> GetAll(bool includeInactive = false)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<Professor>("dbo.usp_Professor_GetAll", new { IncludeInactive = includeInactive }, commandType: Proc).ToList();
            }
        }

        public Professor GetById(int professorId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.QuerySingleOrDefault<Professor>("dbo.usp_Professor_GetById", new { ProfessorId = professorId }, commandType: Proc);
            }
        }

        public int Insert(Professor professor)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.ExecuteScalar<int>("dbo.usp_Professor_Insert",
                    new { professor.FirstName, professor.LastName, professor.Department }, commandType: Proc);
            }
        }

        public void Update(Professor professor)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Professor_Update",
                    new { professor.ProfessorId, professor.FirstName, professor.LastName, professor.Department }, commandType: Proc);
            }
        }

        public void SetActive(int professorId, bool isActive)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Professor_SetActive", new { ProfessorId = professorId, IsActive = isActive }, commandType: Proc);
            }
        }
    }
}
