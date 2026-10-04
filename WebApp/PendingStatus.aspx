<%@ Page Title="Account Status" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PendingStatus.aspx.cs" Inherits="StudentFeedbackSystem.PendingStatus" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-card">
        <h1><asp:Literal ID="litTitle" runat="server">Account Pending</asp:Literal></h1>
        <p><asp:Literal ID="litBody" runat="server" /></p>
        <p class="hint"><a href="~/Login.aspx" runat="server">Back to Log In</a></p>
    </div>
</asp:Content>
