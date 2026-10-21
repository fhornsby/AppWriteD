module appwrite.upload_progress;

/// Progress of a chunked upload, passed to an `onProgress` callback after each chunk.
struct UploadProgress
{
    /// ID of the file being uploaded.
    string id;
    /// Percentage uploaded, 0 to 100.
    double progress;
    /// Bytes uploaded so far.
    ulong sizeUploaded;
    /// Number of chunks the file is split into.
    long chunksTotal;
    /// Number of chunks uploaded so far.
    long chunksUploaded;
}

/// Callback invoked with upload progress.
alias UploadProgressCallback = void delegate(UploadProgress progress);

