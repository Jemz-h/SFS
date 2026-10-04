using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using StudentFeedbackSystem.Models;
using StudentFeedbackSystem.Security;
using StudentFeedbackSystem.Services;

namespace StudentFeedbackSystem.StudentPages
{
    public partial class MyCourses : StudentBasePage
    {
        private readonly RatingService _ratingService = new RatingService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["submitted"] == "1")
                {
                    litMessage.Text = "Thank you! Your course and faculty evaluation has been submitted successfully.";
                    pnlMessage.Visible = true;
                }

                PopulateTerms();
                BindGrid();
            }
        }

        private void PopulateTerms()
        {
            var enrollments = _ratingService.GetStudentEnrollments(CurrentStudentId).ToList();
            var terms = enrollments
                .Select(e => $"{e.SchoolYear} - {e.Term}")
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .OrderByDescending(t => t)
                .ToList();

            ddlTermFilter.Items.Clear();
            ddlTermFilter.Items.Add(new ListItem("-- All School Years / Terms --", ""));

            foreach (var term in terms)
            {
                ddlTermFilter.Items.Add(new ListItem(term, term));
            }
        }

        private void BindGrid()
        {
            var enrollments = _ratingService.GetStudentEnrollments(CurrentStudentId).ToList();

            // Calculate tab badge counts before term filtering
            litCountAll.Text = enrollments.Count.ToString();
            litCountPending.Text = enrollments.Count(e => !e.HasRated && !string.Equals(e.Status, "Dropped", StringComparison.OrdinalIgnoreCase)).ToString();
            litCountCompleted.Text = enrollments.Count(e => e.HasRated).ToString();

            // Filter by Term if selected
            var filtered = enrollments.AsEnumerable();
            if (!string.IsNullOrWhiteSpace(ddlTermFilter.SelectedValue))
            {
                filtered = filtered.Where(e => $"{e.SchoolYear} - {e.Term}".Equals(ddlTermFilter.SelectedValue, StringComparison.OrdinalIgnoreCase));
            }

            // Filter by Tab (all, pending, completed)
            var currentTab = hidFilter.Value.ToLowerInvariant();
            if (currentTab == "pending")
            {
                filtered = filtered.Where(e => !e.HasRated && !string.Equals(e.Status, "Dropped", StringComparison.OrdinalIgnoreCase));
            }
            else if (currentTab == "completed")
            {
                filtered = filtered.Where(e => e.HasRated);
            }

            // Update Tab styles
            btnTabAll.CssClass = currentTab == "all" ? "tab-btn active" : "tab-btn";
            btnTabPending.CssClass = currentTab == "pending" ? "tab-btn active" : "tab-btn";
            btnTabCompleted.CssClass = currentTab == "completed" ? "tab-btn active" : "tab-btn";

            gvCourses.DataSource = filtered.ToList();
            gvCourses.DataBind();
        }

        protected void btnTabFilter_Click(object sender, EventArgs e)
        {
            var btn = (LinkButton)sender;
            hidFilter.Value = btn.CommandArgument;
            gvCourses.PageIndex = 0;
            BindGrid();
        }

        protected void ddlTermFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvCourses.PageIndex = 0;
            BindGrid();
        }

        protected void gvCourses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCourses.PageIndex = e.NewPageIndex;
            BindGrid();
        }
    }
}
