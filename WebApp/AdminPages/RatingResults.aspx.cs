using System;
using System.Linq;
using System.Web.UI.WebControls;
using StudentFeedbackSystem.Repositories;
using StudentFeedbackSystem.Security;
using StudentFeedbackSystem.Services;

namespace StudentFeedbackSystem.AdminPages
{
    public partial class RatingResults : AdminBasePage
    {
        private readonly ReportService _reportService = new ReportService();
        private readonly IProfessorRepository _professorRepository = new ProfessorRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateDepartments();
                BindData();
            }
        }

        private void PopulateDepartments()
        {
            var profs = _professorRepository.GetAll(includeInactive: true);
            var depts = profs
                .Where(p => !string.IsNullOrWhiteSpace(p.Department))
                .Select(p => p.Department.Trim())
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .OrderBy(d => d)
                .ToList();

            ddlFilterDepartment.Items.Clear();
            ddlFilterDepartment.Items.Add(new ListItem("-- All Departments --", ""));

            foreach (var d in depts)
            {
                ddlFilterDepartment.Items.Add(new ListItem(d, d));
            }
        }

        private void BindData()
        {
            var schoolYear = string.IsNullOrWhiteSpace(txtFilterSchoolYear.Text) ? null : txtFilterSchoolYear.Text.Trim();
            var term = string.IsNullOrWhiteSpace(ddlFilterTerm.SelectedValue) ? null : ddlFilterTerm.SelectedValue;
            var department = string.IsNullOrWhiteSpace(ddlFilterDepartment.SelectedValue) ? null : ddlFilterDepartment.SelectedValue;
            var searchQuery = string.IsNullOrWhiteSpace(txtSearchQuery.Text) ? null : txtSearchQuery.Text.Trim();

            // Overall KPIs
            var metrics = _reportService.GetOverallMetrics(schoolYear, term, department);
            litInstAverage.Text = metrics.InstitutionalAverage.ToString("0.00");
            litTotalSubmissions.Text = metrics.TotalSubmissions.ToString();
            litCountVerySatisfactory.Text = metrics.VerySatisfactoryCount.ToString();
            litCountSatisfactory.Text = metrics.SatisfactoryCount.ToString();
            litCountBelowSatisfactory.Text = metrics.BelowSatisfactoryCount.ToString();

            // Prepare Chart.js classification doughnut data: [VerySat, Sat, BelowSat]
            hidChartClassificationData.Value = $"[{metrics.VerySatisfactoryCount}, {metrics.SatisfactoryCount}, {metrics.BelowSatisfactoryCount}]";

            // Grid results
            var results = _reportService.GetProfessorRatings(schoolYear, term, department, searchQuery).ToList();
            litResultCount.Text = results.Count.ToString();

            // Prepare Chart.js top faculty scores: Top 8 professors by score
            var topProfs = results.Take(8).ToList();
            var labelsJson = "[" + string.Join(",", topProfs.Select(p => "\"" + CleanJsonString(p.FullName) + "\"")) + "]";
            var scoresJson = "[" + string.Join(",", topProfs.Select(p => p.AverageScore.ToString("0.00", System.Globalization.CultureInfo.InvariantCulture))) + "]";
            hidChartFacultyScores.Value = $"{{\"labels\": {labelsJson}, \"scores\": {scoresJson}}}";

            gvRatingResults.DataSource = results;
            gvRatingResults.DataBind();
        }

        private static string CleanJsonString(string s)
        {
            return s.Replace("\\", "\\\\").Replace("\"", "\\\"");
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            gvRatingResults.PageIndex = 0;
            pnlDrillDown.Visible = false;
            BindData();
        }

        protected void btnResetFilter_Click(object sender, EventArgs e)
        {
            txtFilterSchoolYear.Text = string.Empty;
            ddlFilterTerm.SelectedIndex = 0;
            ddlFilterDepartment.SelectedIndex = 0;
            txtSearchQuery.Text = string.Empty;
            gvRatingResults.PageIndex = 0;
            pnlDrillDown.Visible = false;
            BindData();
        }

        protected void gvRatingResults_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvRatingResults.PageIndex = e.NewPageIndex;
            BindData();
        }

        protected void gvRatingResults_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewDrillDown")
            {
                if (!int.TryParse(e.CommandArgument?.ToString(), out var professorId)) return;

                var schoolYear = string.IsNullOrWhiteSpace(txtFilterSchoolYear.Text) ? null : txtFilterSchoolYear.Text.Trim();
                var term = string.IsNullOrWhiteSpace(ddlFilterTerm.SelectedValue) ? null : ddlFilterTerm.SelectedValue;

                var drill = _reportService.GetProfessorDrillDown(professorId, schoolYear, term);
                if (drill != null)
                {
                    litDrillProfessorName.Text = Server.HtmlEncode(drill.FullName);
                    litDrillDepartment.Text = Server.HtmlEncode(drill.Department ?? "Not specified");
                    litDrillCourses.Text = Server.HtmlEncode(drill.CoursesTaught.Any() ? string.Join(", ", drill.CoursesTaught) : "All registered courses");
                    litDrillAverage.Text = drill.OverallAverage.ToString("0.00");
                    litDrillClassificationBadge.Text = GetClassificationBadge(drill.Classification);

                    gvDrillCriteria.DataSource = drill.CriterionScores;
                    gvDrillCriteria.DataBind();

                    litDrillCommentsCount.Text = drill.Comments.Count.ToString();
                    if (drill.Comments.Any())
                    {
                        rptComments.DataSource = drill.Comments;
                        rptComments.DataBind();
                        rptComments.Visible = true;
                        pnlNoComments.Visible = false;
                    }
                    else
                    {
                        rptComments.Visible = false;
                        pnlNoComments.Visible = true;
                    }

                    pnlDrillDown.Visible = true;
                }
            }
        }

        protected void btnCloseDrillDown_Click(object sender, EventArgs e)
        {
            pnlDrillDown.Visible = false;
        }

        protected void btnExportCsv_Click(object sender, EventArgs e)
        {
            var schoolYear = string.IsNullOrWhiteSpace(txtFilterSchoolYear.Text) ? null : txtFilterSchoolYear.Text.Trim();
            var term = string.IsNullOrWhiteSpace(ddlFilterTerm.SelectedValue) ? null : ddlFilterTerm.SelectedValue;
            var department = string.IsNullOrWhiteSpace(ddlFilterDepartment.SelectedValue) ? null : ddlFilterDepartment.SelectedValue;

            var csvBytes = _reportService.ExportToCsv(schoolYear, term, department);
            var filename = $"Faculty_Ratings_Report_{DateTime.UtcNow:yyyyMMdd_HHmmss}.csv";

            Response.Clear();
            Response.ContentType = "text/csv";
            Response.AddHeader("Content-Disposition", $"attachment; filename=\"{filename}\"");
            Response.BinaryWrite(csvBytes);
            Response.End();
        }

        protected string GetClassificationBadge(object classificationObj)
        {
            var classification = classificationObj?.ToString() ?? "";
            switch (classification)
            {
                case "Very Satisfactory":
                    return "<span class=\"status-chip chip-success\"><span class=\"pulse-dot\"></span> Very Satisfactory</span>";
                case "Satisfactory":
                    return "<span class=\"status-chip\" style=\"background: rgba(245, 158, 11, 0.1); color: #b45309; border: 1px solid rgba(245, 158, 11, 0.25);\"><span class=\"pulse-dot\" style=\"background: #f59e0b;\"></span> Satisfactory</span>";
                default:
                    return "<span class=\"status-chip\" style=\"background: rgba(239, 68, 68, 0.1); color: #dc2626; border: 1px solid rgba(239, 68, 68, 0.25);\"><span class=\"pulse-dot\" style=\"background: #dc2626;\"></span> Below Satisfactory</span>";
            }
        }

        protected string GetInitials(object fullNameObj)
        {
            var name = fullNameObj?.ToString()?.Trim();
            if (string.IsNullOrWhiteSpace(name)) return "PF";

            var parts = name.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1)
            {
                return parts[0].Substring(0, Math.Min(2, parts[0].Length)).ToUpperInvariant();
            }
            return (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpperInvariant();
        }
    }
}
