#!/usr/bin/perl
# Run this script with the Perl interpreter.
use File::Copy;
# Imports File::Copy, though this script currently does not use it (SUSPICIOUS: unused import).

$TABLE_NAME = "nasdaq_prices";
# Target MySQL table name used in CREATE TABLE and INSERT statements.
$DATABASE_ENGINE = "InnoDB";
# MySQL storage engine for the generated schema.
$DEFAULT_CHARSET = "latin1";
# Default character set for the generated schema.


$filename = "prices.csv";
# Input CSV filename expected in the current working directory.


open(TABLE, ">mysqlCreateSchema.sql") || die "Failed to redirect output";
# Open output file for CREATE TABLE SQL.
open(VALUES, ">mysqlInsertValues.sql") || die "Failed to redirect output";
# Open output file for INSERT statements.


$count = 0;
# Tracks how many data rows were processed.


$Columns_Values = "";
# Stores comma-separated column names for INSERT statements.


open FILE, "$filename" or die $!;
# Open input CSV file for reading; abort on error.


my $columns = <FILE>;
# Read the header row (first line) from the CSV.


chop $columns;
# Remove last character from header (SUSPICIOUS: chop always removes one char, regardless of what it is).

chop $columns;
# Remove another trailing character (SUSPICIOUS: may remove real data if line endings are not exactly expected).

$columns =~ s/'/\\'/g;
# Escape single quotes for SQL safety in column names.


$columns =~ s/\"//;
# Remove one double quote from header (SUSPICIOUS: no /g, so only first match is removed).

chop $columns;
# Remove yet another trailing character (SUSPICIOUS: cumulative chopping can truncate valid header text).


$columns =~ s/ /_/g;
# Replace spaces with underscores to form SQL-friendly identifiers.



@Field_Names = split(",",$columns);
# Split header into individual column names by comma.


$Field_Names_Count = $#Field_Names;
# Highest index in @Field_Names.

$Field_Names_Count_Plus_One = $Field_Names_Count + 1;
# Total number of fields.


$field_count = 0;
# Current field index while processing each row.


if ($count == 0)
# Build the cached comma-separated column list once.

{
# Start block for initial column-list assembly.

$column_count = 0;
# Index used while building the column list string.

   while ($column_count <= $Field_Names_Count)
   # Iterate through all column names.
   
   {
   # Start per-column assembly block.
      if ($column_count < $Field_Names_Count)
      # For all columns except the last, append trailing comma+space.
   
      {
      # Start non-last-column branch.
         $Columns_Values = $Columns_Values . $Field_Names[$column_count] . ", ";
         # Append "name, " to the INSERT column list.
      }
      # End non-last-column branch.
      
      
      if ($column_count == $Field_Names_Count)
      # For the last column, append without trailing comma.
   
      {
      # Start last-column branch.
         $Columns_Values = $Columns_Values . $Field_Names[$column_count];
         # Append final column name.
      }
      # End last-column branch.

      $column_count++;
      # Move to next header column.
   }
   # End header iteration loop.
   

}
# End one-time column-list assembly.

$count = 0;
# Ensure row counter starts at zero before reading data rows.


while (<FILE>)
# Process each remaining CSV row.

{
# Start row-processing block.


chomp $_;
# Remove trailing newline from current row.


$_ =~ s/\"//;
# Remove one double quote from row (SUSPICIOUS: no /g, so other quotes remain).


chop $_;
# Remove final character from row (SUSPICIOUS: may trim real data, not just CR/LF).


@Field_Values = split(",",$_);
# Split row by comma into fields (SUSPICIOUS: naive split breaks quoted CSV containing commas).

while ($field_count <= $Field_Names_Count )
# Iterate through each expected field in this row.

{
# Start field-processing block.


   $Field_Values[$field_count] =~ s/'/\\'/g;
   # Escape single quotes for SQL literals.


         if (length($Field_Values[$field_count]) < 1)
         # Temporarily convert empty values before type checks.
         
         {
         # Start empty-value branch.
            $Field_Values[$field_count] = "0";
            # Use "0" as placeholder for inference (SUSPICIOUS: biases type detection toward numeric).
         }
         # End empty-value branch.


         if ( $Field_Values[$field_count] =~ m/[a-zA-Z]/)
         # If letters are present, classify column as text.
         
         {
         # Start alpha-detected branch.
               $type[$field_count] = "varchar";
               # Mark this column as varchar.
               

               if ($length[$field_count] < 'length($Field_Values[$field_count])')
               # SUSPICIOUS: compares to literal string 'length(...)' instead of function result.
            
               {
               # Start varchar-length update branch.
                  $length[$field_count] = length($Field_Values[$field_count]);
                  # Store max observed text length.
               }
               # End varchar-length update branch.
         }
         # End alpha-detected branch.
   
   if ($type[$field_count] ne "varchar")
   # Only continue numeric inference if column is not already varchar.
   
   {
   # Start non-varchar inference block.
         if ( $Field_Values[$field_count] =~ m/[^a-zA-Z]/)
         # If it contains any non-letter, try integer path first.
   
         {
         # Start non-letter branch.
            if ($type[$field_count] ne "decimal")
            # Avoid downgrading an existing decimal type.
            
            {
            # Start int-candidate branch.
               $type[$field_count] = "int";
               # Mark as int for now.
               
               if ($length[$field_count] lt 'length($Field_Values[$field_count])')
               # SUSPICIOUS: string comparison plus literal 'length(...)' text.
               {
               # Start int-length update branch.
                  $length[$field_count] = length($Field_Values[$field_count]);
                  # Track max integer digit length.
               }
               # End int-length update branch.
            }
            # End int-candidate branch.
         }
         # End non-letter branch.
   
         if ( $Field_Values[$field_count] =~ m/[0-9.]/)
         # If value has digits or dot, evaluate decimal pattern.
   
         {
         # Start decimal-check branch.
               @count_periods = split("\\.",$Field_Values[$field_count]);
               # Split by dot to count decimal separators.
               $number_of_periods = $#count_periods;
               # Number of dots equals array max index after split.
            
            
            if ($number_of_periods > 1)
            # More than one dot is treated as non-numeric text.
            
            {
            # Start multiple-dot branch.
   
            $type[$field_count] = "varchar";
            # Reclassify as varchar due to invalid decimal format.
            
         
               if ($length[$field_count] < 'length($Field_Values[$field_count])')
               # SUSPICIOUS: same literal-string comparison bug as above.
               {
               # Start varchar-length update for malformed decimal.
                  $length[$field_count] = length($Field_Values[$field_count]);
                  # Keep max width for varchar fallback.
               }
               # End varchar-length update for malformed decimal.
   
   
                  $decimal_length1[$field_count] = "";
                  # Reset decimal integer-part width because type changed.
                  $decimal_length2[$field_count] = "";
                  # Reset decimal fractional-part width because type changed.
               }
               # End multiple-dot branch.
   
            if ($number_of_periods == 1)
            # Exactly one dot means decimal candidate.
            
            {
            # Start single-dot branch.
               $type[$field_count] = "decimal";
               # Mark column as decimal.
               @split_decimal_number = split("\\.",$Field_Values[$field_count]);
               # Split into integer and fractional segments.
               
               if ($decimal_length1[$field_count] lt length($split_decimal_number[0]))
               # Update max digits before decimal point.
               
               {
               # Start update for decimal integer-part width.
                  $decimal_length1[$field_count] = length($split_decimal_number[0]);
                  # Store new max integer-part width.
               }
               # End update for decimal integer-part width.
               
               if ($decimal_length2[$field_count] lt length($split_decimal_number[1]))
               # Update max digits after decimal point.
               
               {
               # Start update for decimal fractional-part width.
                  $decimal_length2[$field_count] = length($split_decimal_number[1]);
                  # Store new max fractional-part width.
               }
               # End update for decimal fractional-part width.
                           
            }
            # End single-dot branch.
   
         }
         # End decimal-check branch.
                  
         if ( $Field_Values[$field_count] =~ m/[^0-9.]/)
         # Any non-digit/non-dot forces varchar.
         
         {
         # Start non-numeric-char branch.
               $type[$field_count] = "varchar";
               # Promote to varchar for mixed content.
   
               if ($length[$field_count] lt 'length($Field_Values[$field_count])')
               # SUSPICIOUS: repeats literal 'length(...)' bug.
            
               {
               # Start varchar-length update for mixed content.
                  $length[$field_count] = length($Field_Values[$field_count]);
                  # Track max width for varchar.
               }
               # End varchar-length update for mixed content.
   
         }
         # End non-numeric-char branch.
   
   }
   # End non-varchar inference block.
   
   else
   # If already varchar, only update max width.
   
   {         
   # Start already-varchar block.
   
               if ($length[$field_count] < length($Field_Values[$field_count]))
               # Expand recorded width when a longer value appears.
            
               {
               # Start varchar-width growth branch.
                  $length[$field_count] = length($Field_Values[$field_count]);
                  # Save latest maximum varchar length.
               }
               # End varchar-width growth branch.
   
   
   }
   # End already-varchar block.
   
   
   
         if (length($Field_Values[$field_count]) < 1)
         # Restore placeholder empties back to empty string for output.
         
         {
         # Start final-empty-normalization branch.
            $Field_Values[$field_count] = "";
            # Write true empty value into generated INSERT statement.
         }
         # End final-empty-normalization branch.

   
      if ($field_count == 0)
      # First field starts the INSERT statement for this row.
      
      {
      # Start first-field output branch.
         print VALUES "insert into $TABLE_NAME ($Columns_Values) \nvalues ('$Field_Values[$field_count]'";
         # Emit INSERT header and first quoted value.
      }
      # End first-field output branch.
      
         if ($field_count > 0 && $field_count < $Field_Names_Count_Plus_One)
         # Remaining fields are appended with comma separators.
         
         {
         # Start subsequent-field output branch.
            print VALUES ", '$Field_Values[$field_count]'";
            # Append next quoted value to current INSERT.
         }
         # End subsequent-field output branch.
         
      $field_count++;
      # Move to next field in this row.
      }
      # End field-processing loop.
   
         if ($field_count == $Field_Names_Count_Plus_One)
         # Once all fields are written, close statement and reset index.
         
         {
         # Start end-of-row output branch.
            $field_count = 0;
            # Reset field index for next row.
            $count++;
            # Increment processed row count.
            print VALUES ");\n";
            # Terminate current INSERT statement.
         }
         # End end-of-row output branch.
   


}
# End row-processing loop.

print TABLE "\n\nCREATE TABLE `$TABLE_NAME` (\n";
# Start CREATE TABLE statement in schema file.

$count_columns = 0;
# Index used to output each column definition.


while ($count_columns < $Field_Names_Count_Plus_One)
# Iterate over every discovered column.

{
# Start column-definition loop.
   if (length($Field_Names[$count_columns]) > 0)
   # Skip empty header names.
   
   {
   # Start non-empty-column branch.
      if ($type[$count_columns] =~ "decimal")
      # Use decimal formatting when inferred type is decimal.
      
      {
      # Start decimal-column output branch.
         $decimal_field_length = $decimal_length1[$count_columns] + $decimal_length2[$count_columns];
         # Precision equals digits before + digits after decimal point.
         print TABLE " `$Field_Names[$count_columns]` $type[$count_columns] ($decimal_field_length,$decimal_length2[$count_columns])";
         # Emit decimal column as decimal(precision,scale).
      }
      # End decimal-column output branch.
      
      else
      # Non-decimal columns use stored length with inferred type.
      
      {
      # Start non-decimal-column output branch.
         print TABLE " `$Field_Names[$count_columns]` $type[$count_columns] ($length[$count_columns])";
         # Emit int/varchar style column declaration.
      }
      # End non-decimal-column output branch.
   
      if ($count_columns < $Field_Names_Count)
      # Add comma between column definitions except after last.
      
      {
      # Start comma-output branch.
         print TABLE ",\n";
         # Print trailing comma and newline.
      }
      # End comma-output branch.
      
      if ($count_columns == $Field_Names_Count_Plus_One)
      # SUSPICIOUS: unreachable condition because loop guard is < plus one.
      
      {
      # Start unreachable branch.
         print TABLE "\n\n";
         # Intended extra spacing that likely never executes.
      }
      # End unreachable branch.
      
   }
   # End non-empty-column branch.

$count_columns++;
# Advance to next column index.

}
# End column-definition loop.

print "Processed $column_count columns and $count lines.\n";
# Print summary to stdout (column_count came from header build loop).

print TABLE "\n) ENGINE=$DATABASE_ENGINE DEFAULT CHARSET=$DEFAULT_CHARSET\n";
# Close CREATE TABLE statement with engine and charset options.

print TABLE "\n\n";
# Add trailing blank lines in schema file.

close(FILE);
# Close CSV input file.

exit;
# End script execution successfully.


print "Process completed.\n";
# SUSPICIOUS: unreachable because exit above always terminates first.
