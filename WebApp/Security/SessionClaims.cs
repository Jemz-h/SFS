using System;
using System.Web;
using System.Web.Security;

namespace StudentFeedbackSystem.Security
{
    /// <summary>
    /// Reads the Role|EntityId|SectionId data that AuthService packed into the
    /// Forms Authentication ticket, so pages can authorize/filter without a DB
    /// round-trip on every request. Call from Page_Load — see BasePage.
    /// </summary>
    public static class SessionClaims
    {
        public static bool TryGetCurrentUser(out string role, out int entityId, out int? sectionId)
        {
            role = null;
            entityId = 0;
            sectionId = null;

            var identity = HttpContext.Current?.User?.Identity as FormsIdentity;
            if (identity == null || !identity.IsAuthenticated) return false;

            var parts = identity.Ticket.UserData.Split('|');
            if (parts.Length != 3) return false;

            role = parts[0];
            if (!int.TryParse(parts[1], out entityId)) return false;

            if (int.TryParse(parts[2], out var parsedSectionId))
            {
                sectionId = parsedSectionId;
            }

            return true;
        }

        public static bool CurrentUserIsInRole(params string[] allowedRoles)
        {
            if (!TryGetCurrentUser(out var role, out _, out _)) return false;
            foreach (var r in allowedRoles)
            {
                if (string.Equals(role, r, StringComparison.OrdinalIgnoreCase)) return true;
            }
            return false;
        }
    }
}
