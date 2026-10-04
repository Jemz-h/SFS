using System;
using System.Linq;
using System.Web.UI.WebControls;
using StudentFeedbackSystem.Repositories;
using StudentFeedbackSystem.Security;

namespace StudentFeedbackSystem.AdminPages
{
    public partial class AuditLog : AdminBasePage
    {
        private readonly IAuditLogRepository _auditLogRepository = new AuditLogRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateFilters();
                BindGrid();
            }
        }

        private void PopulateFilters()
        {
            var actions = _auditLogRepository.GetDistinctActions().ToList();
            ddlFilterAction.Items.Clear();
            ddlFilterAction.Items.Add(new ListItem("-- All Actions --", ""));
            foreach (var a in actions)
            {
                ddlFilterAction.Items.Add(new ListItem(a, a));
            }

            var targets = _auditLogRepository.GetDistinctTargetTypes().ToList();
            ddlFilterTargetType.Items.Clear();
            ddlFilterTargetType.Items.Add(new ListItem("-- All Targets --", ""));
            foreach (var t in targets)
            {
                ddlFilterTargetType.Items.Add(new ListItem(t, t));
            }
        }

        private void BindGrid()
        {
            var action = string.IsNullOrWhiteSpace(ddlFilterAction.SelectedValue) ? null : ddlFilterAction.SelectedValue;
            var target = string.IsNullOrWhiteSpace(ddlFilterTargetType.SelectedValue) ? null : ddlFilterTargetType.SelectedValue;
            var search = string.IsNullOrWhiteSpace(txtSearchTerm.Text) ? null : txtSearchTerm.Text.Trim();

            var logs = _auditLogRepository.GetAll(limit: 500, action: action, targetType: target, searchTerm: search).ToList();
            litLogCount.Text = logs.Count.ToString();
            gvAuditLog.DataSource = logs;
            gvAuditLog.DataBind();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            gvAuditLog.PageIndex = 0;
            BindGrid();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            ddlFilterAction.SelectedIndex = 0;
            ddlFilterTargetType.SelectedIndex = 0;
            txtSearchTerm.Text = string.Empty;
            gvAuditLog.PageIndex = 0;
            BindGrid();
        }

        protected void gvAuditLog_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvAuditLog.PageIndex = e.NewPageIndex;
            BindGrid();
        }
    }
}
