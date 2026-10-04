using System;
using System.Linq;
using StudentFeedbackSystem.Security;
using StudentFeedbackSystem.Services;

namespace StudentFeedbackSystem.StudentPages
{
    public partial class MyRatingHistory : StudentBasePage
    {
        private readonly RatingService _ratingService = new RatingService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindHistory();
            }
        }

        private void BindHistory()
        {
            var history = _ratingService.GetStudentRatingHistory(CurrentStudentId).ToList();
            litHistoryCount.Text = history.Count.ToString();
            gvHistory.DataSource = history;
            gvHistory.DataBind();
        }
    }
}
