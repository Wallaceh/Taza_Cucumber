
Before ('@google') do
 @google = Google.new
end

After ('@google') do
  @google.close
end