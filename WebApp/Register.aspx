<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="StudentFeedbackSystem.Register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-card registration-card">
        <h1>Student Registration</h1>
        <p class="hint">Your account will be reviewed by an admin against the official enrollment list before you can log in.</p>

        <asp:Panel ID="pnlMessage" runat="server" CssClass="alert alert-error" Visible="false">
            <asp:Literal ID="litMessage" runat="server" />
        </asp:Panel>

        <div class="form-row name-row">
            <div class="form-group">
                <asp:Label AssociatedControlID="txtFirstName" runat="server">First Name</asp:Label>
                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ControlToValidate="txtFirstName" runat="server" ErrorMessage="Required." Display="Dynamic" CssClass="field-error" ValidationGroup="Reg" />
            </div>
            <div class="form-group">
                <asp:Label AssociatedControlID="txtMiddleName" runat="server">Middle Name</asp:Label>
                <asp:TextBox ID="txtMiddleName" runat="server" CssClass="form-control" />
            </div>
            <div class="form-group">
                <asp:Label AssociatedControlID="txtLastName" runat="server">Last Name</asp:Label>
                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ControlToValidate="txtLastName" runat="server" ErrorMessage="Required." Display="Dynamic" CssClass="field-error" ValidationGroup="Reg" />
            </div>
        </div>

        <div class="form-group">
            <asp:Label AssociatedControlID="txtStudentNumber" runat="server">Student Number</asp:Label>
            <asp:TextBox ID="txtStudentNumber" runat="server" CssClass="form-control" placeholder="e.g. 23-1234"
                MaxLength="7" inputmode="numeric" oninput="formatStudentNumber(this);" />
            <asp:RequiredFieldValidator ControlToValidate="txtStudentNumber" runat="server" ErrorMessage="Required." Display="Dynamic" CssClass="field-error" ValidationGroup="Reg" />
            <asp:RegularExpressionValidator ControlToValidate="txtStudentNumber" runat="server"
                ValidationExpression="^[0-9]{2}-[0-9]{4}$" ErrorMessage="Format: YY-NNNN (six numbers total)." Display="Dynamic" CssClass="field-error" ValidationGroup="Reg" />
        </div>

        <div class="form-row">
            <div class="form-group">
                <asp:Label AssociatedControlID="txtBirthDate" runat="server">Birthdate</asp:Label>
                <asp:TextBox ID="txtBirthDate" runat="server" TextMode="Date" CssClass="form-control" />
                <asp:RequiredFieldValidator ControlToValidate="txtBirthDate" runat="server" ErrorMessage="Required." Display="Dynamic" CssClass="field-error" ValidationGroup="Reg" />
            </div>
            <div class="form-group">
                <asp:Label AssociatedControlID="ddlYearLevel" runat="server">Year Level</asp:Label>
                <asp:DropDownList ID="ddlYearLevel" runat="server" CssClass="form-control">
                    <asp:ListItem Text="1" Value="1" />
                    <asp:ListItem Text="2" Value="2" />
                    <asp:ListItem Text="3" Value="3" />
                    <asp:ListItem Text="4" Value="4" />
                    <asp:ListItem Text="5" Value="5" />
                </asp:DropDownList>
            </div>
        </div>

        <div class="form-group">
            <asp:Label AssociatedControlID="txtSchoolEmail" runat="server">School Email</asp:Label>
            <asp:TextBox ID="txtSchoolEmail" runat="server" TextMode="Email" CssClass="form-control" />
            <asp:RequiredFieldValidator ControlToValidate="txtSchoolEmail" runat="server" ErrorMessage="Required." Display="Dynamic" CssClass="field-error" ValidationGroup="Reg" />
            <asp:RegularExpressionValidator ControlToValidate="txtSchoolEmail" runat="server"
                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" ErrorMessage="Enter a valid email." Display="Dynamic" CssClass="field-error" ValidationGroup="Reg" />
        </div>

        <div class="form-row">
            <div class="form-group">
                <asp:Label AssociatedControlID="ddlProgram" runat="server">Program</asp:Label>
                <asp:DropDownList ID="ddlProgram" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Select a program" Value="" />
                    <asp:ListItem Text="Bachelor of Science in Information Technology" Value="Bachelor of Science in Information Technology" />
                    <asp:ListItem Text="Bachelor of Science in Computer Science" Value="Bachelor of Science in Computer Science" />
                    <asp:ListItem Text="Bachelor of Science in Information System" Value="Bachelor of Science in Information System" />
                    <asp:ListItem Text="Bachelor of Science in Entrepreneurship" Value="Bachelor of Science in Entrepreneurship" />
                    <asp:ListItem Text="Bachelor of Science in Business Administration" Value="Bachelor of Science in Business Administration" />
                    <asp:ListItem Text="Bachelor of Science in Accountancy" Value="Bachelor of Science in Accountancy" />
                    <asp:ListItem Text="Bachelor of Science in Industrial Engineering" Value="Bachelor of Science in Industrial Engineering" />
                    <asp:ListItem Text="Bachelor of Science in Electrical Computer Engineering" Value="Bachelor of Science in Electrical Computer Engineering" />
                    <asp:ListItem Text="Bachelor of Science in Computer Engineering" Value="Bachelor of Science in Computer Engineering" />
                    <asp:ListItem Text="Bachelor of Science in Early Childhood Education" Value="Bachelor of Science in Early Childhood Education" />
                </asp:DropDownList>
                <asp:RequiredFieldValidator ControlToValidate="ddlProgram" InitialValue="" runat="server" ErrorMessage="Required." Display="Dynamic" CssClass="field-error" ValidationGroup="Reg" />
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <asp:Label AssociatedControlID="txtPassword" runat="server">Password</asp:Label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" />
                <asp:RequiredFieldValidator ControlToValidate="txtPassword" runat="server" ErrorMessage="Required." Display="Dynamic" CssClass="field-error" ValidationGroup="Reg" />
                <asp:RegularExpressionValidator ControlToValidate="txtPassword" runat="server"
                    ValidationExpression="^(?=.*[A-Za-z])(?=.*\d).{8,}$"
                    ErrorMessage="At least 8 characters, with letters and numbers." Display="Dynamic" CssClass="field-error" ValidationGroup="Reg" />
                <ul id="passwordRequirements" class="password-requirements" aria-live="polite">
                    <li id="passwordLengthRequirement" class="password-requirement">At least 8 characters</li>
                    <li id="passwordLetterRequirement" class="password-requirement">At least one letter</li>
                    <li id="passwordNumberRequirement" class="password-requirement">At least one number</li>
                </ul>
            </div>
            <div class="form-group">
                <asp:Label AssociatedControlID="txtConfirmPassword" runat="server">Confirm Password</asp:Label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" />
                <asp:CompareValidator ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" runat="server"
                    ErrorMessage="Passwords do not match." Display="Dynamic" CssClass="field-error" ValidationGroup="Reg" />
            </div>
        </div>

        <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-primary"
            OnClick="btnRegister_Click" OnClientClick="markPasswordRequirements();" ValidationGroup="Reg" />
        <p class="hint">Already verified? <a href="~/Login.aspx" runat="server">Log in</a></p>
    </div>

    <script type="text/javascript">
        function formatStudentNumber(input) {
            var digits = input.value.replace(/[^0-9]/g, '').substring(0, 6);
            input.value = digits.length > 2 ? digits.substring(0, 2) + '-' + digits.substring(2) : digits;
        }

        (function () {
            var password = document.getElementById('<%= txtPassword.ClientID %>');
            var passwordValidationStarted = false;
            var requirements = [
                { element: document.getElementById('passwordLengthRequirement'), test: function (value) { return value.length >= 8; } },
                { element: document.getElementById('passwordLetterRequirement'), test: function (value) { return /[A-Za-z]/.test(value); } },
                { element: document.getElementById('passwordNumberRequirement'), test: function (value) { return /\d/.test(value); } }
            ];

            function updatePasswordRequirements(showIncomplete) {
                var value = password.value;
                requirements.forEach(function (requirement) {
                    var complete = requirement.test(value);
                    requirement.element.className = 'password-requirement ' +
                        (complete ? 'requirement-complete' : showIncomplete ? 'requirement-incomplete' : '');
                });
            }

            password.addEventListener('input', function () { updatePasswordRequirements(passwordValidationStarted); });
            window.markPasswordRequirements = function () {
                passwordValidationStarted = true;
                updatePasswordRequirements(true);
            };
            updatePasswordRequirements(false);
        }());
    </script>
</asp:Content>
