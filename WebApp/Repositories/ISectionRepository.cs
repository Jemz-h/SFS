using System.Collections.Generic;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public interface ISectionRepository
    {
        IEnumerable<Section> GetAll();
        Section GetById(int sectionId);
        int Insert(Section section);
        void Update(Section section);
    }
}
