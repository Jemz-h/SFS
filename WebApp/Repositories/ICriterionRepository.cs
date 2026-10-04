using System.Collections.Generic;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public interface ICriterionRepository
    {
        IEnumerable<Criterion> GetAll(bool includeInactive = false);
        Criterion GetById(int criterionId);
        int Insert(Criterion criterion);
        void Update(Criterion criterion);
        void SetActive(int criterionId, bool isActive);
        void Delete(int criterionId);
    }
}
