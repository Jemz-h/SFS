using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using StudentFeedbackSystem.Models;
using StudentFeedbackSystem.Repositories;

namespace StudentFeedbackSystem.Services
{
    public class BulkAssignmentResult
    {
        public int TotalProcessed { get; set; }
        public int SuccessCount { get; set; }
        public int FailCount { get; set; }
        public List<string> Messages { get; set; } = new List<string>();
        public List<string> Errors { get; set; } = new List<string>();
    }

    public class VerificationService
    {
        private readonly IStudentRepository _studentRepo;
        private readonly ISectionRepository _sectionRepo;
        private readonly IAuditLogRepository _auditRepo;
        private readonly IEnrollmentRepository _enrollmentRepo;

        public VerificationService()
            : this(new StudentRepository(), new SectionRepository(), new AuditLogRepository(), new EnrollmentRepository()) { }

        public VerificationService(
            IStudentRepository studentRepo,
            ISectionRepository sectionRepo,
            IAuditLogRepository auditRepo,
            IEnrollmentRepository enrollmentRepo)
        {
            _studentRepo = studentRepo;
            _sectionRepo = sectionRepo;
            _auditRepo = auditRepo;
            _enrollmentRepo = enrollmentRepo;
        }

        public IEnumerable<Student> GetPending() => _studentRepo.GetByStatus("Pending");

        public IEnumerable<Student> GetByStatus(string status) => _studentRepo.GetByStatus(status);

        public void Approve(int studentId, int adminId, int? sectionId)
        {
            _studentRepo.UpdateStatus(studentId, "Verified", null, adminId);
            if (sectionId.HasValue)
            {
                _studentRepo.UpdateSection(studentId, sectionId.Value);
                _enrollmentRepo.CreateEnrollmentsForSectionStudent(studentId, sectionId.Value);
            }

            _auditRepo.Log(adminId, "VerifyStudent", "Student", studentId,
                sectionId.HasValue ? $"Approved and assigned to SectionId {sectionId.Value}" : "Approved without section");
        }

        public void Reject(int studentId, int adminId, string reason)
        {
            _studentRepo.UpdateStatus(studentId, "Rejected", reason, null);
            _auditRepo.Log(adminId, "RejectStudent", "Student", studentId, $"Reason: {reason}");
        }

        public void AssignSection(int studentId, int adminId, int sectionId)
        {
            _studentRepo.UpdateSection(studentId, sectionId);
            _enrollmentRepo.CreateEnrollmentsForSectionStudent(studentId, sectionId);
            _auditRepo.Log(adminId, "AssignSection", "Student", studentId, $"Assigned to SectionId {sectionId}");
        }

        public BulkAssignmentResult BulkAssignFromCsv(string csvContent, int adminId, int? fallbackSectionId = null)
        {
            var result = new BulkAssignmentResult();
            if (string.IsNullOrWhiteSpace(csvContent))
            {
                result.Errors.Add("CSV content is empty.");
                return result;
            }

            var sections = _sectionRepo.GetAll().ToList();
            var sectionByName = sections.ToDictionary(s => s.SectionName.Trim(), s => s, StringComparer.OrdinalIgnoreCase);

            using (var reader = new StringReader(csvContent))
            {
                string line;
                int lineNumber = 0;
                while ((line = reader.ReadLine()) != null)
                {
                    lineNumber++;
                    var trimmed = line.Trim();
                    if (string.IsNullOrEmpty(trimmed) || trimmed.StartsWith("#")) continue;

                    // Skip header row if present
                    if (lineNumber == 1 && (trimmed.StartsWith("StudentNumber", StringComparison.OrdinalIgnoreCase) || trimmed.StartsWith("Student ID", StringComparison.OrdinalIgnoreCase)))
                    {
                        continue;
                    }

                    result.TotalProcessed++;
                    var parts = trimmed.Split(new[] { ',', '\t', ';' }, StringSplitOptions.None);
                    var studentNumber = parts[0].Trim();

                    if (string.IsNullOrWhiteSpace(studentNumber))
                    {
                        result.FailCount++;
                        result.Errors.Add($"Line {lineNumber}: Student identification number is empty.");
                        continue;
                    }

                    var student = _studentRepo.GetByStudentNumber(studentNumber);
                    if (student == null)
                    {
                        result.FailCount++;
                        result.Errors.Add($"Line {lineNumber}: Student #{studentNumber} not found.");
                        continue;
                    }

                    int targetSectionId;
                    string targetSectionName;

                    if (parts.Length > 1 && !string.IsNullOrWhiteSpace(parts[1]))
                    {
                        var sectionNameInput = parts[1].Trim();
                        if (sectionByName.TryGetValue(sectionNameInput, out var matchedSection))
                        {
                            targetSectionId = matchedSection.SectionId;
                            targetSectionName = matchedSection.SectionName;
                        }
                        else
                        {
                            result.FailCount++;
                            result.Errors.Add($"Line {lineNumber}: Section '{sectionNameInput}' for student #{studentNumber} does not exist.");
                            continue;
                        }
                    }
                    else if (fallbackSectionId.HasValue)
                    {
                        targetSectionId = fallbackSectionId.Value;
                        var fallbackSec = sections.FirstOrDefault(s => s.SectionId == targetSectionId);
                        targetSectionName = fallbackSec != null ? fallbackSec.SectionName : $"Section {targetSectionId}";
                    }
                    else
                    {
                        result.FailCount++;
                        result.Errors.Add($"Line {lineNumber}: No section specified for student #{studentNumber} and no fallback section selected.");
                        continue;
                    }

                    try
                    {
                        AssignSection(student.StudentId, adminId, targetSectionId);
                        result.SuccessCount++;
                        result.Messages.Add($"Assigned {student.FullName} (#{student.StudentNumber}) to {targetSectionName}.");
                    }
                    catch (Exception ex)
                    {
                        result.FailCount++;
                        result.Errors.Add($"Line {lineNumber}: Error assigning #{studentNumber} - {ex.Message}");
                    }
                }
            }

            return result;
        }

        public IEnumerable<Section> GetSections() => _sectionRepo.GetAll();
    }
}
