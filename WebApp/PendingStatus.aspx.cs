using System;
using StudentFeedbackSystem.Security;

namespace StudentFeedbackSystem
{
    public partial class PendingStatus : CsrfProtectedPage
    {
        protected global::System.Web.UI.WebControls.Literal litTitle;
        protected global::System.Web.UI.WebControls.Literal litBody;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["justRegistered"] == "1")
            {
                litTitle.Text = "Registration Received";
                litBody.Text = "Thanks for registering. An admin will verify your account against the official " +
                                "enrollment list before you can log in — this usually takes 1-2 business days.";
            }
            else
            {
                litTitle.Text = "Account Not Yet Active";
                litBody.Text = "Your account is pending verification, or was rejected/suspended. " +
                                "Contact the registrar's office if this seems wrong, or wait for admin approval.";
            }
        }
    }
}
