using System;
using StudentFeedbackSystem.Security;
using StudentFeedbackSystem.Services;

namespace StudentFeedbackSystem
{
    public partial class Login : CsrfProtectedPage
    {
        private readonly AuthService _authService = new AuthService();

        protected global::System.Web.UI.WebControls.TextBox txtIdentifier;
        protected global::System.Web.UI.WebControls.TextBox txtPassword;
        protected global::System.Web.UI.WebControls.CheckBox chkRemember;
        protected global::System.Web.UI.WebControls.Literal litMessage;
        protected global::System.Web.UI.WebControls.Panel pnlMessage;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["denied"] == "1")
            {
                ShowMessage("You don't have access to that page, or your session expired. Please log in again.");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            var identifier = txtIdentifier.Text.Trim();
            var password = txtPassword.Text;
            var remember = chkRemember.Checked;

            // Try admin login first (admin uses a plain username, not an email)
            var adminResult = _authService.LoginAdmin(identifier, password, persistCookie: false);
            if (adminResult == LoginResult.Success)
            {
                Response.Redirect("~/AdminPages/Dashboard.aspx", true);
                return;
            }
            if (adminResult == LoginResult.AccountLockedOut)
            {
                ShowMessage($"Too many failed attempts. This account is temporarily locked — try again in {AuthService.ConfiguredLockoutMinutes} minutes.");
                return;
            }

            // If admin login didn't match, try student login
            var studentResult = _authService.LoginStudent(identifier, password, remember);
            switch (studentResult)
            {
                case LoginResult.Success:
                    Response.Redirect("~/StudentPages/Dashboard.aspx", true);
                    break;
                case LoginResult.AccountPending:
                case LoginResult.AccountRejected:
                case LoginResult.AccountSuspended:
                    Response.Redirect("~/PendingStatus.aspx", true);
                    break;
                case LoginResult.AccountLockedOut:
                    ShowMessage($"Too many failed attempts. Your account is temporarily locked — try again in {AuthService.ConfiguredLockoutMinutes} minutes.");
                    break;
                default:
                    ShowMessage("Incorrect email/username or password.");
                    break;
            }
        }

        private void ShowMessage(string message)
        {
            litMessage.Text = message;
            pnlMessage.Visible = true;
        }
    }
}