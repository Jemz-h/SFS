using System;
using System.Globalization;
using StudentFeedbackSystem.Security;
using StudentFeedbackSystem.Services;

namespace StudentFeedbackSystem
{
    public partial class Register : CsrfProtectedPage
    {
        private readonly AuthService _authService = new AuthService();

        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            DateTime birthDate;
            if (!DateTime.TryParseExact(txtBirthDate.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture,
                DateTimeStyles.None, out birthDate))
            {
                litMessage.Text = "Enter a valid birthdate.";
                pnlMessage.Visible = true;
                return;
            }

            var (success, error) = _authService.RegisterStudent(
                studentNumber: txtStudentNumber.Text.Trim(),
                schoolEmail: txtSchoolEmail.Text.Trim(),
                plainPassword: txtPassword.Text,
                firstName: txtFirstName.Text.Trim(),
                middleName: txtMiddleName.Text.Trim(),
                lastName: txtLastName.Text.Trim(),
                program: ddlProgram.SelectedValue,
                yearLevel: int.Parse(ddlYearLevel.SelectedValue),
                birthDate: birthDate);

            if (!success)
            {
                litMessage.Text = error;
                pnlMessage.Visible = true;
                return;
            }

            Response.Redirect("~/PendingStatus.aspx?justRegistered=1", true);
        }
    }
}
