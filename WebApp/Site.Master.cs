using System;
using System.Linq;
using StudentFeedbackSystem.Repositories;
using StudentFeedbackSystem.Security;
using StudentFeedbackSystem.Services;

namespace StudentFeedbackSystem
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string role;
            int entityId;
            int? sectionId;
            var isAuthenticated = SessionClaims.TryGetCurrentUser(out role, out entityId, out sectionId);

            var isAdmin = isAuthenticated
                && (string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase)
                    || string.Equals(role, "SuperAdmin", StringComparison.OrdinalIgnoreCase));

            var isStudent = isAuthenticated
                && string.Equals(role, "Student", StringComparison.OrdinalIgnoreCase);


            pnlAdminSidebar.Visible = isAdmin;
            pnlStudentSidebar.Visible = isStudent;

            if (isAdmin)
            {
                brandLink.HRef = ResolveUrl("~/AdminPages/Dashboard.aspx");
                var username = Context.User?.Identity?.Name;
                if (string.IsNullOrWhiteSpace(username))
                {
                    username = "Administrator";
                }
                litAdminUsername.Text = Server.HtmlEncode(username);
                litAdminRoleBadge.Text = Server.HtmlEncode(string.Equals(role, "SuperAdmin", StringComparison.OrdinalIgnoreCase) ? "Super Admin" : "Administrator");

                try
                {
                    var pendingCount = new VerificationService().GetPending().Count();
                    if (pendingCount > 0)
                    {
                        litSidebarPendingBadge.Text = $"<span class=\"nav-badge-pill\" title=\"{pendingCount} pending verification(s)\">{pendingCount}</span>";
                    }
                    else
                    {
                        litSidebarPendingBadge.Text = string.Empty;
                    }
                }
                catch
                {
                    litSidebarPendingBadge.Text = string.Empty;
                }
            }
            else if (isStudent)
            {
                brandLink.HRef = ResolveUrl("~/StudentPages/Dashboard.aspx");
                try
                {
                    var student = new StudentRepository().GetById(entityId);
                    litStudentUsername.Text = Server.HtmlEncode(student?.FullName ?? Context.User?.Identity?.Name ?? "Student");

                    var pendingCount = new EnrollmentRepository().CountPendingByStudent(entityId);
                    if (pendingCount > 0)
                    {
                        litStudentPendingBadge.Text = $"<span class=\"nav-badge-pill\" title=\"{pendingCount} pending evaluation(s)\">{pendingCount}</span>";
                    }
                    else
                    {
                        litStudentPendingBadge.Text = string.Empty;
                    }
                }
                catch
                {
                    litStudentUsername.Text = "Student";
                    litStudentPendingBadge.Text = string.Empty;
                }
            }
            else
            {
                brandLink.HRef = ResolveUrl("~/Login.aspx");
            }
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            new AuthService().SignOut();
            Response.Redirect("~/Login.aspx");
        }
    }
}
