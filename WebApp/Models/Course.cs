namespace StudentFeedbackSystem.Models
{
    public class Course
    {
        public int CourseId { get; set; }
        public string CourseCode { get; set; }
        public string CourseTitle { get; set; }
        public int Units { get; set; }
        public bool IsActive { get; set; }
    }

    public class Professor
    {
        public int ProfessorId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Department { get; set; }
        public bool IsActive { get; set; }

        public string FullName => $"{FirstName} {LastName}";
    }

    public class CourseOffering
    {
        public int OfferingId { get; set; }
        public int CourseId { get; set; }
        public int ProfessorId { get; set; }
        public int SectionId { get; set; }
        public string SchoolYear { get; set; }
        public string Term { get; set; }

        // Convenience fields populated by joined queries (not DB columns)
        public string CourseCode { get; set; }
        public string CourseTitle { get; set; }
        public string ProfessorName { get; set; }
        public string SectionName { get; set; }
    }
}
