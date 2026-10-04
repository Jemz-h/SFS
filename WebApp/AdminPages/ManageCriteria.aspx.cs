using System;
using System.Linq;
using System.Web.UI.WebControls;
using StudentFeedbackSystem.Models;
using StudentFeedbackSystem.Repositories;
using StudentFeedbackSystem.Security;

namespace StudentFeedbackSystem.AdminPages
{
    public partial class ManageCriteria : AdminBasePage
    {
        private readonly ICriterionRepository _criterionRepository = new CriterionRepository();
        private readonly IAuditLogRepository _auditLogRepository = new AuditLogRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCriteria();
                ResetEditor();
            }
        }

        private void BindCriteria()
        {
            var criteria = _criterionRepository.GetAll(includeInactive: true).ToList();
            litActiveCount.Text = criteria.Count(c => c.IsActive).ToString();
            gvCriteria.DataSource = criteria;
            gvCriteria.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            decimal weight;
            if (!decimal.TryParse(txtWeight.Text.Trim(), out weight) || weight <= 0)
            {
                ShowError("Please enter a valid positive decimal weight (e.g. 1.00).");
                return;
            }

            int displayOrder;
            if (!int.TryParse(txtDisplayOrder.Text.Trim(), out displayOrder) || displayOrder <= 0)
            {
                ShowError("Please enter a valid positive integer for display order.");
                return;
            }

            var criterion = new Criterion
            {
                CriterionName = txtCriterionName.Text.Trim(),
                Weight = weight,
                DisplayOrder = displayOrder,
                IsActive = true
            };

            try
            {
                int criterionId;
                if (int.TryParse(hidCriterionId.Value, out criterionId))
                {
                    criterion.CriterionId = criterionId;
                    var existing = _criterionRepository.GetById(criterionId);
                    criterion.IsActive = existing?.IsActive ?? true;

                    _criterionRepository.Update(criterion);
                    _auditLogRepository.Log(CurrentAdminId, "UpdateCriterion", "Criterion", criterionId, $"Updated '{criterion.CriterionName}'");
                    ShowMessage("Evaluation criterion updated successfully.");
                }
                else
                {
                    var newId = _criterionRepository.Insert(criterion);
                    _auditLogRepository.Log(CurrentAdminId, "CreateCriterion", "Criterion", newId, $"Created '{criterion.CriterionName}'");
                    ShowMessage("New evaluation criterion added successfully.");
                }

                ResetEditor();
                BindCriteria();
            }
            catch (Exception ex)
            {
                ShowError("Could not save evaluation criterion: " + ex.Message);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetEditor();
        }

        protected void gvCriteria_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int criterionId;
            if (!int.TryParse(e.CommandArgument?.ToString(), out criterionId)) return;

            var criterion = _criterionRepository.GetById(criterionId);
            if (criterion == null) return;

            if (e.CommandName == "EditCriterion")
            {
                hidCriterionId.Value = criterion.CriterionId.ToString();
                txtCriterionName.Text = criterion.CriterionName;
                txtWeight.Text = criterion.Weight.ToString("0.00");
                txtDisplayOrder.Text = criterion.DisplayOrder.ToString();
                litEditorTitle.Text = "Edit Evaluation Criterion";
                btnSave.Text = "Update Criterion";
                btnCancel.Visible = true;
            }
            else if (e.CommandName == "ToggleCriterion")
            {
                var newStatus = !criterion.IsActive;
                _criterionRepository.SetActive(criterion.CriterionId, newStatus);
                _auditLogRepository.Log(CurrentAdminId, newStatus ? "ActivateCriterion" : "DeactivateCriterion", "Criterion", criterion.CriterionId, $"Set status of '{criterion.CriterionName}' to {newStatus}");
                ShowMessage(newStatus ? "Criterion activated." : "Criterion deactivated.");
                BindCriteria();
            }
        }

        private void ResetEditor()
        {
            hidCriterionId.Value = string.Empty;
            txtCriterionName.Text = string.Empty;
            txtWeight.Text = "1.00";
            txtDisplayOrder.Text = "1";
            litEditorTitle.Text = "Add Evaluation Criterion";
            btnSave.Text = "Save Criterion";
            btnCancel.Visible = false;
        }

        private void ShowMessage(string message)
        {
            litMessage.Text = message;
            pnlMessage.CssClass = "modern-alert alert-success";
            pnlMessage.Visible = true;
        }

        private void ShowError(string message)
        {
            litMessage.Text = message;
            pnlMessage.CssClass = "modern-alert alert-error";
            pnlMessage.Visible = true;
        }
    }
}
