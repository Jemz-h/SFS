using System;
using System.Linq;
using StudentFeedbackSystem.Repositories;
using StudentFeedbackSystem.Security;
using StudentFeedbackSystem.Services;

namespace StudentFeedbackSystem.AdminPages
{
    public partial class Dashboard : AdminBasePage
    {
        protected global::System.Web.UI.WebControls.Literal litPendingCount;
        protected global::System.Web.UI.WebControls.Literal litPendingBannerCount;
        protected global::System.Web.UI.WebControls.Literal litVerifiedCount;
        protected global::System.Web.UI.WebControls.Literal litTotalCourses;
        protected global::System.Web.UI.WebControls.Literal litActiveCourses;
        protected global::System.Web.UI.WebControls.Literal litTotalProfessors;
        protected global::System.Web.UI.WebControls.Literal litActiveProfessors;
        protected global::System.Web.UI.WebControls.Literal litTotalSections;
        protected global::System.Web.UI.WebControls.Literal litTotalOfferings;
        protected global::System.Web.UI.WebControls.Literal litAdminName;
        protected global::System.Web.UI.WebControls.Literal litCurrentDate;
        protected global::System.Web.UI.WebControls.Panel pnlPendingAlert;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardMetrics();
            }
        }

        private void LoadDashboardMetrics()
        {
            var username = Context.User?.Identity?.Name;
            if (string.IsNullOrWhiteSpace(username))
            {
                username = "Administrator";
            }
            litAdminName.Text = Server.HtmlEncode(username);
            litCurrentDate.Text = DateTime.Now.ToString("dddd, MMMM d, yyyy");

            try
            {
                var verificationService = new VerificationService();
                var pendingCount = verificationService.GetPending().Count();
                var verifiedCount = verificationService.GetByStatus("Verified").Count();

                litPendingCount.Text = pendingCount.ToString();
                litPendingBannerCount.Text = pendingCount.ToString();
                litVerifiedCount.Text = verifiedCount.ToString();

                pnlPendingAlert.Visible = pendingCount > 0;
            }
            catch
            {
                litPendingCount.Text = "0";
                litPendingBannerCount.Text = "0";
                litVerifiedCount.Text = "0";
                pnlPendingAlert.Visible = false;
            }

            try
            {
                var courseRepo = new CourseRepository();
                var courses = courseRepo.GetAll(includeInactive: true).ToList();
                litTotalCourses.Text = courses.Count.ToString();
                litActiveCourses.Text = courses.Count(c => c.IsActive).ToString();
            }
            catch
            {
                litTotalCourses.Text = "0";
                litActiveCourses.Text = "0";
            }

            try
            {
                var profRepo = new ProfessorRepository();
                var profs = profRepo.GetAll(includeInactive: true).ToList();
                litTotalProfessors.Text = profs.Count.ToString();
                litActiveProfessors.Text = profs.Count(p => p.IsActive).ToString();
            }
            catch
            {
                litTotalProfessors.Text = "0";
                litActiveProfessors.Text = "0";
            }

            try
            {
                var sectionRepo = new SectionRepository();
                litTotalSections.Text = sectionRepo.GetAll().Count().ToString();
            }
            catch
            {
                litTotalSections.Text = "0";
            }

            try
            {
                var offeringRepo = new CourseOfferingRepository();
                litTotalOfferings.Text = offeringRepo.GetAll().Count().ToString();
            }
            catch
            {
                litTotalOfferings.Text = "0";
            }
        }
    }
}
