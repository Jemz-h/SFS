<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="StudentFeedbackSystem.AdminPages.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-page-header">
        <div class="header-content">
            <div class="header-badge">Feedback Administration</div>
            <h1 class="page-title">Feedback Overview</h1>
            <p class="page-subtitle">Administrator: <strong><asp:Literal ID="litAdminName" runat="server" /></strong>. Current verification, course, faculty, and offering totals.</p>
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
                <span class="pulse-dot"></span> System Operational
            </span>
        </div>
    </div>

    <asp:Panel ID="pnlPendingAlert" runat="server" CssClass="dashboard-alert-banner" Visible="false">
        <div class="alert-icon-box alert-warning-box">
            <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                <line x1="12" y1="9" x2="12" y2="13"></line>
                <line x1="12" y1="17" x2="12.01" y2="17"></line>
            </svg>
        </div>
        <div class="alert-content">
            <div class="alert-heading">Pending Student Verifications Awaiting Review</div>
            <div class="alert-text">There are currently <strong><asp:Literal ID="litPendingBannerCount" runat="server" /></strong> student registration(s) requiring credential approval and section assignment before they can access ratings.</div>
        </div>
        <a href="VerifyStudents.aspx" class="alert-btn">Review Queue &rarr;</a>
    </asp:Panel>

    <div class="stats-grid">
        <a href="VerifyStudents.aspx" class="stat-card stat-amber">
            <div class="stat-top">
                <div class="stat-icon-wrapper">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <polyline points="12 6 12 12 16 14"></polyline>
                    </svg>
                </div>
                <span class="stat-badge badge-warning">Requires Action</span>
            </div>
            <div class="stat-number"><asp:Literal ID="litPendingCount" runat="server" /></div>
            <div class="stat-label">Pending Verifications</div>
            <div class="stat-subtext">Students waiting for approval</div>
        </a>

        <div class="stat-card stat-emerald">
            <div class="stat-top">
                <div class="stat-icon-wrapper">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="8.5" cy="7" r="4"></circle>
                        <polyline points="17 11 19 13 23 9"></polyline>
                    </svg>
                </div>
                <span class="stat-badge badge-success">Active Cohort</span>
            </div>
            <div class="stat-number"><asp:Literal ID="litVerifiedCount" runat="server" /></div>
            <div class="stat-label">Verified Students</div>
            <div class="stat-subtext">Approved and active accounts</div>
        </div>

        <a href="ManageCourses.aspx" class="stat-card stat-blue">
            <div class="stat-top">
                <div class="stat-icon-wrapper">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                </div>
                <span class="stat-badge badge-info">Curriculum</span>
            </div>
            <div class="stat-number"><asp:Literal ID="litActiveCourses" runat="server" /> <span class="stat-total">/ <asp:Literal ID="litTotalCourses" runat="server" /></span></div>
            <div class="stat-label">Active Courses</div>
            <div class="stat-subtext">Subjects available for evaluation</div>
        </a>

        <a href="ManageProfessors.aspx" class="stat-card stat-purple">
            <div class="stat-top">
                <div class="stat-icon-wrapper">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                </div>
                <span class="stat-badge badge-purple">Faculty</span>
            </div>
            <div class="stat-number"><asp:Literal ID="litActiveProfessors" runat="server" /> <span class="stat-total">/ <asp:Literal ID="litTotalProfessors" runat="server" /></span></div>
            <div class="stat-label">Professors &amp; Faculty</div>
            <div class="stat-subtext">Instructors in active directory</div>
        </a>

        <a href="ManageSections.aspx" class="stat-card stat-teal">
            <div class="stat-top">
                <div class="stat-icon-wrapper">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                        <polyline points="2 17 12 22 22 17"></polyline>
                        <polyline points="2 12 12 17 22 12"></polyline>
                    </svg>
                </div>
                <span class="stat-badge badge-teal">Classes</span>
            </div>
            <div class="stat-number"><asp:Literal ID="litTotalSections" runat="server" /></div>
            <div class="stat-label">Academic Sections</div>
            <div class="stat-subtext">Registered student class blocks</div>
        </a>

        <a href="ManageSections.aspx" class="stat-card stat-cyan">
            <div class="stat-top">
                <div class="stat-icon-wrapper">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                        <line x1="16" y1="2" x2="16" y2="6"></line>
                        <line x1="8" y1="2" x2="8" y2="6"></line>
                        <line x1="3" y1="10" x2="21" y2="10"></line>
                    </svg>
                </div>
                <span class="stat-badge badge-cyan">Scheduled</span>
            </div>
            <div class="stat-number"><asp:Literal ID="litTotalOfferings" runat="server" /></div>
            <div class="stat-label">Course Offerings</div>
            <div class="stat-subtext">Subject assignments per section</div>
        </a>
    </div>

    <div class="section-title-wrap">
        <h2 class="section-title">Quick Administration Actions</h2>
        <span class="section-desc">Jump straight to frequent administrative workflows</span>
    </div>

    <div class="quick-actions-grid">
        <a href="VerifyStudents.aspx" class="action-card">
            <div class="action-icon icon-amber">
                <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="8.5" cy="7" r="4"></circle>
                    <polyline points="17 11 19 13 23 9"></polyline>
                </svg>
            </div>
            <div class="action-text">
                <div class="action-title">Verify Pending Students</div>
                <div class="action-desc">Approve or reject student registrations and assign their designated class section.</div>
            </div>
            <div class="action-arrow">&rarr;</div>
        </a>

        <a href="ManageCourses.aspx" class="action-card">
            <div class="action-icon icon-blue">
                <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                </svg>
            </div>
            <div class="action-text">
                <div class="action-title">Curriculum &amp; Courses</div>
                <div class="action-desc">Create course codes, manage credit units, and toggle active catalog subjects.</div>
            </div>
            <div class="action-arrow">&rarr;</div>
        </a>

        <a href="ManageProfessors.aspx" class="action-card">
            <div class="action-icon icon-purple">
                <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="9" cy="7" r="4"></circle>
                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
            </div>
            <div class="action-text">
                <div class="action-title">Faculty Roster</div>
                <div class="action-desc">Add instructors, update departmental affiliations, and view teaching faculty.</div>
            </div>
            <div class="action-arrow">&rarr;</div>
        </a>

        <a href="ManageSections.aspx" class="action-card">
            <div class="action-icon icon-teal">
                <svg viewBox="0 0 24 24" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                    <polyline points="2 17 12 22 22 17"></polyline>
                    <polyline points="2 12 12 17 22 12"></polyline>
                </svg>
            </div>
            <div class="action-text">
                <div class="action-title">Sections &amp; Offerings</div>
                <div class="action-desc">Structure student cohorts, assign courses and professors to specific sections.</div>
            </div>
            <div class="action-arrow">&rarr;</div>
        </a>
    </div>

    <div class="admin-card workflow-card">
        <div class="admin-card-header">
            <div class="card-title-group">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="16" x2="12" y2="12"></line>
                    <line x1="12" y1="8" x2="12.01" y2="8"></line>
                </svg>
                <h3 class="admin-card-title">Academic Setup Workflow Guide</h3>
            </div>
            <span class="badge-neutral badge">Best Practice</span>
        </div>
        <div class="admin-card-body">
            <div class="workflow-steps">
                <div class="workflow-step">
                    <div class="step-badge">1</div>
                    <div class="step-content">
                        <div class="step-title">Courses &amp; Faculty Setup</div>
                        <p class="step-desc">Register all academic courses and active professors with their departments before scheduling classes.</p>
                    </div>
                </div>
                <div class="workflow-connector"></div>
                <div class="workflow-step">
                    <div class="step-badge">2</div>
                    <div class="step-content">
                        <div class="step-title">Create Sections &amp; Offerings</div>
                        <p class="step-desc">Establish cohort sections (e.g. BSIT-3A) and bind courses with assigned faculty for each term.</p>
                    </div>
                </div>
                <div class="workflow-connector"></div>
                <div class="workflow-step">
                    <div class="step-badge">3</div>
                    <div class="step-content">
                        <div class="step-title">Verify &amp; Assign Students</div>
                        <p class="step-desc">Review pending registrations and assign approved students to their class section to enable feedback evaluation.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
