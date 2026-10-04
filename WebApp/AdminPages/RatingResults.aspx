<%@ Page Title="Faculty Rating Results" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RatingResults.aspx.cs" Inherits="StudentFeedbackSystem.AdminPages.RatingResults" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Load Chart.js for analytics visualizations -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>

    <div class="admin-page-header">
        <div class="header-content">
            <div class="header-badge">Evaluation Analytics</div>
            <h1 class="page-title">Faculty Performance &amp; Rating Results</h1>
            <p class="page-subtitle">Aggregated student feedback results classifying instructors into Very Satisfactory, Satisfactory, and Below Satisfactory buckets.</p>
        </div>
        <div class="header-meta">
            <asp:Button ID="btnExportCsv" runat="server" Text="Export Results to CSV" CssClass="btn btn-secondary btn-sm" OnClick="btnExportCsv_Click" CausesValidation="false" style="display: inline-flex; align-items: center; gap: 0.4rem;" />
        </div>
    </div>

    <!-- Alert / Notification -->
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

    <!-- Top KPI Cards -->
    <div class="stats-grid">
        <div class="stat-card stat-blue">
            <div class="stat-top">
                <div class="stat-icon-wrapper">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                    </svg>
                </div>
                <span class="stat-badge badge-info">Benchmark</span>
            </div>
            <div class="stat-number"><asp:Literal ID="litInstAverage" runat="server" Text="0.00" /> <span class="stat-total">/ 5.00</span></div>
            <div class="stat-label">Institutional Average</div>
            <div class="stat-subtext">Across <asp:Literal ID="litTotalSubmissions" runat="server" Text="0" /> evaluations</div>
        </div>

        <div class="stat-card stat-emerald">
            <div class="stat-top">
                <div class="stat-icon-wrapper">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                    </svg>
                </div>
                <span class="stat-badge badge-success">&ge; 4.20 Score</span>
            </div>
            <div class="stat-number"><asp:Literal ID="litCountVerySatisfactory" runat="server" Text="0" /></div>
            <div class="stat-label">Very Satisfactory</div>
            <div class="stat-subtext">Highest tier rating</div>
        </div>

        <div class="stat-card stat-amber">
            <div class="stat-top">
                <div class="stat-icon-wrapper">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                </div>
                <span class="stat-badge badge-warning">3.40 - 4.19 Score</span>
            </div>
            <div class="stat-number"><asp:Literal ID="litCountSatisfactory" runat="server" Text="0" /></div>
            <div class="stat-label">Satisfactory</div>
            <div class="stat-subtext">Standard competent rating</div>
        </div>

        <div class="stat-card stat-purple">
            <div class="stat-top">
                <div class="stat-icon-wrapper">
                    <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>
                        <line x1="12" y1="9" x2="12" y2="13"></line>
                        <line x1="12" y1="17" x2="12.01" y2="17"></line>
                    </svg>
                </div>
                <span class="stat-badge badge-danger">&lt; 3.40 Score</span>
            </div>
            <div class="stat-number"><asp:Literal ID="litCountBelowSatisfactory" runat="server" Text="0" /></div>
            <div class="stat-label">Below Satisfactory</div>
            <div class="stat-subtext">Requires teaching development</div>
        </div>
    </div>

    <!-- Visual Analytics Charts Row -->
    <div class="analytics-chart-grid">
        <div class="admin-card">
            <div class="admin-card-header">
                <div class="card-title-group">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <path d="M12 2a10 10 0 0 1 10 10H12V2z"></path>
                    </svg>
                    <h3 class="admin-card-title">Satisfaction Classification Breakdown</h3>
                </div>
            </div>
            <div class="admin-card-body analytics-chart-body">
                <canvas id="classificationChart"></canvas>
            </div>
        </div>

        <div class="admin-card">
            <div class="admin-card-header">
                <div class="card-title-group">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="20" x2="18" y2="10"></line>
                        <line x1="12" y1="20" x2="12" y2="4"></line>
                        <line x1="6" y1="20" x2="6" y2="14"></line>
                    </svg>
                    <h3 class="admin-card-title">Top Faculty Average Scores</h3>
                </div>
            </div>
            <div class="admin-card-body analytics-chart-body">
                <canvas id="facultyScoreChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Filter Control Bar -->
    <div class="admin-card" style="margin-bottom: 1.5rem;">
        <div class="admin-card-body" style="padding: 1rem 1.25rem;">
            <div class="form-row-grid" style="grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 1rem; align-items: flex-end;">
                <div class="form-group" style="margin-bottom: 0;">
                    <asp:Label AssociatedControlID="txtFilterSchoolYear" runat="server" CssClass="form-label" style="font-size: 0.8rem;">School Year</asp:Label>
                    <asp:TextBox ID="txtFilterSchoolYear" runat="server" CssClass="form-control" placeholder="e.g. 2025-2026" />
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <asp:Label AssociatedControlID="ddlFilterTerm" runat="server" CssClass="form-label" style="font-size: 0.8rem;">Term / Semester</asp:Label>
                    <asp:DropDownList ID="ddlFilterTerm" runat="server" CssClass="form-control select-clean">
                        <asp:ListItem Text="-- All Terms --" Value="" />
                        <asp:ListItem Text="1st Semester" Value="1st Semester" />
                        <asp:ListItem Text="2nd Semester" Value="2nd Semester" />
                        <asp:ListItem Text="Summer" Value="Summer" />
                    </asp:DropDownList>
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <asp:Label AssociatedControlID="ddlFilterDepartment" runat="server" CssClass="form-label" style="font-size: 0.8rem;">Department</asp:Label>
                    <asp:DropDownList ID="ddlFilterDepartment" runat="server" CssClass="form-control select-clean">
                        <asp:ListItem Text="-- All Departments --" Value="" />
                    </asp:DropDownList>
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <asp:Label AssociatedControlID="txtSearchQuery" runat="server" CssClass="form-label" style="font-size: 0.8rem;">Search Faculty / Course</asp:Label>
                    <asp:TextBox ID="txtSearchQuery" runat="server" CssClass="form-control" placeholder="Search name or course..." />
                </div>

                <div style="display: flex; gap: 0.5rem;">
                    <asp:Button ID="btnFilter" runat="server" Text="Apply Filter" CssClass="btn btn-primary" OnClick="btnFilter_Click" CausesValidation="false" style="padding: 0.5rem 1rem;" />
                    <asp:Button ID="btnResetFilter" runat="server" Text="Reset" CssClass="btn btn-ghost" OnClick="btnResetFilter_Click" CausesValidation="false" style="padding: 0.5rem 1rem;" />
                </div>
            </div>
        </div>
    </div>

    <!-- Rating Results Table -->
    <div class="admin-card">
        <div class="admin-card-header table-toolbar">
            <div class="toolbar-left">
                <div class="card-title-group">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <h3 class="admin-card-title">Faculty Performance Roster</h3>
                </div>
            </div>
            <span class="badge badge-neutral">Showing <asp:Literal ID="litResultCount" runat="server" Text="0" /> Professors</span>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvRatingResults" runat="server" AutoGenerateColumns="false" CssClass="modern-table"
                EmptyDataText="No faculty rating records found matching current criteria." GridLines="None"
                AllowPaging="true" PageSize="10" OnPageIndexChanging="gvRatingResults_PageIndexChanging"
                OnRowCommand="gvRatingResults_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="Faculty Member">
                        <ItemTemplate>
                            <div class="instructor-cell">
                                <div class="avatar-circle">
                                    <%# GetInitials(Eval("FullName")) %>
                                </div>
                                <div>
                                <span class="student-name"><%# Eval("FullName") %></span>
                                    <div class="text-secondary-small"><%# Eval("Department") %></div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Courses Taught">
                        <ItemTemplate>
                            <span class="badge badge-neutral" style="font-size: 0.8rem;"><%# Eval("CoursesTaught") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Student Reviews">
                        <ItemTemplate>
                            <span class="badge badge-teal" style="font-weight: 600;"><%# Eval("ResponseCount") %> Reviews</span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Average Rating">
                        <ItemTemplate>
                <div class="score-cell">
                    <span class="faculty-score"><%# Eval("AverageScore", "{0:0.00}") %></span>
                    <span class="inline-detail">/ 5.00</span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Classification">
                        <ItemTemplate>
                            <%# GetClassificationBadge(Eval("Classification")) %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="actions-cell">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDrillDown" runat="server" CssClass="btn btn-secondary btn-sm"
                                CommandName="ViewDrillDown" CommandArgument='<%# Eval("ProfessorId") %>'
                                CausesValidation="false" style="display: inline-flex; align-items: center; gap: 0.35rem; padding: 0.35rem 0.75rem; font-size: 0.825rem;">
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <span>Drill-Down</span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="empty-state-box">
                        <div class="empty-state-icon">
                            <svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                        </div>
                        <div class="empty-state-title">No Evaluation Records Found</div>
                        <div class="empty-state-desc">Try clearing the search query or adjusting your semester/department filters.</div>
                    </div>
                </EmptyDataTemplate>
                <PagerStyle CssClass="modern-pager" HorizontalAlign="Right" />
            </asp:GridView>
        </div>
    </div>

    <!-- Drill-Down Detail Modal / Panel -->
    <asp:Panel ID="pnlDrillDown" runat="server" Visible="false" CssClass="admin-card editor-card drilldown-panel">
        <div class="admin-card-header">
            <div class="card-title-group">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <polyline points="12 6 12 12 14 14"></polyline>
                </svg>
                <h3 class="admin-card-title">Drill-Down Analysis: <asp:Literal ID="litDrillProfessorName" runat="server" /></h3>
            </div>
            <asp:Button ID="btnCloseDrillDown" runat="server" Text="&times; Close Drill-Down" CssClass="btn btn-ghost btn-sm" OnClick="btnCloseDrillDown_Click" CausesValidation="false" />
        </div>
        <div class="admin-card-body">
            <!-- Faculty Summary Bar -->
            <div class="drilldown-summary">
                <div>
                    <div class="drilldown-meta">Department: <strong><asp:Literal ID="litDrillDepartment" runat="server" /></strong></div>
                    <div class="drilldown-meta">Courses Evaluated: <strong><asp:Literal ID="litDrillCourses" runat="server" /></strong></div>
                </div>
                <div class="drilldown-score-group">
                    <div>
                        <div class="drilldown-score-label">Overall Rating</div>
                        <div class="drilldown-score">
                            <asp:Literal ID="litDrillAverage" runat="server" /> <span>/ 5.00</span>
                        </div>
                    </div>
                    <div>
                        <asp:Literal ID="litDrillClassificationBadge" runat="server" />
                    </div>
                </div>
            </div>

            <!-- Criteria Breakdown Table -->
            <h4 class="drilldown-section-title">Criterion Performance Breakdown</h4>
            <div class="table-responsive">
                <asp:GridView ID="gvDrillCriteria" runat="server" AutoGenerateColumns="false" CssClass="modern-table" GridLines="None">
                    <Columns>
                        <asp:TemplateField HeaderText="Evaluation Criterion">
                            <ItemTemplate>
                                <span class="student-name"><%# Eval("CriterionName") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Weight">
                            <ItemTemplate>
                                <span class="badge badge-neutral"><%# Eval("Weight", "{0:0.##}") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Average Score">
                            <ItemTemplate>
                                <div class="score-cell">
                                    <span class="score-value"><%# Eval("AverageScore", "{0:0.00}") %></span>
                                    <div class="score-track">
                                        <div class="score-fill" style='<%# "width: " + ((decimal)Eval("AverageScore") / 5.0m * 100).ToString("0") + "%;" %>'></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Evaluation Count">
                            <ItemTemplate>
                                <span class="badge badge-teal"><%# Eval("ResponseCount") %> Responses</span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="comments-empty">No criterion breakdown available.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <!-- Qualitative Comments Section -->
            <h4 class="drilldown-section-title">
                Anonymized Student Feedback &amp; Comments (<asp:Literal ID="litDrillCommentsCount" runat="server" Text="0" />)
            </h4>
            <asp:Repeater ID="rptComments" runat="server">
                <HeaderTemplate>
                    <div class="comments-list">
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="comment-item">
                        &ldquo;<%# Server.HtmlEncode((string)Container.DataItem) %>&rdquo;
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoComments" runat="server" Visible="false" CssClass="comments-empty">
                No written comments submitted for this faculty member.
            </asp:Panel>
        </div>
    </asp:Panel>

    <!-- Hidden Fields for Chart Data passing -->
    <asp:HiddenField ID="hidChartClassificationData" runat="server" />
    <asp:HiddenField ID="hidChartFacultyScores" runat="server" />

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Chart.js is loaded from a CDN and is not part of this page's TypeScript declarations.
            /** @type {any} */
            var chartWindow = window;
            // @ts-ignore Chart is defined by the Chart.js script included above.
            var ChartConstructor = chartWindow.Chart;

            // Render Classification Doughnut Chart
            var classDataField = document.getElementById('<%= hidChartClassificationData.ClientID %>');
            var classCtx = document.getElementById('classificationChart');
            if (classDataField instanceof HTMLInputElement && classCtx instanceof HTMLCanvasElement && typeof ChartConstructor === 'function') {
                try {
                    var data = JSON.parse(classDataField.value || '[0, 0, 0]');
                    new ChartConstructor(classCtx, {
                        type: 'doughnut',
                        data: {
                            labels: ['Very Satisfactory', 'Satisfactory', 'Below Satisfactory'],
                            datasets: [{
                                data: data,
                                 backgroundColor: ['#3B6FA8', '#A9C2DE', '#8A94A3'],
                                borderWidth: 2,
                                 borderColor: '#FFFFFF'
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    position: 'bottom',
                                    labels: { boxWidth: 12, padding: 14 }
                                }
                            },
                            cutout: '65%'
                        }
                    });
                } catch (e) {
                    console.error('Error rendering classification chart', e);
                }
            }

            // Render Faculty Scores Bar Chart
            var scoreDataField = document.getElementById('<%= hidChartFacultyScores.ClientID %>');
            var scoreCtx = document.getElementById('facultyScoreChart');
            if (scoreDataField instanceof HTMLInputElement && scoreCtx instanceof HTMLCanvasElement && typeof ChartConstructor === 'function') {
                try {
                    var scoreData = JSON.parse(scoreDataField.value || '{"labels":[], "scores":[]}');
                    new ChartConstructor(scoreCtx, {
                        type: 'bar',
                        data: {
                            labels: scoreData.labels,
                            datasets: [{
                                label: 'Average Score',
                                data: scoreData.scores,
                                 backgroundColor: '#3B6FA8',
                                borderRadius: 4
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            scales: {
                                y: {
                                    min: 0,
                                    max: 5,
                                    ticks: { stepSize: 1 }
                                },
                                x: {
                                    ticks: {
                                        maxRotation: 45,
                                        minRotation: 0,
                                        autoSkip: true
                                    }
                                }
                            },
                            plugins: {
                                legend: { display: false }
                            }
                        }
                    });
                } catch (e) {
                    console.error('Error rendering faculty score chart', e);
                }
            }
        });
    </script>
</asp:Content>
