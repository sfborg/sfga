#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'time'

# Generate schema-changes.yaml by comparing schema.sql across git commits
# from v0.3.30 to the latest version
class SchemaChangeGenerator
  BASE_VERSION = 'v0.3.30'
  SCHEMA_FILE = 'schema.sql'
  OUTPUT_FILE = 'schema-changes.yaml'

  def initialize
    @changes = []
  end

  def generate
    puts "Generating schema changes from #{BASE_VERSION} to HEAD..."

    commits = get_commits_since_base
    base_schema = parse_schema(BASE_VERSION)
    previous_schema = base_schema

    commits.each do |commit|
      current_schema = parse_schema(commit[:sha])
      version = commit[:version]

      # Skip version bumps without schema changes
      next if version && version.match?(/^v0\.3\.\d+$/) && schemas_equal?(previous_schema, current_schema)

      changes = detect_changes(previous_schema, current_schema)

      if changes.any?
        @changes << {
          'version' => version || commit[:sha][0..6],
          'tag' => commit[:sha][0..6],
          'date' => commit[:date],
          'commit_message' => commit[:message],
          'description' => generate_description(changes),
          'changes' => format_changes(changes)
        }
        previous_schema = current_schema
      end
    end

    write_yaml
    puts "Generated #{OUTPUT_FILE} with #{@changes.size} version(s)"
  end

  private

  def get_commits_since_base
    cmd = "git log --oneline --date=short --format='%H|%ad|%s' #{BASE_VERSION}..HEAD"
    output = `#{cmd}`.strip

    commits = output.split("\n").reverse.map do |line|
      sha, date, message = line.split('|', 3)
      version = extract_version(sha)
      { sha: sha, date: date, message: message, version: version }
    end

    commits
  end

  def extract_version(sha)
    # Check if this commit is tagged with a version
    tags = `git tag --points-at #{sha}`.strip.split("\n")
    tags.find { |tag| tag.match?(/^v\d+\.\d+\.\d+$/) }
  end

  def parse_schema(ref)
    schema_content = `git show #{ref}:#{SCHEMA_FILE} 2>/dev/null`
    return {} if schema_content.empty?

    tables = {}
    current_table = nil
    current_columns = []

    schema_content.each_line do |line|
      # Match CREATE TABLE statements
      if line =~ /CREATE TABLE (\w+) \(/
        current_table = $1
        current_columns = []
      # Match column definitions
      elsif current_table && line =~ /^\s+(\w+)\s+(\w+)/
        column_name = $1
        column_type = $2

        # Extract default value if present
        default = nil
        if line =~ /DEFAULT\s+(.+?)(,|\)|--)/
          default = $1.strip
        end

        current_columns << {
          name: column_name,
          type: column_type,
          default: default,
          definition: line.strip
        }
      # End of table definition
      elsif line =~ /^\)\s*STRICT;/ && current_table
        tables[current_table] = current_columns.dup
        current_table = nil
        current_columns = []
      end
    end

    tables
  end

  def schemas_equal?(schema1, schema2)
    schema1.keys.sort == schema2.keys.sort &&
      schema1.all? { |table, cols| cols == schema2[table] }
  end

  def detect_changes(old_schema, new_schema)
    changes = []

    new_schema.each do |table_name, new_columns|
      old_columns = old_schema[table_name] || []

      # Find added columns
      added_columns = find_added_columns(old_columns, new_columns)

      if added_columns.any?
        changes << {
          table: table_name,
          added_columns: added_columns
        }
      end
    end

    changes
  end

  def find_added_columns(old_columns, new_columns)
    old_column_names = old_columns.map { |c| c[:name] }
    new_column_names = new_columns.map { |c| c[:name] }

    added_names = new_column_names - old_column_names
    added_columns = []

    added_names.each do |col_name|
      col_index = new_column_names.index(col_name)
      column_info = new_columns[col_index]

      # Find the column that comes before this one
      previous_column = col_index > 0 ? new_column_names[col_index - 1] : nil

      added_columns << {
        name: column_info[:name],
        type: column_info[:type],
        default: column_info[:default],
        position_after: previous_column
      }
    end

    added_columns
  end

  def generate_description(changes)
    tables = changes.map { |c| c[:table] }.uniq
    columns = changes.flat_map { |c| c[:added_columns].map { |col| col[:name] } }.uniq

    if tables.size == 1
      "Added #{columns.join(', ')} to #{tables.first} table"
    elsif columns.size <= 3
      "Added #{columns.join(', ')} to #{tables.size} tables"
    else
      "Added #{columns.size} columns to #{tables.size} tables"
    end
  end

  def format_changes(changes)
    formatted = []

    changes.each do |change|
      formatted << {
        'type' => 'table_modification',
        'table' => change[:table],
        'action' => 'add_columns',
        'columns' => change[:added_columns].map do |col|
          {
            'name' => col[:name],
            'type' => col[:type],
            'default' => col[:default] || "''",
            'position' => col[:position_after] ? "after #{col[:position_after]}" : 'first'
          }
        end
      }
    end

    formatted
  end

  def write_yaml
    output = {
      'schema_changes' => @changes
    }

    # Convert to YAML
    yaml_content = YAML.dump(output)

    # Add header comment
    yaml_content = "# Schema Change Log\n# Tracking database schema changes from #{BASE_VERSION} to current version\n\n#{yaml_content}"

    File.write(OUTPUT_FILE, yaml_content)
  end
end

# Run the generator
if __FILE__ == $PROGRAM_NAME
  begin
    generator = SchemaChangeGenerator.new
    generator.generate
  rescue StandardError => e
    puts "Error: #{e.message}"
    puts e.backtrace
    exit 1
  end
end
