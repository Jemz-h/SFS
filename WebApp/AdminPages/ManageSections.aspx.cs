using System;
using System.Linq;
using System.Web.UI.WebControls;
using StudentFeedbackSystem.Models;
using StudentFeedbackSystem.Repositories;
using StudentFeedbackSystem.Security;

namespace StudentFeedbackSystem.AdminPages
{
    public partial class ManageSections : AdminBasePage
    {
        private readonly ISectionRepository _sectionRepository = new SectionRepository();
        private readonly ICourseRepository _courseRepository = new CourseRepository();
        private readonly IProfessorRepository _professorRepository = new ProfessorRepository();
        private readonly ICourseOfferingRepository _offeringRepository = new CourseOfferingRepository();
        private readonly IStudentRepository _studentRepository = new StudentRepository();
        private readonly IEnrollmentRepository _enrollmentRepository = new EnrollmentRepository();
        private readonly Services.VerificationService _verificationService = new Services.VerificationService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (string.IsNullOrEmpty(hidActiveTab.Value))
                {
                    hidActiveTab.Value = "sections";
                }
                BindAll();
                ResetSectionEditor();
            }
        }

        private void BindAll()
        {
            var sections = _sectionRepository.GetAll().ToList();
            litTotalSectionsCount.Text = sections.Count.ToString();
            gvSections.DataSource = sections;
            gvSections.DataBind();

            BindOfferingLists();

            var offerings = _offeringRepository.GetAll().ToList();
            litTotalOfferingsCount.Text = offerings.Count.ToString();
            gvOfferings.DataSource = offerings;
            gvOfferings.DataBind();

            ddlAssignSection.DataSource = sections;
            ddlAssignSection.DataTextField = "SectionName";
            ddlAssignSection.DataValueField = "SectionId";
            ddlAssignSection.DataBind();
            ddlAssignSection.Items.Insert(0, new ListItem("-- Select Target Section --", ""));

            ddlBulkFallbackSection.DataSource = sections;
            ddlBulkFallbackSection.DataTextField = "SectionName";
            ddlBulkFallbackSection.DataValueField = "SectionId";
            ddlBulkFallbackSection.DataBind();
            ddlBulkFallbackSection.Items.Insert(0, new ListItem("-- Optional Fallback Section --", ""));
        }

        private void BindOfferingLists()
        {
            var activeCourses = _courseRepository.GetAll(includeInactive: false).ToList();
            ddlOfferingCourse.DataSource = activeCourses;
            ddlOfferingCourse.DataTextField = "CourseCode";
            ddlOfferingCourse.DataValueField = "CourseId";
            ddlOfferingCourse.DataBind();
            ddlOfferingCourse.Items.Insert(0, new ListItem("-- Select Course --", ""));

            var activeProfs = _professorRepository.GetAll(includeInactive: false).ToList();
            ddlOfferingProfessor.DataSource = activeProfs;
            ddlOfferingProfessor.DataTextField = "FullName";
            ddlOfferingProfessor.DataValueField = "ProfessorId";
            ddlOfferingProfessor.DataBind();
            ddlOfferingProfessor.Items.Insert(0, new ListItem("-- Select Instructor --", ""));

            var sections = _sectionRepository.GetAll().ToList();
            ddlOfferingSection.DataSource = sections;
            ddlOfferingSection.DataTextField = "SectionName";
            ddlOfferingSection.DataValueField = "SectionId";
            ddlOfferingSection.DataBind();
            ddlOfferingSection.Items.Insert(0, new ListItem("-- Select Section --", ""));
        }

        protected void btnSaveSection_Click(object sender, EventArgs e)
        {
            hidActiveTab.Value = "sections";
            if (!Page.IsValid) return;

            var section = new Section
            {
                SectionName = txtSectionName.Text.Trim(),
                Program = ddlSectionProgram.SelectedValue,
                YearLevel = int.Parse(ddlSectionYearLevel.SelectedValue),
                SchoolYear = txtSchoolYear.Text.Trim(),
                Term = ddlTerm.SelectedValue
            };

            try
            {
                int sectionId;
                if (int.TryParse(hidSectionId.Value, out sectionId))
                {
                    section.SectionId = sectionId;
                    _sectionRepository.Update(section);
                    ShowMessage("Section updated successfully.");
                }
                else
                {
                    _sectionRepository.Insert(section);
                    ShowMessage("Section created successfully.");
                }

                ResetSectionEditor();
                BindAll();
            }
            catch (Exception)
            {
                ShowError("The section could not be saved. Check that the section name is unique for this school year and term.");
            }
        }

        protected void btnCancelSection_Click(object sender, EventArgs e)
        {
            hidActiveTab.Value = "sections";
            ResetSectionEditor();
        }

        protected void gvSections_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            hidActiveTab.Value = "sections";
            int sectionId;
            if (e.CommandName != "EditSection" || !int.TryParse(e.CommandArgument?.ToString(), out sectionId)) return;

            var section = _sectionRepository.GetById(sectionId);
            if (section == null) return;

            hidSectionId.Value = section.SectionId.ToString();
            txtSectionName.Text = section.SectionName;
            ddlSectionProgram.SelectedValue = section.Program;
            ddlSectionYearLevel.SelectedValue = section.YearLevel.ToString();
            txtSchoolYear.Text = section.SchoolYear;
            ddlTerm.SelectedValue = section.Term;
            litSectionEditorTitle.Text = "Edit Section";
            btnSaveSection.Text = "Update Section";
            btnCancelSection.Visible = true;
        }

        protected void btnSaveOffering_Click(object sender, EventArgs e)
        {
            hidActiveTab.Value = "offerings";
            int courseId;
            int professorId;
            int sectionId;
            if (!int.TryParse(ddlOfferingCourse.SelectedValue, out courseId)
                || !int.TryParse(ddlOfferingProfessor.SelectedValue, out professorId)
                || !int.TryParse(ddlOfferingSection.SelectedValue, out sectionId)
                || string.IsNullOrWhiteSpace(txtOfferingSchoolYear.Text))
            {
                ShowError("Select a valid course, instructor, section, school year, and term.");
                return;
            }

            try
            {
                var newOffering = new CourseOffering
                {
                    CourseId = courseId,
                    ProfessorId = professorId,
                    SectionId = sectionId,
                    SchoolYear = txtOfferingSchoolYear.Text.Trim(),
                    Term = ddlOfferingTerm.SelectedValue
                };
                int offeringId = _offeringRepository.Insert(newOffering);
                _enrollmentRepository.CreateEnrollmentsForOffering(offeringId, sectionId);

                ShowMessage("Course offering successfully added and students in this section have been enrolled.");
                var offerings = _offeringRepository.GetAll().ToList();
                litTotalOfferingsCount.Text = offerings.Count.ToString();
                gvOfferings.DataSource = offerings;
                gvOfferings.DataBind();
            }
            catch (Exception)
            {
                ShowError("The course offering could not be added. This offering may already exist for this section.");
            }
        }

        protected void gvOfferings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            hidActiveTab.Value = "offerings";
            int offeringId;
            if (e.CommandName != "RemoveOffering" || !int.TryParse(e.CommandArgument?.ToString(), out offeringId)) return;

            try
            {
                _offeringRepository.Delete(offeringId);
                ShowMessage("Course offering removed.");
                var offerings = _offeringRepository.GetAll().ToList();
                litTotalOfferingsCount.Text = offerings.Count.ToString();
                gvOfferings.DataSource = offerings;
                gvOfferings.DataBind();
            }
            catch (Exception)
            {
                ShowError("The course offering could not be removed because it may already have student feedback enrollments.");
            }
        }

        protected void btnAssignStudent_Click(object sender, EventArgs e)
        {
            hidActiveTab.Value = "students";
            var studentNumber = txtAssignStudentNumber.Text.Trim();
            var student = _studentRepository.GetByStudentNumber(studentNumber);
            int sectionId;
            if (student == null || !int.TryParse(ddlAssignSection.SelectedValue, out sectionId))
            {
                ShowError("Please enter a valid enrolled student number (e.g. 23-1234) and select a destination section.");
                return;
            }

            _verificationService.AssignSection(student.StudentId, CurrentAdminId, sectionId);
            ShowMessage($"Student {student.FullName} (#{student.StudentNumber}) has been successfully assigned to the section and enrolled in all active courses.");
            txtAssignStudentNumber.Text = string.Empty;
        }

        protected void btnProcessBulkCsv_Click(object sender, EventArgs e)
        {
            hidActiveTab.Value = "students";
            string csvText = null;

            if (fuSectionCsv.HasFile)
            {
                using (var reader = new System.IO.StreamReader(fuSectionCsv.FileContent))
                {
                    csvText = reader.ReadToEnd();
                }
            }
            else if (!string.IsNullOrWhiteSpace(txtBulkCsv.Text))
            {
                csvText = txtBulkCsv.Text;
            }

            if (string.IsNullOrWhiteSpace(csvText))
            {
                ShowError("Please upload a CSV file or paste CSV text to process bulk assignment.");
                return;
            }

            int? fallbackSecId = null;
            if (int.TryParse(ddlBulkFallbackSection.SelectedValue, out var parsedSecId))
            {
                fallbackSecId = parsedSecId;
            }

            var bulkResult = _verificationService.BulkAssignFromCsv(csvText, CurrentAdminId, fallbackSecId);

            var summaryHtml = "<div style=\"background: var(--bg-surface-alt, #f8fafc); border: 1px solid var(--border-color, #e2e8f0); border-radius: 8px; padding: 1rem;\">" +
                "<h4 style=\"margin: 0 0 0.5rem 0; font-size: 0.95rem; font-weight: 600;\">Bulk Placement Summary</h4>" +
                $"<p style=\"margin: 0 0 0.5rem 0;\"><strong>Total processed:</strong> {bulkResult.TotalProcessed} &bull; " +
                $"<span style=\"color: #059669;\"><strong>Success:</strong> {bulkResult.SuccessCount}</span> &bull; " +
                $"<span style=\"color: #dc2626;\"><strong>Failed:</strong> {bulkResult.FailCount}</span></p>";

            if (bulkResult.Errors.Any())
            {
                summaryHtml += "<div style=\"color: #dc2626; font-size: 0.85rem;\"><strong>Issues encountered:</strong><ul style=\"margin: 0.25rem 0 0 1.25rem; padding: 0;\">";
                foreach (var err in bulkResult.Errors.Take(10))
                {
                    summaryHtml += $"<li>{System.Web.HttpUtility.HtmlEncode(err)}</li>";
                }
                if (bulkResult.Errors.Count > 10)
                {
                    summaryHtml += $"<li>...and {bulkResult.Errors.Count - 10} more errors.</li>";
                }
                summaryHtml += "</ul></div>";
            }
            summaryHtml += "</div>";

            litBulkResultSummary.Text = summaryHtml;
            pnlBulkResults.Visible = true;
            txtBulkCsv.Text = string.Empty;

            if (bulkResult.SuccessCount > 0)
            {
                ShowMessage($"Bulk placement completed: {bulkResult.SuccessCount} student(s) successfully assigned.");
            }
            else if (bulkResult.FailCount > 0)
            {
                ShowError("Bulk placement could not complete for the provided records. Check error details below.");
            }
        }

        private void ResetSectionEditor()
        {
            hidSectionId.Value = string.Empty;
            txtSectionName.Text = string.Empty;
            ddlSectionProgram.SelectedIndex = 0;
            ddlSectionYearLevel.SelectedValue = "1";
            txtSchoolYear.Text = string.Empty;
            ddlTerm.SelectedValue = "1st Semester";
            litSectionEditorTitle.Text = "Add Section";
            btnSaveSection.Text = "Save Section";
            btnCancelSection.Visible = false;
        }

        private void ShowMessage(string message)
        {
            litMessage.Text = message;
            pnlMessage.CssClass = "modern-alert alert-success";
            pnlMessage.Visible = true;
        }

        private void ShowError(string message)
        {
            litMessage.Text = message;
            pnlMessage.CssClass = "modern-alert alert-error";
            pnlMessage.Visible = true;
        }
    }
}
