String timeAgo(int timestampMillis) {
    final now = DateTime.now();
    final date = DateTime.fromMillisecondsSinceEpoch(timestampMillis);
    final difference = now.difference(date);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} h ago';
    return '${difference.inDays} d ago';
}