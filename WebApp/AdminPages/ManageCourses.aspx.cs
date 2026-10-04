using System;
using System.Linq;
using System.Web.UI.WebControls;
using StudentFeedbackSystem.Models;
using StudentFeedbackSystem.Repositories;
using StudentFeedbackSystem.Security;

namespace StudentFeedbackSystem.AdminPages
{
    public partial class ManageCourses : AdminBasePage
    {
        private readonly ICourseRepository _courseRepository = new CourseRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCourses();
                ResetEditor();
            }
        }

        private void BindCourses()
        {
            var courses = _courseRepository.GetAll(includeInactive: true);
            var list = courses as System.Collections.Generic.List<Course> ?? new System.Collections.Generic.List<Course>(courses);
            litTotalCoursesCount.Text = list.Count.ToString();
            litActiveCoursesCount.Text = list.Count(c => c.IsActive).ToString();
            litInactiveCoursesCount.Text = list.Count(c => !c.IsActive).ToString();

            gvCourses.DataSource = list;
            gvCourses.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int units;
            if (!int.TryParse(txtUnits.Text.Trim(), out units)) return;

            var course = new Course
            {
                CourseCode = txtCourseCode.Text.Trim(),
                CourseTitle = txtCourseTitle.Text.Trim(),
                Units = units
            };

            try
            {
                int courseId;
                if (int.TryParse(hidCourseId.Value, out courseId))
                {
                    course.CourseId = courseId;
                    _courseRepository.Update(course);
                    ShowMessage("Course updated.");
                }
                else
                {
                    _courseRepository.Insert(course);
                    ShowMessage("Course added.");
                }

                ResetEditor();
                BindCourses();
            }
            catch (Exception)
            {
                ShowError("The course could not be saved. Check that the course code is unique.");
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetEditor();
        }

        protected void gvCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int courseId;
            if (!int.TryParse(e.CommandArgument?.ToString(), out courseId)) return;

            var course = _courseRepository.GetById(courseId);
            if (course == null) return;

            if (e.CommandName == "EditCourse")
            {
                hidCourseId.Value = course.CourseId.ToString();
                txtCourseCode.Text = course.CourseCode;
                txtCourseTitle.Text = course.CourseTitle;
                txtUnits.Text = course.Units.ToString();
                litEditorTitle.Text = "Edit Course";
                btnSave.Text = "Update Course";
                btnCancel.Visible = true;
            }
            else if (e.CommandName == "ToggleCourse")
            {
                _courseRepository.SetActive(course.CourseId, !course.IsActive);
                ShowMessage(course.IsActive ? "Course deactivated." : "Course activated.");
                BindCourses();
            }
        }

        private void ResetEditor()
        {
            hidCourseId.Value = string.Empty;
            txtCourseCode.Text = string.Empty;
            txtCourseTitle.Text = string.Empty;
            txtUnits.Text = "3";
            litEditorTitle.Text = "Add Course";
            btnSave.Text = "Save Course";
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
