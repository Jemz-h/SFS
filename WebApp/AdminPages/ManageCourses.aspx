<%@ Page Title="Manage Courses" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageCourses.aspx.cs" Inherits="StudentFeedbackSystem.AdminPages.ManageCourses" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-page-header">
        <div class="header-content">
            <div class="header-badge">Academic Curriculum</div>
            <h1 class="page-title">Manage Courses</h1>
            <p class="page-subtitle">Configure academic courses, credit units, and manage active catalog subjects available for student evaluations.</p>
        </div>
    </div>

    <!-- Course stats bar -->
    <div class="status-summary-bar">
        <div class="status-summary-card summary-blue">
            <div class="summary-label">Total Courses</div>
            <div class="summary-value"><asp:Literal ID="litTotalCoursesCount" runat="server" /></div>
        </div>
        <div class="status-summary-card summary-emerald">
            <div class="summary-label">Active in Catalog</div>
            <div class="summary-value"><asp:Literal ID="litActiveCoursesCount" runat="server" /></div>
        </div>
        <div class="status-summary-card summary-slate">
            <div class="summary-label">Inactive / Archived</div>
            <div class="summary-value"><asp:Literal ID="litInactiveCoursesCount" runat="server" /></div>
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
                    <path d="M12 20h9"></path>
                    <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                </svg>
                <h3 class="admin-card-title"><asp:Literal ID="litEditorTitle" runat="server" Text="Add Course" /></h3>
            </div>
            <span class="badge badge-info">Course Specifications</span>
        </div>
        <div class="admin-card-body">
            <asp:HiddenField ID="hidCourseId" runat="server" />

            <div class="form-row-grid">
                <div class="form-group">
                    <asp:Label AssociatedControlID="txtCourseCode" runat="server" CssClass="form-label">Course Code <span class="req-star">*</span></asp:Label>
                    <asp:TextBox ID="txtCourseCode" runat="server" CssClass="form-control" MaxLength="20" placeholder="e.g. CS101, IT204" />
                    <asp:RequiredFieldValidator ControlToValidate="txtCourseCode" runat="server" ErrorMessage="Course code is required." Display="Dynamic" CssClass="field-error" ValidationGroup="Course" />
                </div>
                <div class="form-group">
                    <asp:Label AssociatedControlID="txtUnits" runat="server" CssClass="form-label">Credit Units <span class="req-star">*</span></asp:Label>
                    <asp:TextBox ID="txtUnits" runat="server" CssClass="form-control" Text="3" MaxLength="2" inputmode="numeric" placeholder="1 - 6" />
                    <asp:RequiredFieldValidator ControlToValidate="txtUnits" runat="server" ErrorMessage="Units are required." Display="Dynamic" CssClass="field-error" ValidationGroup="Course" />
                    <asp:RangeValidator ControlToValidate="txtUnits" runat="server" Type="Integer" MinimumValue="1" MaximumValue="6" ErrorMessage="Units must be between 1 and 6." Display="Dynamic" CssClass="field-error" ValidationGroup="Course" />
                </div>
            </div>

            <div class="form-group">
                <asp:Label AssociatedControlID="txtCourseTitle" runat="server" CssClass="form-label">Course Title <span class="req-star">*</span></asp:Label>
                <asp:TextBox ID="txtCourseTitle" runat="server" CssClass="form-control" MaxLength="200" placeholder="e.g. Introduction to Programming and Logic Formulation" />
                <asp:RequiredFieldValidator ControlToValidate="txtCourseTitle" runat="server" ErrorMessage="Course title is required." Display="Dynamic" CssClass="field-error" ValidationGroup="Course" />
            </div>

            <div class="form-actions-bar">
                <asp:Button ID="btnSave" runat="server" Text="Save Course" CssClass="btn btn-primary" OnClick="btnSave_Click" ValidationGroup="Course" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel Edit" CssClass="btn btn-ghost" OnClick="btnCancel_Click" CausesValidation="false" Visible="false" />
            </div>
        </div>
    </asp:Panel>

    <div class="admin-card">
        <div class="admin-card-header table-toolbar">
            <div class="toolbar-left">
                <div class="card-title-group">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                    </svg>
                    <h3 class="admin-card-title">Academic Courses Directory</h3>
                </div>
            </div>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvCourses" runat="server" AutoGenerateColumns="false" CssClass="modern-table"
                EmptyDataText="No courses found." DataKeyNames="CourseId" OnRowCommand="gvCourses_RowCommand"
                GridLines="None">
                <Columns>
                    <asp:TemplateField HeaderText="Course Code">
                        <ItemTemplate>
                            <span class="badge-code badge"><%# Eval("CourseCode") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Course Title">
                        <ItemTemplate>
                            <span class="course-name"><%# Eval("CourseTitle") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Credit Units">
                        <ItemTemplate>
                            <span class="badge badge-neutral"><%# Eval("Units") %> Units</span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Catalog Status">
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
                                    CommandName="EditCourse" CommandArgument='<%# Eval("CourseId") %>' ToolTip="Edit Course">
                                    <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                                    <span>Edit</span>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnToggle" runat="server"
                                    CssClass='<%# (bool)Eval("IsActive") ? "btn-action-deactivate" : "btn-action-activate" %>'
                                    CommandName="ToggleCourse" CommandArgument='<%# Eval("CourseId") %>'
                                    ToolTip='<%# (bool)Eval("IsActive") ? "Deactivate course" : "Activate course" %>'>
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
                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                            </svg>
                        </div>
                        <div class="empty-state-title">No Courses Registered</div>
                        <div class="empty-state-desc">Use the form above to register courses into the curriculum.</div>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
