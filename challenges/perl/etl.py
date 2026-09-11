# Here isa complete "re-implementation" of etl.pl in Python
# Author: Vasudev Menon
# Date: 9/11/2026

import csv
import re

# Database table configuration
TABLE_NAME = "nasdaq_prices"
DATABASE_ENGINE = "InnoDB"
DEFAULT_CHARSET = "latin1"

# Input CSV file
filename = "prices.csv"

# Initialize data structures
field_types = {}  # Dictionary to store detected column types
field_lengths = {}  # Dictionary to store max length for each field
decimal_lengths_left = {}  # Max digits before decimal point
decimal_lengths_right = {}  # Max digits after decimal point
column_names = []  # List of cleaned column names
rows = []  # All data rows

# ============================================================================
# PART 1: Read CSV and parse headers
# ============================================================================

try:
    with open(filename, 'r') as csvfile:
        reader = csv.reader(csvfile)
        
        # Read header row
        headers = next(reader)
        
        # Clean and process column names
        cleaned_headers = []
        for header in headers:
            # Remove quotes
            header = header.strip('"').strip("'")
            # Replace spaces with underscores
            header = header.replace(' ', '_')
            # Escape single quotes for SQL
            header = header.replace("'", "\\'")
            cleaned_headers.append(header)
        
        column_names = cleaned_headers
        
        # Read all data rows
        for row in reader:
            rows.append(row)
        
except FileNotFoundError:
    print(f"Error: File '{filename}' not found")
    exit(1)

# ============================================================================
# PART 2: Analyze data types for each column
# ============================================================================

for col_index, col_name in enumerate(column_names):
    field_types[col_index] = None  # Type to be determined
    field_lengths[col_index] = 0  # Max length
    decimal_lengths_left[col_index] = 0
    decimal_lengths_right[col_index] = 0

# Iterate through each row to determine column types
for row in rows:
    for col_index in range(len(column_names)):
        value = row[col_index].strip() if col_index < len(row) else ""
        
        # Handle empty values
        if not value:
            value = "0"
        
        # Update max length
        if col_index not in field_lengths:
            field_lengths[col_index] = 0
        field_lengths[col_index] = max(field_lengths[col_index], len(value))
        
        # Type detection logic
        
        # If contains letters -> varchar
        if re.search(r'[a-zA-Z]', value):
            if field_types[col_index] != "varchar":
                field_types[col_index] = "varchar"
        
        elif field_types[col_index] != "varchar":
            # Check for decimal numbers
            if re.search(r'[0-9.]', value):
                period_count = value.count('.')
                
                if period_count == 0:
                    # Pure integer
                    if field_types[col_index] is None:
                        field_types[col_index] = "int"
                
                elif period_count == 1:
                    # Valid decimal
                    field_types[col_index] = "decimal"
                    parts = value.split('.')
                    decimal_lengths_left[col_index] = max(decimal_lengths_left[col_index], len(parts[0]))
                    decimal_lengths_right[col_index] = max(decimal_lengths_right[col_index], len(parts[1]))
                
                else:
                    # Multiple periods -> varchar
                    field_types[col_index] = "varchar"
            
            elif re.search(r'[^0-9.]', value):
                # Contains non-numeric, non-dot characters -> varchar
                field_types[col_index] = "varchar"
            
            elif field_types[col_index] is None:
                field_types[col_index] = "int"

# Set default type for uninitialized columns
for col_index in range(len(column_names)):
    if field_types[col_index] is None:
        field_types[col_index] = "varchar"

# ============================================================================
# PART 3: Generate SQL INSERT statements
# ============================================================================

with open("mysqlInsertValues.sql", 'w') as insert_file:
    # Build column list string
    columns_str = ", ".join(column_names)
    
    for row in rows:
        # Prepare values for this row
        values = []
        for col_index in range(len(column_names)):
            value = row[col_index].strip() if col_index < len(row) else ""
            
            # Handle empty values
            if not value:
                value = ""
            
            # Escape single quotes for SQL
            value = value.replace("'", "\\'")
            
            values.append(f"'{value}'")
        
        # Write INSERT statement
        values_str = ", ".join(values)
        insert_file.write(f"insert into {TABLE_NAME} ({columns_str} )\nvalues ({values_str});\n")

# ============================================================================
# PART 4: Generate CREATE TABLE statement
# ============================================================================

with open("mysqlCreateSchema.sql", 'w') as schema_file:
    schema_file.write(f"\n\nCREATE TABLE `{TABLE_NAME}` (\n")
    
    for col_index, col_name in enumerate(column_names):
        col_type = field_types[col_index]
        col_length = field_lengths[col_index]
        
        if col_length > 0:  # Only write columns with non-zero length
            if col_type == "decimal":
                # DECIMAL(total_digits, decimal_places)
                total_length = decimal_lengths_left[col_index] + decimal_lengths_right[col_index]
                scale = decimal_lengths_right[col_index]
                schema_file.write(f" `{col_name}` {col_type} ({total_length},{scale})")
            else:
                # VARCHAR or INT with length
                schema_file.write(f" `{col_name}` {col_type} ({col_length})")
            
            # Add comma separator (except for last column)
            if col_index < len(column_names) - 1:
                schema_file.write(",\n")
            else:
                schema_file.write("\n")
    
    # Close table definition
    schema_file.write(f"\n) ENGINE={DATABASE_ENGINE} DEFAULT CHARSET={DEFAULT_CHARSET}\n\n")

# ============================================================================
# PART 5: Print summary
# ============================================================================

print(f"Processed {len(column_names)} columns and {len(rows)} lines.")
print("SQL files generated:")
print("  - mysqlCreateSchema.sql")
print("  - mysqlInsertValues.sql")

