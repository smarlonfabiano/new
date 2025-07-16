#!/bin/bash

# =========================================================================
# Caching and Storage Analysis Script
# =========================================================================
# This script demonstrates various caching strategies, data storage patterns,
# and memory management techniques commonly used in software development.
# =========================================================================

echo "===== Caching and Storage Analysis ====="
echo ""

# -------------------------------------------------------------------------
# SECTION 1: CACHING STRATEGIES
# -------------------------------------------------------------------------
echo "1. CACHING STRATEGIES"
echo "--------------------"

# 1.1 Memoization Cache
# ---------------------
# Memoization is a caching strategy where results of expensive function calls
# are stored and reused when the same inputs occur again.
# This reduces computation time at the expense of memory usage.
echo "1.1 Memoization Cache"

# Create a directory for our cache files if it doesn't exist
mkdir -p /tmp/memo_cache

# Function that simulates an expensive computation
calculate_fibonacci() {
    local n=$1
    
    # Check if result is already in cache
    if [ -f "/tmp/memo_cache/fib_$n" ]; then
        echo "  Cache HIT for fibonacci($n)"
        cat "/tmp/memo_cache/fib_$n"
        return
    fi
    
    echo "  Cache MISS for fibonacci($n), calculating..."
    
    # Simulate expensive calculation
    local result
    if [ $n -le 1 ]; then
        result=$n
    else
        local a=0
        local b=1
        local i=1
        while [ $i -lt $n ]; do
            local temp=$((a + b))
            a=$b
            b=$temp
            i=$((i + 1))
        done
        result=$b
    fi
    
    # Store result in cache
    echo $result > "/tmp/memo_cache/fib_$n"
    echo $result
}

# Demonstrate memoization
echo "  First run (cache misses):"
calculate_fibonacci 10
calculate_fibonacci 20
calculate_fibonacci 15

echo "  Second run (cache hits):"
calculate_fibonacci 10
calculate_fibonacci 20
calculate_fibonacci 15

# 1.2 LRU (Least Recently Used) Cache
# -----------------------------------
# LRU cache keeps track of what was used when and discards the least recently
# used items first when the cache reaches its capacity.
echo ""
echo "1.2 LRU Cache Simulation"

# Create a simple LRU cache using an array and associative array in bash
declare -a lru_order
declare -A lru_cache
max_cache_size=5

# Function to add or update item in LRU cache
lru_cache_put() {
    local key=$1
    local value=$2
    
    # If key already exists, remove it from the order array
    local i=0
    for item in "${lru_order[@]}"; do
        if [ "$item" == "$key" ]; then
            unset 'lru_order[$i]'
            lru_order=("${lru_order[@]}")  # Reindex array
            break
        fi
        i=$((i + 1))
    done
    
    # Add key to the end of order array (most recently used)
    lru_order+=("$key")
    
    # Add/update value in cache
    lru_cache["$key"]=$value
    
    # If cache exceeds max size, remove least recently used item
    if [ ${#lru_order[@]} -gt $max_cache_size ]; then
        local lru_key="${lru_order[0]}"
        unset 'lru_cache[$lru_key]'
        lru_order=("${lru_order[@]:1}")  # Remove first element
        echo "  Evicted key '$lru_key' from LRU cache (least recently used)"
    fi
}

# Function to get item from LRU cache
lru_cache_get() {
    local key=$1
    
    if [ -n "${lru_cache[$key]+x}" ]; then
        # Update access order (move to end)
        local i=0
        for item in "${lru_order[@]}"; do
            if [ "$item" == "$key" ]; then
                unset 'lru_order[$i]'
                lru_order=("${lru_order[@]}")  # Reindex array
                break
            fi
            i=$((i + 1))
        done
        lru_order+=("$key")
        
        echo "  Cache HIT for key '$key': ${lru_cache[$key]}"
        return 0
    else
        echo "  Cache MISS for key '$key'"
        return 1
    fi
}

# Demonstrate LRU cache
echo "  Adding items to LRU cache:"
lru_cache_put "key1" "value1"
lru_cache_put "key2" "value2"
lru_cache_put "key3" "value3"
lru_cache_put "key4" "value4"
lru_cache_put "key5" "value5"

echo "  Current cache state: ${lru_order[*]}"

echo "  Accessing key3:"
lru_cache_get "key3"
echo "  Current cache state: ${lru_order[*]}"

echo "  Adding key6 (should evict key1):"
lru_cache_put "key6" "value6"
echo "  Current cache state: ${lru_order[*]}"

echo "  Trying to access key1 (should be a miss):"
lru_cache_get "key1"

# 1.3 Time-based Cache Expiration
# ------------------------------
# Time-based caching involves storing data with a timestamp and
# invalidating it after a certain period of time has passed.
echo ""
echo "1.3 Time-based Cache Expiration"

# Create a directory for our time-based cache
mkdir -p /tmp/time_cache

# Function to add item to time-based cache with TTL (Time To Live)
time_cache_put() {
    local key=$1
    local value=$2
    local ttl=$3  # TTL in seconds
    
    # Calculate expiration time
    local expiry=$(($(date +%s) + ttl))
    
    # Store value and expiration time
    echo "$value|$expiry" > "/tmp/time_cache/$key"
    echo "  Added key '$key' to time-based cache with $ttl second TTL"
}

# Function to get item from time-based cache
time_cache_get() {
    local key=$1
    
    if [ -f "/tmp/time_cache/$key" ]; then
        local cache_data=$(cat "/tmp/time_cache/$key")
        local value=$(echo "$cache_data" | cut -d'|' -f1)
        local expiry=$(echo "$cache_data" | cut -d'|' -f2)
        local now=$(date +%s)
        
        if [ $now -lt $expiry ]; then
            echo "  Cache HIT for key '$key': $value (valid for $((expiry - now)) more seconds)"
            return 0
        else
            echo "  Cache EXPIRED for key '$key'"
            rm "/tmp/time_cache/$key"
            return 1
        fi
    else
        echo "  Cache MISS for key '$key'"
        return 1
    fi
}

# Demonstrate time-based cache
echo "  Adding items to time-based cache:"
time_cache_put "weather" "sunny" 5
time_cache_put "stock_price" "100.50" 10

echo "  Accessing items immediately:"
time_cache_get "weather"
time_cache_get "stock_price"

echo "  Waiting 6 seconds..."
sleep 6

echo "  Accessing items after delay:"
time_cache_get "weather"  # Should be expired
time_cache_get "stock_price"  # Should still be valid

# -------------------------------------------------------------------------
# SECTION 2: DATA STORAGE PATTERNS
# -------------------------------------------------------------------------
echo ""
echo "2. DATA STORAGE PATTERNS"
echo "----------------------"

# 2.1 File-based Storage
# ---------------------
# File-based storage involves persisting data to the filesystem.
# This is a simple and reliable way to store data between program executions.
echo "2.1 File-based Storage"

# Create a directory for our file storage
mkdir -p /tmp/file_storage

# Function to store data in a file
file_store() {
    local key=$1
    local value=$2
    
    echo "$value" > "/tmp/file_storage/$key"
    echo "  Stored '$value' with key '$key' in file storage"
}

# Function to retrieve data from a file
file_retrieve() {
    local key=$1
    
    if [ -f "/tmp/file_storage/$key" ]; then
        local value=$(cat "/tmp/file_storage/$key")
        echo "  Retrieved value for key '$key': $value"
        echo "$value"
    else
        echo "  No data found for key '$key'"
        return 1
    fi
}

# Demonstrate file-based storage
echo "  Storing data in files:"
file_store "user_settings" '{"theme":"dark","font_size":12}'
file_store "app_config" '{"debug":true,"log_level":"info"}'

echo "  Retrieving data from files:"
file_retrieve "user_settings"
file_retrieve "app_config"
file_retrieve "nonexistent_key"  # Should fail

# 2.2 In-memory Storage
# --------------------
# In-memory storage keeps data in RAM for fast access but loses data
# when the program terminates. Good for temporary data and caching.
echo ""
echo "2.2 In-memory Storage"

# Using bash associative arrays for in-memory storage
declare -A memory_store

# Functions for in-memory storage operations
memory_put() {
    local key=$1
    local value=$2
    
    memory_store["$key"]=$value
    echo "  Stored '$value' with key '$key' in memory"
}

memory_get() {
    local key=$1
    
    if [ -n "${memory_store[$key]+x}" ]; then
        echo "  Retrieved value for key '$key': ${memory_store[$key]}"
        echo "${memory_store[$key]}"
        return 0
    else
        echo "  No data found for key '$key' in memory"
        return 1
    fi
}

memory_delete() {
    local key=$1
    
    if [ -n "${memory_store[$key]+x}" ]; then
        unset 'memory_store[$key]'
        echo "  Deleted key '$key' from memory"
        return 0
    else
        echo "  Key '$key' not found in memory"
        return 1
    fi
}

# Demonstrate in-memory storage
echo "  Storing data in memory:"
memory_put "session_token" "a1b2c3d4e5f6"
memory_put "user_id" "12345"
memory_put "cart_items" "3"

echo "  Retrieving data from memory:"
memory_get "session_token"
memory_get "user_id"

echo "  Deleting data from memory:"
memory_delete "user_id"
memory_get "user_id"  # Should fail

# 2.3 Key-value Storage Pattern
# ----------------------------
# Key-value storage is a simple but powerful pattern where data is stored
# and retrieved using unique keys. It's the foundation of many NoSQL databases.
echo ""
echo "2.3 Key-value Storage Pattern"

# Create a directory for our key-value store
mkdir -p /tmp/kv_store

# Functions for key-value store operations with JSON support
kv_put() {
    local collection=$1
    local key=$2
    local value=$3
    
    # Create collection directory if it doesn't exist
    mkdir -p "/tmp/kv_store/$collection"
    
    # Store value
    echo "$value" > "/tmp/kv_store/$collection/$key"
    echo "  Stored value with key '$key' in collection '$collection'"
}

kv_get() {
    local collection=$1
    local key=$2
    
    if [ -f "/tmp/kv_store/$collection/$key" ]; then
        local value=$(cat "/tmp/kv_store/$collection/$key")
        echo "  Retrieved value for key '$key' from collection '$collection'"
        echo "$value"
        return 0
    else
        echo "  No data found for key '$key' in collection '$collection'"
        return 1
    fi
}

kv_list() {
    local collection=$1
    
    if [ -d "/tmp/kv_store/$collection" ]; then
        echo "  Keys in collection '$collection':"
        ls -1 "/tmp/kv_store/$collection"
    else
        echo "  Collection '$collection' does not exist"
        return 1
    fi
}

# Demonstrate key-value storage pattern
echo "  Storing data in key-value store:"
kv_put "users" "user123" '{"name":"John Doe","email":"john@example.com"}'
kv_put "users" "user456" '{"name":"Jane Smith","email":"jane@example.com"}'
kv_put "products" "prod789" '{"name":"Laptop","price":999.99}'

echo "  Retrieving data from key-value store:"
kv_get "users" "user123"
kv_get "products" "prod789"

echo "  Listing keys in collections:"
kv_list "users"
kv_list "products"

# -------------------------------------------------------------------------
# SECTION 3: MEMORY MANAGEMENT TECHNIQUES
# -------------------------------------------------------------------------
echo ""
echo "3. MEMORY MANAGEMENT TECHNIQUES"
echo "-----------------------------"

# 3.1 Garbage Collection Simulation
# --------------------------------
# Garbage collection is the process of automatically freeing memory that is
# no longer referenced by the program. This is a simulation of how it works.
echo "3.1 Garbage Collection Simulation"

# Create an array to hold our objects
declare -a objects
declare -A object_refs

# Function to create an object and return its ID
create_object() {
    local name=$1
    local data=$2
    
    # Generate a unique ID
    local id="obj_$(date +%s%N)"
    
    # Store object data
    objects+=("$id")
    object_refs["$id"]="$name:$data"
    
    echo "  Created object $name with ID $id"
    echo "$id"
}

# Function to reference an object (increment reference count)
reference_object() {
    local id=$1
    local ref_name=$2
    
    if [ -n "${object_refs[$id]+x}" ]; then
        # In a real system, we'd increment a reference counter
        # Here we'll just add a reference name to the object data
        local current_data="${object_refs[$id]}"
        object_refs["$id"]="$current_data|ref:$ref_name"
        echo "  Object $id referenced by $ref_name"
    else
        echo "  Error: Object $id does not exist"
        return 1
    fi
}

# Function to dereference an object (decrement reference count)
dereference_object() {
    local id=$1
    local ref_name=$2
    
    if [ -n "${object_refs[$id]+x}" ]; then
        # In a real system, we'd decrement a reference counter
        # Here we'll just remove the reference name from the object data
        local current_data="${object_refs[$id]}"
        object_refs["$id"]=$(echo "$current_data" | sed "s/|ref:$ref_name//")
        echo "  Object $id dereferenced by $ref_name"
    else
        echo "  Error: Object $id does not exist"
        return 1
    fi
}

# Function to run garbage collection
run_garbage_collection() {
    echo "  Running garbage collection..."
    
    local collected=0
    
    # Check each object
    for id in "${objects[@]}"; do
        # If object exists but has no references (other than its name)
        if [ -n "${object_refs[$id]+x}" ] && ! echo "${object_refs[$id]}" | grep -q "|ref:"; then
            echo "  Collecting unreferenced object: $id (${object_refs[$id]})"
            unset 'object_refs[$id]'
            collected=$((collected + 1))
        fi
    done
    
    # Rebuild objects array to remove collected objects
    objects=()
    for id in "${!object_refs[@]}"; do
        objects+=("$id")
    done
    
    echo "  Garbage collection complete. Collected $collected objects."
}

# Demonstrate garbage collection
echo "  Creating objects:"
obj1=$(create_object "UserData" "name=John")
obj2=$(create_object "TempData" "value=42")
obj3=$(create_object "SessionData" "token=abc123")

echo "  Adding references:"
reference_object "$obj1" "main_program"
reference_object "$obj2" "function_a"
reference_object "$obj3" "function_b"

echo "  Current objects:"
for id in "${objects[@]}"; do
    echo "    $id: ${object_refs[$id]}"
done

echo "  Removing references:"
dereference_object "$obj2" "function_a"  # obj2 is now unreferenced

echo "  Running garbage collection:"
run_garbage_collection

echo "  Remaining objects after garbage collection:"
for id in "${objects[@]}"; do
    echo "    $id: ${object_refs[$id]}"
done

# 3.2 Memory Allocation and Deallocation
# -------------------------------------
# This section demonstrates explicit memory management through allocation
# and deallocation, similar to malloc/free in C or new/delete in C++.
echo ""
echo "3.2 Memory Allocation and Deallocation"

# Create a simple memory pool
declare -A memory_pool
total_memory=1000
used_memory=0

# Function to allocate memory
allocate_memory() {
    local size=$1
    local purpose=$2
    
    if [ $((used_memory + size)) -gt $total_memory ]; then
        echo "  Memory allocation failed: Not enough memory"
        return 1
    fi
    
    # Generate a memory address (simulated)
    local address="mem_$(date +%s%N)"
    
    # Allocate memory
    memory_pool["$address"]="$size:$purpose"
    used_memory=$((used_memory + size))
    
    echo "  Allocated $size bytes at address $address for $purpose"
    echo "  Memory usage: $used_memory/$total_memory bytes"
    echo "$address"
}

# Function to free memory
free_memory() {
    local address=$1
    
    if [ -n "${memory_pool[$address]+x}" ]; then
        local size=$(echo "${memory_pool[$address]}" | cut -d':' -f1)
        local purpose=$(echo "${memory_pool[$address]}" | cut -d':' -f2)
        
        # Free memory
        unset 'memory_pool[$address]'
        used_memory=$((used_memory - size))
        
        echo "  Freed $size bytes from address $address ($purpose)"
        echo "  Memory usage: $used_memory/$total_memory bytes"
    else
        echo "  Error: Invalid memory address $address"
        return 1
    fi
}

# Demonstrate memory allocation and deallocation
echo "  Initial memory usage: $used_memory/$total_memory bytes"

echo "  Allocating memory:"
addr1=$(allocate_memory 200 "image_buffer")
addr2=$(allocate_memory 150 "text_data")
addr3=$(allocate_memory 300 "audio_buffer")

echo "  Attempting to allocate too much memory:"
allocate_memory 400 "video_buffer"  # Should fail

echo "  Freeing memory:"
free_memory "$addr2"  # Free the text_data

echo "  Allocating memory after free:"
addr4=$(allocate_memory 250 "video_buffer")  # Should succeed now

# 3.3 Memory Usage Monitoring
# --------------------------
# This section demonstrates techniques for monitoring memory usage
# and detecting memory leaks.
echo ""
echo "3.3 Memory Usage Monitoring"

# Function to get current system memory usage
get_system_memory_usage() {
    if [ -f "/proc/meminfo" ]; then
        echo "  System memory usage:"
        grep -E "MemTotal|MemFree|MemAvailable|Buffers|Cached" /proc/meminfo | 
            awk '{printf "    %-15s %8d MB\n", $1, $2/1024}'
    else
        echo "  System memory info not available on this system"
    fi
}

# Function to get memory usage of current process
get_process_memory_usage() {
    echo "  Current process memory usage:"
    ps -o pid,vsz,rss,comm -p $$ | 
        awk 'NR>1 {printf "    PID: %s, Virtual: %s KB, Physical: %s KB\n", $1, $2, $3}'
}

# Function to simulate memory leak detection
detect_memory_leaks() {
    echo "  Checking for memory leaks in our memory pool:"
    
    local leak_count=0
    for address in "${!memory_pool[@]}"; do
        local details="${memory_pool[$address]}"
        local purpose=$(echo "$details" | cut -d':' -f2)
        
        # In a real system, we'd check if these allocations are still needed
        # Here we'll just report them as potential leaks
        echo "    Potential leak: $address - $details"
        leak_count=$((leak_count + 1))
    done
    
    if [ $leak_count -eq 0 ]; then
        echo "    No memory leaks detected"
    else
        echo "    Found $leak_count potential memory leaks"
    fi
}

# Demonstrate memory monitoring
echo "  Monitoring system memory:"
get_system_memory_usage

echo "  Monitoring process memory:"
get_process_memory_usage

echo "  Running leak detection:"
detect_memory_leaks

# -------------------------------------------------------------------------
# CONCLUSION
# -------------------------------------------------------------------------
echo ""
echo "===== Analysis Summary ====="
echo "This script demonstrated:"
echo "1. Caching Strategies:"
echo "   - Memoization (storing results of expensive function calls)"
echo "   - LRU (Least Recently Used) cache"
echo "   - Time-based cache expiration"
echo ""
echo "2. Data Storage Patterns:"
echo "   - File-based storage"
echo "   - In-memory storage"
echo "   - Key-value storage pattern"
echo ""
echo "3. Memory Management Techniques:"
echo "   - Garbage collection"
echo "   - Memory allocation and deallocation"
echo "   - Memory usage monitoring"
echo ""
echo "These techniques are fundamental to efficient software development"
echo "and can be applied in various programming languages and environments."
echo "============================="