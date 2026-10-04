<%@ Page Title="Log In" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="StudentFeedbackSystem.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="login-page">
        <div class="auth-card">
            <h1>Log In</h1>

            <asp:Panel ID="pnlMessage" runat="server" CssClass="alert alert-error" Visible="false">
                <asp:Literal ID="litMessage" runat="server" />
            </asp:Panel>

            <div class="form-group">
                <asp:Label AssociatedControlID="txtIdentifier" runat="server">Email or Username</asp:Label>
                <asp:TextBox ID="txtIdentifier" runat="server" CssClass="form-control" placeholder="Enter email or username" />
                <asp:RequiredFieldValidator ControlToValidate="txtIdentifier" runat="server"
                    ErrorMessage="Email or username is required." Display="Dynamic" CssClass="field-error" ValidationGroup="Login" />
            </div>
            <div class="form-group">
                <asp:Label AssociatedControlID="txtPassword" runat="server">Password</asp:Label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your password" />
                <asp:RequiredFieldValidator ControlToValidate="txtPassword" runat="server"
                    ErrorMessage="Password is required." Display="Dynamic" CssClass="field-error" ValidationGroup="Login" />
            </div>
            <div class="form-group remember-group">
                <asp:CheckBox ID="chkRemember" runat="server" CssClass="remember-checkbox" Text="Keep me signed in" TextAlign="Right" />
            </div>
            <asp:Button ID="btnLogin" runat="server" Text="Log In" CssClass="btn btn-primary"
                OnClick="btnLogin_Click" ValidationGroup="Login" />
            <p class="hint">No account yet? <a href="~/Register.aspx" runat="server">Register here</a></p>
        </div>
    </div>
</asp:Content>
