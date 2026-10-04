using System.Collections.Generic;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public interface IProfessorRepository
    {
        IEnumerable<Professor> GetAll(bool includeInactive = false);
        Professor GetById(int professorId);
        int Insert(Professor professor);
        void Update(Professor professor);
        void SetActive(int professorId, bool isActive);
    }
}
