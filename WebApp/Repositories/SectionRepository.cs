using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;
using StudentFeedbackSystem.DataAccess;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public class SectionRepository : ISectionRepository
    {
        private const CommandType Proc = CommandType.StoredProcedure;

        public IEnumerable<Section> GetAll()
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<Section>("dbo.usp_Section_GetAll", commandType: Proc).ToList();
            }
        }

        public int Insert(Section section)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.ExecuteScalar<int>("dbo.usp_Section_Insert", new
                {
                    section.SectionName,
                    section.Program,
                    section.YearLevel,
                    section.SchoolYear,
                    section.Term
                }, commandType: Proc);
            }
        }

        public void Update(Section section)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Section_Update", new
                {
                    section.SectionId,
                    section.SectionName,
                    section.Program,
                    section.YearLevel,
                    section.SchoolYear,
                    section.Term
                }, commandType: Proc);
            }
        }

        public Section GetById(int sectionId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.QuerySingleOrDefault<Section>("dbo.usp_Section_GetById", new { SectionId = sectionId }, commandType: Proc);
            }
        }
    }
}
