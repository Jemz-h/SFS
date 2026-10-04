using System;
using System.Linq;
using StudentFeedbackSystem.Repositories;
using StudentFeedbackSystem.Security;
using StudentFeedbackSystem.Services;

namespace StudentFeedbackSystem.StudentPages
{
    public partial class Dashboard : StudentBasePage
    {
        private readonly IStudentRepository _studentRepository = new StudentRepository();
        private readonly ISectionRepository _sectionRepository = new SectionRepository();
        private readonly RatingService _ratingService = new RatingService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                litCurrentDate.Text = DateTime.Now.ToString("dddd, MMMM d, yyyy");
                LoadStudentInfo();
                LoadDashboardMetrics();
            }
        }

        private void LoadStudentInfo()
        {
            var student = _studentRepository.GetById(CurrentStudentId);
            if (student != null)
            {
                litStudentFullName.Text = Server.HtmlEncode(student.FullName);
                litStudentNumber.Text = Server.HtmlEncode(student.StudentNumber);
                litProgram.Text = Server.HtmlEncode(student.Program);
                litYearLevel.Text = student.YearLevel.ToString();

                if (student.SectionId.HasValue)
                {
                    var section = _sectionRepository.GetById(student.SectionId.Value);
                    litSectionName.Text = Server.HtmlEncode(section != null ? section.SectionName : $"Section #{student.SectionId.Value}");
                }
                else
                {
                    litSectionName.Text = "Not yet assigned";
                }
            }
        }

        private void LoadDashboardMetrics()
        {
            var (total, pending, completed) = _ratingService.GetStudentDashboardCounts(CurrentStudentId);

            litTotalCoursesCount.Text = total.ToString();
            litPendingCount.Text = pending.ToString();
            litCompletedCount.Text = completed.ToString();

            if (pending > 0)
            {
                pnlPendingNotice.Visible = true;
                litPendingAlertCount.Text = pending.ToString();
            }

            var allEnrollments = _ratingService.GetStudentEnrollments(CurrentStudentId);
            var pendingEnrollments = allEnrollments.Where(e => !e.HasRated && !string.Equals(e.Status, "Dropped", StringComparison.OrdinalIgnoreCase)).ToList();

            gvPendingCourses.DataSource = pendingEnrollments;
            gvPendingCourses.DataBind();
        }
    }
}
