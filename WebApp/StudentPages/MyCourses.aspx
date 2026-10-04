<%@ Page Title="My Enrolled Courses" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyCourses.aspx.cs" Inherits="StudentFeedbackSystem.StudentPages.MyCourses" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-page-header">
        <div class="header-content">
            <div class="header-badge">Enrolled Curriculum</div>
            <h1 class="page-title">My Courses &amp; Evaluations</h1>
            <p class="page-subtitle">View all subjects you are enrolled in and submit faculty feedback for your instructors.</p>
        </div>
    </div>

    <!-- Alert / notification panel -->
    <asp:Panel ID="pnlMessage" runat="server" CssClass="modern-alert alert-success" Visible="false">
        <div class="alert-icon">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                <polyline points="22 4 12 14.01 9 11.01"></polyline>
            </svg>
        </div>
        <div class="alert-message">
            <asp:Literal ID="litMessage" runat="server" />
        </div>
    </asp:Panel>

    <!-- Filter & status bar -->
    <div class="admin-card student-course-filter">
        <div class="admin-card-body">
            <div class="student-filter-layout">
                <div class="student-filter-tabs">
                    <asp:LinkButton ID="btnTabAll" runat="server" CssClass="student-filter-tab active" OnClick="btnTabFilter_Click" CommandArgument="all">
                        All Courses (<asp:Literal ID="litCountAll" runat="server" Text="0" />)
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnTabPending" runat="server" CssClass="student-filter-tab" OnClick="btnTabFilter_Click" CommandArgument="pending">
                        Needs Rating (<asp:Literal ID="litCountPending" runat="server" Text="0" />)
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnTabCompleted" runat="server" CssClass="student-filter-tab" OnClick="btnTabFilter_Click" CommandArgument="completed">
                        Evaluated (<asp:Literal ID="litCountCompleted" runat="server" Text="0" />)
                    </asp:LinkButton>
                </div>

                <div>
                    <asp:DropDownList ID="ddlTermFilter" runat="server" CssClass="form-control select-clean student-filter-term" AutoPostBack="true" OnSelectedIndexChanged="ddlTermFilter_SelectedIndexChanged">
                        <asp:ListItem Text="-- All School Years / Terms --" Value="" />
                    </asp:DropDownList>
                </div>
            </div>
        </div>
    </div>

    <!-- Hidden field for active filter -->
    <asp:HiddenField ID="hidFilter" runat="server" Value="all" />

    <!-- Courses Grid -->
    <div class="admin-card">
        <div class="admin-card-header table-toolbar">
            <div class="toolbar-left">
                <div class="card-title-group">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                    <h3 class="admin-card-title">Enrolled Courses List</h3>
                </div>
            </div>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvCourses" runat="server" AutoGenerateColumns="false" CssClass="modern-table"
                EmptyDataText="No enrolled courses match the selected filter." GridLines="None"
                AllowPaging="true" PageSize="10" OnPageIndexChanging="gvCourses_PageIndexChanging">
                <Columns>
                    <asp:TemplateField HeaderText="Course Code &amp; Title">
                        <ItemTemplate>
                            <div class="course-cell">
                                <span class="badge-code badge"><%# Eval("CourseCode") %></span>
                                <span class="course-name"><%# Eval("CourseTitle") %></span>
                                <span class="badge badge-neutral"><%# Eval("Units") %> Units</span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Assigned Faculty">
                        <ItemTemplate>
                            <div class="instructor-cell">
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                                <div>
                                    <span class="student-name"><%# Eval("ProfessorName") %></span>
                                    <div class="inline-detail"><%# Eval("Department") %></div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Class Section &amp; Term">
                        <ItemTemplate>
                            <div class="term-cell">
                                <span class="badge badge-teal"><%# Eval("SectionName") %></span>
                                <span class="badge badge-neutral"><%# Eval("SchoolYear") %> &bull; <%# Eval("Term") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Evaluation Status">
                        <ItemTemplate>
                            <%# (bool)Eval("HasRated")
                                ? "<span class=\"status-chip chip-success\"><span class=\"pulse-dot\"></span> Completed</span>"
                                : "<span class=\"status-chip evaluation-status-pending\"><span class=\"pulse-dot\"></span> Pending Rating</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Action" ItemStyle-CssClass="actions-cell">
                        <ItemTemplate>
                            <%# !(bool)Eval("HasRated")
                                ? "<a href=\"RateCourse.aspx?enrollmentId=" + Eval("EnrollmentId") + "\" class=\"btn btn-primary btn-sm\">" +
                                  "<svg viewBox=\"0 0 24 24\" width=\"14\" height=\"14\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><polygon points=\"12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2\"></polygon></svg>" +
                                  "<span>Rate Now</span></a>"
                                 : "<a href=\"MyRatingHistory.aspx\" class=\"btn btn-ghost btn-sm\">" +
                                  "<svg viewBox=\"0 0 24 24\" width=\"14\" height=\"14\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><circle cx=\"12\" cy=\"12\" r=\"10\"></circle><polyline points=\"12 6 12 12 14 14\"></polyline></svg>" +
                                  "<span>View History</span></a>" %>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="empty-state-box">
                        <div class="empty-state-icon">
                            <svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                            </svg>
                        </div>
                        <div class="empty-state-title">No Courses Found</div>
                        <div class="empty-state-desc">You currently have no course offerings under this filter criteria.</div>
                    </div>
                </EmptyDataTemplate>
                <PagerStyle CssClass="modern-pager" HorizontalAlign="Right" />
            </asp:GridView>
        </div>
    </div>
</asp:Content>
