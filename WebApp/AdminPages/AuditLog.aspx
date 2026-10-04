<%@ Page Title="System Audit Log" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AuditLog.aspx.cs" Inherits="StudentFeedbackSystem.AdminPages.AuditLog" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-page-header">
        <div class="header-content">
            <div class="header-badge">Compliance &amp; Accountability</div>
            <h1 class="page-title">Administrative Audit Trail</h1>
            <p class="page-subtitle">A chronological record of student verifications, section placements, curriculum changes, and rubric adjustments.</p>
        </div>
    </div>

    <!-- Filter Control Bar -->
    <div class="admin-card" style="margin-bottom: 1.5rem;">
        <div class="admin-card-body" style="padding: 1rem 1.25rem;">
            <div class="form-row-grid" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; align-items: flex-end;">
                <div class="form-group" style="margin-bottom: 0;">
                    <asp:Label AssociatedControlID="ddlFilterAction" runat="server" CssClass="form-label" style="font-size: 0.8rem;">Filter Action</asp:Label>
                    <asp:DropDownList ID="ddlFilterAction" runat="server" CssClass="form-control select-clean">
                        <asp:ListItem Text="-- All Actions --" Value="" />
                    </asp:DropDownList>
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <asp:Label AssociatedControlID="ddlFilterTargetType" runat="server" CssClass="form-label" style="font-size: 0.8rem;">Target Entity</asp:Label>
                    <asp:DropDownList ID="ddlFilterTargetType" runat="server" CssClass="form-control select-clean">
                        <asp:ListItem Text="-- All Targets --" Value="" />
                    </asp:DropDownList>
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <asp:Label AssociatedControlID="txtSearchTerm" runat="server" CssClass="form-label" style="font-size: 0.8rem;">Search Description / Admin</asp:Label>
                    <asp:TextBox ID="txtSearchTerm" runat="server" CssClass="form-control" placeholder="Search keywords..." />
                </div>

                <div style="display: flex; gap: 0.5rem;">
                    <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn btn-primary" OnClick="btnFilter_Click" CausesValidation="false" style="padding: 0.5rem 1rem;" />
                    <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-ghost" OnClick="btnReset_Click" CausesValidation="false" style="padding: 0.5rem 1rem;" />
                </div>
            </div>
        </div>
    </div>

    <!-- Audit Log Table -->
    <div class="admin-card">
        <div class="admin-card-header table-toolbar">
            <div class="toolbar-left">
                <div class="card-title-group">
                    <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    </svg>
                    <h3 class="admin-card-title">Activity Trail Records</h3>
                </div>
            </div>
            <span class="badge badge-neutral"><asp:Literal ID="litLogCount" runat="server" Text="0" /> Events Recorded</span>
        </div>

        <div class="table-responsive">
            <asp:GridView ID="gvAuditLog" runat="server" AutoGenerateColumns="false" CssClass="modern-table"
                EmptyDataText="No audit log records match the search filter." GridLines="None"
                AllowPaging="true" PageSize="15" OnPageIndexChanging="gvAuditLog_PageIndexChanging">
                <Columns>
                    <asp:TemplateField HeaderText="Timestamp">
                        <ItemTemplate>
                            <span style="font-size: 0.825rem; color: var(--text-muted, #64748b);">
                                <%# Eval("CreatedAt", "{0:MMM d, yyyy h:mm:ss tt}") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Operator / Admin">
                        <ItemTemplate>
                            <div style="font-weight: 600; color: var(--text-heading, #0f172a);">
                                <%# Eval("AdminUsername") ?? "System Process" %>
                            </div>
                            <div style="font-size: 0.75rem; color: var(--text-muted, #64748b);">
                                <%# Eval("AdminFullName") %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Action Executed">
                        <ItemTemplate>
                            <span class="badge badge-teal" style="font-weight: 600;"><%# Eval("Action") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Target Entity">
                        <ItemTemplate>
                            <span class="badge badge-neutral"><%# Eval("TargetType") %> #<%# Eval("TargetId") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Event Details">
                        <ItemTemplate>
                            <div style="max-width: 380px; font-size: 0.85rem; color: var(--text-body, #334155); word-break: break-word;">
                                <%# Eval("Details") %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="empty-state-box">
                        <div class="empty-state-icon">
                            <svg viewBox="0 0 24 24" width="36" height="36" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                            </svg>
                        </div>
                        <div class="empty-state-title">No Audit Events</div>
                        <div class="empty-state-desc">There are no logged administrative events matching your current filters.</div>
                    </div>
                </EmptyDataTemplate>
                <PagerStyle CssClass="modern-pager" HorizontalAlign="Right" />
            </asp:GridView>
        </div>
    </div>
</asp:Content>
