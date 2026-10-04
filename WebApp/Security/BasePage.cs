using System.Web.UI;

namespace StudentFeedbackSystem.Security
{
    /// <summary>Applies a session-bound ViewState MAC to every Web Forms postback.</summary>
    public abstract class CsrfProtectedPage : Page
    {
        protected override void OnInit(System.EventArgs e)
        {
            if (Session != null)
            {
                ViewStateUserKey = Session.SessionID;
            }

            base.OnInit(e);
        }
    }

    /// <summary>
    /// Base class for every protected .aspx.cs code-behind. Web.config location
    /// rules already block unauthorized folder access, but WebForms auth can be
    /// bypassed if only one layer checks it, so every protected page re-checks
    /// here too (defense in depth, per the project plan §4).
    ///
    /// Usage: inherit from StudentBasePage or AdminBasePage instead of Page.
    /// </summary>
    public abstract class RoleRestrictedPage : CsrfProtectedPage
    {
        protected abstract string[] AllowedRoles { get; }

        protected int CurrentEntityId { get; private set; }
        protected int? CurrentSectionId { get; private set; }
        protected string CurrentRole { get; private set; }

        protected override void OnLoad(System.EventArgs e)
        {
            if (!SessionClaims.TryGetCurrentUser(out var role, out var entityId, out var sectionId)
                || !IsAllowed(role))
            {
                Response.Redirect("~/Login.aspx?denied=1", true);
                return;
            }

            CurrentRole = role;
            CurrentEntityId = entityId;
            CurrentSectionId = sectionId;

            base.OnLoad(e);
        }

        private bool IsAllowed(string role)
        {
            foreach (var allowed in AllowedRoles)
            {
                if (string.Equals(role, allowed, System.StringComparison.OrdinalIgnoreCase)) return true;
            }
            return false;
        }
    }

    public abstract class StudentBasePage : RoleRestrictedPage
    {
        protected override string[] AllowedRoles => new[] { "Student" };

        /// <summary>The logged-in student's own StudentId. Always filter queries by this — never trust an ID from the query string.</summary>
        protected int CurrentStudentId => CurrentEntityId;
    }

    public abstract class AdminBasePage : RoleRestrictedPage
    {
        protected override string[] AllowedRoles => new[] { "Admin", "SuperAdmin" };

        protected int CurrentAdminId => CurrentEntityId;
    }

    public abstract class SuperAdminBasePage : RoleRestrictedPage
    {
        protected override string[] AllowedRoles => new[] { "SuperAdmin" };

        protected int CurrentAdminId => CurrentEntityId;
    }
}
