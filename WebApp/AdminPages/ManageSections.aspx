<%@ Page Title="Manage Sections" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageSections.aspx.cs" Inherits="StudentFeedbackSystem.AdminPages.ManageSections" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-page-header">
        <div class="header-content">
            <div class="header-badge">Academic Structure</div>
            <h1 class="page-title">Class Sections &amp; Offerings</h1>
            <p class="page-subtitle">Configure student class cohorts, schedule course offerings with assigned instructors, and place students into sections.</p>
        </div>
    </div>

    <!-- Stats Bar -->
    <div class="status-summary-bar">
        <div class="status-summary-card summary-teal">
            <div class="summary-label">Active Sections</div>
            <div class="summary-value"><asp:Literal ID="litTotalSectionsCount" runat="server" /></div>
        </div>
        <div class="status-summary-card summary-blue">
            <div class="summary-label">Scheduled Offerings</div>
            <div class="summary-value"><asp:Literal ID="litTotalOfferingsCount" runat="server" /></div>
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

    <!-- Hidden field to preserve active tab across postbacks -->
    <asp:HiddenField ID="hidActiveTab" runat="server" Value="sections" />

    <!-- Modern Segmented Tabs -->
    <div class="tabs-container">
        <div class="admin-tab-nav" role="tablist">
            <button type="button" class="tab-btn active" data-target="tab-sections" role="tab">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                    <polyline points="2 17 12 22 22 17"></polyline>
                    <polyline points="2 12 12 17 22 12"></polyline>
                </svg>
                <span>Class Sections</span>
            </button>
            <button type="button" class="tab-btn" data-target="tab-offerings" role="tab">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
                <span>Course Offerings</span>
            </button>
            <button type="button" class="tab-btn" data-target="tab-students" role="tab">
                <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                    <circle cx="8.5" cy="7" r="4"></circle>
                    <line x1="20" y1="8" x2="20" y2="14"></line>
                    <line x1="23" y1="11" x2="17" y2="11"></line>
                </svg>
                <span>Student Placement</span>
            </button>
        </div>

        <!-- TAB 1: SECTIONS -->
        <div id="tab-sections" class="tab-pane active">
            <asp:Panel ID="pnlSectionEditor" runat="server" CssClass="admin-card editor-card">
                <div class="admin-card-header">
                    <div class="card-title-group">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                            <polyline points="2 17 12 22 22 17"></polyline>
                            <polyline points="2 12 12 17 22 12"></polyline>
                        </svg>
                        <h3 class="admin-card-title"><asp:Literal ID="litSectionEditorTitle" runat="server" Text="Add Section" /></h3>
                    </div>
                    <span class="badge badge-teal">Section Cohort</span>
                </div>
                <div class="admin-card-body">
                    <asp:HiddenField ID="hidSectionId" runat="server" />

                    <div class="form-row-grid">
                        <div class="form-group">
                            <asp:Label AssociatedControlID="txtSectionName" runat="server" CssClass="form-label">Section Name <span class="req-star">*</span></asp:Label>
                            <asp:TextBox ID="txtSectionName" runat="server" CssClass="form-control" MaxLength="50" placeholder="e.g. BSIT-3A, BSCS-1B" />
                            <asp:RequiredFieldValidator ControlToValidate="txtSectionName" runat="server" ErrorMessage="Section name is required." Display="Dynamic" CssClass="field-error" ValidationGroup="Section" />
                        </div>
                        <div class="form-group">
                            <asp:Label AssociatedControlID="ddlSectionYearLevel" runat="server" CssClass="form-label">Year Level <span class="req-star">*</span></asp:Label>
                            <asp:DropDownList ID="ddlSectionYearLevel" runat="server" CssClass="form-control select-clean">
                                <asp:ListItem Text="1st Year" Value="1" />
                                <asp:ListItem Text="2nd Year" Value="2" />
                                <asp:ListItem Text="3rd Year" Value="3" />
                                <asp:ListItem Text="4th Year" Value="4" />
                                <asp:ListItem Text="5th Year" Value="5" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="form-group">
                        <asp:Label AssociatedControlID="ddlSectionProgram" runat="server" CssClass="form-label">Degree Program <span class="req-star">*</span></asp:Label>
                        <asp:DropDownList ID="ddlSectionProgram" runat="server" CssClass="form-control select-clean">
                            <asp:ListItem Text="-- Select Academic Program --" Value="" />
                            <asp:ListItem Text="Bachelor of Science in Information Technology" Value="Bachelor of Science in Information Technology" />
                            <asp:ListItem Text="Bachelor of Science in Computer Science" Value="Bachelor of Science in Computer Science" />
                            <asp:ListItem Text="Bachelor of Science in Information System" Value="Bachelor of Science in Information System" />
                            <asp:ListItem Text="Bachelor of Science in Entrepreneurship" Value="Bachelor of Science in Entrepreneurship" />
                            <asp:ListItem Text="Bachelor of Science in Business Administration" Value="Bachelor of Science in Business Administration" />
                            <asp:ListItem Text="Bachelor of Science in Accountancy" Value="Bachelor of Science in Accountancy" />
                            <asp:ListItem Text="Bachelor of Science in Industrial Engineering" Value="Bachelor of Science in Industrial Engineering" />
                            <asp:ListItem Text="Bachelor of Science in Electrical Computer Engineering" Value="Bachelor of Science in Electrical Computer Engineering" />
                            <asp:ListItem Text="Bachelor of Science in Computer Engineering" Value="Bachelor of Science in Computer Engineering" />
                            <asp:ListItem Text="Bachelor of Science in Early Childhood Education" Value="Bachelor of Science in Early Childhood Education" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ControlToValidate="ddlSectionProgram" InitialValue="" runat="server" ErrorMessage="Degree program is required." Display="Dynamic" CssClass="field-error" ValidationGroup="Section" />
                    </div>

                    <div class="form-row-grid">
                        <div class="form-group">
                            <asp:Label AssociatedControlID="txtSchoolYear" runat="server" CssClass="form-label">Academic Year <span class="req-star">*</span></asp:Label>
                            <asp:TextBox ID="txtSchoolYear" runat="server" CssClass="form-control" MaxLength="9" placeholder="e.g. 2026-2027" />
                            <asp:RequiredFieldValidator ControlToValidate="txtSchoolYear" runat="server" ErrorMessage="Academic school year is required." Display="Dynamic" CssClass="field-error" ValidationGroup="Section" />
                        </div>
                        <div class="form-group">
                            <asp:Label AssociatedControlID="ddlTerm" runat="server" CssClass="form-label">Semester / Term <span class="req-star">*</span></asp:Label>
                            <asp:DropDownList ID="ddlTerm" runat="server" CssClass="form-control select-clean">
                                <asp:ListItem Text="1st Semester" Value="1st Semester" />
                                <asp:ListItem Text="2nd Semester" Value="2nd Semester" />
                                <asp:ListItem Text="Summer" Value="Summer" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="form-actions-bar">
                        <asp:Button ID="btnSaveSection" runat="server" Text="Save Section" CssClass="btn btn-primary" OnClick="btnSaveSection_Click" ValidationGroup="Section" />
                        <asp:Button ID="btnCancelSection" runat="server" Text="Cancel Edit" CssClass="btn btn-ghost" OnClick="btnCancelSection_Click" CausesValidation="false" Visible="false" />
                    </div>
                </div>
            </asp:Panel>

            <div class="admin-card">
                <div class="admin-card-header table-toolbar">
                    <div class="toolbar-left">
                        <div class="card-title-group">
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                                <polyline points="2 17 12 22 22 17"></polyline>
                                <polyline points="2 12 12 17 22 12"></polyline>
                            </svg>
                            <h3 class="admin-card-title">Registered Class Sections</h3>
                        </div>
                    </div>
                </div>

                <div class="table-responsive">
                    <asp:GridView ID="gvSections" runat="server" AutoGenerateColumns="false" CssClass="modern-table"
                        EmptyDataText="No sections found." DataKeyNames="SectionId" OnRowCommand="gvSections_RowCommand"
                        GridLines="None">
                        <Columns>
                            <asp:TemplateField HeaderText="Section Name">
                                <ItemTemplate>
                                    <span class="badge-code badge"><%# Eval("SectionName") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Degree Program">
                                <ItemTemplate>
                                    <span class="program-name"><%# Eval("Program") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Year">
                                <ItemTemplate>
                                    <span class="badge badge-neutral">Year <%# Eval("YearLevel") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="School Year &amp; Term">
                                <ItemTemplate>
                                    <div class="term-cell">
                                        <span><%# Eval("SchoolYear") %></span>
                                        <span class="badge badge-teal"><%# Eval("Term") %></span>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="actions-cell">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEditSection" runat="server" CssClass="btn-action-edit"
                                        CommandName="EditSection" CommandArgument='<%# Eval("SectionId") %>' ToolTip="Edit Section">
                                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                                        <span>Edit</span>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="empty-state-box">
                                <div class="empty-state-icon">
                                    <svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                        <polygon points="12 2 2 7 12 12 22 7 12 2"></polygon>
                                        <polyline points="2 17 12 22 22 17"></polyline>
                                        <polyline points="2 12 12 17 22 12"></polyline>
                                    </svg>
                                </div>
                                <div class="empty-state-title">No Sections Created</div>
                                <div class="empty-state-desc">Use the form above to configure cohort class sections.</div>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- TAB 2: COURSE OFFERINGS -->
        <div id="tab-offerings" class="tab-pane">
            <asp:Panel ID="pnlOfferingEditor" runat="server" CssClass="admin-card editor-card">
                <div class="admin-card-header">
                    <div class="card-title-group">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                        <h3 class="admin-card-title">Schedule Course Offering</h3>
                    </div>
                    <span class="badge badge-info">Offering Assignment</span>
                </div>
                <div class="admin-card-body">
                    <div class="form-row-grid">
                        <div class="form-group">
                            <asp:Label AssociatedControlID="ddlOfferingCourse" runat="server" CssClass="form-label">Subject / Course <span class="req-star">*</span></asp:Label>
                            <asp:DropDownList ID="ddlOfferingCourse" runat="server" CssClass="form-control select-clean" />
                        </div>
                        <div class="form-group">
                            <asp:Label AssociatedControlID="ddlOfferingProfessor" runat="server" CssClass="form-label">Assigned Instructor <span class="req-star">*</span></asp:Label>
                            <asp:DropDownList ID="ddlOfferingProfessor" runat="server" CssClass="form-control select-clean" />
                        </div>
                    </div>

                    <div class="form-row-grid">
                        <div class="form-group">
                            <asp:Label AssociatedControlID="ddlOfferingSection" runat="server" CssClass="form-label">Target Section <span class="req-star">*</span></asp:Label>
                            <asp:DropDownList ID="ddlOfferingSection" runat="server" CssClass="form-control select-clean" />
                        </div>
                        <div class="form-group">
                            <asp:Label AssociatedControlID="txtOfferingSchoolYear" runat="server" CssClass="form-label">Academic Year <span class="req-star">*</span></asp:Label>
                            <asp:TextBox ID="txtOfferingSchoolYear" runat="server" CssClass="form-control" MaxLength="9" placeholder="e.g. 2026-2027" />
                        </div>
                        <div class="form-group">
                            <asp:Label AssociatedControlID="ddlOfferingTerm" runat="server" CssClass="form-label">Semester / Term <span class="req-star">*</span></asp:Label>
                            <asp:DropDownList ID="ddlOfferingTerm" runat="server" CssClass="form-control select-clean">
                                <asp:ListItem Text="1st Semester" Value="1st Semester" />
                                <asp:ListItem Text="2nd Semester" Value="2nd Semester" />
                                <asp:ListItem Text="Summer" Value="Summer" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="form-actions-bar">
                        <asp:Button ID="btnSaveOffering" runat="server" Text="Schedule Offering" CssClass="btn btn-primary" OnClick="btnSaveOffering_Click" CausesValidation="false" />
                    </div>
                </div>
            </asp:Panel>

            <div class="admin-card">
                <div class="admin-card-header table-toolbar">
                    <div class="toolbar-left">
                        <div class="card-title-group">
                            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                            <h3 class="admin-card-title">Scheduled Course Offerings</h3>
                        </div>
                    </div>
                </div>

                <div class="table-responsive">
                    <asp:GridView ID="gvOfferings" runat="server" AutoGenerateColumns="false" CssClass="modern-table"
                        EmptyDataText="No course offerings found." DataKeyNames="OfferingId" OnRowCommand="gvOfferings_RowCommand"
                        GridLines="None">
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

                            <asp:TemplateField HeaderText="Section">
                                <ItemTemplate>
                                    <span class="badge badge-teal"><%# Eval("SectionName") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Term">
                                <ItemTemplate>
                                    <span class="badge badge-neutral"><%# Eval("SchoolYear") %> &bull; <%# Eval("Term") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="actions-cell">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnRemoveOffering" runat="server" CssClass="btn-action-reject"
                                        CommandName="RemoveOffering" CommandArgument='<%# Eval("OfferingId") %>'
                                        OnClientClick="return confirm('Remove this course offering schedule?');" ToolTip="Remove Offering">
                                        <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                        <span>Remove</span>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="empty-state-box">
                                <div class="empty-state-icon">
                                    <svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                </div>
                                <div class="empty-state-title">No Course Offerings Scheduled</div>
                                <div class="empty-state-desc">Assign courses and professors to sections using the schedule form above.</div>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <!-- TAB 3: STUDENT ASSIGNMENT -->
        <div id="tab-students" class="tab-pane">
            <asp:Panel ID="pnlAssignment" runat="server" CssClass="admin-card editor-card">
                <div class="admin-card-header">
                    <div class="card-title-group">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="8.5" cy="7" r="4"></circle>
                            <line x1="20" y1="8" x2="20" y2="14"></line>
                            <line x1="23" y1="11" x2="17" y2="11"></line>
                        </svg>
                        <h3 class="admin-card-title">Assign Enrolled Student to Section</h3>
                    </div>
                    <span class="badge badge-warning">Direct Placement</span>
                </div>
                <div class="admin-card-body">
                    <p class="form-hint-text">Quickly reassign or place a verified student directly into a specific section by entering their student identification number.</p>

                    <div class="form-row-grid">
                        <div class="form-group">
                            <asp:Label AssociatedControlID="txtAssignStudentNumber" runat="server" CssClass="form-label">Student Identification Number <span class="req-star">*</span></asp:Label>
                            <asp:TextBox ID="txtAssignStudentNumber" runat="server" CssClass="form-control" MaxLength="7" placeholder="e.g. 23-1234" />
                        </div>
                        <div class="form-group">
                            <asp:Label AssociatedControlID="ddlAssignSection" runat="server" CssClass="form-label">Target Section <span class="req-star">*</span></asp:Label>
                            <asp:DropDownList ID="ddlAssignSection" runat="server" CssClass="form-control select-clean" />
                        </div>
                    </div>

                    <div class="form-actions-bar">
                        <asp:Button ID="btnAssignStudent" runat="server" Text="Assign Student to Section" CssClass="btn btn-primary" OnClick="btnAssignStudent_Click" CausesValidation="false" />
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlBulkAssignment" runat="server" CssClass="admin-card editor-card" style="margin-top: 1.5rem;">
                <div class="admin-card-header">
                    <div class="card-title-group">
                        <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="16" y1="13" x2="8" y2="13"></line>
                            <line x1="16" y1="17" x2="8" y2="17"></line>
                            <polyline points="10 9 9 9 8 9"></polyline>
                        </svg>
                        <h3 class="admin-card-title">Bulk Section Assignment via CSV</h3>
                    </div>
                    <span class="badge badge-teal">Bulk Import</span>
                </div>
                <div class="admin-card-body">
                    <p class="form-hint-text">
                        Upload a <code>.csv</code> file or paste rows below. Accepted format is <code>StudentNumber,SectionName</code> (e.g. <code>23-1234,BSIT-3A</code>).
                        If your file only has student numbers, select a target fallback section from the dropdown.
                    </p>

                    <div class="form-row-grid">
                        <div class="form-group">
                            <asp:Label AssociatedControlID="fuSectionCsv" runat="server" CssClass="form-label">Upload CSV File</asp:Label>
                            <asp:FileUpload ID="fuSectionCsv" runat="server" CssClass="form-control" />
                        </div>
                        <div class="form-group">
                            <asp:Label AssociatedControlID="ddlBulkFallbackSection" runat="server" CssClass="form-label">Fallback Section (if not in CSV)</asp:Label>
                            <asp:DropDownList ID="ddlBulkFallbackSection" runat="server" CssClass="form-control select-clean" />
                        </div>
                    </div>

                    <div class="form-group">
                        <asp:Label AssociatedControlID="txtBulkCsv" runat="server" CssClass="form-label">Or Paste CSV Data Directly</asp:Label>
                        <asp:TextBox ID="txtBulkCsv" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" placeholder="23-1234,BSIT-3A&#10;24-5678,BSIT-3A" />
                    </div>

                    <div class="form-actions-bar">
                        <asp:Button ID="btnProcessBulkCsv" runat="server" Text="Execute Bulk Assignment" CssClass="btn btn-primary" OnClick="btnProcessBulkCsv_Click" CausesValidation="false" />
                    </div>

                    <asp:Panel ID="pnlBulkResults" runat="server" Visible="false" style="margin-top: 1.25rem;">
                        <asp:Literal ID="litBulkResultSummary" runat="server" />
                    </asp:Panel>
                </div>
            </asp:Panel>
        </div>
    </div>

    <script>
        (function () {
            var hidActiveTab = document.getElementById('<%= hidActiveTab.ClientID %>');
            var studentNumberInput = document.getElementById('<%= txtAssignStudentNumber.ClientID %>');
            var tabButtons = document.querySelectorAll('.admin-tab-nav .tab-btn');
            var tabPanes = document.querySelectorAll('.tab-pane');

            function formatStudentNumber() {
                if (!studentNumberInput) return;

                var value = studentNumberInput.value;
                var caret = studentNumberInput.selectionStart;
                if (caret === null) caret = value.length;

                var digitsBeforeCaret = value.slice(0, caret).replace(/\D/g, '').length;
                var digits = value.replace(/\D/g, '').slice(0, 6);
                var formatted = digits.length > 2
                    ? digits.slice(0, 2) + '-' + digits.slice(2)
                    : digits;

                studentNumberInput.value = formatted;
                var caretDigits = Math.min(digitsBeforeCaret, digits.length);
                var nextCaret = caretDigits + (caretDigits > 2 ? 1 : 0);
                studentNumberInput.setSelectionRange(nextCaret, nextCaret);
            }

            if (studentNumberInput) {
                studentNumberInput.setAttribute('inputmode', 'numeric');
                studentNumberInput.setAttribute('pattern', '[0-9]{2}-[0-9]{4}');
                studentNumberInput.addEventListener('input', formatStudentNumber);
                formatStudentNumber();
            }

            function activateTab() {
                if (!(hidActiveTab instanceof HTMLInputElement) || !hidActiveTab.value) return;
                var tabId = hidActiveTab.value;

                tabButtons.forEach(function (btn) {
                    var target = btn.getAttribute('data-target');
                    if (target === 'tab-' + tabId || target === tabId) {
                        btn.classList.add('active');
                    } else {
                        btn.classList.remove('active');
                    }
                });

                tabPanes.forEach(function (pane) {
                    if (pane.id === 'tab-' + tabId || pane.id === tabId) {
                        pane.classList.add('active');
                    } else {
                        pane.classList.remove('active');
                    }
                });

            }

            tabButtons.forEach(function (btn) {
                btn.addEventListener('click', function () {
                    var target = btn.getAttribute('data-target');
                    if (target && hidActiveTab instanceof HTMLInputElement) {
                        hidActiveTab.value = target.replace('tab-', '');
                        activateTab();
                    }
                });
            });

            // Initial load check
            if (hidActiveTab instanceof HTMLInputElement && hidActiveTab.value) {
                activateTab();
            }
        }());
    </script>
</asp:Content>
