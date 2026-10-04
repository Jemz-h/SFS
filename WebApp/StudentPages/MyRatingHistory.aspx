<%@ Page Title="My Evaluation History" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyRatingHistory.aspx.cs" Inherits="StudentFeedbackSystem.StudentPages.MyRatingHistory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-page-header">
        <div class="header-content">
            <div class="header-badge">Student Records</div>
            <h1 class="page-title">My Evaluation History</h1>
            <p class="page-subtitle">A confidential, read-only record of course evaluations and feedback you have submitted.</p>
        </div>
        <div class="header-meta">
            <a href="MyCourses.aspx" class="btn btn-ghost btn-sm">&larr; Back to My Courses</a>
        </div>
    </div>

    <div class="admin-card">
        <div class="admin-card-header table-toolbar">
            <div class="toolbar-left">
                <div class="card-title-group">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <polyline points="14 2 14 8 20 8"></polyline>
                        <line x1="16" y1="13" x2="8" y2="13"></line>
                        <line x1="16" y1="17" x2="8" y2="17"></line>
                    </svg>
                    <h3 class="admin-card-title">Completed Evaluations (<asp:Literal ID="litHistoryCount" runat="server" Text="0" />)</h3>
                </div>
            </div>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="false" CssClass="modern-table"
                EmptyDataText="You have not submitted any evaluations yet." GridLines="None">
                <Columns>
                    <asp:TemplateField HeaderText="Course">
                        <ItemTemplate>
                            <div class="course-cell">
                                <span class="badge-code badge"><%# Eval("CourseCode") %></span>
                                <span class="course-name"><%# Eval("CourseTitle") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Evaluated Faculty">
                        <ItemTemplate>
                            <div class="instructor-cell">
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                                <span><%# Eval("ProfessorName") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Term">
                        <ItemTemplate>
                            <span class="badge badge-neutral"><%# Eval("SchoolYear") %> &bull; <%# Eval("Term") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Date Submitted">
                        <ItemTemplate>
                            <span class="inline-detail">
                                <%# Eval("SubmittedAt", "{0:MMM d, yyyy h:mm tt}") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Average Score">
                        <ItemTemplate>
                            <div style="display: flex; align-items: center; gap: 0.5rem;">
                                <span class="badge badge-teal">
                                    <%# Eval("AverageScore", "{0:0.00}") %> / 5.00
                                </span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Comments">
                        <ItemTemplate>
                            <div class="comment-preview" title='<%# System.Web.HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("Comments"))) %>'>
                                <%# string.IsNullOrWhiteSpace((string)Eval("Comments")) ? "<em>None provided</em>" : System.Web.HttpUtility.HtmlEncode((string)Eval("Comments")) %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="empty-state-box">
                        <div class="empty-state-icon">
                            <svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 14 14"></polyline>
                            </svg>
                        </div>
                        <div class="empty-state-title">No Evaluation History</div>
                        <div class="empty-state-desc">You have not submitted any faculty evaluations yet. Visit your courses to get started.</div>
                        <a href="MyCourses.aspx" class="btn btn-primary btn-sm" style="margin-top: 1rem;">Go to My Courses</a>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
