using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using StudentFeedbackSystem.Models;
using StudentFeedbackSystem.Security;
using StudentFeedbackSystem.Services;

namespace StudentFeedbackSystem.StudentPages
{
    public partial class RateCourse : StudentBasePage
    {
        private readonly RatingService _ratingService = new RatingService();

        private int EnrollmentId
        {
            get
            {
                int.TryParse(Request.QueryString["enrollmentId"], out var id);
                return id;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (EnrollmentId <= 0)
            {
                Response.Redirect("MyCourses.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadEnrollmentDetails();
            }
        }

        private void LoadEnrollmentDetails()
        {
            var enrollment = _ratingService.GetEnrollmentForRating(EnrollmentId, CurrentStudentId);
            if (enrollment == null)
            {
                Response.Redirect("MyCourses.aspx");
                return;
            }

            litCourseCode.Text = Server.HtmlEncode(enrollment.CourseCode);
            litCourseTitle.Text = Server.HtmlEncode(enrollment.CourseTitle);
            litUnits.Text = enrollment.Units.ToString();
            litSectionName.Text = Server.HtmlEncode(enrollment.SectionName);
            litSchoolYear.Text = Server.HtmlEncode(enrollment.SchoolYear);
            litTerm.Text = Server.HtmlEncode(enrollment.Term);
            litProfessorName.Text = Server.HtmlEncode(enrollment.ProfessorName);
            litDepartment.Text = Server.HtmlEncode(string.IsNullOrWhiteSpace(enrollment.Department) ? "Faculty of Instruction" : enrollment.Department);

            var criteria = _ratingService.GetActiveCriteria().ToList();
            if (!criteria.Any())
            {
                ShowError("No evaluation criteria are currently active. Please contact the administrator.");
                btnSubmitRating.Enabled = false;
                return;
            }

            rptCriteria.DataSource = criteria;
            rptCriteria.DataBind();
        }

        protected void btnSubmitRating_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;

            var enrollment = _ratingService.GetEnrollmentForRating(EnrollmentId, CurrentStudentId);
            if (enrollment == null)
            {
                ShowError("This course enrollment is either invalid, already evaluated, or not authorized for your account.");
                return;
            }

            var activeCriteria = _ratingService.GetActiveCriteria().ToList();
            var scores = new Dictionary<int, int>();

            foreach (var criterion in activeCriteria)
            {
                var formKey = "rating_" + criterion.CriterionId;
                var rawValue = Request.Form[formKey];

                if (string.IsNullOrWhiteSpace(rawValue) || !int.TryParse(rawValue, out var score) || score < 1 || score > 5)
                {
                    ShowError($"Please select a rating from 1 to 5 for '{criterion.CriterionName}'.");
                    return;
                }

                scores[criterion.CriterionId] = score;
            }

            try
            {
                _ratingService.SubmitRating(
                    CurrentStudentId,
                    EnrollmentId,
                    scores,
                    txtComments.Text,
                    chkAnonymous.Checked);

                Response.Redirect("MyCourses.aspx?submitted=1", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (UnauthorizedAccessException)
            {
                ShowError("This enrollment is not available for your account.");
            }
            catch (InvalidOperationException ex)
            {
                ShowError(ex.Message);
            }
            catch (ArgumentException ex)
            {
                ShowError(ex.Message);
            }
            catch (Exception)
            {
                ShowError("The evaluation could not be submitted. Please try again.");
            }
        }

        private void ShowError(string message)
        {
            litErrorMessage.Text = Server.HtmlEncode(message);
            pnlError.Visible = true;
        }
    }
}
