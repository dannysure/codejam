#!/usr/bin/perl
use File::Copy; # Import file copy module

# Configure the namws of the databases
$TABLE_NAME = "nasdaq_prices"; # Name of the table to create
$DATABASE_ENGINE = "InnoDB"; # MySQL storage engine
$DEFAULT_CHARSET = "latin1"; # Character encoding


$filename = "prices.csv"; # Input CSV file to process

# Now we'll open the tables

# File for CREATE TABLE
open(TABLE, ">mysqlCreateSchema.sql") || die "Failed to redirect output";
# File for INSERT statements
open(VALUES, ">mysqlInsertValues.sql") || die "Failed to redirect output";

# Counts processed rows
$count = 0;

# Stores comma-separated column names for the INSERT statements
$Columns_Values = "";

# Open input CSV file for reading
open FILE, "$filename" or die $!;

# Read the first line (header row) from the CSV file
my $columns = <FILE>; # Read the first line (header row)

# Remove CRLF line ending characters (\n and \r)
chop $columns;
chop $columns;

# Escape single quotes with backslash for SQL safety
$columns =~ s/'/\\'/g; # Replace all ' with \'

# Remove all double quotes from column names  
$columns =~ s/\"//; # Delete all double quote characters
chop $columns; # Remove another trailing character

# Replace spaces with underscores in column names (SQL naming convention)
$columns =~ s/ /_/g; # Replace all spaces with underscores

# Split the header string by commas into an array of column names
@Field_Names = split(",",$columns); # Create array of column names

# Get the index of the last element (number of columns - 1)
$Field_Names_Count = $#Field_Names; # $# returns last index of array

# Calculate actual number of columns
$Field_Names_Count_Plus_One = $Field_Names_Count + 1; # Total column count

# Initialize counter for iterating through fields
$field_count = 0; # Counter for current field being processed

# Build the column list string for INSERT statements (only done once)
if ($count == 0) # Check if this is the first iteration
{
$column_count = 0; # Initialize column counter for header processing

   while ($column_count <= $Field_Names_Count) # Loop through all columns
   {
      if ($column_count < $Field_Names_Count) # If not the last column
      {
         # Append column name with comma separator
         $Columns_Values = $Columns_Values . $Field_Names[$column_count] . ", "; # Add column name then comma
      }
      
      # For the last column, don't add comma separator
      if ($column_count == $Field_Names_Count) # If this is the last column
      {
         # Append the last column name without comma
         $Columns_Values = $Columns_Values . $Field_Names[$column_count]; # Add final column
      }

      $column_count++; # Move to next column
   } # End of column building loop

} # End header processing

$count = 0; # Reset counter for row processing

# Main loop to read and process each data row from the CSV file
while (<FILE>) # Read next line from file into $_
{
# Remove trailing newline from the line
chomp $_; # Remove newline character

# Remove quotes and clean the line
$_ =~ s/\"//; # Remove all double quotes from the line

chop $_; # Remove trailing character

# Split the current row into field values
@Field_Values = split(",",$_); # Create array of values for this row

# Process each field in the current row
while ($field_count <= $Field_Names_Count ) # Loop through all fields in this row
{
# Escape single quotes in field values for SQL safety
   $Field_Values[$field_count] =~ s/'/\\'/g; # Replace all ' with \'

# Handle empty fields - convert to "0" for initial analysis
         if (length($Field_Values[$field_count]) < 1) # If field is empty
         {
            $Field_Values[$field_count] = "0"; # Set empty field to "0" temporarily
         } # End empty field check

# Detect field type: if contains letters, it's varchar
         if ( $Field_Values[$field_count] =~ m/[a-zA-Z]/) # If field contains any letter
         {
               $type[$field_count] = "varchar"; # Set column type to varchar
               
# Track maximum length for varchar fields
               if ($length[$field_count] < 'length($Field_Values[$field_count])') # If current value is longer
               {
                  $length[$field_count] = length($Field_Values[$field_count]); # Update max length
               } # End length check
         } # End varchar detection
   
# If field doesn't contain letters, check for numeric types
   if ($type[$field_count] ne "varchar") # If type is not already varchar
   { # Analyze non-varchar fields for int or decimal
         # Check if field contains non-letter characters
         if ( $Field_Values[$field_count] =~ m/[^a-zA-Z]/) # If field has non-letter chars
         {
            if ($type[$field_count] ne "decimal") # If not already decimal
            {
               $type[$field_count] = "int"; # Tentatively set to int
               
               # Track maximum length for int fields
               if ($length[$field_count] lt 'length($Field_Values[$field_count])') # If current is longer
               {
                  $length[$field_count] = length($Field_Values[$field_count]);
               }
            }
         }
   
         # Check for numeric content and decimal points
         if ( $Field_Values[$field_count] =~ m/[0-9.]/) # If field contains digits or decimal point
         {
               # Count how many decimal points exist
               @count_periods = split("\\.",$Field_Values[$field_count]);
               $number_of_periods = $#count_periods; # Get number of decimal points (as array index)
            
            # If more than one decimal point, it's invalid decimal - store as varchar
            if ($number_of_periods > 1) # More than one decimal point
            { # This is invalid as a decimal number
   
            $type[$field_count] = "varchar"; # Store as varchar since it's not a valid number
            
         
               if ($length[$field_count] < 'length($Field_Values[$field_count])') # Track max length
               {
                  $length[$field_count] = length($Field_Values[$field_count]);
               }
   
   
                  $decimal_length1[$field_count] = ""; # Clear decimal length tracking
                  $decimal_length2[$field_count] = ""; # Clear decimal length tracking
               } # End multi-period handling
   
            # If exactly one decimal point, it's a valid decimal number
            if ($number_of_periods == 1) # Exactly one decimal point
            { # Valid decimal number
               $type[$field_count] = "decimal"; # Set type to decimal
               # Split the number into integer and fractional parts
               @split_decimal_number = split("\\.",$Field_Values[$field_count]);
               
               # Track max digits before decimal point
               if ($decimal_length1[$field_count] lt length($split_decimal_number[0])) # If this part is longer
               {
                  $decimal_length1[$field_count] = length($split_decimal_number[0]);
               }
               
               # Track max digits after decimal point
               if ($decimal_length2[$field_count] lt length($split_decimal_number[1])) # If this part is longer
               {
                  $decimal_length2[$field_count] = length($split_decimal_number[1]);
               }
                           
            }
   
         } # End decimal handling
                  
         # If field contains non-numeric characters, it must be varchar
         if ( $Field_Values[$field_count] =~ m/[^0-9.]/) # If field contains chars other than digits and dots
         { # This can't be a valid number
               $type[$field_count] = "varchar"; # Must be varchar if it has non-numeric chars
   
               # Track max length for varchar
               if ($length[$field_count] lt 'length($Field_Values[$field_count])') # If current is longer
               {
                  $length[$field_count] = length($Field_Values[$field_count]);
               }
   
         } # End non-numeric character check
   
   }
   
   else # If type is already varchar (contains letters)
   { # Just track the max length
               # Track maximum length for varchar fields
               if ($length[$field_count] < length($Field_Values[$field_count])) # If current value is longer
               {
                  $length[$field_count] = length($Field_Values[$field_count]);
               }
   
   
   }
   
   
         # Clear empty fields (reset from "0" to empty string for final output)
         if (length($Field_Values[$field_count]) < 1) # If field is empty
         {
            $Field_Values[$field_count] = ""; # Set to empty string for SQL
         } # End empty field reset

   
      # Generate INSERT statement values - handle first field specially
      if ($field_count == 0) # If this is the first field
      { # Start the INSERT statement with first value
         # Print INSERT statement header with first value
         print VALUES "insert into $TABLE_NAME ($Columns_Values) \nvalues ('$Field_Values[$field_count]'"; # Write INSERT beginning
      } # End first field
      
         # For middle and remaining fields, add values with commas
         if ($field_count > 0 && $field_count < $Field_Names_Count_Plus_One) # If not first and not beyond end
         {
            print VALUES ", '$Field_Values[$field_count]'"; # Append next value with comma
         } # End value appending
         
      $field_count++; # Move to next field
      } # End field loop for this row
   
         # When all fields for a row are processed, close the INSERT statement
         if ($field_count == $Field_Names_Count_Plus_One) # If we've processed all fields
         {
            $field_count = 0; # Reset counter for next row
            $count++; # Increment row counter
            print VALUES ");\n"; # Close the INSERT statement
         } # End row processing
   


}

# Generate the CREATE TABLE SQL statement
print TABLE "\n\nCREATE TABLE `$TABLE_NAME` (\n"; # Start CREATE TABLE statement

$count_columns = 0; # Initialize counter for column iteration

# Loop through each column to write the table schema
while ($count_columns < $Field_Names_Count_Plus_One) # For each column

{
   if (length($Field_Names[$count_columns]) > 0) # If column name exists
   
   {
      if ($type[$count_columns] =~ "decimal") # If column type is decimal
      
      {
         $decimal_field_length = $decimal_length1[$count_columns] + $decimal_length2[$count_columns]; # Total digits
         print TABLE " `$Field_Names[$count_columns]` $type[$count_columns] ($decimal_field_length,$decimal_length2[$count_columns])"; # DECIMAL(total, scale)
      }
      
      else # Not a decimal column
      
      {
         print TABLE " `$Field_Names[$count_columns]` $type[$count_columns] ($length[$count_columns])"; # Write column with type and length
      }
   
      if ($count_columns < $Field_Names_Count) # If not the last column
      
      {
         print TABLE ",\n"; # Add comma and newline after column definition
      }
      
      if ($count_columns == $Field_Names_Count_Plus_One)
      
      {
         print TABLE "\n\n";
      }
      
   }

$count_columns++; # Move to next column

} # End column loop

print "Processed $column_count columns and $count lines.\n"; # Print stats to console

print TABLE "\n) ENGINE=$DATABASE_ENGINE DEFAULT CHARSET=$DEFAULT_CHARSET\n"; # Close table definition

print TABLE "\n\n"; # Add spacing

close(FILE); # Close input CSV file

exit; # Exit the script


print "Process completed.\n";