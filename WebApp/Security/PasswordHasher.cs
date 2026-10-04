namespace StudentFeedbackSystem.Security
{
    /// <summary>
    /// Thin wrapper around BCrypt.Net-Next (NuGet: BCrypt.Net-Next).
    /// Never store or compare plaintext passwords, and never use MD5/SHA1 alone.
    /// </summary>
    public static class PasswordHasher
    {
        // Work factor 12 is a reasonable default as of 2026; raise it as
        // hardware gets faster (re-hash on next successful login if you bump it).
        private const int WorkFactor = 12;

        public static string Hash(string plainPassword)
        {
            return BCrypt.Net.BCrypt.HashPassword(plainPassword, WorkFactor);
        }

        public static bool Verify(string plainPassword, string hash)
        {
            if (string.IsNullOrEmpty(hash)) return false;
            return BCrypt.Net.BCrypt.Verify(plainPassword, hash);
        }
    }
}
