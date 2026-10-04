using System;
using System.Linq;
using System.Web.UI.WebControls;
using StudentFeedbackSystem.Security;
using StudentFeedbackSystem.Services;

namespace StudentFeedbackSystem.AdminPages
{
    public partial class VerifyStudents : AdminBasePage
    {
        private readonly VerificationService _verificationService = new VerificationService();

        protected global::System.Web.UI.WebControls.GridView gvStudents;
        protected global::System.Web.UI.WebControls.Literal litMessage;
        protected global::System.Web.UI.WebControls.Panel pnlMessage;
        protected global::System.Web.UI.WebControls.DropDownList ddlStatusFilter;
        protected global::System.Web.UI.WebControls.Literal litPendingCount;
        protected global::System.Web.UI.WebControls.Literal litVerifiedCount;
        protected global::System.Web.UI.WebControls.Literal litRejectedCount;
        protected global::System.Web.UI.WebControls.Literal litSuspendedCount;
        protected global::System.Web.UI.WebControls.Literal litCurrentFilterLabel;
        protected global::System.Web.UI.WebControls.Literal litFilteredCount;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGrid();
            }
        }

        private void BindGrid()
        {
            UpdateStatusCounters();

            var currentStatus = ddlStatusFilter.SelectedValue;
            var students = _verificationService.GetByStatus(currentStatus).ToList();
            litCurrentFilterLabel.Text = Server.HtmlEncode(ddlStatusFilter.SelectedItem.Text);
            litFilteredCount.Text = students.Count.ToString();

            gvStudents.DataSource = students;
            gvStudents.DataBind();

            // Populate each row's section dropdown after binding (GridView doesn't
            // support per-row DataSource declaratively for a nested control).
            var sections = _verificationService.GetSections().ToList();
            foreach (GridViewRow row in gvStudents.Rows)
            {
                if (row.RowType != DataControlRowType.DataRow) continue;
                var ddl = row.FindControl("ddlSection") as DropDownList;
                if (ddl == null) continue;

                ddl.DataSource = sections;
                ddl.DataBind();
                ddl.Items.Insert(0, new ListItem("-- Assign Section --", ""));
            }
        }

        private void UpdateStatusCounters()
        {
            try
            {
                litPendingCount.Text = _verificationService.GetByStatus("Pending").Count().ToString();
                litVerifiedCount.Text = _verificationService.GetByStatus("Verified").Count().ToString();
                litRejectedCount.Text = _verificationService.GetByStatus("Rejected").Count().ToString();
                litSuspendedCount.Text = _verificationService.GetByStatus("Suspended").Count().ToString();
            }
            catch
            {
                litPendingCount.Text = "0";
                litVerifiedCount.Text = "0";
                litRejectedCount.Text = "0";
                litSuspendedCount.Text = "0";
            }
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvStudents.PageIndex = 0;
            pnlMessage.Visible = false;
            BindGrid();
        }

        protected void gvStudents_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvStudents.PageIndex = e.NewPageIndex;
            BindGrid();
        }

        protected void gvStudents_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (!int.TryParse(e.CommandArgument?.ToString(), out var studentId)) return;

            // CurrentAdminId comes from the authenticated ticket via AdminBasePage —
            // never trust a client-supplied admin id.
            if (e.CommandName == "Approve")
            {
                var row = FindRowByStudentId(studentId);
                var ddl = row?.FindControl("ddlSection") as DropDownList;
                int? sectionId = null;
                if (ddl != null && !string.IsNullOrEmpty(ddl.SelectedValue))
                {
                    sectionId = int.Parse(ddl.SelectedValue);
                }

                _verificationService.Approve(studentId, CurrentAdminId, sectionId);
                ShowMessage(sectionId.HasValue
                    ? "Student successfully approved and assigned to section."
                    : "Student successfully approved (no section assigned yet).");
            }
            else if (e.CommandName == "Reject")
            {
                // A minimal reason; a full implementation would prompt via a modal/text field.
                _verificationService.Reject(studentId, CurrentAdminId, "Did not match official enrollment list.");
                ShowMessage("Student registration rejected.");
            }

            BindGrid();
        }

        private GridViewRow FindRowByStudentId(int studentId)
        {
            foreach (GridViewRow row in gvStudents.Rows)
            {
                if (row.RowType != DataControlRowType.DataRow) continue;
                var keyValue = gvStudents.DataKeys[row.RowIndex].Value;
                if (keyValue != null && (int)keyValue == studentId) return row;
            }
            return null;
        }

        private void ShowMessage(string message)
        {
            litMessage.Text = message;
            pnlMessage.Visible = true;
        }

        protected string GetInitials(object fullNameObj)
        {
            var name = fullNameObj?.ToString()?.Trim();
            if (string.IsNullOrWhiteSpace(name)) return "ST";

            var parts = name.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1)
            {
                return parts[0].Substring(0, Math.Min(2, parts[0].Length)).ToUpperInvariant();
            }
            return (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpperInvariant();
        }

        protected string GetCurrentStatusBadgeClass()
        {
            var status = ddlStatusFilter?.SelectedValue ?? "Pending";
            switch (status)
            {
                case "Pending": return "badge-warning";
                case "Verified": return "badge-success";
                case "Rejected": return "badge-danger";
                case "Suspended": return "badge-neutral";
                default: return "badge-info";
            }
        }
    }
}
