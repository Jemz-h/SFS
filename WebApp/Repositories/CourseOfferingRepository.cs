using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;
using StudentFeedbackSystem.DataAccess;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public class CourseOfferingRepository : ICourseOfferingRepository
    {
        private const CommandType Proc = CommandType.StoredProcedure;

        public IEnumerable<CourseOffering> GetAll()
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<CourseOffering>("dbo.usp_CourseOffering_GetAll", commandType: Proc).ToList();
            }
        }

        public int Insert(CourseOffering offering)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.ExecuteScalar<int>("dbo.usp_CourseOffering_Insert", new
                {
                    offering.CourseId,
                    offering.ProfessorId,
                    offering.SectionId,
                    offering.SchoolYear,
                    offering.Term
                }, commandType: Proc);
            }
        }

        public void Delete(int offeringId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_CourseOffering_Delete", new { OfferingId = offeringId }, commandType: Proc);
            }
        }
    }
}
