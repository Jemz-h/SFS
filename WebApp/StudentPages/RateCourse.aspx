<%@ Page Title="Rate Course & Faculty" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RateCourse.aspx.cs" Inherits="StudentFeedbackSystem.StudentPages.RateCourse" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="admin-page-header">
        <div class="header-content">
            <div class="header-badge">Student Evaluation</div>
            <h1 class="page-title">Faculty &amp; Course Evaluation</h1>
            <p class="page-subtitle">Your constructive feedback is anonymous and helps enhance academic excellence.</p>
        </div>
        <div class="header-meta">
            <a href="MyCourses.aspx" class="btn btn-ghost btn-sm">&larr; Back to My Courses</a>
        </div>
    </div>

    <!-- Error message alert -->
    <asp:Panel ID="pnlError" runat="server" CssClass="modern-alert alert-error" Visible="false">
        <div class="alert-icon">
            <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
        </div>
        <div class="alert-message">
            <asp:Literal ID="litErrorMessage" runat="server" />
        </div>
    </asp:Panel>

    <!-- Course & Faculty Information Card -->
    <div class="admin-card course-summary-card">
        <div class="admin-card-body">
            <div class="course-summary-layout">
                <div>
                    <div class="course-summary-tags">
                        <span class="badge-code badge"><asp:Literal ID="litCourseCode" runat="server" /></span>
                        <span class="badge badge-neutral"><asp:Literal ID="litUnits" runat="server" /> Units</span>
                        <span class="badge badge-teal"><asp:Literal ID="litSectionName" runat="server" /></span>
                    </div>
                    <h2 class="course-summary-title"><asp:Literal ID="litCourseTitle" runat="server" /></h2>
                    <div class="course-summary-term">
                        Term: <strong><asp:Literal ID="litSchoolYear" runat="server" /> &bull; <asp:Literal ID="litTerm" runat="server" /></strong>
                    </div>
                </div>

                <div class="course-summary-instructor">
                    <div class="summary-label">Evaluating Instructor</div>
                    <div class="course-instructor-name">
                        <asp:Literal ID="litProfessorName" runat="server" />
                    </div>
                    <div class="course-summary-term"><asp:Literal ID="litDepartment" runat="server" /></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Rating Scale Guide -->
    <div class="admin-card rating-guide-card">
        <div class="admin-card-header compact-card-header">
            <div class="card-title-group">
                <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="16" x2="12" y2="12"></line>
                    <line x1="12" y1="8" x2="12.01" y2="8"></line>
                </svg>
                <h4 class="admin-card-title">Rating Scale Reference (Likert 1 to 5)</h4>
            </div>
        </div>
        <div class="admin-card-body compact-card-body">
            <div class="rating-guide-grid">
                <div class="rating-guide-item">
                    <div class="rating-guide-title rating-guide-low">1 - Poor</div>
                    <div class="rating-guide-description">Rarely meets standard</div>
                </div>
                <div class="rating-guide-item">
                    <div class="rating-guide-title rating-guide-mid">2 - Fair</div>
                    <div class="rating-guide-description">Needs improvement</div>
                </div>
                <div class="rating-guide-item">
                    <div class="rating-guide-title rating-guide-mid">3 - Satisfactory</div>
                    <div class="rating-guide-description">Competently meets standard</div>
                </div>
                <div class="rating-guide-item">
                    <div class="rating-guide-title rating-guide-high">4 - Very Satisfactory</div>
                    <div class="rating-guide-description">Consistently exceeds standard</div>
                </div>
                <div class="rating-guide-item">
                    <div class="rating-guide-title rating-guide-high">5 - Excellent</div>
                    <div class="rating-guide-description">Exceptional performance</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Rating Form -->
    <div class="admin-card editor-card">
        <div class="admin-card-header">
            <div class="card-title-group">
                <svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                </svg>
                <h3 class="admin-card-title">Criteria Evaluation Rubric</h3>
            </div>
            <span class="badge badge-warning">Required Rubric</span>
        </div>
        <div class="admin-card-body">
            <asp:Repeater ID="rptCriteria" runat="server">
                <ItemTemplate>
            <div class="rating-criteria-item">
                        <asp:HiddenField ID="hidCriterionId" runat="server" Value='<%# Eval("CriterionId") %>' />
                        <div class="rating-criteria-heading">
                            <div>
                                <span class="criterion-number">Criterion <%# Container.ItemIndex + 1 %>:</span>
                                <span class="criteria-label"><%# Eval("CriterionName") %></span>
                            </div>
                                <span class="badge badge-neutral">Weight: <%# Eval("Weight", "{0:0.##}") %></span>
                        </div>

                        <!-- Rating radio options 1 to 5 -->
                        <div class="rating-scale">
                            <label>
                                <input type="radio" name='<%# "rating_" + Eval("CriterionId") %>' value="1" />
                                <span>1 - Poor</span>
                            </label>
                            <label>
                                <input type="radio" name='<%# "rating_" + Eval("CriterionId") %>' value="2" />
                                <span>2 - Fair</span>
                            </label>
                            <label>
                                <input type="radio" name='<%# "rating_" + Eval("CriterionId") %>' value="3" />
                                <span>3 - Satisfactory</span>
                            </label>
                            <label>
                                <input type="radio" name='<%# "rating_" + Eval("CriterionId") %>' value="4" />
                                <span>4 - Very Satisfactory</span>
                            </label>
                            <label>
                                <input type="radio" name='<%# "rating_" + Eval("CriterionId") %>' value="5" />
                                <span>5 - Excellent</span>
                            </label>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <!-- Qualitative Comments Box -->
            <div class="form-group comments-group">
                <asp:Label AssociatedControlID="txtComments" runat="server" CssClass="form-label">
                    Constructive Comments &amp; Remarks (Optional)
                </asp:Label>
                <p class="form-hint-text">Please share specific suggestions, observations, or commendations regarding teaching methodology and classroom interaction.</p>
                <asp:TextBox ID="txtComments" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" MaxLength="1000" placeholder="e.g. Lectures are very organized and engaging. Appreciate the clear explanations of complex assignments..." />
            </div>

            <!-- Anonymous Option -->
            <div class="anonymous-option">
                <label>
                    <asp:CheckBox ID="chkAnonymous" runat="server" Checked="true" />
                    <span>Submit this evaluation anonymously (Your name and student identification will not be linked to this feedback)</span>
                </label>
            </div>

            <!-- Action buttons -->
            <div class="form-actions-bar rating-actions">
                <asp:Button ID="btnSubmitRating" runat="server" Text="Submit Evaluation" CssClass="btn btn-primary" OnClick="btnSubmitRating_Click" />
                <a href="MyCourses.aspx" class="btn btn-ghost">Cancel</a>
            </div>
        </div>
    </div>
</asp:Content>
