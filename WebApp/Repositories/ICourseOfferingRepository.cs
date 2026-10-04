using System.Collections.Generic;
using StudentFeedbackSystem.Models;

namespace StudentFeedbackSystem.Repositories
{
    public interface ICourseOfferingRepository
    {
        IEnumerable<CourseOffering> GetAll();
        int Insert(CourseOffering offering);
        void Delete(int offeringId);
    }
}
