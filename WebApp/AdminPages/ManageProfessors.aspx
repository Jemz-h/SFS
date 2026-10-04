<%@ Page Title="Manage Professors" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageProfessors.aspx.cs" Inherits="StudentFeedbackSystem.AdminPages.ManageProfessors" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-page-header">
        <div class="header-content">
            <div class="header-badge">Faculty Directory</div>
            <h1 class="page-title">Manage Professors &amp; Faculty</h1>
            <p class="page-subtitle">Manage instructor profiles, departmental affiliations, and active status for course evaluations.</p>
        </div>
    </div>

    <!-- Stats bar -->
    <div class="status-summary-bar">
        <div class="status-summary-card summary-purple">
            <div class="summary-label">Total Faculty</div>
            <div class="summary-value"><asp:Literal ID="litTotalProfessorsCount" runat="server" /></div>
        </div>
        <div class="status-summary-card summary-emerald">
            <div class="summary-label">Active Instructors</div>
            <div class="summary-value"><asp:Literal ID="litActiveProfessorsCount" runat="server" /></div>
        </div>
        <div class="status-summary-card summary-slate">
            <div class="summary-label">Departments Represented</div>
            <div class="summary-value"><asp:Literal ID="litDepartmentCount" runat="server" /></div>
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

    <asp:Panel ID="pnlEditor" runat="server" CssClass="admin-card editor-card">
        <div class="admin-card-header">
            <div class="card-title-group">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="8.5" cy="7" r="4"></circle>
                    <line x1="20" y1="8" x2="20" y2="14"></line>
                    <line x1="23" y1="11" x2="17" y2="11"></line>
                </svg>
                <h3 class="admin-card-title"><asp:Literal ID="litEditorTitle" runat="server" Text="Add Professor" /></h3>
            </div>
            <span class="badge badge-purple">Instructor Details</span>
        </div>
        <div class="admin-card-body">
            <asp:HiddenField ID="hidProfessorId" runat="server" />

            <div class="form-row-grid">
                <div class="form-group">
                    <asp:Label AssociatedControlID="txtFirstName" runat="server" CssClass="form-label">First Name <span class="req-star">*</span></asp:Label>
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" MaxLength="100" placeholder="e.g. Maria, John" />
                    <asp:RequiredFieldValidator ControlToValidate="txtFirstName" runat="server" ErrorMessage="First name is required." Display="Dynamic" CssClass="field-error" ValidationGroup="Professor" />
                </div>
                <div class="form-group">
                    <asp:Label AssociatedControlID="txtLastName" runat="server" CssClass="form-label">Last Name <span class="req-star">*</span></asp:Label>
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" MaxLength="100" placeholder="e.g. Santos, Dela Cruz" />
                    <asp:RequiredFieldValidator ControlToValidate="txtLastName" runat="server" ErrorMessage="Last name is required." Display="Dynamic" CssClass="field-error" ValidationGroup="Professor" />
                </div>
            </div>

            <div class="form-group">
                <asp:Label AssociatedControlID="ddlDepartment" runat="server" CssClass="form-label">Department / College</asp:Label>
                <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-control select-clean">
                    <asp:ListItem Text="-- Select Department / College --" Value="" />
                    <asp:ListItem Text="College of Computer Studies" Value="College of Computer Studies" />
                    <asp:ListItem Text="College of Engineering" Value="College of Engineering" />
                    <asp:ListItem Text="College of Business Administration" Value="College of Business Administration" />
                    <asp:ListItem Text="College of Education" Value="College of Education" />
                    <asp:ListItem Text="Department of Information Technology" Value="Department of Information Technology" />
                    <asp:ListItem Text="Department of Computer Science" Value="Department of Computer Science" />
                    <asp:ListItem Text="General Education Department" Value="General Education Department" />
                </asp:DropDownList>
            </div>

            <div class="form-actions-bar">
                <asp:Button ID="btnSave" runat="server" Text="Save Professor" CssClass="btn btn-primary" OnClick="btnSave_Click" ValidationGroup="Professor" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel Edit" CssClass="btn btn-ghost" OnClick="btnCancel_Click" CausesValidation="false" Visible="false" />
            </div>
        </div>
    </asp:Panel>

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
                    <h3 class="admin-card-title">Teaching Faculty Directory</h3>
                </div>
            </div>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvProfessors" runat="server" AutoGenerateColumns="false" CssClass="modern-table"
                EmptyDataText="No professors found." DataKeyNames="ProfessorId" OnRowCommand="gvProfessors_RowCommand"
                GridLines="None">
                <Columns>
                    <asp:TemplateField HeaderText="Faculty Member">
                        <ItemTemplate>
                            <div class="student-cell">
                                <div class="avatar-initials avatar-purple"><%# GetInitials(Eval("FullName")) %></div>
                                <div class="student-info-col">
                                    <span class="student-name"><%# Eval("FullName") %></span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Department / College">
                        <ItemTemplate>
                            <div class="dept-cell">
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M3 21h18"></path>
                                    <path d="M5 21V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v16"></path>
                                </svg>
                                <span><%# string.IsNullOrWhiteSpace((string)Eval("Department")) ? "General Faculty" : Eval("Department") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='badge <%# (bool)Eval("IsActive") ? "badge-success" : "badge-neutral" %>'>
                                <%# (bool)Eval("IsActive") ? "Active" : "Inactive" %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="actions-cell">
                        <ItemTemplate>
                            <div class="action-btn-group">
                                <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn-action-edit"
                                    CommandName="EditProfessor" CommandArgument='<%# Eval("ProfessorId") %>' ToolTip="Edit Professor">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                                    <span>Edit</span>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnToggle" runat="server"
                                    CssClass='<%# (bool)Eval("IsActive") ? "btn-action-deactivate" : "btn-action-activate" %>'
                                    CommandName="ToggleProfessor" CommandArgument='<%# Eval("ProfessorId") %>'
                                    ToolTip='<%# (bool)Eval("IsActive") ? "Deactivate instructor" : "Activate instructor" %>'>
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18.36 6.64a9 9 0 1 1-12.73 0"></path><line x1="12" y1="2" x2="12" y2="12"></line></svg>
                                    <span><%# (bool)Eval("IsActive") ? "Deactivate" : "Activate" %></span>
                                </asp:LinkButton>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="empty-state-box">
                        <div class="empty-state-icon">
                            <svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                            </svg>
                        </div>
                        <div class="empty-state-title">No Faculty Members Registered</div>
                        <div class="empty-state-desc">Use the form above to add professors and instructors.</div>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
