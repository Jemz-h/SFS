using System;
using System.Linq;
using System.Web.UI.WebControls;
using StudentFeedbackSystem.Models;
using StudentFeedbackSystem.Repositories;
using StudentFeedbackSystem.Security;

namespace StudentFeedbackSystem.AdminPages
{
    public partial class ManageProfessors : AdminBasePage
    {
        private static readonly string[] DepartmentOptions =
        {
            "College of Computer Studies",
            "College of Engineering",
            "College of Business Administration",
            "College of Education",
            "Department of Information Technology",
            "Department of Computer Science",
            "General Education Department"
        };

        private readonly IProfessorRepository _professorRepository = new ProfessorRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindProfessors();
                ResetEditor();
            }
        }

        private void BindProfessors()
        {
            var profs = _professorRepository.GetAll(includeInactive: true);
            var list = profs as System.Collections.Generic.List<Professor> ?? new System.Collections.Generic.List<Professor>(profs);
            litTotalProfessorsCount.Text = list.Count.ToString();
            litActiveProfessorsCount.Text = list.Count(p => p.IsActive).ToString();
            litDepartmentCount.Text = list.Where(p => !string.IsNullOrWhiteSpace(p.Department))
                                          .Select(p => p.Department.Trim())
                                          .Distinct(StringComparer.OrdinalIgnoreCase)
                                          .Count().ToString();

            gvProfessors.DataSource = list;
            gvProfessors.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            var professor = new Professor
            {
                FirstName = txtFirstName.Text.Trim(),
                LastName = txtLastName.Text.Trim(),
                Department = ddlDepartment.SelectedValue.Trim()
            };

            try
            {
                int professorId;
                if (int.TryParse(hidProfessorId.Value, out professorId))
                {
                    professor.ProfessorId = professorId;
                    _professorRepository.Update(professor);
                    ShowMessage("Professor details successfully updated.");
                }
                else
                {
                    _professorRepository.Insert(professor);
                    ShowMessage("Professor successfully added to faculty roster.");
                }

                ResetEditor();
                BindProfessors();
            }
            catch (Exception)
            {
                ShowError("The professor could not be saved. Please review the details and try again.");
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetEditor();
        }

        protected void gvProfessors_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int professorId;
            if (!int.TryParse(e.CommandArgument?.ToString(), out professorId)) return;

            var professor = _professorRepository.GetById(professorId);
            if (professor == null) return;

            if (e.CommandName == "EditProfessor")
            {
                hidProfessorId.Value = professor.ProfessorId.ToString();
                txtFirstName.Text = professor.FirstName;
                txtLastName.Text = professor.LastName;
                SelectDepartment(professor.Department);
                litEditorTitle.Text = "Edit Professor";
                btnSave.Text = "Update Professor";
                btnCancel.Visible = true;
            }
            else if (e.CommandName == "ToggleProfessor")
            {
                _professorRepository.SetActive(professor.ProfessorId, !professor.IsActive);
                ShowMessage(professor.IsActive ? "Professor deactivated." : "Professor activated.");
                BindProfessors();
            }
        }

        private void ResetEditor()
        {
            hidProfessorId.Value = string.Empty;
            txtFirstName.Text = string.Empty;
            txtLastName.Text = string.Empty;
            for (var i = ddlDepartment.Items.Count - 1; i > 0; i--)
            {
                if (!DepartmentOptions.Contains(ddlDepartment.Items[i].Value, StringComparer.OrdinalIgnoreCase))
                {
                    ddlDepartment.Items.RemoveAt(i);
                }
            }
            ddlDepartment.SelectedIndex = 0;
            litEditorTitle.Text = "Add Professor";
            btnSave.Text = "Save Professor";
            btnCancel.Visible = false;
        }

        private void SelectDepartment(string department)
        {
            ddlDepartment.ClearSelection();
            if (string.IsNullOrWhiteSpace(department))
            {
                ddlDepartment.SelectedIndex = 0;
                return;
            }

            var item = ddlDepartment.Items.FindByValue(department);
            if (item == null)
            {
                item = new ListItem(department, department);
                ddlDepartment.Items.Insert(1, item);
            }

            item.Selected = true;
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

        protected string GetInitials(object fullNameObj)
        {
            var name = fullNameObj?.ToString()?.Trim();
            if (string.IsNullOrWhiteSpace(name)) return "PF";

            var parts = name.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1)
            {
                return parts[0].Substring(0, Math.Min(2, parts[0].Length)).ToUpperInvariant();
            }
            return (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpperInvariant();
        }
    }
}
