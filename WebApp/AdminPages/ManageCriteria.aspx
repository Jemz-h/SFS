<%@ Page Title="Manage Rating Criteria" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageCriteria.aspx.cs" Inherits="StudentFeedbackSystem.AdminPages.ManageCriteria" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-page-header">
        <div class="header-content">
            <div class="header-badge">Rubric Configuration</div>
            <h1 class="page-title">Evaluation Criteria &amp; Rubric</h1>
            <p class="page-subtitle">Configure the performance dimensions, weighting factors, and active criteria students use to evaluate faculty.</p>
        </div>
    </div>

    <!-- Alert / Message -->
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

    <!-- Criteria Editor Card -->
    <asp:Panel ID="pnlEditor" runat="server" CssClass="admin-card editor-card" style="margin-bottom: 1.5rem;">
        <div class="admin-card-header">
            <div class="card-title-group">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 20h9"></path>
                    <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                </svg>
                <h3 class="admin-card-title"><asp:Literal ID="litEditorTitle" runat="server" Text="Add Evaluation Criterion" /></h3>
            </div>
            <span class="badge badge-teal">Rubric Parameter</span>
        </div>
        <div class="admin-card-body">
            <asp:HiddenField ID="hidCriterionId" runat="server" />

            <div class="form-group">
                <asp:Label AssociatedControlID="txtCriterionName" runat="server" CssClass="form-label">Criterion Title / Description <span class="req-star">*</span></asp:Label>
                <asp:TextBox ID="txtCriterionName" runat="server" CssClass="form-control" MaxLength="150" placeholder="e.g. Command of Subject Matter, Clarity of Instruction..." />
                <asp:RequiredFieldValidator ControlToValidate="txtCriterionName" runat="server" ErrorMessage="Criterion title is required." Display="Dynamic" CssClass="field-error" ValidationGroup="Criteria" />
            </div>

            <div class="form-row-grid">
                <div class="form-group">
                    <asp:Label AssociatedControlID="txtWeight" runat="server" CssClass="form-label">Weight Multiplier (e.g. 1.00) <span class="req-star">*</span></asp:Label>
                    <asp:TextBox ID="txtWeight" runat="server" CssClass="form-control" Text="1.00" />
                    <asp:RequiredFieldValidator ControlToValidate="txtWeight" runat="server" ErrorMessage="Weight is required." Display="Dynamic" CssClass="field-error" ValidationGroup="Criteria" />
                </div>
                <div class="form-group">
                    <asp:Label AssociatedControlID="txtDisplayOrder" runat="server" CssClass="form-label">Display Order (Sorting sequence) <span class="req-star">*</span></asp:Label>
                    <asp:TextBox ID="txtDisplayOrder" runat="server" CssClass="form-control" Text="1" TextMode="Number" />
                    <asp:RequiredFieldValidator ControlToValidate="txtDisplayOrder" runat="server" ErrorMessage="Display order is required." Display="Dynamic" CssClass="field-error" ValidationGroup="Criteria" />
                </div>
            </div>

            <div class="form-actions-bar">
                <asp:Button ID="btnSave" runat="server" Text="Save Criterion" CssClass="btn btn-primary" OnClick="btnSave_Click" ValidationGroup="Criteria" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel Edit" CssClass="btn btn-ghost" OnClick="btnCancel_Click" CausesValidation="false" Visible="false" />
            </div>
        </div>
    </asp:Panel>

    <!-- Criteria Table -->
    <div class="admin-card">
        <div class="admin-card-header table-toolbar">
            <div class="toolbar-left">
                <div class="card-title-group">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="8" y1="6" x2="21" y2="6"></line>
                        <line x1="8" y1="12" x2="21" y2="12"></line>
                        <line x1="8" y1="18" x2="21" y2="18"></line>
                        <line x1="3" y1="6" x2="3.01" y2="6"></line>
                        <line x1="3" y1="12" x2="3.01" y2="12"></line>
                        <line x1="3" y1="18" x2="3.01" y2="18"></line>
                    </svg>
                    <h3 class="admin-card-title">Configured Rating Criteria</h3>
                </div>
            </div>
            <span class="badge badge-neutral"><asp:Literal ID="litActiveCount" runat="server" Text="0" /> Active Criteria</span>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvCriteria" runat="server" AutoGenerateColumns="false" CssClass="modern-table"
                EmptyDataText="No rating criteria found." GridLines="None" DataKeyNames="CriterionId"
                OnRowCommand="gvCriteria_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="Order">
                        <ItemTemplate>
                            <span class="badge badge-neutral" style="font-weight: 700;">#<%# Eval("DisplayOrder") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Criterion Title">
                        <ItemTemplate>
                            <span style="font-weight: 600; color: var(--text-heading, #0f172a);"><%# Eval("CriterionName") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Weight">
                        <ItemTemplate>
                            <span class="badge badge-teal"><%# Eval("Weight", "{0:0.00}") %>x</span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <%# (bool)Eval("IsActive")
                                ? "<span class=\"status-chip chip-success\"><span class=\"pulse-dot\"></span> Active</span>"
                                : "<span class=\"status-chip\" style=\"background: rgba(100, 116, 139, 0.1); color: #64748b;\">Inactive</span>" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="actions-cell">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn-action-edit"
                                CommandName="EditCriterion" CommandArgument='<%# Eval("CriterionId") %>' CausesValidation="false">
                                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                                <span>Edit</span>
                            </asp:LinkButton>

                            <asp:LinkButton ID="btnToggle" runat="server" CssClass='<%# (bool)Eval("IsActive") ? "btn-action-reject" : "btn-action-approve" %>'
                                CommandName="ToggleCriterion" CommandArgument='<%# Eval("CriterionId") %>' CausesValidation="false">
                                <span><%# (bool)Eval("IsActive") ? "Deactivate" : "Activate" %></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
