# TODO: Database-Driven Architecture with Flat Artifact Storage

## Proposal: SQLite-Centric File Management

### Current Issues
- File-based metadata tracking using `yes/` and `no/` directories is fragile
- Complex nested directory structure makes artifact management difficult
- No centralized tracking of processing pipeline state
- Difficult to query relationships between original and processed images

### Proposed Architecture

#### Database Schema
Replace directory-based tracking with comprehensive SQLite tables:

```sql
-- Core image metadata and processing state
CREATE TABLE images (
    id TEXT PRIMARY KEY,                    -- Base filename without extension
    sha256 TEXT UNIQUE NOT NULL,           -- File content hash for deduplication
    original_url TEXT,                     -- Source URL if downloaded
    username TEXT,                         -- Associated user if applicable
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Processing flags (replace yes/no directories)
    approved BOOLEAN DEFAULT FALSE,         -- Replaces yes/ directory
    rejected BOOLEAN DEFAULT FALSE,         -- Replaces no/ directory
    rejection_reason TEXT,                 -- Why rejected (gif, invalid, etc.)
    
    -- Metadata
    width INTEGER,
    height INTEGER,
    file_size INTEGER,
    mime_type TEXT
);

-- Track all artifact files in processing pipeline
CREATE TABLE artifacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    image_id TEXT NOT NULL,                -- References images.id
    stage TEXT NOT NULL,                   -- Stage name (see directory structure below)
    file_path TEXT NOT NULL,              -- Relative path from art/ directory
    sha256 TEXT,                          -- Artifact content hash
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Stage-specific metadata
    width INTEGER,                        -- Dimensions for image artifacts
    height INTEGER,
    file_size INTEGER,
    processing_params TEXT,               -- JSON params used to create this artifact
    
    FOREIGN KEY (image_id) REFERENCES images(id),
    UNIQUE(image_id, stage)               -- One artifact per stage per image
); 

-- Processing job tracking
CREATE TABLE jobs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    image_id TEXT NOT NULL,
    stage TEXT NOT NULL,                  -- Target stage
    status TEXT NOT NULL,                 -- pending, running, completed, failed
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    
    FOREIGN KEY (image_id) REFERENCES images(id)
);

-- Blurhash cache (replaces blur/ directory)
CREATE TABLE blurhash_cache (
    image_id TEXT NOT NULL,
    stage TEXT NOT NULL,
    blurhash TEXT NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (image_id, stage),
    FOREIGN KEY (image_id) REFERENCES images(id)
);
```

#### Directory Structure: art/

Replace complex nested structure with flat artifact storage:

```
art/
├── upstream/              # Original downloaded images (replaces img/)
├── thumbnails-small/      # 400px thumbnails (replaces thumbs/)
├── web-optimized/         # 400px web images (replaces t2/)
├── ersgan-enhanced/       # ESRGAN super-resolution outputs (replaces replicate/img/)
├── ersgan-thumbnails/     # Enhanced image thumbnails (replaces replicate/t2/)
├── face-swap-sources/     # Source images for face manipulation (replaces pub/W/)
├── face-swap-styles/      # Style reference images (replaces pub/w-*/)
├── face-swap-results/     # Generated face-swapped images (replaces pub/w-*/results)
├── video-sources/         # Source video files (replaces v/mp4/)
├── video-frames/          # Extracted video frames (replaces v/img/)
└── gallery-html/          # Generated HTML galleries (replaces g/, tmp/g/, W/)
```

### Command-Line SQL Operations

Based on existing patterns in the Justfile, here are bash functions for database operations:

#### Database Schema Creation
```bash
# Create new tables (run once)
cat <<'EOF' | sqlite3 cv.db
CREATE TABLE IF NOT EXISTS images (
    id TEXT PRIMARY KEY,
    sha256 TEXT UNIQUE NOT NULL,
    original_url TEXT,
    username TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved BOOLEAN DEFAULT FALSE,
    rejected BOOLEAN DEFAULT FALSE,
    rejection_reason TEXT,
    width INTEGER,
    height INTEGER,
    file_size INTEGER,
    mime_type TEXT
);

CREATE TABLE IF NOT EXISTS artifacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    image_id TEXT NOT NULL,
    stage TEXT NOT NULL,
    file_path TEXT NOT NULL,
    sha256 TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    width INTEGER,
    height INTEGER,
    file_size INTEGER,
    processing_params TEXT,
    FOREIGN KEY (image_id) REFERENCES images(id),
    UNIQUE(image_id, stage)
);

CREATE TABLE IF NOT EXISTS jobs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    image_id TEXT NOT NULL,
    stage TEXT NOT NULL,
    status TEXT NOT NULL,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    FOREIGN KEY (image_id) REFERENCES images(id)
);

CREATE TABLE IF NOT EXISTS blurhash_cache (
    image_id TEXT NOT NULL,
    stage TEXT NOT NULL,
    blurhash TEXT NOT NULL,
    width INTEGER NOT NULL,
    height INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (image_id, stage),
    FOREIGN KEY (image_id) REFERENCES images(id)
);
EOF
```

#### Bulk Image Registration (following existing pattern)
```bash
# Function to upsert multiple images (similar to db-upsert-img)
db-upsert-images() {
    echo "BEGIN TRANSACTION;"
    runmany 16 'id=$1; sha256=$(sha256sum "img/$1.jpeg" | cut -d" " -f1); size=$(stat -c%s "img/$1.jpeg"); echo "INSERT OR REPLACE INTO images (id, sha256, file_size, approved) VALUES ('"'"'$id'"'"', '"'"'$sha256'"'"', $size, $(test -f yes/$1.jpeg && echo true || echo false));"' "$@"
    echo "COMMIT;"
}

# Usage: find all images and register them
find img/ -name "*.jpeg" | cut -d/ -f2 | cut -d. -f1 | sort | xargs -n 100 bash -c 'db-upsert-images "$@" | sqlite3 cv.db' _
```

#### Artifact Logging (improved over existing pattern)
```bash
# Function to log artifact creation with metadata
db-log-artifact() {
    local image_id="$1"
    local stage="$2" 
    local file_path="$3"
    local processing_params="${4:-null}"
    
    # Get file metadata
    if [[ -f "$file_path" ]]; then
        local sha256=$(sha256sum "$file_path" | cut -d' ' -f1)
        local size=$(stat -c%s "$file_path")
        local dimensions=$(identify -format "%w %h" "$file_path" 2>/dev/null || echo "null null")
        local width=$(echo $dimensions | cut -d' ' -f1)
        local height=$(echo $dimensions | cut -d' ' -f2)
        
        cat <<EOF | sqlite3 cv.db
INSERT OR REPLACE INTO artifacts 
(image_id, stage, file_path, sha256, width, height, file_size, processing_params)
VALUES ('$image_id', '$stage', '$file_path', '$sha256', 
        $(test "$width" = "null" && echo "NULL" || echo "$width"),
        $(test "$height" = "null" && echo "NULL" || echo "$height"),
        $size, $(test "$processing_params" = "null" && echo "NULL" || echo "'$processing_params'"));
EOF
    fi
}

# Bulk artifact logging for existing files
db-sync-artifacts() {
    local stage="$1"
    local directory="$2"
    
    find "$directory" -name "*.png" -o -name "*.jpeg" | while read -r file; do
        local id=$(basename "$file" | cut -d. -f1)
        db-log-artifact "$id" "$stage" "$file"
    done
}

# Usage examples:
# db-sync-artifacts "thumbnails-small" "thumbs/"
# db-sync-artifacts "web-optimized" "t2/"
```

#### Job Management
```bash
# Start a processing job
db-start-job() {
    local image_id="$1"
    local stage="$2"
    
    cat <<EOF | sqlite3 cv.db
INSERT INTO jobs (image_id, stage, status, started_at) 
VALUES ('$image_id', '$stage', 'running', datetime('now'));
EOF
}

# Complete a job successfully  
db-complete-job() {
    local image_id="$1"
    local stage="$2"
    
    cat <<EOF | sqlite3 cv.db
UPDATE jobs SET status = 'completed', completed_at = datetime('now')
WHERE image_id = '$image_id' AND stage = '$stage' AND status = 'running';
EOF
}

# Mark job as failed with error message
db-fail-job() {
    local image_id="$1"
    local stage="$2"
    local error_msg="$3"
    
    cat <<EOF | sqlite3 cv.db
UPDATE jobs SET status = 'failed', completed_at = datetime('now'), 
               error_message = '$error_msg', retry_count = retry_count + 1
WHERE image_id = '$image_id' AND stage = '$stage' AND status = 'running';
EOF
}
```

#### Blurhash Cache Management
```bash
# Store blurhash (following existing caching pattern)
db-store-blurhash() {
    local image_id="$1"
    local stage="$2"
    local blurhash="$3"
    local width="$4"
    local height="$5"
    
    cat <<EOF | sqlite3 cv.db
INSERT OR REPLACE INTO blurhash_cache (image_id, stage, blurhash, width, height)
VALUES ('$image_id', '$stage', '$blurhash', $width, $height);
EOF
}

# Batch blurhash generation (similar to existing blur cache approach)
db-generate-blurhash() {
    local stage="$1"
    local directory="$2"
    
    # Find images missing blurhash
    echo "SELECT a.image_id, a.file_path FROM artifacts a 
          LEFT JOIN blurhash_cache b ON a.image_id = b.image_id AND a.stage = b.stage
          WHERE a.stage = '$stage' AND b.image_id IS NULL;" | sqlite3 cv.db | \
    while IFS='|' read -r image_id file_path; do
        # Generate blurhash using existing blurmap.go logic or external tool
        dimensions=$(identify -format "%w %h" "$file_path")
        width=$(echo $dimensions | cut -d' ' -f1)
        height=$(echo $dimensions | cut -d' ' -f2)
        
        # Placeholder - would call actual blurhash generation
        blurhash="L9AB23~q^+IA4;xDRjSh{9s:O9M}"
        
        db-store-blurhash "$image_id" "$stage" "$blurhash" "$width" "$height"
    done
}
```

#### Query Operations (following existing reporting pattern)
```bash
# Get processing statistics (similar to existing qa checks)
db-stats() {
    cat <<'EOF' | sqlite3 cv.db
.mode column
.headers on

SELECT 'Total Images' as metric, COUNT(*) as value FROM images
UNION ALL
SELECT 'Approved Images', COUNT(*) FROM images WHERE approved = true
UNION ALL  
SELECT 'Rejected Images', COUNT(*) FROM images WHERE rejected = true
UNION ALL
SELECT 'Pending Approval', COUNT(*) FROM images WHERE approved = false AND rejected = false;

SELECT stage, COUNT(*) as count FROM artifacts GROUP BY stage ORDER BY stage;
EOF
}

# Find images ready for processing (replaces directory scanning)
db-find-ready() {
    local input_stage="$1"
    local output_stage="$2"
    
    cat <<EOF | sqlite3 cv.db
SELECT i.id FROM images i
JOIN artifacts a1 ON i.id = a1.image_id AND a1.stage = '$input_stage'
LEFT JOIN artifacts a2 ON i.id = a2.image_id AND a2.stage = '$output_stage'
WHERE i.approved = true AND a2.id IS NULL;
EOF
}

# Usage: db-find-ready "web-optimized" "ersgan-enhanced" | runmany 5 './ersgan.mjs $1'
```

#### Migration Helpers
```bash
# Migrate existing yes/no structure to database flags
db-migrate-approval() {
    echo "BEGIN TRANSACTION;"
    
    # Mark approved images
    find yes/ -name "*.jpeg" | cut -d/ -f2 | cut -d. -f1 | \
    runmany 16 'echo "UPDATE images SET approved = true WHERE id = '"'"'$1'"'"';"'
    
    # Mark rejected images and store reason
    find no/ -name "*" | cut -d/ -f2 | \
    runmany 16 'echo "UPDATE images SET rejected = true, rejection_reason = '"'"'manual'"'"' WHERE id = '"'"'$1'"'"';"'
    
    echo "COMMIT;"
} | sqlite3 cv.db

# Migrate existing blur cache to database
db-migrate-blurhash() {
    # This would parse existing blur/ cache files and import to database
    # Implementation depends on current blur cache format
    echo "-- TODO: Implement based on current blur/ directory structure"
}
```

### Migration Strategy

#### Phase 1: Database Integration
1. **Create new schema** using the SQL commands above
2. **Populate database** from existing file structure:
   ```bash
   # Register all existing images
   find img/ -name "*.jpeg" | cut -d/ -f2 | cut -d. -f1 | sort | \
   xargs -n 100 bash -c 'db-upsert-images "$@" | sqlite3 cv.db' _
   
   # Migrate approval status
   db-migrate-approval
   
   # Sync existing artifacts
   db-sync-artifacts "thumbnails-small" "thumbs/"
   db-sync-artifacts "web-optimized" "t2/"
   db-sync-artifacts "ersgan-enhanced" "replicate/img/"
   ```

3. **Update processing scripts** to use database logging instead of directory operations

#### Phase 2: Directory Restructure
1. **Create art/ subdirectories**
2. **Migrate files** with hard links to avoid duplication:
   ```bash
   # Example migration
   find img/ -name "*.jpeg" | while read f; do
       id=$(basename "$f" .jpeg)
       ln "$f" "art/upstream/${id}.jpeg"
   done
   ```

3. **Update path references** in all processing scripts
4. **Validate migration** by comparing file counts and checksums

#### Phase 3: Query-Based Processing
Replace directory scanning with database queries:

```sql
-- Find images ready for ESRGAN processing
SELECT i.id FROM images i
JOIN artifacts a1 ON i.id = a1.image_id AND a1.stage = 'web-optimized'
LEFT JOIN artifacts a2 ON i.id = a2.image_id AND a2.stage = 'ersgan-enhanced'
WHERE i.approved = TRUE AND a2.id IS NULL;

-- Find failed processing jobs for retry
SELECT image_id, stage FROM jobs 
WHERE status = 'failed' AND retry_count < 3;

-- Gallery generation with metadata
SELECT i.id, i.width, i.height, b.blurhash, a.file_path
FROM images i
JOIN artifacts a ON i.id = a.image_id AND a.stage = 'web-optimized'
LEFT JOIN blurhash_cache b ON i.id = b.image_id AND b.stage = 'web-optimized'
WHERE i.approved = TRUE
ORDER BY i.created_at DESC;
```

### Benefits

#### Improved Reliability
- **Atomic operations**: Database transactions ensure consistency
- **Constraint enforcement**: Foreign keys prevent orphaned artifacts
- **Audit trail**: Complete processing history with timestamps
- **Conflict resolution**: Unique constraints prevent duplicate processing

#### Better Performance
- **Indexed queries**: Fast lookups by image_id, stage, status
- **Bulk operations**: Process multiple images in single transactions
- **Parallel safety**: Database handles concurrent access correctly
- **Cached metadata**: No need to stat files repeatedly

#### Enhanced Functionality
- **Advanced filtering**: Complex queries for image selection
- **Processing pipeline**: Track job status and dependencies
- **Duplicate detection**: SHA256-based deduplication
- **Rollback capability**: Recreate any processing stage from database state

#### Simplified Maintenance
- **Flat storage**: Easy backup and synchronization
- **Consistent naming**: All artifacts follow same pattern
- **Clear dependencies**: Database schema documents relationships
- **Tool integration**: Standard SQL tools for debugging and analysis

### Implementation Priority

1. **High Priority**: Database schema and basic CRUD operations
2. **Medium Priority**: Migration scripts and validation tools  
3. **Low Priority**: Advanced querying and optimization features

### Compatibility Notes

- **Backward compatibility**: Keep existing Justfile commands working during transition
- **Incremental adoption**: New features use database, existing features continue with directories
- **Rollback plan**: Database can regenerate directory structure if needed