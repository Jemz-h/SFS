using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;
using StudentFeedbackSystem.DataAccess;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public class CriterionRepository : ICriterionRepository
    {
        private const CommandType Proc = CommandType.StoredProcedure;

        public IEnumerable<Criterion> GetAll(bool includeInactive = false)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.Query<Criterion>("dbo.usp_Criterion_GetAll", new { IncludeInactive = includeInactive }, commandType: Proc).ToList();
            }
        }

        public Criterion GetById(int criterionId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.QuerySingleOrDefault<Criterion>("dbo.usp_Criterion_GetById", new { CriterionId = criterionId }, commandType: Proc);
            }
        }

        public int Insert(Criterion criterion)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                return conn.ExecuteScalar<int>("dbo.usp_Criterion_Insert", new
                {
                    criterion.CriterionName,
                    criterion.Weight,
                    criterion.DisplayOrder,
                    criterion.IsActive
                }, commandType: Proc);
            }
        }

        public void Update(Criterion criterion)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Criterion_Update", new
                {
                    criterion.CriterionId,
                    criterion.CriterionName,
                    criterion.Weight,
                    criterion.DisplayOrder,
                    criterion.IsActive
                }, commandType: Proc);
            }
        }

        public void SetActive(int criterionId, bool isActive)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Criterion_SetActive", new { CriterionId = criterionId, IsActive = isActive }, commandType: Proc);
            }
        }

        public void Delete(int criterionId)
        {
            using (var conn = DbConnectionFactory.CreateOpenConnection())
            {
                conn.Execute("dbo.usp_Criterion_Delete", new { CriterionId = criterionId }, commandType: Proc);
            }
        }
    }
}
