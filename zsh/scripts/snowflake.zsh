# Wraps snowsql to provide query output as shell-usable JSON. Typical usage is something like:
# > snowsql-json --connection my-connection --query "SELECT * FROM widgets"
function snowsql-json {
  snowsql -o output_format=json -o friendly=false $@ | ag -v "^\d+ Row\(s\) produced\.\s+Time Elapsed: \d+\.\d+s$"
}
