<%@ Page Title="Verify Students" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="VerifyStudents.aspx.cs" Inherits="StudentFeedbackSystem.AdminPages.VerifyStudents" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-page-header">
        <div class="header-content">
            <div class="header-badge">Enrollment Management</div>
            <h1 class="page-title">Verify Students &amp; Section Placement</h1>
            <p class="page-subtitle">Review incoming registration requests, verify academic credentials, and assign students to their designated class section.</p>
        </div>
    </div>

    <!-- Status counter cards -->
    <div class="status-summary-bar">
        <div class="status-summary-card summary-amber">
            <div class="summary-label">Pending Verification</div>
            <div class="summary-value"><asp:Literal ID="litPendingCount" runat="server" /></div>
        </div>
        <div class="status-summary-card summary-emerald">
            <div class="summary-label">Verified &amp; Active</div>
            <div class="summary-value"><asp:Literal ID="litVerifiedCount" runat="server" /></div>
        </div>
        <div class="status-summary-card summary-rose">
            <div class="summary-label">Rejected Registrations</div>
            <div class="summary-value"><asp:Literal ID="litRejectedCount" runat="server" /></div>
        </div>
        <div class="status-summary-card summary-slate">
            <div class="summary-label">Suspended Accounts</div>
            <div class="summary-value"><asp:Literal ID="litSuspendedCount" runat="server" /></div>
        </div>
    </div>

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

    <div class="admin-card">
        <div class="admin-card-header table-toolbar">
            <div class="toolbar-left">
                <div class="filter-control-wrap">
                    <label for="<%= ddlStatusFilter.ClientID %>" class="filter-label">Filter by Status:</label>
                    <div class="select-wrapper">
                        <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" CssClass="form-control select-clean" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                            <asp:ListItem Text="Pending Approval" Value="Pending" Selected="True" />
                            <asp:ListItem Text="Verified" Value="Verified" />
                            <asp:ListItem Text="Rejected" Value="Rejected" />
                            <asp:ListItem Text="Suspended" Value="Suspended" />
                        </asp:DropDownList>
                    </div>
                </div>
            </div>
            <div class="toolbar-right">
                <span class="results-badge">
                    Showing <asp:Literal ID="litFilteredCount" runat="server" /> records (<asp:Literal ID="litCurrentFilterLabel" runat="server" />)
                </span>
            </div>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvStudents" runat="server" AutoGenerateColumns="false" CssClass="modern-table"
                DataKeyNames="StudentId" OnRowCommand="gvStudents_RowCommand"
                AllowPaging="true" PageSize="20" OnPageIndexChanging="gvStudents_PageIndexChanging"
                GridLines="None">
                <Columns>
                    <asp:TemplateField HeaderText="Student Info">
                        <ItemTemplate>
                            <div class="student-cell">
                                <div class="avatar-initials"><%# GetInitials(Eval("FullName")) %></div>
                                <div class="student-info-col">
                                    <span class="student-name"><%# Eval("FullName") %></span>
                                    <span class="badge-code badge">#<%# Eval("StudentNumber") %></span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Email Address">
                        <ItemTemplate>
                            <div class="contact-cell">
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                    <polyline points="22,6 12,13 2,6"></polyline>
                                </svg>
                                <span><%# Eval("SchoolEmail") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Program &amp; Year">
                        <ItemTemplate>
                            <div class="program-badge-group">
                                <span class="program-name"><%# Eval("Program") %></span>
                                <span class="badge badge-neutral">Year <%# Eval("YearLevel") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Assign Section">
                        <ItemTemplate>
                            <div class="section-select-wrap">
                                <asp:DropDownList ID="ddlSection" runat="server" CssClass="form-control form-control-sm table-select" DataTextField="SectionName" DataValueField="SectionId" />
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="actions-cell">
                        <ItemTemplate>
                            <div class="action-btn-group">
                                <asp:LinkButton ID="btnApprove" runat="server" CssClass="btn-action-approve"
                                    CommandName="Approve" CommandArgument='<%# Eval("StudentId") %>' ToolTip="Approve Student">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                    <span>Approve</span>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnReject" runat="server" CssClass="btn-action-reject"
                                    CommandName="Reject" CommandArgument='<%# Eval("StudentId") %>'
                                    OnClientClick="return confirm('Reject this student registration?');" ToolTip="Reject Student">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                    <span>Reject</span>
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="empty-state-box">
                        <div class="empty-state-icon">
                            <svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                        <div class="empty-state-title">No Students Found</div>
                        <div class="empty-state-desc">There are currently no student accounts matching the selected status filter.</div>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
