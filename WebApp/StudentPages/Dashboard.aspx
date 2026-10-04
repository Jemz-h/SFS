<%@ Page Title="Student Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="StudentFeedbackSystem.StudentPages.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-page-header">
        <div class="header-content">
            <div class="header-badge">Student Feedback</div>
            <h1 class="page-title"><asp:Literal ID="litStudentFullName" runat="server" /></h1>
            <p class="page-subtitle">
                Student ID: <strong><asp:Literal ID="litStudentNumber" runat="server" /></strong> &bull;
                Program: <strong><asp:Literal ID="litProgram" runat="server" /></strong> &bull;
                Year Level: <strong>Year <asp:Literal ID="litYearLevel" runat="server" /></strong> &bull;
                Section: <strong><asp:Literal ID="litSectionName" runat="server" /></strong>
            </p>
        </div>
        <div class="header-meta">
            <span class="date-chip">
                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
                <asp:Literal ID="litCurrentDate" runat="server" />
            </span>
            <span class="status-chip chip-success">
                <span class="pulse-dot"></span> Account Verified
            </span>
        </div>
    </div>

    <!-- Alert for pending evaluations -->
    <asp:Panel ID="pnlPendingNotice" runat="server" CssClass="dashboard-alert-banner" Visible="false">
        <div class="alert-icon-box alert-warning-box">
            <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
        </div>
        <div class="alert-content">
            <div class="alert-heading">Course Evaluations Available</div>
            <div class="alert-text">You have <strong><asp:Literal ID="litPendingAlertCount" runat="server" /></strong> enrolled course(s) awaiting your faculty evaluation. Your feedback is confidential and greatly helps improve instruction quality.</div>
        </div>
        <a href="MyCourses.aspx" class="alert-btn">Evaluate Now &rarr;</a>
    </asp:Panel>

    <!-- Stats Grid -->
    <div class="stats-grid">
        <div class="stat-card stat-blue">
            <div class="stat-top">
                <div class="stat-icon-wrapper">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                </div>
                <span class="stat-badge badge-info">Enrolled</span>
            </div>
            <div class="stat-number"><asp:Literal ID="litTotalCoursesCount" runat="server" Text="0" /></div>
            <div class="stat-label">Total Enrolled Courses</div>
            <div class="stat-subtext">Courses registered for evaluation</div>
        </div>

        <div class="stat-card stat-amber">
            <div class="stat-top">
                <div class="stat-icon-wrapper">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <polyline points="12 6 12 12 16 14"></polyline>
                    </svg>
                </div>
                <span class="stat-badge badge-warning">Awaiting Feedback</span>
            </div>
            <div class="stat-number"><asp:Literal ID="litPendingCount" runat="server" Text="0" /></div>
            <div class="stat-label">Pending Evaluations</div>
            <div class="stat-subtext">Ratings ready for your review</div>
        </div>

        <div class="stat-card stat-emerald">
            <div class="stat-top">
                <div class="stat-icon-wrapper">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                    </svg>
                </div>
                <span class="stat-badge badge-success">Submitted</span>
            </div>
            <div class="stat-number"><asp:Literal ID="litCompletedCount" runat="server" Text="0" /></div>
            <div class="stat-label">Completed Evaluations</div>
            <div class="stat-subtext">Ratings successfully submitted</div>
        </div>
    </div>

    <!-- Quick Navigation Cards -->
    <div class="section-title-wrap">
        <h2 class="section-title">Quick Actions</h2>
        <span class="section-desc">Manage your course evaluations and submission history</span>
    </div>

    <div class="quick-actions-grid">
        <a href="MyCourses.aspx" class="action-card">
            <div class="action-icon icon-blue">
                <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                </svg>
            </div>
            <div class="action-text">
                <div class="action-title">My Courses &amp; Evaluations</div>
                <div class="action-desc">View your enrolled subjects and evaluate professors currently instructing you.</div>
            </div>
            <div class="action-arrow">&rarr;</div>
        </a>

        <a href="MyRatingHistory.aspx" class="action-card">
            <div class="action-icon icon-teal">
                <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="16" y1="13" x2="8" y2="13"></line>
                    <line x1="16" y1="17" x2="8" y2="17"></line>
                    <polyline points="10 9 9 9 8 9"></polyline>
                </svg>
            </div>
            <div class="action-text">
                <div class="action-title">My Rating History</div>
                <div class="action-desc">Review your past evaluation submissions and scores per semester.</div>
            </div>
            <div class="action-arrow">&rarr;</div>
        </a>
    </div>

    <!-- Active Courses Overview -->
    <div class="admin-card" style="margin-top: 1.5rem;">
        <div class="admin-card-header table-toolbar">
            <div class="toolbar-left">
                <div class="card-title-group">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                        <polyline points="2 17 12 22 22 17"></polyline>
                        <polyline points="2 12 12 17 22 12"></polyline>
                    </svg>
                    <h3 class="admin-card-title">Enrolled Courses Awaiting Feedback</h3>
                </div>
            </div>
            <a href="MyCourses.aspx" class="btn btn-ghost btn-sm">View All Courses &rarr;</a>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvPendingCourses" runat="server" AutoGenerateColumns="false" CssClass="modern-table"
                EmptyDataText="You have no pending course evaluations at this time." GridLines="None">
                <Columns>
                    <asp:TemplateField HeaderText="Course">
                        <ItemTemplate>
                            <div class="course-cell">
                                <span class="badge-code badge"><%# Eval("CourseCode") %></span>
                                <span class="course-name"><%# Eval("CourseTitle") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Instructor">
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

                    <asp:TemplateField HeaderText="Section &amp; Term">
                        <ItemTemplate>
                            <div class="term-cell">
                                <span class="badge badge-teal"><%# Eval("SectionName") %></span>
                                <span class="badge badge-neutral"><%# Eval("SchoolYear") %> &bull; <%# Eval("Term") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Action" ItemStyle-CssClass="actions-cell">
                        <ItemTemplate>
                            <a href='<%# "RateCourse.aspx?enrollmentId=" + Eval("EnrollmentId") %>' class="btn btn-primary btn-sm">
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                </svg>
                                <span>Rate Course</span>
                            </a>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="empty-state-box">
                        <div class="empty-state-icon">
                            <svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                        </div>
                        <div class="empty-state-title">All Caught Up!</div>
                        <div class="empty-state-desc">You have completed all pending evaluations, or you have not yet been assigned to a class section.</div>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
