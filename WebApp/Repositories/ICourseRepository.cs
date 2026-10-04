using System.Collections.Generic;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public interface ICourseRepository
    {
        IEnumerable<Course> GetAll(bool includeInactive = false);
        Course GetById(int courseId);
        int Insert(Course course);
        void Update(Course course);
        void SetActive(int courseId, bool isActive);
    }
}
