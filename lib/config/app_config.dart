class AppConfig {
  static const supabaseUrl = 'https://ocktxsojvviepxijmqxe.supabase.co';

  static const supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ja3R4c29qdnZpZXB4aWptcXhlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTM0OTgyNTgsImV4cCI6MjEwOTA3NDI1OH0.z3DX2pdEUECSvjX6_ANZS1-4KWapPbyLdD0CUcqYlb0';

  static const studentId = '2415051001';
  static const studentName = 'I Gede Adiwidya Utama';
  static const studentClass = '5IKI-PTI';

  static bool get supabaseReady =>
      !supabaseUrl.contains('GANTI') && !supabaseAnonKey.contains('GANTI');
}