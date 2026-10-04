using System;

namespace StudentFeedbackSystem.Models
{
    public class Section
    {
        public int SectionId { get; set; }
        public string SectionName { get; set; }
        public string Program { get; set; }
        public int YearLevel { get; set; }
        public string SchoolYear { get; set; }
        public string Term { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
